//
//  StaticJSONMapper.swift
//  SimpleMovieApp
//
//  Created by Tow Ching Shen on 04/08/2024.
//

import Foundation

struct StaticJSONMapper {
    static func decode<U: Decodable>(
        file: String,
        type: U.Type
    ) throws -> U {
//        print(file)
        guard !file.isEmpty,
                let path = Bundle.main.path(forResource: file, ofType: "json"),
                let data = FileManager.default.contents(atPath: path) else {
            throw MappingError.failedToGetContents
        }
//        print(data)
        return try JSONDecoder().decode(U.self, from: data)
    }
}

extension StaticJSONMapper {
    enum MappingError: Error {
        case failedToGetContents
    }
}
