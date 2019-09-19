//
//  SearchInteractor.swift
//  IMusic SwiftUI
//
//  Created by Миронов Влад on 13.09.2019.
//  Copyright (c) 2019 Миронов Влад. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
  func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {
    var dataFetcherService = DataFetcherService()
  var presenter: SearchPresentationLogic?
  var service: SearchService?
  
  func makeRequest(request: Search.Model.Request.RequestType) {
    if service == nil {
      service = SearchService()
    }
    switch request {
    case .some:
        print("interactor .some")
    case .getTracks(let searchTerm):
        presenter?.presentData(response: .presentFooterView)
        dataFetcherService.fetchArtistMusic(artistName: searchTerm) { [weak self] (itunesData) in
            if let itunesData = itunesData {
                self?.presenter?.presentData(response: .presetTracks(searchResponce: itunesData))
            } else {
                Log("itunesData is \(String(describing: itunesData))")
            }
        }
    }
  }
}
