//
//  UIViewController + Storyboard.swift
//  IMusic SwiftUI
//
//  Created by Миронов Влад on 13.09.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit

extension UIViewController {
    class func loadFromStoryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if let viewController = storyboard.instantiateInitialViewController() as? T {
            return viewController
        } else {
            fatalError("ERROR: No initial view controller in \(name) storyboard")
        }
    }
}
