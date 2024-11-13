//
//  MockPicOfDayRepository.swift
//  JPMCNasaAPOD
//
//  Created by Bhushan Abhyankar on 12/11/2024.
//

import Foundation
@testable import JPMCNasaAPOD

class MockPicOfDayRepository{
    private var error: NetworkError?
    private var picOfDayResponse: PicOfDayResponse?
    private var imageData: Data?
    
    func setPicOfDayResponse(picOfDayResponse:PicOfDayResponse){
        self.picOfDayResponse = picOfDayResponse
    }
    
    func setError(error:NetworkError){
        self.error = error
    }
    
    func setimageData(data:Data){
        self.imageData = data
    }
 
}
extension MockPicOfDayRepository:RepositoryActions{
    func getPictureOfTheDayData(for date: String) async throws -> JPMCNasaAPOD.PicOfDayResponse {
        if error != nil{
            throw error!
        }
        return picOfDayResponse!
    }
    
    func loadImage(for url: String) async throws -> Data? {
        if error != nil{
            throw error!
        }
        if let imageData = imageData{
            return imageData
        }
        return nil
    }
}
