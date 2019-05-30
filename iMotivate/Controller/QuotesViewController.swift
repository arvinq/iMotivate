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
    
    //MARK:- View LifeCycle
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
    
    /** Function to end refresh */
    @objc func refreshItem() {
        collectionView.refreshControl?.endRefreshing()
    }
    
    /** Calls the service method to fetch the quotes to be displayed */
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

    //MARK:- Collection View delegate and datasource methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quotesViewModels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuotesCell", for: indexPath) as! QuotesCollectionViewCell
        cell.quoteViewModel = quotesViewModels[indexPath.item]
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Get the cell that has been tapped and attach the imageTap gesture created to cell's quoteImageView
        
        let cell = collectionView.cellForItem(at: indexPath) as! QuotesCollectionViewCell
     
        guard let imageTap = imageTap else { return }
        
        cell.quoteImageView.addGestureRecognizer(imageTap)
        cell.quoteImageView.isUserInteractionEnabled = true
        imageViewToEnlarge = cell.quoteImageView
        enableImageFullscreen(imageTap)
    }
    
    
}


/**
 Delegate flow layout is used for the item's size and edge insets.
 */
extension QuotesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.size.width, height: view.frame.size.height * 0.20)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
}


/**
 All Gesture Methods
 */
extension QuotesViewController {
    //MARK:- Gesture Methods
    
    /// Being called when a tap on imageView is triggered
    @objc private func enableImageFullscreen(_ sender: UITapGestureRecognizer) {
        guard let imageViewToEnlarge = imageViewToEnlarge else { return }
        
        let newImageView = UIImageView(image: imageViewToEnlarge.image)
        newImageView.contentMode = .scaleAspectFit
        newImageView.frame = self.view.bounds
        newImageView.backgroundColor = .black
        newImageView.isUserInteractionEnabled = true
        
        
        let swipeGestures = setupSwipeGesture(onView: newImageView)
        setupPanGesture(swipeGestures: swipeGestures, onView: newImageView)
        
        // Hide all of the elements visible. and add this imageView as subview.
        self.navigationController?.isNavigationBarHidden = true
        self.view.addSubview(newImageView)
        
    }
    
    /// Setting up PanGesture. We require swipeGesture to fail so we can trigger panning of imageView
    func setupPanGesture(swipeGestures: [UISwipeGestureRecognizer], onView newImageView: UIImageView) {
        let imagePan = UIPanGestureRecognizer(target: self, action: #selector(dragged(_:)))
        for swipeGesture in swipeGestures {
            imagePan.require(toFail: swipeGesture)
        }
        newImageView.addGestureRecognizer(imagePan)
    }
    
    func setupSwipeGesture(onView newImageView: UIImageView) -> [UISwipeGestureRecognizer] {
        // Create a new gestureRecognizer for this new full screen Imageview.
        // Include all direction to account for all the finger swipes.
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
        
        return [imageSwipeUp, imageSwipeDown, imageSwipeLeft, imageSwipeRight]
    }
    
    // This is called when tapping imageView. all of the hidden elements are now shown
    // Remove the imageView from superView.
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
    
    @objc private func dragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began ||
            gestureRecognizer.state == UIGestureRecognizer.State.changed {
            let translation = gestureRecognizer.translation(in: self.view)
            gestureRecognizer.view!.center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
            gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)
        }
    }
}
