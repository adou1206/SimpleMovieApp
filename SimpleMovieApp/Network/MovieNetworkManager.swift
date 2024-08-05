//
//  MovieNetworkManager.swift
//  SimpleMovieApp
//
//  Created by Tow Ching Shen on 03/08/2024.
//

import Foundation

protocol MovieNetworkManagerImpl {
    func request<U: Decodable>(
        session: URLSession,
        endpoint: MovieEndpoint,
        type: U.Type
    ) async throws -> U
}

final class MovieNetworkManager: MovieNetworkManagerImpl {
    static let shared = MovieNetworkManager()
    
    private init() {}
    
    func request<U>(session: URLSession, endpoint: MovieEndpoint, type: U.Type) async throws -> U where U : Decodable {
        guard let request = buildRequest(endpoint: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(for: request)
        print("decode response json: \(String(data: data, encoding: .utf8)!)")
        guard let response = response as? HTTPURLResponse,
              (200...300) ~= response.statusCode else {
            let statusCode = (response as! HTTPURLResponse).statusCode
            throw NetworkError.invalidStatusCode(statusCode: statusCode)
        }
        
        return try JSONDecoder().decode(U.self, from: data)
    }
}

extension MovieNetworkManager {
    enum NetworkError: LocalizedError {
        case invalidURL
        case custom(error: Error)
        case invalidStatusCode(statusCode: Int)
        case invalidData
        case failedToDecode(error: Error)
    }
}

extension MovieNetworkManager.NetworkError: Equatable {
    static func == (lhs: MovieNetworkManager.NetworkError, rhs: MovieNetworkManager.NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
            
        case (.custom(let lhsType), .custom(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
            
        case (.invalidStatusCode(let lhsType), .invalidStatusCode(let rhsType)):
            return lhsType == rhsType
            
        case (.invalidData, .invalidData):
            return true
            
        case (.failedToDecode(let lhsType), .failedToDecode(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
            
        default:
            return false
        }
    }
}

extension MovieNetworkManager.NetworkError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL isn't valid"
            
        case .custom(error: let error):
            return "Something went wrong.\n \(error.localizedDescription)"
            
        case .invalidStatusCode(_):
            return "Status code falls into the wrong range"
            
        case .invalidData:
            return "Response data is invalid"
            
        case .failedToDecode(_):
            return "Failed to decode"
        }
    }
}

private extension MovieNetworkManager {
    func buildRequest(
        endpoint: MovieEndpoint
    ) -> URLRequest? {
        guard let url = endpoint.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        
        switch endpoint.methodType {
        case .GET:
            request.httpMethod = "GET"
        }
        
        request.allHTTPHeaderFields = endpoint.headerQueryItems
        
        return request
    }
}
