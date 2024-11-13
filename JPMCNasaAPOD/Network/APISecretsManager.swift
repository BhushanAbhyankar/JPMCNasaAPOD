//
//  APISecretsManager.swift
//  JPMCNasaAPOD
//
//  Created by Bhushan Abhyankar on 12/11/2024.
//

import Foundation

enum APISecretsManager {
    static func value(for key: String) -> String? {
        guard let filePath = Bundle.main.path(forResource: "APISecrets", ofType: "plist"),
              let plist = NSDictionary(contentsOfFile: filePath) else { return nil }
        return plist[key] as? String
    }

    static var NasaAPODApiKey: String {
        return value(for: "NASA_APOD_API_KEY") ?? ""
    }
}
