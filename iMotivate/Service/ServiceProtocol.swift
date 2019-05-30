//
//  ServiceProtocol.swift
//  iMotivate
//
//  Created by Arvin Quiliza on 5/30/19.
//  Copyright © 2019 arvinq. All rights reserved.
//

import Foundation

/** For Mock Service */
protocol ServiceProtocol {
    func fetchQuotes(completion: @escaping ([Quote]?)->())
}
