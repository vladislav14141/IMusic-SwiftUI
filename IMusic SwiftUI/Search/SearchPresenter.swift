//
//  SearchPresenter.swift
//  IMusic SwiftUI
//
//  Created by Миронов Влад on 13.09.2019.
//  Copyright (c) 2019 Миронов Влад. All rights reserved.
//

import UIKit

protocol SearchPresentationLogic {
  func presentData(response: Search.Model.Response.ResponseType)
}

class SearchPresenter: SearchPresentationLogic {
  weak var viewController: SearchDisplayLogic?
  
  func presentData(response: Search.Model.Response.ResponseType) {
    switch response {
    case .some:
        Log("Presenter .some")
    case .presetTracks(let searchResults):
        let cells = searchResults.results.map { (track) in
            cellViewModel(from: track)
        }
        let searchViewModel = SearchViewModel(cells: cells)
        viewController?.displayData(viewModel: .displayTracks(searchViewModel: searchViewModel))
    case .presentFooterView:
        viewController?.displayData(viewModel: .displayFooterView)
    }
  }
    private func cellViewModel(from track: Track) -> SearchViewModel.Cell {
        return SearchViewModel.Cell(iconUrlString: track.artworkUrl100,
                                    trackName: track.trackCensoredName,
                                    collectionName: track.collectionCensoredName ?? "",
                                    artistName: track.artistName,
                                    previewUrl: track.previewUrl)
    }
}
