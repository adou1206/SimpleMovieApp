//
//  Movie+CoreDataProperties.swift
//  SimpleMovieApp
//
//  Created by Tow Ching Shen on 05/08/2024.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var movie_id: Double
    @NSManaged public var original_title: String?
    @NSManaged public var poster_path: String?
    @NSManaged public var overview: String?
    @NSManaged public var vote_average: Double

}

extension Movie : Identifiable {

}
