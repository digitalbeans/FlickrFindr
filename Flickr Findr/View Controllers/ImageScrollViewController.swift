//
//  ImageScrollViewController.swift
//  Flickr Findr
//
//  Created by Dean Thibault on 2/19/19.
//  Copyright © 2019 Digital Beans. All rights reserved.
//

import UIKit

/// A view displaying an image in a scroll view so that the image can be zoomed.

class ImageScrollViewController: UIViewController {

	/// Photo to be displayed in this view
	var photo: Photo?
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
	@IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
	
	override func viewDidLoad() {
		
		super.viewDidLoad()
		
//		let backItem = UIBarButtonItem()
//		backItem.title = NSLocalizedString("Back", comment: "")
//		navigationItem.backBarButtonItem = backItem
	}
	
	override func viewDidLayoutSubviews() {
		
		super.viewDidLayoutSubviews()
		updateConstraintsForSize(view.frame.size)
		updateMinZoomScaleForSize(size: view.bounds.size)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		
		super.viewWillAppear(animated)
		
		imageView.image = nil
		
		if let photo = photo {
			
			navigationItem.title = photo.title
			let urlString = String(format: Constants.Flickr.photoURL, photo.farm, photo.server, photo.id, photo.secret, PhotoType.large1024.rawValue)
			
			guard let url = URL(string: urlString) else { return }
			
			imageView.image(from: url)
		}
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		
		super.viewWillTransition(to: size, with: coordinator)
		coordinator.animate(alongsideTransition: nil, completion: {
			_ in
			
			self.updateMinZoomScaleForSize(size: size)
		})
		
	}
	private func updateMinZoomScaleForSize(size: CGSize) {
		
		let widthScale = size.width / imageView.bounds.width
		let heightScale = size.height / imageView.bounds.height
		let minScale = min(widthScale, heightScale)
		scrollView.minimumZoomScale = minScale
		scrollView.zoomScale = minScale
	}
	
	fileprivate func updateConstraintsForSize(_ size: CGSize) {
		
		let yOffset = max(0, (size.height - imageView.frame.height) / 2)
		imageViewTopConstraint.constant = yOffset
		imageViewBottomConstraint.constant = yOffset
		
		let xOffset = max(0, (size.width - imageView.frame.width) / 2)
		imageViewLeadingConstraint.constant = xOffset
		imageViewTrailingConstraint.constant = xOffset
		
		view.layoutIfNeeded()
	}
	
	@IBAction func tappedBackground(_ sender: UIGestureRecognizer) {
		
		updateMinZoomScaleForSize(size: view.bounds.size)
	}
}

extension ImageScrollViewController: UIScrollViewDelegate {
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		
		return imageView
	}
	
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		updateConstraintsForSize(view.bounds.size)
	}
}

