//
//  MainViewControllerTests.swift
//  Flickr FindrTests
//
//  Created by Dean Thibault on 2/20/19.
//  Copyright © 2019 Digital Beans. All rights reserved.
//

import XCTest
@testable import Flickr_Findr

class MainViewControllerTests: XCTestCase {
	
	var mainViewController: MainViewController = MainViewController()

    override func setUp() {
		
		mainViewController.loadView()
		mainViewController.viewDidLoad()

	}

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
	// Tests the loading of data

    func testLoadDataSuccess() {
		
		let mockDataLoader = MockDataLoader()
		mainViewController.loadData(searchTerm: "", dataLoader: mockDataLoader)
		
		// Verifies the initial load of data
		XCTAssert(mainViewController.collectionView(mainViewController.collectionView, numberOfItemsInSection: 0) == 2)

		// Verifies loading second page of data
		mainViewController.loadData(searchTerm: "", dataLoader: mockDataLoader)
		XCTAssert(mainViewController.collectionView(mainViewController.collectionView, numberOfItemsInSection: 0) == 4)
	}

	// tests failure in loading data
    func testLoadDataFail() {

		let mockDataLoader = MockDataLoader()
		mockDataLoader.isFailure = true
		mainViewController.loadData(searchTerm: "", dataLoader: mockDataLoader)
		
		// Verifies the empty photos on failure
		XCTAssert(mainViewController.collectionView(mainViewController.collectionView, numberOfItemsInSection: 0) == 0)
		
		// Verify empty list message displayed
		XCTAssertNotNil(mainViewController.collectionView.backgroundView)
	}

}
