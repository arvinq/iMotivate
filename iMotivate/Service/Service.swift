//
//  Service.swift
//  iMotivate
//
//  Created by Arvin Quiliza on 5/29/19.
//  Copyright © 2019 arvinq. All rights reserved.
//

import Foundation
import UIKit

class Service {
    static let shared = Service()
    
    func fetchImage(from imageUrl: URL, completion: @escaping (UIImage?)->()) {
                
        let dataTask = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            
            if let error = error {
                print("Error fetching image.", error)
            }
            
                if let data = data {
                    
                    DispatchQueue.main.async {
                        completion(UIImage(data: data))
                    }

                }
                else {
                    print("Image Data corrupted")
                    return
                }
            
        }
        
        dataTask.resume()
        
    }
    
}

extension Service: ServiceProtocol {
    /**
     use our Quotes intermediary to get the array of quotes
     because our quote structure in json is enclosed in a large quotes array
     */
    func fetchQuotes(completion: @escaping ([Quote]?)->()) {
        
        guard let baseUrl = URL(string: PropertyKey.baseUrl),
            let finalUrl = baseUrl.withQuery(items: PropertyKey.queryItems) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: finalUrl) { (data, response, error) in
            
            if let error = error  {
                completion(nil)
                print("Failed to fetch data", error)
                return
            }
            
            guard let data = data else { return }
            do {
                let jsonQuotes = try JSONDecoder().decode(Quotes.self, from: data)
                let quotes = jsonQuotes.quotes
                
                DispatchQueue.main.async {
                    completion(quotes)
                }
                
            } catch let error {
                print("Cannot decode data", error)
                return
            }
            
        }
        
        dataTask.resume()
        
    }
}
