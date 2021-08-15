//
//  FlickrSearchPresenterTests.swift
//  FlickrApiSearchAppTests
//
//  Created by Nitin Auti on 14/08/21.
//

import XCTest
@testable import FlickrApiSearchApp

final class FlickrSearchPresenterTests: XCTestCase {
    
    var interactorMock: FlickrSearchInteractorMock!
    var presenterMock: FlickrSearchPresenterMock!
    var viewMock: FlickrSearchViewControllerMock!
    var wireFrameMock: FlickrSearchWireFrameMock?
    var network: NetworkProtocol!
    
    override func setUp() {
        presenterMock = FlickrSearchPresenterMock()
        network = NetworkManagerMock()
        interactorMock = FlickrSearchInteractorMock(presenter: presenterMock, network: network)
        wireFrameMock = FlickrSearchWireFrameMock()
        viewMock = FlickrSearchViewControllerMock(presenter: presenterMock)
        
        presenterMock.interactor = interactorMock
        presenterMock.view = viewMock
        presenterMock.wireFrame = wireFrameMock
    }
    
    override func tearDown() {
        presenterMock = nil
        viewMock = nil
        interactorMock = nil
        network = nil
    }
    
    func testSearchMethodCall() {
        presenterMock.getSearchedFlickrPhotos(SearchImageName: "nature")
        XCTAssertTrue(viewMock.showFlickrImages)
        XCTAssertNotNil(presenterMock.flickrSearchViewModel)
        XCTAssertTrue(presenterMock.flickrSearchViewModel.photoCount == 2)
    }
    
    
    func testDidSelectPhotoCall() {
        presenterMock.didSelectPhoto(at: 0)
        XCTAssertTrue(presenterMock.selectedPhoto)
    }
    
    func testflickrSearchError(_ error: NetworkError) {
        presenterMock.flickrSearchError(.emptyData)
        XCTAssertTrue(presenterMock.flickrSearchFailure)
    }
    
    func testChangeViewState() {
        presenterMock.flickrSearchError(.emptyData)
        XCTAssertTrue(presenterMock.changeSateCalled)
    }
    
    func testclearData(){
        presenterMock.clearData()
        XCTAssertTrue(presenterMock.resetViewCalled)
    }
}

final class FlickrSearchPresenterMock: FlickrSearchPresenterProtocol {
    
    var view: FlickrSearchViewProtocol?    
    var interactor: FlickrSearchInteractorProtocol?
    var wireFrame: FlickrSearchWireFrameProtocol?
    var flickrSearchViewModel: FlickrSearchModel!
    
    var isMoreDataAvailable: Bool { return true }
    var flickrSearchSuccess = false
    var flickrSearchFailure = false
    var changeSateCalled = false
    var resetViewCalled = false
    var selectedPhoto = false

    func getSearchedFlickrPhotos(SearchImageName: String) {
        interactor?.loadFlickrPhotos(imageName: SearchImageName, pageNum: 1)
    }
    
    func flickrSearchSuccess(flickrPhotos: FlickrPhotos) {
        flickrSearchSuccess = true
        XCTAssertFalse(flickrPhotos.photo.isEmpty)
        let flickrPhotoList = buildFlickrPhotoUrlList(from: flickrPhotos.photo)
        let viewModel = FlickrSearchModel(photoUrlList: flickrPhotoList)
        self.flickrSearchViewModel = viewModel
        view?.displayFlickrSearchImages(with: viewModel)
    }
   
    
    func flickrSearchError(_ error: NetworkError) {
        changeSateCalled = true
        view?.changeViewState(.loading)
    }
    
    func clearData() {
        resetViewCalled = true
        view?.resetViews()
    }
    
    //MARK: FlickrImageURLList
    func buildFlickrPhotoUrlList(from photos: [FlickrPhoto]) -> [URL] {
        let flickrPhotoUrlList = photos.compactMap { (photo) -> URL? in
            let url = "https://farm\(photo.farm).staticflickr.com.com/\(photo.server)/\(photo.id)_\(photo.secret).jpg"
            guard let imageUrl = URL(string: url) else {
                return nil
            }
            return imageUrl
        }
        return flickrPhotoUrlList
    }
    
    func didSelectPhoto(at index: Int) {
        selectedPhoto = true
    }
    
}

