//
//  QuotesCollectionViewCell.swift
//  iMotivate
//
//  Created by Arvin Quiliza on 5/29/19.
//  Copyright © 2019 arvinq. All rights reserved.
//

import UIKit

class QuotesCollectionViewCell: UICollectionViewCell {
    
    var quoteViewModel: QuoteViewModel? {
        didSet {
            quoteLabel.text = quoteViewModel?.quoteText
            quoteImageView.setImage(usingUrl: quoteViewModel?.quoteStrUrl)
            loader.stopAnimating()
        }
    }
    
    //MARK:- Views
    let quoteLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        //shadows for the texts
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.8
        label.layer.shadowRadius = 2
        label.layer.shadowOffset = CGSize(width: 2, height: 3)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let quoteImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.hidesWhenStopped = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCellView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // we want to set the image's content to be shown once constraints have been set.
        // we do it here in layoutSubviews
        
        quoteImageView.layer.contentsRect = CGRect(x: 0, y: 0, width: 1, height: 0.2)
    }
    
    /**
     This is to setup cell view's properties and set the controls accordingly
     */
    func setupCellView() {
        backgroundColor = .black
        layer.borderWidth = 1
        addSubview(quoteImageView)
        addSubview(quoteLabel)
        addSubview(loader)
        
        loader.startAnimating()
        
        setupConstraints()
    }
    
    /**
     This is to setup the constraints
     */
    func setupConstraints() {
        NSLayoutConstraint.activate([
            quoteLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            quoteLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            quoteLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            quoteImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            quoteImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            quoteImageView.topAnchor.constraint(equalTo: topAnchor),
            quoteImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    
}
