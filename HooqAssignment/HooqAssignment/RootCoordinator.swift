//
//  RootCoordinator.swift
//  HooqAssignment
//
//  Created by Sudheer Palchuri on 13/12/19.
//  Copyright © 2019 Sudheer Palchuri. All rights reserved.
//

import UIKit

/// Root Coordinator
/// The coordinator responsible for coordinating the screen flow.
final class RootCoordinator {
    
    private let api = MovieAPI(session: URLSession.shared)

    weak var window: UIWindow!
    
    init(window: UIWindow) {
        self.window = window
    }
    
    
    // MARK: Presentation
    func initMainScreen() {
        guard let window = window else { return }
        window.rootViewController = getMoviesListScreen()
        window.makeKeyAndVisible()
    }
    
    
    /// Builds a now playing movie screen with all the dependencies
    /// Ready to use now playing movies screen as UIViewController
    private func getMoviesListScreen() -> UIViewController {
        
        let popularViewController: MoviesViewController = {
            let vc = MoviesViewController.instantiate()
            vc.title = "Now Playing"
            return vc
        }()
       
        let detailsScreen = MovieDetailsViewController.instantiate()
        let nowPlayingMoviesModel = NowPlayingMoviesModel(api: api)
        let nowPlayingMoviesViewModel =  MoviesViewModel(model: nowPlayingMoviesModel)
        popularViewController.viewModel = nowPlayingMoviesViewModel
        
        let navigation = popularViewController.wrappedInNavigationController()
        nowPlayingMoviesViewModel.onSelectMovie = { [weak navigation] movie in
            detailsScreen.viewModel = MovieDetailsViewModel(movie: movie)
            navigation?.pushViewController(detailsScreen, animated: true)
        }
        return navigation
    }
    
}

private extension UIViewController {
    /// Wraps the view controller in navigation controller
    /// Returns UINavigationController
    func wrappedInNavigationController() -> UINavigationController {
        let nc = UINavigationController(rootViewController: self)
        nc.title = self.title
        return nc
    }
}
