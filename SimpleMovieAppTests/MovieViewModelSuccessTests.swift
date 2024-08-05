//
//  MovieViewModelSuccessTests.swift
//  SimpleMovieAppTests
//
//  Created by Tow Ching Shen on 04/08/2024.
//

import XCTest
@testable import SimpleMovieApp

final class MovieViewModelSuccessTests: XCTestCase {
    private var networkMock: MovieNetworkManagerImpl!
    private var vm: MovieViewModel!
    
    override func setUp() {
        networkMock = NetworkManagerMovieListResponseSuccessMock()
        vm = MovieViewModel(networkManagerImpl: networkMock)
    }
    
    override func tearDown() {
        networkMock = nil
        vm = nil
    }

    func test_with_successful_response_weather_details_is_set() async throws {
        XCTAssertFalse(vm.isLoading, "The Movie view model shouldn't be loading any data")
        
        defer {
            XCTAssertFalse(vm.isLoading, "The Movie view model shouldn't be loading any data")
        }
        
        await vm.fetchMovie()
        
        XCTAssertNotNil(vm.movieModel, "The Movie detail in the view model should not be nil")
        
        let movie_list_data = try StaticJSONMapper.decode(file: "MovieList", type: MovieModel.self)
        
        XCTAssertEqual(vm.movieModel, movie_list_data, "The movie list response from our netwrk mock should match")
    }
}
