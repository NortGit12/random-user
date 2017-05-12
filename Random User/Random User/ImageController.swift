//
//  ImageController.swift
//  Random User
//
//  Created by Jeff Norton on 5/12/17.
//  Copyright © 2017 Jeff Norton. All rights reserved.
//

import UIKit

class ImageController {
    
    //==================================================
    // MARK: - Methods
    //==================================================
    
    static func imageForURL(urlString: String, completion: @escaping ((_ image: UIImage?) -> Void)) {
        
        guard let url = URL(string: urlString) else { fatalError("Image URL optional is nil") }
        
        NetworkController.performRequest(for: url, httpMethod: .Get) { (data, error) in
            
            if let error = error {
                
                NSLog("Erorr: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            }
        }
    }
}
