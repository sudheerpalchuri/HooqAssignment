//
//  NowPlayingMoviesModel.swift
//  HooqAssignment
//
//  Created by Sudheer Palchuri on 11/12/19.
//  Copyright © 2019 Sudheer Palchuri. All rights reserved.
//

import Foundation

final class NowPlayingMoviesModel {
    
    private let moviesListPaginator = MoviesListPaginator()
    private let api: MovieAPI
    
    init(api: MovieAPI) {
        self.api = api
    }
    
}

protocol PaginatedMoviesListModel {
    func load(page: Int)
    var state: Observable<PaginatedMoviesListState> { get }
    var lastPage: Int {get}
}

// MARK: - PaginatedMoviesListModel

extension NowPlayingMoviesModel: PaginatedMoviesListModel {
    
    var lastPage: Int {
        return moviesListPaginator.lastPage
    }
    
    var state: Observable<PaginatedMoviesListState> {
        return moviesListPaginator.state
    }
    
    func load(page: Int)  {
        api.discover(page: page, success: {[moviesListPaginator] response in
            moviesListPaginator.add(
                movies: response.results.map(MovieAPI.toMovie),
                toPage: page
            )
            }, failure: { [moviesListPaginator] error in
                moviesListPaginator.handleAPIError(error)
        })
    }
}
