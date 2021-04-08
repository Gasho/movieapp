//
//  MovieDetails.swift
//  MovieApp
//
//  Created by Gasho on 31.03.2021..
//

import Foundation


struct Genre: Decodable{
    let name: String
}

struct Movie: Decodable, Identifiable{
    let id: Int
    let posterFilePath: String?
    let backDropFilePath: String?
    let title: String
    private let releaseDate: String
    let genres: [Genre]?
    let overView: String
    var similarMovies:[Movie] = []
    
    private enum CodingKeys: String, CodingKey{
        case id
        case posterFilePath = "poster_path"
        case releaseDate = "release_date"
        case backDropFilePath = "backdrop_path"
        case title
        case overView = "overview"
        case genres 
    }
    
    // All this below can be moved to ViewModel if we use are using MVVM
    var posterPathURL: URL {
        return URL(string: NetworkLayer.imageBaseURL + (posterFilePath ?? ""))!
    }
    
    var backDropPathURL: URL {
        return URL(string: NetworkLayer.imageBaseURL + (backDropFilePath ?? ""))!
    }
    
   private var genreText: String{
        guard let genres = genres else {
            return ""
        }
        let names = genres.map{
            $0.name
        }
        return names.joined(separator: ", ")
    }
    
   private var formattedReleaseDate: String{
        guard let date = self.releaseDate.toDate() else {
            return releaseDate
        }
        return date.toString()
    }
    
    var detailTextData: [(title: String, description: String)]{
        return [(title: "Release date:", description: self.formattedReleaseDate),
                (title: "Genres:", description: self.genreText),
                (title: "Overview:", description: self.overView)]
    }
}
