//
//  NetworkManager.swift
//  JPMCNasaAPOD
//
//  Created by Bhushan Abhyankar on 11/11/2024.
//
import Foundation

class NetworkManager {
    
    let urlsession:URLSession
    
    init(urlsession: URLSession = URLSession.shared) {
        self.urlsession = urlsession
    }
    
}
extension NetworkManager:Networking{
    
    func request<T:Decodable>(endpoint: Endpoint, from type:T.Type) async throws -> T{
        var components = URLComponents(url: endpoint.baseURL.appendingPathComponent(endpoint.path), resolvingAgainstBaseURL: true)
        
        switch endpoint.method {
        case .get:
            components?.queryItems = endpoint.parameters.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        default:
            throw NetworkError.invalidHTTPMethod
        }
        
        guard let url = components?.url else {
            throw NetworkError.invalidURLComponents
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        do{
            let (data, response) = try await self.urlsession.data(for: request)
            
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            guard (200...299).contains(response.statusCode) else {
                throw NetworkError.invalidResponse
            }
            let parsedData = try await decode(type, from: data)
            return parsedData
        }catch{
            print(error.localizedDescription)
            throw error
        }
    }
    
    func decode<T>(_ type: T.Type, from data: Data) async throws -> T where T : Decodable {
        lazy var decoder = JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func requestData(url: URL) async throws -> Data {
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        }catch{
            print(error.localizedDescription)
            throw error
        }
    }
}
