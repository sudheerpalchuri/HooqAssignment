//
//  MoviesViewController.swift
//  HooqAssignment
//
//  Created by Sudheer Palchuri on 11/12/19.
//  Copyright © 2019 Sudheer Palchuri. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {

    @IBOutlet weak var emptyDatasetLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: MoviesViewModel!
    private var cancelSubscription: CancelSubscription?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MovieCell.nib, forCellReuseIdentifier: MovieCell.identifier)

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 198
        
        cancelSubscription = viewModel.state.subscribe(on: .main) { [weak self] state in
            self?.handle(state)
        }
        viewModel.loadNextPage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    /// Changes the representation regarding the view model state
    func handle(_ state: MoviesViewModel.State) {
        switch state {
            
        case .loading, .empty:
            tableView.isHidden = true
            emptyDatasetLabel.isHidden = false

        case .error(let message):
            tableView.isHidden = false
            emptyDatasetLabel.isHidden = true

            let alert = UIAlertController(
                title: "ERROR",
                message: message,
                preferredStyle: .alert
            )
            present(alert, animated: true)
            
        case .movies:
            tableView.isHidden = false
            emptyDatasetLabel.isHidden = true
            tableView.reloadData()
        }
    }
    
    deinit {
        cancelSubscription?()
    }
}

extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.moviesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = viewModel.movie(at: indexPath.row)!
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier) as! MovieCell
        cell.configure(with: movie)
        return cell
    }
}

extension MoviesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.moviesCount - 7 {
            viewModel.loadNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.selectMovie(at: indexPath.row)
    }
}


// MARK: - Instantiation
extension MoviesViewController {
        static func instantiate() -> MoviesViewController {
        let vc = UIStoryboard(name: "MoviesList", bundle: nil)
            .instantiateInitialViewController() as! MoviesViewController
        return vc
    }
}
