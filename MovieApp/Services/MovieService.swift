//
//  MovieService.swift
//  MovieApp
//
//  Created by Gasho on 31.03.2021..
//

import Foundation
import Alamofire

protocol  MovieServiceProtocol {
    static func fetchMovies(form endPoint:MovieListEndpoint, page:Int, completion: @escaping(Result<MovieResponse, MovieError>) -> ())
    static func fetchMovie(with id: Int, completion: @escaping(Result<Movie, MovieError>) -> ())
}

enum MovieListEndpoint {
    case top_rated
    case popular
    case similar(Int)
    
    var title: String{
        switch self {
        case .top_rated: return "Top rated movies"
        case .popular: return "Popular movies"
        case .similar(_): return "Similar movies"
        }
    }
    
    var toString: String{
        switch self {
        case .top_rated: return "top_rated"
        case .popular: return "popular"
        case .similar(let id): return "\(id)/similar"
        }
    }
}

struct MovieResponse: Decodable{
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let movies: [Movie]
    
    private enum CodingKeys: String, CodingKey{
        case page
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case movies = "results"
    }
}

enum MovieError: Error, CustomNSError{
    case apiError
    case invalidResponse
    case noData
    case serilizationError
    
    var localizedDescription: String{
        switch self {
        case .apiError: return "Failed to get data"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serilizationError: return "Failed to decode data"
        }
    }
    
    var errorUserInfo: [String: Any]{
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}

final class MovieService: MovieServiceProtocol{
    
    static func fetchMovie(with id: Int, completion: @escaping (Result<Movie, MovieError>) -> ()) {
        let url = NetworkLayer.baseURL + "\(id)"
        NetworkLayer.shared.request(with: url, parameters: nil, completion: completion)
    }
    
    static func fetchMovies(form endPoint: MovieListEndpoint, page: Int, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        let url = NetworkLayer.baseURL + endPoint.toString
        let param = ["page": page]
        NetworkLayer.shared.request(with: url, parameters: param, completion: completion)
    }
}
