//
//  MockDataLoader.swift
//  Flickr FindrTests
//
//  Created by Dean Thibault on 2/20/19.
//  Copyright © 2019 Digital Beans. All rights reserved.
//

import Foundation
@testable import Flickr_Findr

class MockDataLoader: DataLoader {
	
	var testPhotos: [Photo] = [
		Photo(id: "1", owner: "2", secret: "3", server: "xyz", farm: 1, title: "Image 1", ispublic: 1, isfriend: 1, isfamily: 1),
		Photo(id: "2", owner: "2", secret: "3", server: "mno", farm: 1, title: "Image 2", ispublic: 1, isfriend: 1, isfamily: 1)		   ]
	
	var testError: APIError = APIError(stat: "fail", code: 1, message: "An error occurred")
	
	var isFailure: Bool = false
	
	override func searchPhotos(searchTerm: String, page: Int, completion: @escaping ([Photo]?) -> Void, failure: @escaping (String?) -> Void) {
		
		if isFailure {
			failure(testError.message)
		}
		else {
			completion(testPhotos)
		}
	}
}
