//
//  MovieManager.swift
//  SimpleMovieApp
//
//  Created by Tow Ching Shen on 05/08/2024.
//

import Foundation
import CoreData

struct MovieManager {
    let mainContext: NSManagedObjectContext

    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.mainContext = mainContext
    }
    
    func createMovies(
        data_for_saving: [MovieDetail]
    ) {
        _ = data_for_saving.map{self.createMovieEntityFrom(movie_detail: $0)}
        
        do {
            try mainContext.save()
            
        } catch let error {
            print("Failed to create: \(error)")
        }
    }
    
    func fetchMovies(
        predicate: NSPredicate? = nil
    ) -> [Movie]? {
        let fetchRequest = NSFetchRequest<Movie>(entityName: CoreDataEntity.movie.rawValue)
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        do {
            let movies = try mainContext.fetch(fetchRequest)
            return movies
            
        } catch let error {
            print("Failed to fetch companies: \(error)")
        }
        
        return nil
    }
    
    func convertToMovieDetail(
        predicate: NSPredicate? = nil
    ) -> [MovieDetail] {
        guard let movies = fetchMovies(predicate: predicate) else { return [] }
        
        var array = [MovieDetail]()
        
        for movie in movies {
            array.append(
                MovieDetail(
                    id: Int(movie.movie_id),
                    originalTitle: movie.original_title ?? "",
                    overview: movie.overview ?? "",
                    posterPath: movie.poster_path ?? "",
                    voteAverage: movie.vote_average
                )
            )
        }
        
        return array
    }
    
    func checkMovieListExists() -> Bool {
        guard let movies = fetchMovies() else { return false }
        
        return movies.count > 0
    }
    
    private func createMovieEntityFrom(
        movie_detail: MovieDetail
    ) -> Movie? {
        let movie = Movie(context: mainContext)
        
        movie.movie_id = Double(movie_detail.id)
        movie.original_title = movie_detail.originalTitle
        movie.poster_path = movie_detail.posterPath
        movie.overview = movie_detail.overview
        movie.vote_average = movie_detail.voteAverage
        
        return movie
    }
}
