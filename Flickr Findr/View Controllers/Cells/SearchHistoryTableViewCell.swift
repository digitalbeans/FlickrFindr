//
//  SearchHistoryTableViewCell.swift
//  Flickr Findr
//
//  Created by Dean Thibault on 2/20/19.
//  Copyright © 2019 Digital Beans. All rights reserved.
//

import UIKit

/// Custom table view cell for displaying search history
class SearchHistoryTableViewCell: UITableViewCell {
	
	@IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {

		super.awakeFromNib()
	}

	/// Override of the reuse identifier property to return the class name
	override var reuseIdentifier: String? {
		
		return SearchHistoryTableViewCell.identifier
	}
	
	/// convience method for returning reuse identifier same as class name
	static var identifier: String {
		
		return String(describing: self)
	}
}
