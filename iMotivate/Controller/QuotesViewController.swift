//
//  ViewController.swift
//  iMotivate
//
//  Created by Arvin Quiliza on 5/29/19.
//  Copyright © 2019 arvinq. All rights reserved.
//

import UIKit

class QuotesViewController: UICollectionViewController {

    var quotesViewModels = [QuoteViewModel]()
    var imageTap: UITapGestureRecognizer?
    var imageViewToEnlarge: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshItem), for: .valueChanged)
        collectionView.refreshControl = refresh
        
        fetchQuotes()
        
        imageTap = UITapGestureRecognizer(target: self, action: #selector(enableImageFullscreen(_:)))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        title = PropertyKey.title
        let textAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .bold)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.barStyle = .black
    }
    
    @objc func refreshItem() {
        collectionView.refreshControl?.endRefreshing()
    }
    
    func fetchQuotes() {
        Service.shared.fetchQuotes { [weak self] quoteArray in
            guard let strongSelf = self else { return }
            
            strongSelf.quotesViewModels = quoteArray?.map {
                return QuoteViewModel(quote: $0)
            } ?? []
            
            DispatchQueue.main.async {
                strongSelf.collectionView.reloadData()
            }
            
            
        }
        
    }

    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quotesViewModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuotesCell", for: indexPath) as! QuotesCollectionViewCell
        cell.quoteViewModel = quotesViewModels[indexPath.item]
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! QuotesCollectionViewCell
     
        guard let imageTap = imageTap else { return }
        
        cell.quoteImageView.addGestureRecognizer(imageTap)
        cell.quoteImageView.isUserInteractionEnabled = true
        imageViewToEnlarge = cell.quoteImageView
        
        enableImageFullscreen(imageTap)
    }
    
    
    //being called when a tap on imageView is triggered
    @objc private func enableImageFullscreen(_ sender: UITapGestureRecognizer) {
        guard let imageViewToEnlarge = imageViewToEnlarge else { return }
        
        let newImageView = UIImageView(image: imageViewToEnlarge.image)
        newImageView.contentMode = .scaleAspectFit
        newImageView.frame = self.view.bounds
        newImageView.backgroundColor = .black
        newImageView.isUserInteractionEnabled = true
        
        //crate a new gestureRecognizer for this new Imageview.
        let imageSwipeRight = UISwipeGestureRecognizer(target: self, action: #selector(disableImageFullscreen(_:)))
        let imageSwipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(disableImageFullscreen(_:)))
        let imageSwipeUp = UISwipeGestureRecognizer(target: self, action: #selector(disableImageFullscreen(_:)))
        let imageSwipeDown = UISwipeGestureRecognizer(target: self, action: #selector(disableImageFullscreen(_:)))
        
        imageSwipeDown.direction = .down
        imageSwipeUp.direction = .up
        imageSwipeLeft.direction = .left
        imageSwipeRight.direction = .right
        
        newImageView.addGestureRecognizer(imageSwipeDown)
        newImageView.addGestureRecognizer(imageSwipeUp)
        newImageView.addGestureRecognizer(imageSwipeLeft)
        newImageView.addGestureRecognizer(imageSwipeRight)
        
        //hide all of the elements visible. and add this imageView as subview.
        self.navigationController?.isNavigationBarHidden = true
        self.view.addSubview(newImageView)
        
    }
    
    //this is called when tapping imageView. all of the hidden elements are now shown
    //remove the imageView from superView.
    @objc private func disableImageFullscreen(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            switch sender.direction {
            case .right, .left, .up, .down:
                self.navigationController?.isNavigationBarHidden = false
                sender.view?.removeFromSuperview()
            default: break
            }
        }
    }
    
    
    
}


extension QuotesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.size.width, height: view.frame.size.height * 0.20)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
}

