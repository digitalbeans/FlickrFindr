//
//  UserDefaults+FlickrFindr.swift
//  Flickr Findr
//
//  Created by Dean Thibault on 2/20/19.
//  Copyright © 2019 Digital Beans. All rights reserved.
//

import Foundation

/// Extension to UserDefaults to allow for saving the search history
extension UserDefaults {
	
	/// Retrieves the UserDefaults suite for the app
	///
	/// - returns: UserDefaults for Flickr Findr

	static func searchHistory() -> UserDefaults? {
		
		return UserDefaults.init(suiteName: Constants.UserDefaults.Suite)
	}
	
	/// Saves the search history to user defaults
	///
	/// - parameter searchHistory: The array representing the search history
	///
	/// - returns: void
	
	static func saveSearchHistory(searchHistory: [String]) {
		
		UserDefaults.searchHistory()?.set(searchHistory, forKey: Constants.UserDefaults.SearchHistoryKey)
		UserDefaults.searchHistory()?.synchronize()
	}
	
	/// Loads the search history from user defaults
	///
	/// - returns: [String] String array representing the search history
	
	static func loadSearchHistory() -> [String] {
		
		guard let array = UserDefaults.searchHistory()?.array(forKey: Constants.UserDefaults.SearchHistoryKey) as? [String]  else { return [] }
		
		return array
	}
	
}
