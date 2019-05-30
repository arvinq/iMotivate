//
//  Quote.swift
//  iMotivate
//
//  Created by Arvin Quiliza on 5/29/19.
//  Copyright © 2019 arvinq. All rights reserved.
//

import Foundation

struct Quote: Codable {
    let imageUrl: String
    let quoteText: String
}

/** intermediary structure */
struct Quotes: Codable {
    let quotes: [Quote]
}
