//
//  MovieCreditsViewModelFailureTests.swift
//  SimpleMovieAppTests
//
//  Created by Tow Ching Shen on 04/08/2024.
//

import XCTest
@testable import SimpleMovieApp

final class MovieCreditsViewModelFailureTests: XCTestCase {
    private var networkMock: MovieNetworkManagerImpl!
    private var vm: MovieCreditsViewModel!

    override func setUp() {
        networkMock = NetworkManagerMovieCreditsListResponseFailureMock()
        vm = MovieCreditsViewModel(networkManagerImpl: networkMock)
    }
    
    override func tearDown() {
        networkMock = nil
        vm = nil
    }
    
    func test_with_unsuccessful_response_error_is_handled() async {
        XCTAssertFalse(vm.isLoading, "The Movie Credits view model shouldn't be loading any data")
        
        defer {
            XCTAssertFalse(vm.isLoading, "The Movie Credits view model shouldn't be loading any data")
        }
        
        await vm.fetchMovieCredits(movie_id: 0)
        
        XCTAssertTrue(vm.hasError, "The Movie Credits view model error should be true")
        
        XCTAssertNotNil(vm.error, "The Movie Credits view model error should not be nil")
    }
}
