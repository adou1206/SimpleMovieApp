//
//  MovieCreditsListJSONMapperTests.swift
//  SimpleMovieAppTests
//
//  Created by Tow Ching Shen on 04/08/2024.
//

import XCTest
@testable import SimpleMovieApp

final class MovieCreditsListJSONMapperTests: XCTestCase {
    func test_with_valid_json_successfully_decodes() {
        XCTAssertNoThrow(try StaticJSONMapper.decode(file: "MovieCreditsList", type: MovieDetailCredits.self), "Mapper shouldn't throw an error (MovieDetailCredits)")

        let movie_credits_list = try? StaticJSONMapper.decode(file: "MovieCreditsList", type: MovieDetailCredits.self)
        
        XCTAssertNotNil(movie_credits_list, "Movie credits list shouldn't be nil")
        
        XCTAssertEqual(movie_credits_list?.cast.count, 57, "Movie credits list cast count should be 57")
        XCTAssertEqual(movie_credits_list?.crew.count, 88, "Movie credits list crew count should be 88")

        
        XCTAssertEqual(
            movie_credits_list?.cast[0].originalName,
            "Ryan Reynolds",
            "Movie credits list cast first original name should be Ryan Reynolds"
        )
        XCTAssertEqual(
            movie_credits_list?.cast[0].profilePath,
            "/2Orm6l3z3zukF1q0AgIOUqvwLeB.jpg",
            "Movie credits list cast first profile path should be /2Orm6l3z3zukF1q0AgIOUqvwLeB.jpg"
        )
        XCTAssertEqual(
            movie_credits_list?.cast[0].character,
            "Wade Wilson / Deadpool / Nicepool",
            "Movie credits list cast first character should be Wade Wilson / Deadpool / Nicepool"
        )
        
        XCTAssertEqual(
            movie_credits_list?.crew[0].originalName,
            "Fabian Nicieza",
            "Movie credits list cast first original name should be Fabian Nicieza"
        )
        XCTAssertEqual(
            movie_credits_list?.crew[0].profilePath,
            "/vV0VKVThe1o6fyS6SCRAlVNVdLX.jpg",
            "Movie credits list cast first profile path should be /vV0VKVThe1o6fyS6SCRAlVNVdLX.jpg"
        )
        XCTAssertEqual(
            movie_credits_list?.crew[0].job,
            "Characters",
            "Movie credits list cast first character should be Characters"
        )
    }
    
    func test_with_missing_file_error_thrown() {
        XCTAssertThrowsError(try StaticJSONMapper.decode(file: "", type: MovieDetailCredits.self), "An error should be thrown (MovieDetailCredits)")
        
        do {
            _ = try StaticJSONMapper.decode(file: "", type: MovieDetailCredits.self)
            
        }catch {
            guard let mappingError = error as? StaticJSONMapper.MappingError else {
                XCTFail("This is the wrong type of error for missing files (MovieDetailCredits)")
                return
            }
            
            XCTAssertEqual(
                mappingError,
                StaticJSONMapper.MappingError.failedToGetContents,
                "This should be a failed to get contents error (MovieDetailCredits)"
            )
        }
    }
    
    func test_with_invalid_file_error_thrown() {
        XCTAssertThrowsError(try StaticJSONMapper.decode(file: "nnnnnn", type: MovieDetailCredits.self), "An error should be thrown (MovieDetailCredits)")
        
        do {
            _ = try StaticJSONMapper.decode(file: "nnnnnn", type: MovieDetailCredits.self)
            
        }catch {
            guard let mappingError = error as? StaticJSONMapper.MappingError else {
                XCTFail("This is the wrong type of error for missing files (MovieDetailCredits)")
                return
            }
            
            XCTAssertEqual(mappingError,
                           StaticJSONMapper.MappingError.failedToGetContents,
                           "This should be a failed to get contents error (MovieDetailCredits)"
            )
        }
    }
}
