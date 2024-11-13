//
//  CacheManager.swift
//  JPMCNasaAPOD
//
//  Created by Bhushan Abhyankar on 12/11/2024.
//

import Foundation

protocol CacheManagerActions {
    func cacheData<T: Codable>(_ data: T, key: String)
    func loadCachedData<T: Codable>(key: String, as type: T.Type) -> T?
    func cacheImageData(_ imageData: Data, for url: String)
    func loadCachedImageData(for url: String) -> Data?
}

class CacheManager:CacheManagerActions {
    static let shared = CacheManager()
    private let imageCache = NSCache<NSString, NSData>()
    private let cacheExpiryTime: TimeInterval = 60 * 60 * 24 // 24 hours

    private init() {}
    
    // MARK: - API data Caching Logic
    func cacheData<T: Codable>(_ data: T, key: String) {
        let fileURL = cacheFileURL(for: key)
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(data) {
            try? encodedData.write(to: fileURL)
            updateCacheTimestamp(for: fileURL)
        }
    }
    
    func loadCachedData<T: Codable>(key: String, as type: T.Type) -> T? {
        let fileURL = cacheFileURL(for: key)
        guard isCacheValid(for: fileURL),
              let data = try? Data(contentsOf: fileURL),
              let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
            return nil
        }
        return decodedData
    }
    
    // MARK: - Image Caching Logic
    func cacheImageData(_ imageData: Data, for url: String) {
        let cacheKey = urlToFileName(url)
        imageCache.setObject(imageData as NSData, forKey: cacheKey as NSString)
        
        let fileURL = cacheFileURL(for: cacheKey)
        try? imageData.write(to: fileURL)
        updateCacheTimestamp(for: fileURL)
    }
    
    func loadCachedImageData(for url: String) -> Data? {
        let cacheKey = urlToFileName(url)
        
        if let cachedImageData = imageCache.object(forKey: cacheKey as NSString) {
            return cachedImageData as Data
        }
        
        let fileURL = cacheFileURL(for: cacheKey)
        guard isCacheValid(for: fileURL),
              let imageData = try? Data(contentsOf: fileURL) else {
            return nil
        }
        
        imageCache.setObject(imageData as NSData, forKey: cacheKey as NSString)
        return imageData
    }

    // MARK: - Internal Helper Methods
    private func cacheFileURL(for key: String) -> URL {
        let fileName = urlToFileName(key)
        return getDocumentsDirectory().appendingPathComponent(fileName)
    }
    
    private func urlToFileName(_ url: String) -> String {
        return String(url.hashValue)
    }
    
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func updateCacheTimestamp(for fileURL: URL) {
        let timestamp = Date().timeIntervalSince1970
        try? (String(timestamp).data(using: .utf8))?.write(to: fileURL.appendingPathExtension("timestamp"))
    }
    
    private func isCacheValid(for fileURL: URL) -> Bool {
        let timestampURL = fileURL.appendingPathExtension("timestamp")
        guard let timestampData = try? Data(contentsOf: timestampURL),
              let timestampString = String(data: timestampData, encoding: .utf8),
              let timestamp = TimeInterval(timestampString) else {
            return false
        }
        return Date().timeIntervalSince1970 - timestamp < cacheExpiryTime
    }
    
    func clearCache() {
        imageCache.removeAllObjects()
        let fileManager = FileManager.default
        if let documentURL = try? fileManager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false) {
            try? fileManager.contentsOfDirectory(at: documentURL, includingPropertiesForKeys: nil).forEach { url in
                try? fileManager.removeItem(at: url)
            }
        }
    }
}
