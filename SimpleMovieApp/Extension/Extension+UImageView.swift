//
//  Extension+UImageView.swift
//  SimpleMovieApp
//
//  Created by Tow Ching Shen on 03/08/2024.
//

import UIKit

extension UIImageView {
    func loadFrom(URLAddress: String, image_corner_radius: CGFloat? = nil) {
        let not_found_image_icon = UIImage(systemName: "photo")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        let indicator = UIActivityIndicatorView(style: .medium)
        
        addSubview(indicator)
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        indicator.color = (UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        
        guard let url = URL(string: URLAddress) else {
            indicator.stopAnimating()
            
            if let image_corner_radius = image_corner_radius {
                image = not_found_image_icon?.roundedCornerImage(with: image_corner_radius)
                
                return
            }
            
            image = not_found_image_icon
            
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) {
            data,
            response,
            error in
            
            defer {
                DispatchQueue.main.async { [weak self] in
                    indicator.stopAnimating()
                    
                    guard let self = self else { return }
                    
                    if self.image == nil {
                        self.image = not_found_image_icon
                    }
                }
            }
            
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  error == nil else
            {                                              // check for fundamental networking error
                let errorStr = "error: \(error?.localizedDescription ?? "Unknown error")"
                print(errorStr)
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            guard let loadedImage = UIImage(data: data) else {
                print("Not valid image")
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if let image_corner_radius = image_corner_radius {
                    self.image = loadedImage.roundedCornerImage(with: image_corner_radius)
                    
                    return
                }
                
                self.image = loadedImage
            }
        }
        
        task.resume()
    }
}
