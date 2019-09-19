//
//  NetworkDataFetcher.swift
//  ViewController. Single Responsibility Principle.
//
//  Created by Миронов Владислав on 13.06.2019.
//  Copyright © 2019 Миронов Владислав. All rights reserved.
//

import Foundation
protocol DataFetcher {
    func fetchGenericJsonData<T: Decodable>(urlString: String, response: @escaping (T?) -> Void)
}
class NetworkDataFetcher: DataFetcher {
    
    // MARK: - Public Properties
    var networking: Networking
    
    // MARK: - Initializers
    init(networking: Networking = NetworkService()) {
        self.networking = networking
    }
    
    // MARK: - Public Methods
    /// Fetching generic JSON data
    /// - Parameter urlString: url
    /// - Parameter response: decoded response
    func fetchGenericJsonData<T: Decodable>(urlString: String, response: @escaping (T?) -> Void){
        networking.request(urlString: urlString) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
                response(nil)
            } else {
                let decoded = self.decodeJSON(type: T.self, from: data)
                response(decoded)
            }
           
        }
    }
    
    func decodeJSON<T:Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else {
            Log("Data is nil")
            return nil
        }
            let response = try? decoder.decode(type.self, from: data)
            return response
    }
}
