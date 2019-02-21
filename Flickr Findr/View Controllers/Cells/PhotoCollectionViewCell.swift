//
//  PhotoCollectionViewCell.swift
//  Flickr Findr
//
//  Created by Dean Thibault on 2/18/19.
//  Copyright © 2019 Digital Beans. All rights reserved.
//

import UIKit

/// Custom UICollectionViewCell used to display Photo image and title
class PhotoCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var titleLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	/// Setup the cell using the photo
	///
	/// - parameter photo: The photo to display in this cell.
	///
	/// - returns: void

	func setupCell(photo: Photo) {
		
		imageView.image = nil
		titleLabel.text = photo.title
		
		let urlString = String(format: Constants.Flickr.photoURL, photo.farm, photo.server, photo.id, photo.secret, PhotoType.thumbnail100.rawValue)
		
		guard let url = URL(string: urlString) else { return }
		
		imageView.image(from: url)
	}

	/// Override of the reuse identifier property to return the class name
	override var reuseIdentifier: String? {
		
		return PhotoCollectionViewCell.identifier
	}
	
	/// convience method for returning reuse identifier same as class name
	static var identifier: String {
		
		return String(describing: self)
	}
}
