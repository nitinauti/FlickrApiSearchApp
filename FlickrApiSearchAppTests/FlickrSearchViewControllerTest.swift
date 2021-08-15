//
//  FlickrSearchViewControllerTest.swift
//  FlickrApiSearchAppTests
//
//  Created by Nitin Auti on 14/08/21.
//

import XCTest
import UIKit
import Foundation
@testable import FlickrApiSearchApp

final class FlickrSearchViewControllerTest: XCTestCase {
    
    var viewMock: FlickrSearchViewControllerMock!
    var presenterMock: FlickrSearchPresenterMock!
    
    override func setUp() {
        super.setUp()
        presenterMock = FlickrSearchPresenterMock() 
        viewMock = FlickrSearchViewControllerMock(presenter: presenterMock)

    }
    
    override func tearDown() {
        viewMock = nil
        presenterMock = nil
    }
    
    func testshowSpinner(){
        viewMock.showSpinner()
        XCTAssertTrue(viewMock.showSpinnerCalled)
    }
    
    func testSpinner(){
        viewMock.hideSpinner()
        XCTAssertTrue(viewMock.hideSpinnerCalled)
    }

}



final class FlickrSearchViewControllerMock: FlickrSearchViewProtocol {
  
    var presenter: FlickrSearchPresenterProtocol?

    var showFlickrImages = false
    var showSpinnerCalled = false
    var hideSpinnerCalled = false

    
    init(presenter: FlickrSearchPresenterProtocol) {
        self.presenter = presenter
    }
        
    func changeViewState(_ state: ViewState) {}
    
    func displayFlickrSearchImages(with viewModel: FlickrSearchModel) {
        XCTAssertFalse(viewModel.isEmpty)
        XCTAssertTrue(viewModel.photoUrlList.count == 2)
        showFlickrImages = true
    }
    
    func insertFlickrSearchImages(with viewModel: FlickrSearchModel, at indexPaths: [IndexPath]) {}
    
    func resetViews() {
        
    }
    
    func showSpinner() {
        showSpinnerCalled = true
    }
    
    func hideSpinner() {
        hideSpinnerCalled = true
    }
    
}



