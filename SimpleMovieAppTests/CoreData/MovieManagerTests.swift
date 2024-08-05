//
//  MovieManagerTests.swift
//  SimpleMovieAppTests
//
//  Created by Tow Ching Shen on 05/08/2024.
//

import XCTest
import CoreData
@testable import SimpleMovieApp

final class MovieManagerTests: XCTestCase {
    
    var movieManager: MovieManager!
    var coreDataStack: CoreDataTestStack!

    override func setUp() {
        super.setUp()
        coreDataStack = CoreDataTestStack()
        movieManager = MovieManager(mainContext: coreDataStack.mainContext)
    }
    
    func test_create_movies() throws {
        let movie_list = try XCTUnwrap(StaticJSONMapper.decode(file: "MovieList", type: MovieModel.self), "Movie list should not be nil")
        
        movieManager.createMovies(data_for_saving: movie_list.results)
        let movies = movieManager.fetchMovies()

        XCTAssertNotNil(movies, "Movie shouldn't be nil")
        XCTAssertEqual(movies?.count, 20, "Movie count should be 20")
        
        let filter_movie = movies?.filter({ $0.original_title == "Deadpool & Wolverine" }).first
        
        XCTAssertNotNil(filter_movie, "Filter movie shouldn't be nil")
        
        XCTAssertEqual(filter_movie?.movie_id, 533535, "Movie first ID should be 533535")
        XCTAssertEqual(
            filter_movie?.original_title,
            "Deadpool & Wolverine",
            "Movie list results first originale title should be Deadpool & Wolverine"
        )
        XCTAssertEqual(
            filter_movie?.overview,
            "A listless Wade Wilson toils away in civilian life with his days as the morally flexible mercenary, Deadpool, behind him. But when his homeworld faces an existential threat, Wade must reluctantly suit-up again with an even more reluctant Wolverine.",
            "Movie list results first overview should be A listless Wade Wilson toils away in civilian life with his days as the morally flexible mercenary, Deadpool, behind him. But when his homeworld faces an existential threat, Wade must reluctantly suit-up again with an even more reluctant Wolverine."
        )
        XCTAssertEqual(
            filter_movie?.poster_path,
            "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg",
            "Movie list results first poster path should be /8cdWjvZQUExUUTzyp4t6EDMubfO.jpg"
        )
        XCTAssertEqual(
            filter_movie?.vote_average,
            7.979,
            "Movie list results first vote average should be 7.979"
        )
    }
    
    func test_check_movie_exists() throws {
        let movie_list = try XCTUnwrap(StaticJSONMapper.decode(file: "MovieList", type: MovieModel.self), "Movie list should not be nil")
        
        movieManager.createMovies(data_for_saving: movie_list.results)
        
        XCTAssertTrue(movieManager.checkMovieListExists(), "Check movie list exists should be true")
    }
    
    func test_check_movie_not_exists() throws {
        XCTAssertFalse(movieManager.checkMovieListExists(), "Check movie list exists should be false")
    }
    
    func test_convert_to_movie_detail() throws {
        let movie_list = try XCTUnwrap(StaticJSONMapper.decode(file: "MovieList", type: MovieModel.self), "Movie list should not be nil")
        
        movieManager.createMovies(data_for_saving: movie_list.results)
        
        let movie_details = movieManager.convertToMovieDetail()
        
        XCTAssertEqual(movie_details.count, 20, "Movie count should be 20")
        
        let filter_movie_details = movie_details.filter({ $0.originalTitle == "Deadpool & Wolverine" }).first
        
        XCTAssertEqual(filter_movie_details?.id, 533535, "Movie first ID should be 533535")
        XCTAssertEqual(
            filter_movie_details?.originalTitle,
            "Deadpool & Wolverine",
            "Movie list results first originale title should be Deadpool & Wolverine"
        )
        XCTAssertEqual(
            filter_movie_details?.overview,
            "A listless Wade Wilson toils away in civilian life with his days as the morally flexible mercenary, Deadpool, behind him. But when his homeworld faces an existential threat, Wade must reluctantly suit-up again with an even more reluctant Wolverine.",
            "Movie list results first overview should be A listless Wade Wilson toils away in civilian life with his days as the morally flexible mercenary, Deadpool, behind him. But when his homeworld faces an existential threat, Wade must reluctantly suit-up again with an even more reluctant Wolverine."
        )
        XCTAssertEqual(
            filter_movie_details?.posterPath,
            "/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg",
            "Movie list results first poster path should be /8cdWjvZQUExUUTzyp4t6EDMubfO.jpg"
        )
        XCTAssertEqual(
            filter_movie_details?.voteAverage,
            7.979,
            "Movie list results first vote average should be 7.979"
        )
    }
}
