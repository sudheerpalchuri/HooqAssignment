//
//  URLSessionProtocol.swift
//  HooqAssignment
//
//  Created by Sudheer Palchuri on 11/12/19.
//  Copyright © 2019 Sudheer Palchuri. All rights reserved.
//

import Foundation

/// Dependency invertion protocol for URLSession, allows me to test API Service
protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}


protocol URLSessionDataTaskProtocol {
    func cancel()
    func resume()
    func suspend()
    var state: URLSessionTask.State { get }
}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completion)
    }
}


extension URLSessionDataTask: URLSessionDataTaskProtocol { }
