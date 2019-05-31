//
//  QuoteViewModel.swift
//  iMotivate
//
//  Created by Arvin Quiliza on 5/29/19.
//  Copyright © 2019 arvinq. All rights reserved.
//

import Foundation
import UIKit

protocol QuoteViewModelView {
    var quoteImage: CustomImageView { get }
    var quoteTextLabel: UILabel { get }
    var quoteLoader: UIActivityIndicatorView { get }
}

struct QuoteViewModel {
    
    let quote: Quote
    
    let quoteImageUrl: URL?
    let quoteText: String
    let quoteStrUrl: String
    
    init(quote: Quote) {
        self.quote = quote
        
        self.quoteImageUrl = URL(string: quote.imageUrl)
        self.quoteText = quote.quoteText
        self.quoteStrUrl = quote.imageUrl
    }
    
}


extension QuoteViewModel {
    func configure(_ view: QuoteViewModelView) {
        view.quoteTextLabel.text = quoteText
        view.quoteImage.setImage(usingUrl: quoteStrUrl)
        view.quoteLoader.stopAnimating()
    }
}
