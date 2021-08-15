//
//  FlickrSearchInteractorTest.swift
//  FlickrApiSearchAppTests
//
//  Created by Nitin Auti on 14/08/21.
//

import XCTest
@testable import FlickrApiSearchApp

final class FlickrSearchInteractorTest: XCTestCase {
    
    var interactorMock: FlickrSearchInteractorMock!
    var presenter: FlickrSearchPresenterMock!
    
    override func setUp() {
        presenter = FlickrSearchPresenterMock()
        let network = NetworkManagerMock()
        interactorMock = FlickrSearchInteractorMock(presenter: presenter, network: network)
    }
    
    override func tearDown() {
        interactorMock = nil
        presenter = nil
    }
    
    func testLoadFlickrPhotos() {
        interactorMock?.loadFlickrPhotos(imageName: "nature", pageNum: 1)
        XCTAssertTrue(interactorMock.loadPhotosCalled)
    }
    
    
    func testLoadFlickrPhotosErrorResponse() {
        interactorMock.loadFlickrPhotos(imageName: "nature", pageNum: -1)
        XCTAssertTrue(interactorMock.loadPhotosCalled)
    }

}


final class FlickrSearchInteractorMock: FlickrSearchInteractorProtocol {
    
    
    weak var presenter: FlickrSearchPresenterProtocol?
    var loadPhotosCalled: Bool = false
    var networkProtocol: NetworkProtocol?
    
    init(presenter: FlickrSearchPresenterProtocol, network: NetworkProtocol) {
        self.presenter = presenter
        self.networkProtocol = network
    }
    
    func loadFlickrPhotos(imageName: String, pageNum: Int) {
        networkProtocol?.connect(httpMethod: .post, request: Endpoints.getFlickrSearch(imageName, pageNum).urlRequest, responseType: FlickrSearchPhoto.self, body: Body()) { result  in
            self.loadPhotosCalled = true

            switch result {
            case .success(let FlickrSearch):
                self.presenter?.flickrSearchSuccess(flickrPhotos: FlickrSearch.photos)
            case .failure(let error):
                self.presenter?.flickrSearchError(error)
            }
        }
    }
    
    
    
}
