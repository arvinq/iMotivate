//
//  UIImageView+Extension.swift
//  iMotivate
//
//  Created by Arvin Quiliza on 5/30/19.
//  Copyright © 2019 arvinq. All rights reserved.
//

import Foundation
import UIKit

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    /**
     Method to call service and fetch UIImage from image url.
     - Parameter url: image url
     */
    func setImage(usingUrl urlString: String?) {
        
        imageUrlString = urlString
        
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return }
        
        image = nil
        
        if let imageFromCache = AppDelegate.shared.imageCache?.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        Service.shared.fetchImage(from: url) { [weak self] image in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                let imageToCache = image
                
                if strongSelf.imageUrlString == urlString {
                    strongSelf.image = imageToCache
                }
                
                AppDelegate.shared.imageCache?.setObject(imageToCache ?? UIImage(named: "black.jpg")!, forKey: urlString as NSString)
                
            }
            
        }
        
        
    }
}
