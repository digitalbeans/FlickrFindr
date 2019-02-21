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
	
	/// Adds item to search history and saves to user defaults.
	/// New search is added to the first position in the array. If new search term alrady exists in array, it is removed.
	///
	/// - parameter searchTerm: The new search term to add.
	///
	/// - returns: [String] String array representing the updated search history
	
	static func addSearchTerm(searchTerm: String) -> [String] {
		
		var array = UserDefaults.loadSearchHistory()
		array =	array.filter { $0 != searchTerm }
		array.insert(searchTerm, at: 0)
		UserDefaults.saveSearchHistory(searchHistory: array)
		return array
	}
}
