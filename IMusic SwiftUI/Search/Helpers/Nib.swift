//
//  Nib.swift
//  IMusic SwiftUI
//
//  Created by Миронов Влад on 16.09.2019.
//  Copyright © 2019 Миронов Влад. All rights reserved.
//

import UIKit

extension UIView {
    class func loadFromNib<T: UIView>() -> T{
        print(T.self)
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
