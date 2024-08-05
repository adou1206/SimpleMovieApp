//
//  MovieListJSONMapperTests.swift
//  SimpleMovieAppTests
//
//  Created by Tow Ching Shen on 04/08/2024.
//

import XCTest
@testable import SimpleMovieApp

final class MovieListJSONMapperTests: XCTestCase {
    func test_with_valid_json_successfully_decodes() {
        XCTAssertNoThrow(try StaticJSONMapper.decode(file: "MovieList", type: MovieModel.self), "Mapper shouldn't throw an error (MovieModel)")
        
        let movie_list = try? StaticJSONMapper.decode(file: "MovieList", type: MovieModel.self)
        
        XCTAssertNotNil(movie_list, "Movie list shouldn't be nil")
            
        XCTAssertEqual(movie_list?.page, 1, "Movie list page should be 1")
        XCTAssertEqual(movie_list?.totalPages, 45370, "Movie list total pages should be 45370")
        XCTAssertEqual(movie_list?.totalResults, 907384, "Movie list total results should be 907384")
        
        XCTAssertEqual(movie_list?.results.count, 20, "Movie list results count should be 20")
        
        XCTAssertEqual(movie_list?.results[0].id, 533535, "Movie list results first ID should be 533535")
        XCTAssertEqual(
            movie_list?.results[0].originalTitle,
            "Deadpool & Wolverine",
            "Movie list results first originale title should be Deadpool & Wolverine"
        )
        XCTAssertEqual(
            movie_list?.results[0].overview,
            "A listless Wade Wilson toils away in civilian life with his days as the morally flexible mercenary, Deadpool, behind him. But when his homeworld faces an existential threat, Wade must reluctantly suit-up again with an even more reluctant Wolverine.",
            "Movie list results first overview should be A listless Wade Wilson toils away in civilian life with his days as the morally flexible mercenary, Deadpool, behind him. But when his homeworld faces an existential threat, Wade must reluctantly suit-up again with an even more reluctant Wolverine."
        )
        XCTAssertEqual(
            movie_list?.results[0].posterPath,
            "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg",
            "Movie list results first poster path should be /8cdWjvZQUExUUTzyp4t6EDMubfO.jpg"
        )
        XCTAssertEqual(
            movie_list?.results[0].voteAverage,
            7.979,
            "Movie list results first vote average should be 7.979"
        )
        XCTAssertEqual(
            movie_list?.results[0].ratingValue(),
            3.9895,
            "Movie list results first rating value should be 3.9895"
        )
        XCTAssertEqual(
            movie_list?.results[0].posterURL(size: .original),
            "https://image.tmdb.org/t/p/original/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg",
            "Movie list results first poster URL with original should be https://image.tmdb.org/t/p/original/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg"
        )
        XCTAssertEqual(
            movie_list?.results[0].posterURL(size: .w500),
            "https://image.tmdb.org/t/p/w500/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg",
            "Movie list results first poster URL with w500 should be https://image.tmdb.org/t/p/w500/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg"
        )
    }
    
    func test_with_missing_file_error_thrown() {
        XCTAssertThrowsError(try StaticJSONMapper.decode(file: "", type: MovieModel.self), "An error should be thrown (MovieModel)")
        
        do {
            _ = try StaticJSONMapper.decode(file: "", type: MovieModel.self)
            
        }catch {
            guard let mappingError = error as? StaticJSONMapper.MappingError else {
                XCTFail("This is the wrong type of error for missing files (MovieModel)")
                return
            }
            
            XCTAssertEqual(
                mappingError,
                StaticJSONMapper.MappingError.failedToGetContents,
                "This should be a failed to get contents error (MovieModel)"
            )
        }
    }
    
    func test_with_invalid_file_error_thrown() {
        XCTAssertThrowsError(try StaticJSONMapper.decode(file: "nnnnnn", type: MovieModel.self), "An error should be thrown (MovieModel)")
        
        do {
            _ = try StaticJSONMapper.decode(file: "nnnnnn", type: MovieModel.self)
            
        }catch {
            guard let mappingError = error as? StaticJSONMapper.MappingError else {
                XCTFail("This is the wrong type of error for missing files (WeatherModel)")
                return
            }
            
            XCTAssertEqual(mappingError,
                           StaticJSONMapper.MappingError.failedToGetContents,
                           "This should be a failed to get contents error (WeatherModel)"
            )
        }
    }
}
