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
	
	private var pageOffset: Int = 0
	private var photos: [Photo] = []
    private var searchTerm: String?
	private let reloadDistance: CGFloat = 50
	private let dataLoader = DataLoader()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
		collectionView.register(UINib(nibName: PhotoCollectionViewCell.identifier, bundle: nil),
								forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)

		navigationItem.title = Constants.titles.appTitle
		
		guard let searchTerm = searchTerm else { return }
		
		loadData(searchTerm: searchTerm, dataLoader: dataLoader)
	}
	
	var backgroundView: UIView {
		
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
		label.numberOfLines = 0
		label.text = NSLocalizedString("No matching photos found, please enter a new search term.", comment: "")
		label.textAlignment = .center
		
		return label
	}
	
	func reset() {
		
		photos = []
		pageOffset = 0
	}
}
    // MARK: UICollectionViewDataSource
	
extension MainViewController: UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {

		return 1
    }

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

//extension MainViewController: UICollectionViewDelegateFlowLayout {
//	
//	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//		
//	}
//	
//}

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

extension MainViewController: UISearchBarDelegate {
	
	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

		searchBar.resignFirstResponder()
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

		searchBar.resignFirstResponder()
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

		searchBar.resignFirstResponder()
		guard let searchTerm = searchTerm, !searchTerm.isEmpty else { return }
		
		reset()
		collectionView.reloadData()
		loadData(searchTerm: searchTerm, dataLoader: dataLoader)
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {


		searchTerm = searchText
	}
}
