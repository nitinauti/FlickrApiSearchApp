//
//  FlickrSearchWireframeTest.swift
//  FlickrApiSearchAppTests
//
//  Created by Nitin Auti on 14/08/21.
//

import XCTest
import UIKit
@testable import FlickrApiSearchApp

final class FlickrSearchWireframeTest: XCTestCase {

    var wireFrameMock: FlickrSearchWireFrameMock!
 
    override func setUp() {
        super.setUp()
        wireFrameMock = FlickrSearchWireFrameMock()
    }

    override func tearDown() {
       wireFrameMock = nil
    }

    func testPresentFlickrSearchModule(){
        wireFrameMock.presentFlickrSearchModule(fromView:FlickrSearchViewController())
        XCTAssertTrue(wireFrameMock.showFlickrPhotoDetailsCalled)
    }
   
}

final class FlickrSearchWireFrameMock: FlickrSearchWireFrameProtocol {
   
    
    var wireFrame: FlickrSearchWireFrameProtocol?
    var showFlickrPhotoDetailsCalled = false
    
  
     func presentFlickrSearchModule(fromView: AnyObject) {
             showFlickrPhotoDetailsCalled = true
        wireFrame?.presentFlickrSearchModule(fromView:fromView)
    }
    
}
