//
//  MovieNetworkManagerTests.swift
//  SimpleMovieAppTests
//
//  Created by Tow Ching Shen on 04/08/2024.
//

import XCTest
@testable import SimpleMovieApp

final class MovieListNetworkManagerTests: XCTestCase {
    private var session: URLSession!
    private var url: URL!
    
    override func setUp() {
        url = URL(string: "https://api.themoviedb.org/")
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLSessionProtocol.self]
        session = URLSession(configuration: configuration)
    }
    
    override func tearDown() {
        url = nil
        session = nil
    }

    func test_with_successful_response_response_is_valid() async throws {
        guard let path = Bundle.main.path(forResource: "MovieList", ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            XCTFail("Failed to get the MovieList file")
            return
        }
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(
                url: self.url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            
            return (response!, data, nil)
        }
        
        let res = try await MovieNetworkManager.shared.request(
            session: session,
            endpoint: .movie_list,
            type: MovieModel.self
        )

        let staticJSON = try StaticJSONMapper.decode(file: "MovieList", type: MovieModel.self)

        XCTAssertEqual(res, staticJSON, "The returned MovieModel response should be decoded properly")
    }
    
    func test_with_unsucessful_response_code_in_invalid_range_is_invalid() async {
        let invalidStatusCode: Int = 400
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(
                url: self.url,
                statusCode: invalidStatusCode,
                httpVersion: nil,
                headerFields: nil
            )
            
            return (response!, nil, nil)
        }
        
        do {
            _ = try await MovieNetworkManager.shared.request(
                session: session,
                endpoint: .movie_list,
                type: MovieModel.self
            )
            
        }catch {
            guard let networkError = error as? MovieNetworkManager.NetworkError else {
                XCTFail("Got the wrong type of error, expecting Weather NetworkingManager NetworkingError")
                return
            }
            
            XCTAssertEqual(
                networkError,
                MovieNetworkManager.NetworkError.invalidStatusCode(statusCode: invalidStatusCode),
                "Error should be a Weather networking error which throws an invalid status code"
            )
        }
    }
    
    func test_with_successful_response_with_invalid_json_is_invalid() async {
        guard let path = Bundle.main.path(forResource: "MovieList", ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            XCTFail("Failed to get the MovieList file")
            return
        }
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(
                url: self.url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )
            
            return (response!, data, nil)
        }
        
        do {
            _ = try await MovieNetworkManager.shared.request(
                session: session,
                endpoint: .movie_list,
                type: MovieDetail.self
            )
            
        }catch {
            if error is MovieNetworkManager.NetworkError {
                XCTFail("The error should be a system decoding error (Movie List)")
            }
        }
    }
}
