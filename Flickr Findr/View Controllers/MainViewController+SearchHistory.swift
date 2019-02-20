//
//  MainViewController+TableView.swift
//  Flickr Findr
//
//  Created by Dean Thibault on 2/20/19.
//  Copyright © 2019 Digital Beans. All rights reserved.
//

import UIKit

/// Extension to add UITableViewDataSource handling to MainViewController
extension MainViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return searchHistory.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryTableViewCell.identifier, for: indexPath) as? SearchHistoryTableViewCell else {
			return UITableViewCell()
		}
		
		cell.titleLabel.text = searchHistory[indexPath.row]
		
		return cell
	}
	
	
}

/// Extension to add UITableViewDelegate handling to MainViewController
extension MainViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchHistoryHeaderViewCell.identifier) as? SearchHistoryHeaderViewCell else {
			return nil
		}
		
		cell.clearButton.addTarget(self, action: #selector(clearSearchHistory(_:)), for: .touchUpInside)
		
		return cell.contentView
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		tableView.deselectRow(at: indexPath, animated: true)
		
		searchTerm = searchHistory[indexPath.row]
		searchBar.text = searchTerm
		searchBarSearchButtonClicked(searchBar)
	}
	
}

// MARK: Search history

/// Extension to add handling of search history to MainViewController
extension MainViewController {
	
	/// Clears the search history
	@IBAction func clearSearchHistory(_ sender: Any) {
		
		searchHistory = []
		UserDefaults.saveSearchHistory(searchHistory: searchHistory)
		hideSearchHistory()
	}

	/// Adds item to search history and saves to user defaults
	///
	/// - parameter searchTerm: The new search term to add.
	///
	/// - returns: void

	func addSearchTerm(searchTerm: String) {
		
		var array = searchHistory.filter { $0 != searchTerm }
		array.insert(searchTerm, at: 0)
		searchHistory = array
		UserDefaults.saveSearchHistory(searchHistory: array)
	}
	
	/// Hides the search history table view
	///
	/// - returns: void

	func hideSearchHistory() {
		
		searchHistoryTableHeightConstraint.constant = 0
		searchHistoryTableView.layoutIfNeeded()
	}
	
	/// Displays the search history table view
	///
	/// - returns: void
	
	func showSearchHistory() {
		
		guard !searchHistory.isEmpty else { return }
		
		searchHistoryTableView.reloadData()
		let height:CGFloat = (CGFloat(searchHistory.count) * Constants.SearchHistory.CellHeight) + Constants.SearchHistory.HeaderHeight
		
		searchHistoryTableHeightConstraint.constant = height
		searchHistoryTableView.layoutIfNeeded()
	}
}
