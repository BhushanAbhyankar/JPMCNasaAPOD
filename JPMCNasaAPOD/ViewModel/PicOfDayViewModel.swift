//
//  PicOfDayViewModel.swift
//  JPMCNasaAPOD
//
//  Created by Bhushan Abhyankar on 11/11/2024.
//

import Foundation

enum ViewState {
    case loading
    case loaded(PicOfDayResponse)
    case error(Error)
}

final class PicOfDayViewModel:ObservableObject{
    private var repository: RepositoryActions
    
    @Published var viewState: ViewState = .loading
    @Published var dayImageData: Data?
    
    init(repository: RepositoryActions) {
        self.repository = repository
    }
}
extension PicOfDayViewModel{
    
    @MainActor
    func getPictureOfTheDay(for date: String) async{
        viewState = .loading
        do{
            let result = try await repository.getPictureOfTheDayData(for: date)
            viewState = .loaded(result)
            if let imageUrl = result.mediaType == "image" ? result.url : nil {
                let imageData = try? await repository.loadImage(for: imageUrl)
                DispatchQueue.main.async{
                    self.dayImageData = imageData
                }
            }
        }catch{
            viewState = .error(error)
        }
    }
    
}
