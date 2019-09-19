//
//  NetworkService.swift
//  ViewController. Single Responsibility Principle.
//
//  Created by Миронов Владислав on 31/05/2019.
//  Copyright © 2019 Миронов Владислав. All rights reserved.
//

import Foundation

protocol Networking {
    func request(urlString: String, completion: @escaping (Data?, Error?) -> Void)
}

class NetworkService: Networking {
    
    /// Making request via URL
    /// - Parameter urlString: URL
    /// - Parameter completion: received Data, Response, Error
    func request(urlString: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    
    /// Create Data Task
    /// - Parameter requst: URL Request of URL
    /// - Parameter completion: Data, Response, Error
    private func createDataTask(from requst: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: requst, completionHandler: { (data, response, error) in
            if let error = error{
                Log(error)
            }
            DispatchQueue.main.async {
                completion(data, error)
            }
        })
    }
}
