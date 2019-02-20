//
//  SearchResult.swift
//  Flickr Findr
//
//  Created by Dean Thibault on 2/18/19.
//  Copyright © 2019 Digital Beans. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
	let photos: Photos
	let stat: String
}

struct Photos: Codable {
	let page: Int
	let pages: Int
	let perpage: Int
	let total: String
	let photo: [Photo]
}

struct Photo: Codable {
	let id, owner, secret, server: String
	let farm: Int
	let title: String
	let ispublic, isfriend, isfamily: Int
}

struct APIError: Codable {
	let stat: String
	let code: Int
	let message: String
}
