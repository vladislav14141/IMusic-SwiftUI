//
//  MainTabBarController.swift
//  IMusic SwiftUI
//
//  Created by Миронов Влад on 12.09.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit
import SwiftUI

protocol MainTabBarControllerDelegate {
    func minimizeTrackDetailController()
    func muximizeTrackDetailController(viewModel: SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController {
    
    private var minimizedTopAnchorConstraints: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraints: NSLayoutConstraint!
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tabBar.tintColor = #colorLiteral(red: 1, green: 0.2806717753, blue: 0.4058929086, alpha: 1)
        
        setupTrackDetailView()
        
        searchVC.tabBarDelegate = self
        
        var library = Library()
        library.tabBarDelegate = self
        let hostVC = UIHostingController(rootView: library)
        hostVC.tabBarItem.image = #imageLiteral(resourceName: "ios10-apple-music-library-5nav-icon")
        hostVC.tabBarItem.title = "Library"
        viewControllers = [
            generateVC(rootVC: searchVC, image:#imageLiteral(resourceName: "ios10-apple-music-search-5nav-icon"), title: "Search"),
            hostVC
        ]
    }
    private func generateVC(rootVC: UIViewController, image: UIImage, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootVC)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootVC.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        return navigationVC
    }
    
    private func setupTrackDetailView() {
        
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedTopAnchorConstraints = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottomAnchorConstraints = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        
        bottomAnchorConstraints.isActive = true
        maximizedTopAnchorConstraint.isActive = true
        
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true

    }
}

extension MainTabBarController: MainTabBarControllerDelegate {
    func muximizeTrackDetailController(viewModel: SearchViewModel.Cell?) {
        minimizedTopAnchorConstraints.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraints.constant = 0
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.view.layoutIfNeeded()
                        self.tabBar.alpha = 0
                        self.trackDetailView.miniTrackView.alpha = 0
                        self.trackDetailView.maximizedStackView.alpha = 1
        },
                       completion: nil)
        guard let viewModel = viewModel else {return}
        self.trackDetailView.set(viewModel: viewModel)
    }
    
    func minimizeTrackDetailController() {
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraints.constant = view.frame.height
        minimizedTopAnchorConstraints.isActive = true
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.tabBar.alpha = 1
                        self.view.layoutIfNeeded()
                        self.trackDetailView.miniTrackView.alpha = 1
                        self.trackDetailView.maximizedStackView.alpha = 0
        },
                       completion: nil)
    }
    
    
}
