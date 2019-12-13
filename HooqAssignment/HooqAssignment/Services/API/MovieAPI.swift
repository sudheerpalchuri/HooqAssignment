//
//  MovieAPI.swift
//  HooqAssignment
//
//  Created by Sudheer Palchuri on 11/12/19.
//  Copyright © 2019 Sudheer Palchuri. All rights reserved.
//

import Foundation

/// Facade class provides with discover endpoints
final class MovieAPI {
    
    enum APIError: Error {
        case parsingError(String)
        case networkError(Error)
        case curruptedData(Error)
        case emptyResult
    }
    
    static let imageBaseURL = URL(string: "http://image.tmdb.org/t/p/")!
    private let baseURL = "https://api.themoviedb.org/3/"
    private let apiKEY = "01b864dcf48f33c62ea3ef952a9bf094"
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    
}


// MARK: - Interface -

extension MovieAPI {
    
    /// Discover popular movies request
    ///
    /// - Parameters:
    ///   - page: page
    ///   - success: callback
    ///   - failure: callback
    func discover(
        page: Int,
        success: @escaping (MoviesListResponse) -> Void,
        failure: @escaping (APIError) -> Void)
    {
        
        let endpoint = baseURL + "movie/now_playing?api_key=\(apiKEY)&page=\(page)"
        let url = URL(string: endpoint)!
        let discoverRequest = URLRequest(url: url)
        request(discoverRequest, success: success, failure: failure)
    }
    
}


// MARK: - Networking -
// this must be a separated class in a real project
extension MovieAPI {
    
    private func request(
        _ request: URLRequest,
        success: @escaping (MoviesListResponse) -> Void,
        failure: @escaping (APIError) -> Void)
    {
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                failure(.networkError(error))
                return
            }
            
            guard let data = data else {
                failure(.emptyResult)
                return
            }
            
            do {
                let value = try JSONDecoder().decode(
                    MoviesListResponse.self,
                    from: data
                )
                success(value)
            } catch {
                print(error)
                failure(.curruptedData(error))
            }
        }
        task.resume()
    }
}

extension MovieAPI {
    // MovieResponse to Movie converter
    static func toMovie(_ data: MovieAPI.MovieResponse) -> Movie {
        
        let poster: URL? = {
            guard let posterPath = data.posterPath else {return nil}
            return imageBaseURL
            .appendingPathComponent("w780")
            .appendingPathComponent(posterPath)
        }()
        
        return Movie(
            id: data.id,
            poster: poster,
            name: data.title,
            released: data.releaseDate.date,
            overview: data.overview ?? ""
        )
    }
}
