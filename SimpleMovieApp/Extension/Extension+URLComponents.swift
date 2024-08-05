//
//  Extension+URLComponents.swift
//  SimpleMovieApp
//
//  Created by Tow Ching Shen on 03/08/2024.
//

import Foundation

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: Any]) {
        var newURLQueryItems: [URLQueryItem] = []
        parameters.forEach { (key: String, values: Any) in
            switch values {
            case let n as [String]:
                newURLQueryItems.append(contentsOf: n.sorted().map { item in
                    URLQueryItem(name: key, value: item)
                })
                
                break
                
            case let t as String:
                newURLQueryItems.append(URLQueryItem(name: key, value: t))
                
                break
                
            default:
                break
            }
        }
        
        queryItems = newURLQueryItems.sorted(by: { item1, item2 in
            return item1.name.caseInsensitiveCompare(item2.name) == .orderedAscending
        })
    }
}
