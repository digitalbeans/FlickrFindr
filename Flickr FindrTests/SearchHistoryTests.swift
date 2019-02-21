//
//  SearchHistoryTests.swift
//  Flickr FindrTests
//
//  Created by Dean Thibault on 2/21/19.
//  Copyright © 2019 Digital Beans. All rights reserved.
//

import XCTest
@testable import Flickr_Findr

class SearchHistoryTests: XCTestCase {
	
	let first = "First"
	let second = "Second"

    override func setUp() {
		// reset search history
        UserDefaults.saveSearchHistory(searchHistory: [])
    }

    override func tearDown() {
		// reset search history
		UserDefaults.saveSearchHistory(searchHistory: [])
    }

	// verifies adding and removing from search history
    func testSearchHistory() {
		
		// add first search term
		var searchHistory = UserDefaults.addSearchTerm(searchTerm: first)

		// verify retrieved search history is not empty
		XCTAssert(!searchHistory.isEmpty)
		XCTAssert(searchHistory.count == 1)
		XCTAssertEqual(first, searchHistory[0])
		
		// add second search term
		searchHistory = UserDefaults.addSearchTerm(searchTerm: second)

		// validate adding element to search history
		XCTAssert(!searchHistory.isEmpty)
		XCTAssert(searchHistory.count == 2)
		XCTAssertEqual(second, searchHistory[0])

		// validate clearing search history
		UserDefaults.saveSearchHistory(searchHistory: [])
		searchHistory = UserDefaults.loadSearchHistory()
		XCTAssert(searchHistory.isEmpty)
	}
}
