//
//  NetworkError.swift
//  JPMCNasaAPOD
//
//  Created by Bhushan Abhyankar on 11/11/2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidURLComponents
    case invalidHTTPMethod
    case decodingError
}

extension NetworkError:LocalizedError{
    var errorDescription: String?{
        switch self{
        case .invalidURL:
            return NSLocalizedString("API EndPoint URL is Invalid", comment: "invalidURL")
        case .invalidResponse:
            return NSLocalizedString("Got Invalid response code from API Endpoint,No data available for this date", comment: "invalidResponse")
        case .invalidURLComponents:
            return NSLocalizedString("InCorect URL parameters", comment: "invalidURLComponents")
        case .invalidHTTPMethod:
            return NSLocalizedString("API Failed to give data", comment: "invalidHTTPMethod")
        case .decodingError:
            return NSLocalizedString("Failed to parse API Resonse", comment: "decodingError")

        }
    }
}
