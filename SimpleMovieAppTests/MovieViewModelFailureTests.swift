//
//  MovieListViewModelFailureTests.swift
//  SimpleMovieAppTests
//
//  Created by Tow Ching Shen on 04/08/2024.
//

import XCTest
@testable import SimpleMovieApp

final class MovieViewModelFailureTests: XCTestCase {
    private var networkMock: MovieNetworkManagerImpl!
    private var vm: MovieViewModel!

    override func setUp() {
        networkMock = NetworkManagerMovieListResponseFailureMock()
        vm = MovieViewModel(networkManagerImpl: networkMock)
    }
    
    override func tearDown() {
        networkMock = nil
        vm = nil
    }
    
    func test_with_unsuccessful_response_error_is_handled() async {
        XCTAssertFalse(vm.isLoading, "The Movie view model shouldn't be loading any data")
        
        defer {
            XCTAssertFalse(vm.isLoading, "The Movie view model shouldn't be loading any data")
        }
        
        await vm.fetchMovie()
        
        XCTAssertTrue(vm.hasError, "The Movie view model error should be true")
        
        XCTAssertNotNil(vm.error, "The Movie view model error should not be nil")
    }
}
