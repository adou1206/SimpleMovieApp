//
//  MovieListEndpointTests.swift
//  SimpleMovieAppTests
//
//  Created by Tow Ching Shen on 04/08/2024.
//

import XCTest
@testable import SimpleMovieApp

final class MovieListEndpointTests: XCTestCase {
    func test_with_detail_endpoint_request_is_valid() {
        let endpoint: MovieEndpoint = .movie_list
        
        XCTAssertEqual(endpoint.host, "api.themoviedb.org", "The host should be api.themoviedb.org")
        XCTAssertEqual(endpoint.path, "/3/discover/movie", "The path should be /3/discover/movie")
        XCTAssertEqual(endpoint.methodType, .GET, "The methodType should be .GET")
        XCTAssertEqual(
            endpoint.queryItems,
            [:],
            "The queryItems should be []"
        )
        
        XCTAssertEqual(
            endpoint.url?.absoluteString,
            "https://api.themoviedb.org/3/discover/movie",
            "The generated doesn't match our endpoint (Movie List)"
        )
    }
}
