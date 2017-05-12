//
//  NetworkController.swift
//  Random User
//
//  Created by Jeff Norton on 5/12/17.
//  Copyright © 2017 Jeff Norton. All rights reserved.
//

import Foundation

class NetworkController {
    
    enum HTTPMethod: String {
        case Get = "GET"
        case Put = "PUT"
        case Post = "POST"
        case Patch = "PATCH"
        case Delete = "DELETE"
    }
    
    //==================================================
    // MARK: - Methods
    //==================================================
    
    static func performRequest(for url: URL,
                               httpMethod: HTTPMethod,
                               urlParameters: [String:String]? = nil,
                               body: Data? = nil,
                               completion: ((Data?, Error?) -> Void)? = nil) {
        
        let requestURL = self.url(byAdding: urlParameters, to: url)
        var request = URLRequest(url: requestURL)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body
        
        // Access the instance of the global (shared) session and build a data task (a.k.a. a GET request)
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let completion = completion {
                
                if let error = error {
                    completion(nil, error)
                }
                
                completion(data, nil)
            }
        }
        
        dataTask.resume()
    }
    
    static func url(byAdding parameters: [String : String]?, to url: URL) -> URL {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters?.flatMap({URLQueryItem(name: $0.0, value: $0.1)})
        
        guard let url = components?.url else {
            fatalError("URL optional is nil")
        }
        return url
    }
}









