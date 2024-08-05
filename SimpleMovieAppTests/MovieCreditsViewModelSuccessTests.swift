//
//  MovieCreditsViewModelSuccessTests.swift
//  SimpleMovieAppTests
//
//  Created by Tow Ching Shen on 04/08/2024.
//

import XCTest
@testable import SimpleMovieApp

final class MovieCreditsViewModelSuccessTests: XCTestCase {
    private var networkMock: MovieNetworkManagerImpl!
    private var vm: MovieCreditsViewModel!
    
    override func setUp() {
        networkMock = NetworkManagerMovieCreditsListResponseSuccessMock()
        vm = MovieCreditsViewModel(networkManagerImpl: networkMock)
    }
    
    override func tearDown() {
        networkMock = nil
        vm = nil
    }

    func test_with_successful_response_weather_details_is_set() async throws {
        XCTAssertFalse(vm.isLoading, "The Movie Credits view model shouldn't be loading any data")
        
        defer {
            XCTAssertFalse(vm.isLoading, "The Movie Credits view model shouldn't be loading any data")
        }
        
        await vm.fetchMovieCredits(movie_id: 533535)
        
        XCTAssertNotNil(vm.movieCreditsModel, "The Movie Credits detail in the view model should not be nil")
        
        let movie_credits_list_data = try StaticJSONMapper.decode(file: "MovieCreditsList", type: MovieDetailCredits.self)
        
        XCTAssertEqual(vm.movieCreditsModel, movie_credits_list_data, "The movie credits list response from our netwrk mock should match")
    }
}
