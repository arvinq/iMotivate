//
//  iMotivateTests.swift
//  iMotivateTests
//
//  Created by Arvin Quiliza on 5/30/19.
//  Copyright © 2019 arvinq. All rights reserved.
//

import XCTest
@testable import iMotivate

class iMotivateTests: XCTestCase {
    let mockService = MockService()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMockFetchQuote() {
        mockService.fetchQuotes { quotes in
            guard let quotes = quotes else {
                XCTFail()
                return
            }
            XCTAssertNotNil(quotes)
        }
    }
    
    func testFetchQuote() {
        Service.shared.fetchQuotes { quotes in
            guard let quotes = quotes else {
                XCTFail()
                return
            }
            XCTAssertNotNil(quotes)
        }
    }
    
    func testQuoteViewModel() {
        let quote = Quote(imageUrl: "https://s3.ap-southeast-2.amazonaws.com/dailyfixme.content/image/quotes/2019-05-07/a2dca990-7093-11e9-bdb4-454a373ead8b.png", quoteText: "belief")
        let quoteViewModel = QuoteViewModel(quote: quote)
       
        XCTAssertEqual(quote.imageUrl, quoteViewModel.quoteStrUrl)
        XCTAssertEqual(quote.quoteText, quoteViewModel.quoteText)
    }
    
    

}
