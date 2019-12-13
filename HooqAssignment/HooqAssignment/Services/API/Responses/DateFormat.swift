//
//  DateFormat.swift
//  HooqAssignment
//
//  Created by Sudheer Palchuri on 11/12/19.
//  Copyright © 2019 Sudheer Palchuri. All rights reserved.
//

import Foundation

extension MovieAPI {
    
    /// Data format parser
    struct DateFormat: Codable {
        let date: Date

        private static let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self)
            guard let date = DateFormat.formatter.date(from: rawValue) else {
                throw APIError.parsingError("\(rawValue) doesn't match the format \(DateFormat.formatter.dateFormat ?? "") ")
            }
            self.date = date
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encode(DateFormat.formatter.string(from: date))
        }
    }
}
