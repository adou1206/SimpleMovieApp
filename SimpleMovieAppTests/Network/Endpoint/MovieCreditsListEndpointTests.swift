//
//  MovieCreditsListEndpointTests.swift
//  SimpleMovieAppTests
//
//  Created by Tow Ching Shen on 04/08/2024.
//

import XCTest
@testable import SimpleMovieApp

final class MovieCreditsListEndpointTests: XCTestCase {
    func test_with_detail_endpoint_request_is_valid() {
        let movie_id: Int = 533535
        let endpoint: MovieEndpoint = .movie_credits(movie_id: movie_id)
        
        XCTAssertEqual(endpoint.host, "api.themoviedb.org", "The host should be api.themoviedb.org")
        XCTAssertEqual(endpoint.path, "/3/movie/\(movie_id)/credits", "The path should be /3/movie/\(movie_id)/credits")
        XCTAssertEqual(endpoint.methodType, .GET, "The methodType should be .GET")
        XCTAssertEqual(
            endpoint.queryItems,
            [:],
            "The queryItems should be []"
        )
        
        XCTAssertEqual(
            endpoint.url?.absoluteString,
            "https://api.themoviedb.org/3/movie/\(movie_id)/credits",
            "The generated doesn't match our endpoint (Movie Credits List)"
        )
    }
}
