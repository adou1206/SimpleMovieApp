//
//  Extension+UIViewController.swift
//  SimpleMovieApp
//
//  Created by Tow Ching Shen on 03/08/2024.
//

import UIKit

fileprivate var spinnerView: UIView?

extension UIViewController {
    /// add indicator spinner to cover entire page
    func showSpinner() {
        if spinnerView == nil {
            spinnerView = UIView(frame: view.bounds)
            spinnerView?.backgroundColor = .clear
            
            let indicator = UIActivityIndicatorView(style: .medium)
            indicator.color = (UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black)
            indicator.center = spinnerView!.center
            indicator.startAnimating()
            spinnerView?.addSubview(indicator)
            view.addSubview(spinnerView!)
        }
    }
    
    /// remove indicator spinner from covered entire page
    func removeSpinner() {
        guard let spinner = spinnerView else { return }
        spinner.removeFromSuperview()
        spinnerView = nil
    }
    
    func alertWithTitle(
        _ title: String,
        message: String,
        button_title: String = "OK",
        accessibility_identifier: String = "",
        closure: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.view.accessibilityIdentifier = accessibility_identifier
        
        alert.addAction(UIAlertAction(title: button_title, style: .cancel, handler: { _ in
            if let closure = closure {
                closure()
            }
        }))
        
        showDetailViewController(alert, sender: self)
    }
}
