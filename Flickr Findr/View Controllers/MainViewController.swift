//
//  MainCollectionViewController.swift
//  Flickr Findr
//
//  Created by Dean Thibault on 2/18/19.
//  Copyright © 2019 Digital Beans. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
	
	@IBOutlet var collectionView: UICollectionView!
	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	@IBOutlet var searchBar: UISearchBar!
	@IBOutlet var searchHistoryTableView: UITableView!
	@IBOutlet var searchHistoryTableHeightConstraint: NSLayoutConstraint!
	
	private var pageOffset: Int = 0
	private var photos: [Photo] = []
	var searchTerm: String?
	private let reloadDistance: CGFloat = 50
	private let dataLoader = DataLoader()
	var searchHistory: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
		collectionView.register(UINib(nibName: PhotoCollectionViewCell.identifier, bundle: nil),
								forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
		
		searchHistoryTableView.register(UINib(nibName: SearchHistoryTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SearchHistoryTableViewCell.identifier)
		searchHistoryTableView.register(UINib(nibName: SearchHistoryHeaderViewCell.identifier, bundle: nil), forCellReuseIdentifier: SearchHistoryHeaderViewCell.identifier)

		navigationItem.title = Constants.titles.appTitle
		searchHistoryTableView.setBorder(color: .lightGray)
		searchHistory = UserDefaults.loadSearchHistory()
		
		guard let searchTerm = searchTerm else { return }
		
		loadData(searchTerm: searchTerm, dataLoader: dataLoader)
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		
		// update the height of the search history table so that it doesn't fall past bottom of screen
		// execute after delay, so that view can commplete drawing
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
			self.showSearchHistory()
		})
	}
	
	/// Background view to display message when there are no photos to display
	var backgroundView: UIView {
		
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
		label.numberOfLines = 0
		label.text = NSLocalizedString("No matching photos found, please enter a new search term.", comment: "")
		label.textAlignment = .center
		
		return label
	}
	
	/// Clears current photo data
	func reset() {
		
		photos = []
		pageOffset = 0
	}
}
    // MARK: UICollectionViewDataSource
	
extension MainViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

		collectionView.backgroundView = photos.count == 0 ? backgroundView : nil

		return photos.count
    }

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier,
															for: indexPath) as? PhotoCollectionViewCell else { return PhotoCollectionViewCell() }
		let photo = photos[indexPath.row]
		cell.setupCell(photo: photo)
		
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let photo = photos[indexPath.row]
		
		let viewController = ImageScrollViewController()
		viewController.photo = photo
		let backItem = UIBarButtonItem()
		backItem.title = NSLocalizedString("Back", comment: "")
		navigationItem.backBarButtonItem = backItem
		navigationController?.pushViewController(viewController, animated: true)
	}
}

// MARK: Data Loading

extension MainViewController {
	
	/// Initiates the request to retrieve photo data. The completion block result contains an array of Photo. The result array is appended to
	/// existing Photo array and the collection view is reloaded.
	///
	/// - parameter searchTerm: The search string
	///
	/// - returns: void

	func loadData(searchTerm: String, dataLoader: DataLoader) {
		
		activityIndicator.startAnimating()
		
		pageOffset = pageOffset + 1
		
		dataLoader.searchPhotos(searchTerm: searchTerm, page: pageOffset, completion: { [weak self]
			(result) in
			
			self?.activityIndicator?.stopAnimating()
			
			guard let photos = result else { return }
			
			self?.photos.append(contentsOf: photos)
			self?.collectionView.reloadData()
			
			}, failure: { [weak self]
				(result) in
				
				self?.activityIndicator?.stopAnimating()
				let errorMessage = result ?? NSLocalizedString("An error was encountered.", comment: "")
					
				let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
				
				let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: "") , style: .default, handler: nil)
				alertController.addAction(okAction)
				
				self?.present(alertController, animated: true)

		})
	}
}

// MARK: UIScrollViewDelegate

/// Captures scroll drag end events and if collection view has scrolled beyond the end by the specified constant,
/// the next page of photos will be loaded.
extension MainViewController: UIScrollViewDelegate {
	
	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		
		guard let searchTerm = searchTerm, !searchTerm.isEmpty else { return }

		// Determines whether current scroll offset is greater than the reloadDistance constant
		// and loads the next page of photos
		let offset = scrollView.contentOffset
		let bounds = scrollView.bounds
		let inset = scrollView.contentInset
		let y = offset.y + bounds.size.height - inset.bottom
		let height = scrollView.contentSize.height
		
		if y > height + reloadDistance {
			
			loadData(searchTerm: searchTerm, dataLoader: dataLoader)
		}
	}
}

// MARK: UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
	
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		
		showSearchHistory()
	}
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

		searchBar.resignFirstResponder()
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

		searchBar.resignFirstResponder()
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

		searchBar.resignFirstResponder()
		guard let searchTerm = searchTerm, !searchTerm.isEmpty else { return }
		
		// save new search term to search history
		searchHistory =  UserDefaults.addSearchTerm(searchTerm: searchTerm)
		
		hideSearchHistory()
		
		// reset and refresh
		reset()
		collectionView.reloadData()
		// retrieve photos for specified search term
		loadData(searchTerm: searchTerm, dataLoader: dataLoader)
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {


		searchTerm = searchText
	}
}
