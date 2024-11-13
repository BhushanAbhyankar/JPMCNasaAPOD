//
//  PicOfTheDayView.swift
//  JPMCNasaAPOD
//
//  Created by Bhushan Abhyankar on 11/11/2024.
//

import SwiftUI
import AVKit

struct PicOfTheDayView: View {
    @StateObject var viewModel = PicOfDayViewModel(repository: PicOfDayRepository(manager: NetworkManager(), cacheManager: CacheManager.shared))
    @State private var isDateSelectionShown = false
    @State private var selectedDate = Date()
    @State private var selectedDateString = ""

    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 16) {
                    switch viewModel.viewState{
                    case .loading:
                        ProgressView()
                            .progressViewStyle(.circular)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.top, 50)
                            .foregroundColor(.nasaAccentColor)
                            .accessibilityLabel("Loading")
                            .accessibilityHint("Loading the Astronomy Picture of the Day")

                    case .loaded(let data):
                        displayPicView(picOfDayData: data)
                    case .error(let error):
                        showErrorView(error: error)
                    }
                }
                .padding(.horizontal)
            }
            .background(Color.nasaBackgroundColor.ignoresSafeArea())
            .task {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                selectedDateString = dateFormatter.string(from: selectedDate)
                await viewModel.getPictureOfTheDay(for: selectedDateString)
            }
            .sheet(isPresented: $isDateSelectionShown) {
                DateSelectionView(viewModel: viewModel, selectedDate: $selectedDate, selectedDateString: $selectedDateString)
            }
            .navigationTitle("NASA Pic")
            .foregroundColor(.nasaTextColor)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isDateSelectionShown.toggle()
                    } label: {
                        Image(systemName: "calendar")
                            .font(.title2)
                            .foregroundStyle(.nasaAccent)
                            .accessibilityLabel("Select Date")
                            .accessibilityHint("Opens the date selection to view another Astronomy Picture of the Day")
                    }

                }
            }
        }
    }
    
    @ViewBuilder
    func displayPicView(picOfDayData:PicOfDayResponse) -> some View{
        
        VStack(alignment: .leading, spacing: 4) {
            
            //Date
            Text(selectedDateString)
                .font(.headline)
                .foregroundColor(.nasaTextColor.opacity(0.7))
                .accessibilityLabel("Date")
                .accessibilityValue(selectedDateString)
            
            //Title
            Text(picOfDayData.title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.nasaTextColor)
                .multilineTextAlignment(.leading)
                .padding(.bottom, 10)
                .accessibilityLabel("Title")
                .accessibilityValue(picOfDayData.title)
        }
        .padding(.horizontal)
        
        //Image or Video
        if picOfDayData.mediaType == "image" {
            loadImageFromURL(imageURL: picOfDayData.url)
                .padding(.horizontal)
                .accessibilityLabel("Astronomy Picture")
                .accessibilityHint("Image for the selected date")

        } else if picOfDayData.mediaType == "video" {
            if let url = URL(string: picOfDayData.url){
                NASAVideoPlayerView(videoURL: url)
                    .frame(height: 300)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                    .accessibilityLabel("Astronomy Video")
                    .accessibilityHint("Video for the selected date")
            } else {
                Text("Invalid video link")
                    .foregroundColor(.nasaAccentColor)
                    .padding(.horizontal)
                    .accessibilityLabel("Invalid video URL")
                    .accessibilityHint("The video URL for this date is invalid")
            }
        }
        
        //Explanation
        Text(picOfDayData.explanation)
            .font(.body)
            .foregroundColor(.nasaTextColor)
            .lineSpacing(4)
            .padding(.horizontal)
            .padding(.top, 10)
            .padding(.bottom, 20)
            .accessibilityLabel("Explanation")
            .accessibilityValue(picOfDayData.explanation)
    }
    
    @ViewBuilder
    func loadImageFromURL(imageURL:String) -> some View{
        if let imageData = viewModel.dayImageData, let image = UIImage(data: imageData) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .cornerRadius(12)
                .shadow(radius: 5)
                .accessibilityLabel("Loading image")

        } else {
            ProgressView()
                .frame(height: 300)
                .frame(maxWidth: .infinity)
                .foregroundColor(.nasaAccentColor)
        }

    }


    @ViewBuilder
    func showErrorView(error:Error) -> some View{
        VStack(spacing: 8) {
        Text("Something Went Wrong!")
            .font(.title3)
            .fontWeight(.semibold)
            .foregroundColor(.nasaAccentColor)
            .padding(.top, 20)
            .accessibilityLabel("Error")
            .accessibilityValue("Something went wrong")

        Text(error.localizedDescription)
            .font(.body)
            .foregroundColor(.nasaTextColor)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .accessibilityLabel("Error details")
            .accessibilityValue(error.localizedDescription)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    PicOfTheDayView()
}
