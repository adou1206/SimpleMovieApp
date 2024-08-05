//
//  Extension+UIColor.swift
//  SimpleMovieApp
//
//  Created by Tow Ching Shen on 03/08/2024.
//

import UIKit

extension UIColor {
    static func appColor(name: ColorSets) -> UIColor? {
        return UIColor(named: name.rawValue)
    }
}
