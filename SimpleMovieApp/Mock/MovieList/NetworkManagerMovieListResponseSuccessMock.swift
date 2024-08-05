//
//  NetworkManagerMovieListResponseSuccessMock.swift
//  SimpleMovieApp
//
//  Created by Tow Ching Shen on 04/08/2024.
//

import Foundation

class NetworkManagerMovieListResponseSuccessMock: MovieNetworkManagerImpl {
    func request<U>(
        session: URLSession,
        endpoint: MovieEndpoint,
        type: U.Type
    ) async throws -> U where U : Decodable {
        return try StaticJSONMapper.decode(file: "MovieList", type: MovieModel.self) as! U
    }
}
