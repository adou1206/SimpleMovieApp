//
//  Endpoint.swift
//  SimpleMovieApp
//
//  Created by Tow Ching Shen on 03/08/2024.
//

import Foundation

enum MovieEndpoint {
    case movie_list
    case movie_credits(movie_id: Int)
}

extension MovieEndpoint {
    enum MethodType: Equatable {
        case GET
    }
}

extension MovieEndpoint {
    var moview_api_key: String {
        return "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1NjhmZTE4ODBkYjdjYWYxNzA0MGE1OGYwNGQ5YTA3ZCIsIm5iZiI6MTcyMjY3MjQxMy4yMjQ5MDIsInN1YiI6IjY2YWRlM2M0OTkzMzk4OTk1MzUyMmNiNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Z8jmFg6eZIpUZJHP0lZMD9Xkyo3kpONT9tnEAprYgkI"
    }
    
    var host: String {
        return "api.themoviedb.org"
    }
    
    var methodType: MethodType {
        switch self {
        case .movie_list, .movie_credits(_):
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .movie_list:
            return "/3/discover/movie"
            
        case .movie_credits(movie_id: let movie_id):
            return "/3/movie/\(movie_id)/credits"
        }
    }
    
    var queryItems: [String: String] {
        switch self {
        case .movie_list:
//            let parameter: [String: String] = [
//                "include_video" : "false",
//                "include_adult" : "false",
//                "sort_by": "popularity.desc",
//                "page": "1"
//            ]
//            
//            return parameter
            // "append_to_response": "credits", for getting caster list within movie details API
            return [:]
            
        case .movie_credits(_):
            return [:]
        }
    }
    
    var headerQueryItems: [String: String] {
        return [
            "accept": "application/json",
            "Authorization": "Bearer \(moview_api_key)"
        ]
    }
}

extension MovieEndpoint {
    var url: URL? {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = host
        urlComponent.path = path
        
        if queryItems.count > 0 {
            urlComponent.setQueryItems(with: queryItems)
        }
        
        return urlComponent.url
    }
}
