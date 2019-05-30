//
//  MockService.swift
//  iMotivateTests
//
//  Created by Arvin Quiliza on 5/30/19.
//  Copyright © 2019 arvinq. All rights reserved.
//

import Foundation
@testable import iMotivate

class MockService {
    
    let mockFetchQuoteResponse: Quote = Quote(imageUrl: "https://s3.ap-southeast-2.amazonaws.com/dailyfixme.content/image/quotes/2019-05-07/a2dca990-7093-11e9-bdb4-454a373ead8b.png", quoteText: "belief")
}

extension MockService: ServiceProtocol {
    /**
     Mock fetchQuote for Unit test
     */
    
    func fetchQuotes(completion: @escaping ([Quote]?) -> ()) {
        completion([mockFetchQuoteResponse])
    }
    
}
