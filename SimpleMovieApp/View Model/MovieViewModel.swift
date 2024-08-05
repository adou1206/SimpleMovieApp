//
//  MovieViewModel.swift
//  SimpleMovieApp
//
//  Created by Tow Ching Shen on 03/08/2024.
//

import Foundation

final class MovieViewModel {
    private (set) var movieModel: MovieModel?
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
    func fetchMovie() async {
        isLoading = true
        
        defer {
            isLoading = false
        }
        
        do {
            movieModel = try await networkManager.request(
                session: .shared,
                endpoint: .movie_list,
                type: MovieModel.self
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
