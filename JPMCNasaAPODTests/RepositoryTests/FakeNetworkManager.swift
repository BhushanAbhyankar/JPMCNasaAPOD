//
//  FakeNetworkManager.swift
//  JPMCNasaAPODTests
//
//  Created by Bhushan Abhyankar on 12/11/2024.
//

import Foundation
@testable import JPMCNasaAPOD

class FakeNetworkManager:NetworkActions {
    var mockPath = ""
    private var imageData: Data?
    private var error: NetworkError?

    
    func request<T>(endpoint: any JPMCNasaAPOD.Endpoint, from type: T.Type) async throws -> T where T : Decodable {
        let bundle = Bundle(for: FakeNetworkManager.self)
        let url = bundle.url(forResource: mockPath, withExtension: "json")
        guard let url = url else{
            throw NetworkError.invalidURL
        }
        do{
            let fileData = try Data(contentsOf: url)
            let parsedList = try JSONDecoder().decode(type, from: fileData)
            return parsedList
        }catch{
            throw error
        }
        
    }
    
    func requestData(url: URL) async throws -> Data {
        if error != nil{
            throw error!
        }
        return imageData!
    }
    
    func setimageData(data:Data){
        self.imageData = data
    }
    
}
