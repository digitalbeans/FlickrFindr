//
//  SearchHistoryHeaderViewCell.swift
//  Flickr Findr
//
//  Created by Dean Thibault on 2/20/19.
//  Copyright © 2019 Digital Beans. All rights reserved.
//

import UIKit

/// Custom table view cell used for displaying the search history table header
class SearchHistoryHeaderViewCell: UITableViewCell {
	
	/// Button to clear search history.
	@IBOutlet var clearButton: UIButton!
	
	/// Button to dismiss search history
	@IBOutlet var cancelButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	/// Override of the reuse identifier property to return the class name
	override var reuseIdentifier: String? {
		
		return SearchHistoryHeaderViewCell.identifier
	}
	
	/// convience method for returning reuse identifier same as class name
	static var identifier: String {
		
		return String(describing: self)
	}
}
