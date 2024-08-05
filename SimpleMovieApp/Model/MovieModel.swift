//
//  MovieModel.swift
//  SimpleMovieApp
//
//  Created by Tow Ching Shen on 03/08/2024.
//

import Foundation

struct MovieModel: Decodable, Equatable {
    let page: Int
    let results: [MovieDetail]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieDetail: Decodable, Equatable {
    let id: Int
    let originalTitle: String
    let overview: String
    let posterPath: String
    let voteAverage: Double
//    var credits: MovieDetailCredits? = nil
    
    enum CodingKeys: String, CodingKey {
        case id, overview//, credits
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
    }
    
    func posterURL(size: posterSize = .original) -> String? {
        return "https://image.tmdb.org/t/p/\(size)\(posterPath)"
    }
    
    func ratingValue() -> Double {
        return ((voteAverage / 10) * 5).round(to: 4)
    }
}

struct MovieDetailCredits: Decodable, Equatable {
    let cast: [MovieDetailCreditsCast]
    let crew: [MovieDetailCreditsCrew]
}

struct MovieDetailCreditsCast: Decodable, Equatable {
    let originalName: String
    let profilePath: String?
    let character: String
    
    enum CodingKeys: String, CodingKey {
        case originalName = "original_name"
        case profilePath = "profile_path"
        case character
    }
}

struct MovieDetailCreditsCrew: Decodable, Equatable {
    let originalName: String
    let profilePath: String?
    let job: String
    
    enum CodingKeys: String, CodingKey {
        case originalName = "original_name"
        case profilePath = "profile_path"
        case job
    }
}

enum posterSize: String {
    case original = "original"
    case w92 = "w92"
    case w154 = "w154"
    case w185 = "w185"
    case w342 = "w342"
    case w500 = "w500"
    case w780 = "w780"
}
