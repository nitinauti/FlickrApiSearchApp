//
//  FlickrSearchInteractor.swift
//  FlickrApiSearchApp
//
//  Created by Nitin Auti on 12/08/21.
//

import Foundation

class FlickrSearchInteractor: FlickrSearchInteractorProtocol {
    var presenter: FlickrSearchPresenterProtocol?
    
    let networkProtocol : NetworkProtocol
    
    init(network:NetworkProtocol) {
        self.networkProtocol = network
    }

    func loadFlickrPhotos(imageName: String, pageNum: Int) {
      
        networkProtocol.connect(httpMethod: .post, request: Endpoints.getFlickrSearch(imageName, pageNum).urlRequest, responseType: FlickrSearchPhoto.self, body: Body()) { result  in
            
            switch result {
            case .success(let FlickrSearch):
                self.presenter?.flickrSearchSuccess(flickrPhotos: FlickrSearch.photos)
            case .failure(let error):
                self.presenter?.flickrSearchError(error)
            }
        }
    }
}
