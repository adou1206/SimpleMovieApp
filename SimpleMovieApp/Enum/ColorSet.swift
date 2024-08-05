//
//  ColorSet.swift
//  SimpleMovieApp
//
//  Created by Tow Ching Shen on 03/08/2024.
//

import UIKit

enum ColorSets: String, CaseIterable {
    case background = "background"
    
    func color() -> UIColor? {
        return UIColor.appColor(name: self)
    }
}
