//
//  File.swift
//  Flickr Findr
//
//  Created by Dean Thibault on 2/18/19.
//  Copyright © 2019 Digital Beans. All rights reserved.
//

import UIKit

struct Constants {
	
	struct Flickr {
		
		/// Flickr api-key
		static let apiKey = "1508443e49213ff84d566777dc211f2a"
		
		/// URL to use for the photo search REST API
		static let photoSearchURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search"
							+ "&api_key=" + apiKey
							+ "&text=%@"
							+ "&per_page=25"
							+ "&page=%d"
							+ "&format=json"
							+ "&nojsoncallback=1"
		
		/// URL to use for retrieving image
		/// params: farm, server-id, id, secret, mstzb
		static let photoURL = "https://farm%d.staticflickr.com/%@/%@_%@_%@.jpg"
	}
	
	struct Image {
		
		/// Default placeholder image name
		static let placeHolder = "PlaceHolderSmall"
	}
	
	struct titles {
		/// App display name
		static let appTitle = "Flickr Findr"
	}
	
	struct UserDefaults {
		/// UserDefaults suite name
		static let suite = "group.com.digitalbeans.flickrfindr"
		/// Key to use for saving/retrieving search history from user defaults
		static let searchHistoryKey = "SearchHistory"
	}
	
	struct SearchHistory {
		/// default height for search history table cell
		static let cellHeight: CGFloat = 34.0
		/// default height for search history table header
		static let headerHeight: CGFloat = 30.0
	}
}
