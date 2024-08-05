//
//  Extension+UIView.swift
//  SimpleMovieApp
//
//  Created by Tow Ching Shen on 03/08/2024.
//

import UIKit

extension UIView {
    ///get top anchor or safe area top anchor
    var safeTopAnchor: NSLayoutYAxisAnchor {
        return self.safeAreaLayoutGuide.topAnchor
    }
    
    ///get bottom anchor or safe area bottom anchor
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        return self.safeAreaLayoutGuide.bottomAnchor
    }
    
    ///get leading anchor or safe area leading anchor
    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        return self.safeAreaLayoutGuide.leadingAnchor
    }
    
    ///get trailing anchor or safe area trailing anchor
    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        return self.safeAreaLayoutGuide.trailingAnchor
    }
}
