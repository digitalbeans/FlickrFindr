//
//  UIView+FlickrFindr.swift
//  Flickr Findr
//
//  Created by Dean Thibault on 2/20/19.
//  Copyright © 2019 Digital Beans. All rights reserved.
//

import UIKit

// extension to easily allow adding borders to UIViews.
extension UIView {
	
	/// Adds a border to view
	///
	/// - parameter color: The border color.
	/// - parameter width: The width of the border.
	///
	/// - returns: void
	
	func setBorder(color: UIColor, width: CGFloat = 0.5) {
		
		layer.borderWidth = width
		layer.borderColor = color.cgColor
	}
}
