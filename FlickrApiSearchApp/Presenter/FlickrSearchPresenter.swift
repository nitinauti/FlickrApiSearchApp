//
//  FlickrSearchPresenter.swift
//  FlickrApiSearchApp
//
//  Created by Nitin Auti on 12/08/21.
//

import Foundation
class FlickrSearchPresenter {
    var view: FlickrSearchViewProtocol?
    var interactor: FlickrSearchInteractorProtocol?
    var wireFrame: FlickrSearchWireFrameProtocol?
    var flickrSearchModel: FlickrSearchModel!
    
    var pageNum = Constants.defaultPageNum
    var totalCount = Constants.defaultTotalCount
    var totalPages = Constants.defaultPageNum
    
}

extension FlickrSearchPresenter: FlickrSearchPresenterProtocol {
       
    func flickrSearchError(_ error: NetworkError){
        DispatchQueue.main.async {
          self.view?.changeViewState(.error(error.description))
        }
    }

    var isMoreDataAvailable: Bool {
        guard totalPages != 0 else {
            return true
        }
        return pageNum < totalPages
    }
    
    ///
    func getSearchedFlickrPhotos(SearchImageName: String) {
        guard isMoreDataAvailable else { return }
        view?.changeViewState(.loading)
        pageNum += 1
        interactor?.loadFlickrPhotos(imageName: SearchImageName, pageNum: pageNum)
    }
    
        /// Receved Ficker Photo from intracter -> convert into URL List Array
    func flickrSearchSuccess(flickrPhotos: FlickrPhotos) {
        let flickrPhotoUrlList = crateFlickrPhotoUrlList(from: flickrPhotos.photo)
        guard !flickrPhotoUrlList.isEmpty else {
            return
        }
        /// initally Total count will be zero
        if totalCount == Constants.defaultTotalCount {
            flickrSearchModel = FlickrSearchModel(photoUrlList: flickrPhotoUrlList)
            totalCount = flickrPhotos.photo.count
            totalPages = flickrPhotos.pages
            DispatchQueue.main.async { [unowned self] in
                self.view?.displayFlickrSearchImages(with: self.flickrSearchModel)
                self.view?.changeViewState(.content)
            }
        } else {
            /// method called for page count 2
            appendMoreFlickrPhotos(with: flickrPhotoUrlList)
        }
    }
    
    /// method called after suseesfully load first page .
    fileprivate func appendMoreFlickrPhotos(with flickrPhotoUrlList: [URL]) {
        let previousCount = totalCount
        totalCount += flickrPhotoUrlList.count
        flickrSearchModel.addMorePhotoUrls(flickrPhotoUrlList)
      
        let indexPaths: [IndexPath] = (previousCount..<totalCount).map {
            return IndexPath(item: $0, section: 0)
        }
        DispatchQueue.main.async { [unowned self] in
            self.view?.insertFlickrSearchImages(with: self.flickrSearchModel, at: indexPaths)
            self.view?.changeViewState(.content)
        }
    }
    
    
    func crateFlickrPhotoUrlList(from photos: [FlickrPhoto]) -> [URL] {
        let flickrPhotoUrlList = photos.compactMap { (photo) -> URL? in
            let url = "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_z.jpg"
            guard let imageUrl = URL(string: url) else {
                return nil
            }
            return imageUrl
        }
        return flickrPhotoUrlList
    }
    
    func clearData() {
        pageNum = Constants.defaultPageNum
        totalCount = Constants.defaultTotalCount
        totalPages = Constants.defaultTotalCount
        flickrSearchModel = nil
        view?.resetViews()
        view?.changeViewState(.none)
    }
    
}
