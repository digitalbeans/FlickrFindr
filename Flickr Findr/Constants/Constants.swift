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
		
		static let apiKey = "1508443e49213ff84d566777dc211f2a"
		static let photoSearchURL = "https://api.flickr.com/services/rest/?method=flickr.photos.search"
							+ "&api_key=" + apiKey
							+ "&text=%@"
							+ "&per_page=25"
							+ "&page=%d"
							+ "&format=json"
							+ "&nojsoncallback=1"
		
		// params: farm, server-id, id, secret, mstzb
		static let photoURL = "https://farm%d.staticflickr.com/%@/%@_%@_%@.jpg"
	}
	
	struct Image {
		static let placeHolder = "PlaceHolderSmall"
	}
	
	struct titles {
		static let appTitle = "Flickr Findr"
	}
	
	struct UserDefaults {
		static let Suite = "group.com.digitalbeans.flickrfindr"
		static let SearchHistoryKey = "SearchHistory"
	}
	
	struct SearchHistory {
		static let CellHeight: CGFloat = 34.0
		static let HeaderHeight: CGFloat = 30.0
	}
}
