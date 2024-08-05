//
//  NetworkManagerMovieCreditsListResponseSuccessMock.swift
//  SimpleMovieApp
//
//  Created by Tow Ching Shen on 04/08/2024.
//

import Foundation

class NetworkManagerMovieCreditsListResponseSuccessMock: MovieNetworkManagerImpl {
    func request<U>(
        session: URLSession,
        endpoint: MovieEndpoint,
        type: U.Type
    ) async throws -> U where U : Decodable {
        return try StaticJSONMapper.decode(file: "MovieCreditsList", type: MovieDetailCredits.self) as! U
    }
}
