//
//  Networking.swift
//  JPMCNasaAPOD
//
//  Created by Bhushan Abhyankar on 11/11/2024.
//

import Foundation
protocol NetworkActions {
    func request<T:Decodable>(endpoint: Endpoint, from type:T.Type) async throws -> T
    func requestData(url:URL) async throws -> Data
}

protocol JSONDecoding {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) async throws -> T
}

typealias Networking = NetworkActions & JSONDecoding

