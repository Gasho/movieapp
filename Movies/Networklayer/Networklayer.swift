//
//  MovieService.swift
//  MovieApp
//
//  Created by Gasho on 31.03.2021..
//

import Foundation
import Alamofire

final class NetworkLayer{
    
    static let shared = NetworkLayer()
    static let imageBaseURL = "https://image.tmdb.org/t/p/w400"
    static let baseURL = "https://api.themoviedb.org/3/movie/"
    
    private let apiKey = "fe3b8cf16d78a0e23f0c509d8c37caad"
    private lazy var manager: Alamofire.Session = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        return Alamofire.Session(configuration: config)
    }()
    
    func request<D: Decodable>(with URL: String, parameters: [String:Any]? = nil, completion: @escaping(Result<D, MovieError>) -> ()){

        var urlParameters: [String : Any] = ["api_key" : apiKey]
        if let param = parameters{
            for (key,value) in param{
                urlParameters[key] = value
            }
        }
        
        manager.request(URL, method: .get, parameters: urlParameters).responseData{ (response) in
            switch response.result {
            case .success(let value):
                do{
                    let data = try JSONDecoder().decode(D.self, from: value)
                    self.executeInMianThread(with: .success(data), completion: completion)
                }catch{
                    print(error)
                    self.executeInMianThread(with: .failure(.serilizationError), completion: completion)
                }
            case .failure(_):
                self.executeInMianThread(with: .failure(.apiError), completion: completion)
                
            }
        }
    }
    
    private func executeInMianThread<D :Decodable>(with result: Result<D, MovieError>, completion:  @escaping(Result<D, MovieError>) -> ()){
        DispatchQueue.main.async {
            completion(result)
        }
    }
   
}
