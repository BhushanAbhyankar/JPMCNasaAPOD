//
//  APIEndpoint.swift
//  JPMCNasaAPOD
//
//  Created by Bhushan Abhyankar on 11/11/2024.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}


protocol Endpoint {
    var baseURL: URL { get }
    var path: String { get }
    var headers: [String: String] { get }
    var parameters: [String: String] { get }
    var method: HTTPMethod { get }
}

struct PicOfDayEndpoint: Endpoint {
    let baseURL: URL = .init(string: "https://api.nasa.gov")!
    let path: String = "/planetary/apod"
    let headers: [String: String] = [:]
    var parameters: [String : String] = [:]
    let method: HTTPMethod = .get
}

extension PicOfDayEndpoint {
    static func loadAPOD(for date: String) -> Self {
        let parameters: [String: String] = [
            "api_key": APISecretsManager.NasaAPODApiKey, 
            "date": date
        ]
        return PicOfDayEndpoint(parameters: parameters)
    }
}
