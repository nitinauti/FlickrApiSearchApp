//
//  FlickrSearchInteractor.swift
//  FlickrApiSearchApp
//
//  Created by Nitin Auti on 12/08/21.
//

import Foundation

class FlickrSearchInteractor: FlickrSearchInteractorProtocol {
    var presenter: FlickrSearchPresenterProtocol?
    var APIManager: FlickrSearchAPIManagerProtocol?
      
    func loadFlickrPhotos(imageName: String, pageNum: Int) {
        
        APIManager?.getFlickrSearch(imageName: imageName, pageNum: pageNum, completionHandler: { result  in
            print(result)
            switch result {
            case .success(let FlickrSearch):
                self.presenter?.flickrSearchSuccess(flickrPhotos: FlickrSearch.photos)
            case .failure(let error):
                self.presenter?.flickrSearchError(NetworkError.apiError(error))
            }
        })
    }

}
