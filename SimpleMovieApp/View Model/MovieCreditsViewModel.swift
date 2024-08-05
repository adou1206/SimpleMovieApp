//
//  MovieDetailsViewModel.swift
//  SimpleMovieApp
//
//  Created by Tow Ching Shen on 04/08/2024.
//

import Foundation

final class MovieCreditsViewModel {
    private (set) var movieCreditsModel: MovieDetailCredits?
    private (set) var error: MovieNetworkManager.NetworkError?
    @Published private (set) var isLoading: Bool = false
    private (set) var hasError: Bool = false
    
    private let networkManager: MovieNetworkManagerImpl!
    
    init(
        networkManagerImpl: MovieNetworkManagerImpl = MovieNetworkManager.shared
    ) {
        self.networkManager = networkManagerImpl
    }
    
    @MainActor
    func fetchMovieCredits(
        movie_id: Int
    ) async {
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            movieCreditsModel = try await networkManager.request(
                session: .shared,
                endpoint: .movie_credits(movie_id: movie_id),
                type: MovieDetailCredits.self
            )
        }catch {
            hasError = true
            
            if let networkError = error as? MovieNetworkManager.NetworkError {
                self.error = networkError
            }else {
                self.error = .custom(error: error)
            }
        }
    }
}
