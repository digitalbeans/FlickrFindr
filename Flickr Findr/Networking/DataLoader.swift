//
//  DataLoader.swift
//  Flickr Findr
//
//  Created by Dean Thibault on 2/18/19.
//  Copyright © 2019 Digital Beans. All rights reserved.
//

import Foundation
import Alamofire

/// Flickr image size suffixes
enum PhotoType: String {
	/// small, 240 on longest side
	case small240 = "m"
	/// small square 75x75
	case smallSquare75 = "s"
	/// thumbnail, 100 on longest side
	case thumbnail100 = "t"
	/// medium 640, 640 on longest side
	case mediumSquare640 = "z"
	/// large, 1024 on longest side
	case large1024 = "b"
}

/// This class handles all of the communications with the Flickr Restful API.
class DataLoader {
	
	/// Makes a get request to the Flickr flickr.photos.search api
	///
	/// - parameter searchTerm: The search string
	/// - parameter page: The page offset for results to retreive
	/// - parameter completion: The completion block to be called when search results are retrieved, takes an array of Photo as parameter.
	///
	/// - returns: void
	
	func searchPhotos(searchTerm: String, page: Int = 1, completion: @escaping (_ result: [Photo]?) -> Void, failure: @escaping (_ result: String?) -> Void) {
		
		guard let urlString = String(format: Constants.Flickr.photoSearchURL, searchTerm, page).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
			  let url = URL(string: urlString) else {
			
			failure("Error processing URL")
			return
		}
		
		Alamofire.request(url)
			.validate()
			.responseJSON { response in
				
				guard response.result.isSuccess,
				      let data = response.data else {
						
					failure(response.result.error?.localizedDescription)
					return
				}
				
				do {
					
					let decoder = JSONDecoder()
					let result = try decoder.decode(SearchResult.self, from: data)
					completion(result.photos.photo)
				}
				catch {
					
					print("Error decoding type \(Photos.self);\n  \(error)")
					self.handleError(data: data, failure: failure)
				}
		}
	}
	
	/// Parses error JSON data and passes error message to failure completion block
	///
	/// - parameter data: JSON data
	/// - parameter failure: The completion block to be called when failure is encountered, takes error string as parameter.
	///
	/// - returns: void

	func handleError(data: Data, failure: @escaping (_ result: String?) -> Void) {
		
		do {
			
			let decoder = JSONDecoder()
			let result = try decoder.decode(APIError.self, from: data)
			failure(result.message)
		}
		catch {
			
			print("Error decoding type \(APIError.self);\n  \(error)")
			failure(nil)
		}

	}
}
