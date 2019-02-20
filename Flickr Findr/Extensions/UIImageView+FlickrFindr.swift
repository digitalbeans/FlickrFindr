//
//  UIImageView+FlickrFindr.swift
//  Flickr Findr
//
//  Created by Dean Thibault on 2/18/19.
//  Copyright © 2019 Digital Beans. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

// Extension to provide for downloading images asynchronously and setting in the UIImageView
extension UIImageView {
	
	/// Retrieves an image from the given URL. The retrieved image is set to the image property of UIImageView.
	///
	/// - parameter url: The URL of the image
	/// - parameter placeHolder: The placeholder image to use. Optional and defaults to placeholder image.
	///
	/// - returns: void

	func image(from url: URL, placeHolder: UIImage? = UIImage(named: Constants.Image.placeHolder)) {
		
		/// Check if image is in cache an return it
		if let cachedImage = imageCache.object(forKey: NSString(string: url.absoluteString)) {
			self.image = cachedImage
			return
		}
		
		// fetch image asynchronously from URL
		DispatchQueue.global().async { [weak self] in
			if let data = try? Data(contentsOf: url) {
				
				// set image in image view on the main queue
				if let downloadedImage = UIImage(data: data) {
					DispatchQueue.main.async {
						imageCache.setObject(downloadedImage, forKey: NSString(string: url.absoluteString))
						self?.image = downloadedImage
					}
				}
			}
			else {
				DispatchQueue.main.async {
					self?.image = placeHolder
				}
			}
		}
	}
}
