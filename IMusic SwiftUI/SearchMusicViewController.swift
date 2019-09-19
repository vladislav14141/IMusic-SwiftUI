//
//  SearchViewController.swift
//  IMusic SwiftUI
//
//  Created by Миронов Влад on 12.09.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit
struct TrackModel {
    var trackName: String
    var artistsName: String
}
class SearchMusicViewController: UITableViewController {
    private var timer: Timer?
    private var itunesData: ItunesData?
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellid")
    }

    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self

    }
}

// MARK: UISearchBarDelegate
extension SearchMusicViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            let dataFetcherService = DataFetcherService()
            dataFetcherService.fetchArtistMusic(artistName: searchText) { [weak self] (itunesData) in
                self?.itunesData = itunesData
                self?.tableView.reloadData()
            }
        })
    }
}

// MARK: Data source
extension SearchMusicViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itunesData?.results.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
        if let song = self.itunesData?.results[indexPath.row] {
            cell.textLabel?.text = "\(song.trackCensoredName)\n\(song.artistName)"
            cell.textLabel?.numberOfLines = 2
        }
        return cell
    }
}
