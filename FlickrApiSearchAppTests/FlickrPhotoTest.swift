//
//  FlickrPhotoTest.swift
//  FlickrApiSearchAppTests
//
//  Created by Nitin Auti on 15/08/21.
//


import XCTest
@testable import FlickrApiSearchApp

final class FlickrPhotoTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //MARK: Test sample response mapping to FlickrPhotos
    func testFlickrPhotosJSONDecoder() {
        let fileUrl = Bundle.main.url(forResource: "FlickerAPISearchTestData", withExtension: "json")
        let data = try! Data(contentsOf: fileUrl!)
        let flickrPhotos = try! JSONDecoder().decode(FlickrSearchPhoto.self, from: data)
        XCTAssertFalse(flickrPhotos.photos.photo.isEmpty)
        XCTAssertTrue(flickrPhotos.photos.photo.count == 2)
        XCTAssertTrue(flickrPhotos.photos.page == 1)
        XCTAssertTrue(flickrPhotos.photos.total == 2)
        XCTAssertTrue(flickrPhotos.photos.perpage == 2)
    }
}
