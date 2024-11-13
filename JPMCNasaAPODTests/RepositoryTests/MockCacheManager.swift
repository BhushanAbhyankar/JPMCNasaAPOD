//
//  MockCacheManager.swift
//  JPMCNasaAPODTests
//
//  Created by Bhushan Abhyankar on 12/11/2024.
//

import Foundation
@testable import JPMCNasaAPOD

class MockCacheManager: CacheManagerActions {
    
    
    private var cachedData: [String: Any] = [:]
    private var cachedImages: [String: Data] = [:] 
    
    func cacheData<T: Codable>(_ data: T, key: String) {
        cachedData[key] = data
    }
    
    func loadCachedData<T: Codable>(key: String, as type: T.Type) -> T? {
        return cachedData[key] as? T
    }
    
    func cacheImageData(_ imageData: Data, for url: String) {
        cachedImages[url] = imageData
    }
    
    func loadCachedImageData(for url: String) -> Data? {
        return cachedImages[url]
    }
    
    func clearCache() {
        cachedData.removeAll()
        cachedImages.removeAll()
    }
    
}
