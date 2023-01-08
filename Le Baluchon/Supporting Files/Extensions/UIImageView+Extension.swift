//
//  UIImageViewExtension.swift
//  Le Baluchon
//
//  Created by Maxime Point on 01/12/2022.
//

import Foundation
import UIKit

extension UIImageView {
    
    /// Function to download and add an image to its ImageView, from a URL.
    /// - Parameters:
    ///   - url: image URL
    ///   - mode: image mode (default .scaleAspectFit)
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async { [weak self] in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                else {
                    self?.image = .emptyImage
                    return
                }
                self?.image = image
            }
        }.resume()
    }
    
    /// Function to download and add an image to its ImageView, from a link (String).
    /// - Parameters:
    ///   - link: image link
    ///   - mode: image mode (default .scaleAspectFit)
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
