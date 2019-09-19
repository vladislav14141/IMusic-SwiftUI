//
//  DataFetcherService.swift
//  IMusic SwiftUI
//
//  Created by Миронов Влад on 13.09.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import Foundation

class DataFetcherService {
    var networkDataFetcher: DataFetcher
    
    var urlComponents: URLComponents{
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "itunes.apple.com"
        urlComponents.path = "/search"
        return urlComponents
    }

    init(dataFetcher: DataFetcher = NetworkDataFetcher()) {
        self.networkDataFetcher = dataFetcher
    }
    
    func fetchArtistMusic(artistName: String, completion: @escaping (ItunesData?) -> Void){
        var urlComponents = self.urlComponents
        urlComponents.queryItems = [
            URLQueryItem(name: "term", value: "\(artistName)"),
            URLQueryItem(name: "limit", value: "25")
        ]
       
        if let url = urlComponents.url?.absoluteString {
            networkDataFetcher.fetchGenericJsonData(urlString: url, response: completion)
        } else {
            Log("Can't make url via urlComponents\(urlComponents.url?.absoluteString)")
            return
        }
    }
}
