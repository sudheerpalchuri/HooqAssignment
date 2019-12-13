//
//  Movie.swift
//  HooqAssignment
//
//  Created by Sudheer Palchuri on 11/12/19.
//  Copyright © 2019 Sudheer Palchuri. All rights reserved.
//

import Foundation

/// Domain model is a model from real world

struct Movie {
    let id: Int
    let poster: URL?
    let name: String
    let released: Date
    let overview: String
}
