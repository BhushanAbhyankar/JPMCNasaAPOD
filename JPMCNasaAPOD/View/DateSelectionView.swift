//
//  DateSelectionView.swift
//  JPMCNasaAPOD
//
//  Created by Bhushan Abhyankar on 11/11/2024.
//

import SwiftUI

struct DateSelectionView: View {
    @ObservedObject var viewModel:PicOfDayViewModel
    @Binding var selectedDate: Date
    @Binding var selectedDateString: String
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Text("Select a Date")
                .font(.headline)
                .foregroundColor(.nasaTextColor)
                .padding(.top)
                .multilineTextAlignment(.center)
                .accessibilityLabel("Select a Date")
                .accessibilityHint("Choose a date to view the Astronomy Picture of the Day")
            
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .frame(maxHeight: 400)
                .background(Color.nasaBackgroundColor.opacity(0.8))
                .cornerRadius(10)
                .padding(.horizontal)
                .accessibilityLabel("Date Picker")
                .accessibilityHint("Scroll to select a date")

            Button(action: {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                selectedDateString = dateFormatter.string(from: selectedDate)
                Task {
                    await viewModel.getPictureOfTheDay(for: selectedDateString)
                }
                dismiss()
                
            }) {
                Text("Done")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.nasaAccentColor)
                    .foregroundColor(Color.nasaTextColor)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .accessibilityLabel("Done button")
                    .accessibilityHint("Select this date and close the date picker")
            }
            Spacer()
        }
        .padding()
        .background(Color.nasaBackgroundColor.ignoresSafeArea())
        //.environment(\.dynamicTypeSize, .accessibility3)
    }
    
}

#Preview {
    DateSelectionView(viewModel: PicOfDayViewModel(repository: PicOfDayRepository(manager: NetworkManager(), cacheManager: CacheManager.shared)), selectedDate: .constant(Date()), selectedDateString: .constant("2024-11-11"))
}
