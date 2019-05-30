//
//  URL+Extension.swift
//  iMotivate
//
//  Created by Arvin Quiliza on 5/29/19.
//  Copyright © 2019 arvinq. All rights reserved.
//

import Foundation

extension URL {
    func withQuery(items: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = items.compactMap {
            return URLQueryItem(name: $0.key, value: $0.value)
        }
        
        return components?.url
    }
}
