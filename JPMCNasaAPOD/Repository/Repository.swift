//
//  Repository.swift
//  JPMCNasaAPOD
//
//  Created by Bhushan Abhyankar on 11/11/2024.
//

import Foundation

protocol RepositoryActions{
    func getPictureOfTheDayData(for date: String) async throws -> PicOfDayResponse
    func loadImage(for url: String) async throws -> Data?
}
final class PicOfDayRepository{
    private var manager: NetworkActions
    private let cacheManager: CacheManagerActions

    init(manager:NetworkActions, cacheManager: CacheManagerActions) {
        self.manager = manager
        self.cacheManager = cacheManager
    }
}
extension PicOfDayRepository:RepositoryActions{
   
    func getPictureOfTheDayData(for date: String)  async throws -> PicOfDayResponse  {
        let cacheKey = date
        
        // Trying to fetch cached data if available
        if let cachedResponse: PicOfDayResponse = cacheManager.loadCachedData(key: cacheKey, as: PicOfDayResponse.self) {
            return cachedResponse
        }
        do{
            let result = try await manager.request(endpoint: PicOfDayEndpoint.loadAPOD(for: date), from: PicOfDayResponse.self)
            print(result)
            cacheManager.cacheData(result, key: cacheKey)
            return result
        }catch{
            print(error.localizedDescription)
            throw error
        }
    }
    
    func loadImage(for url: String) async throws -> Data? {
        if let cachedImageData = cacheManager.loadCachedImageData(for: url) {
            return cachedImageData
        }
        guard let imageUrl = URL(string: url) else { throw NetworkError.invalidURL}
            let imageData = try? await manager.requestData(url: imageUrl)
            return imageData
        
    }
}
