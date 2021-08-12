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
    var flickrSearchViewModel: FlickrSearchViewModel!
    
    var pageNum = Constants.defaultPageNum
    var totalCount = Constants.defaultTotalCount
    var totalPages = Constants.defaultPageNum
    
}

extension FlickrSearchPresenter: FlickrSearchPresenterProtocol {
   
    func recivedError(message: String) {
        view?.recivedError(message: message)
    }
    
    var isMoreDataAvailable: Bool {
        guard totalPages != 0 else {
            return true
        }
        return pageNum < totalPages
    }
    
    //MARK: FlickrSearchViewOutput
    func searchFlickrPhotos(SearchImageName: String) {
        guard isMoreDataAvailable else { return }
        view?.changeViewState(.loading)
        pageNum += 1
        interactor?.loadFlickrPhotos(imageName: SearchImageName, pageNum: pageNum)
    }
    
    //MARK: Photo Seach Success
    fileprivate func insertMoreFlickrPhotos(with flickrPhotoUrlList: [URL]) {
        let previousCount = totalCount
        totalCount += flickrPhotoUrlList.count
        flickrSearchViewModel.addMorePhotoUrls(flickrPhotoUrlList)
        let indexPaths: [IndexPath] = (previousCount..<totalCount).map {
            return IndexPath(item: $0, section: 0)
        }
        DispatchQueue.main.async { [unowned self] in
            self.view?.insertFlickrSearchImages(with: self.flickrSearchViewModel, at: indexPaths)
            self.view?.changeViewState(.content)
        }
    }
    
    func flickrSearchSuccess(flickrPhotos: FlickrPhotos) {
        let flickrPhotoUrlList = buildFlickrPhotoUrlList(from: flickrPhotos.photo)
        guard !flickrPhotoUrlList.isEmpty else {
            return
        }
        if totalCount == Constants.defaultTotalCount {
            flickrSearchViewModel = FlickrSearchViewModel(photoUrlList: flickrPhotoUrlList)
            totalCount = flickrPhotos.photo.count
            totalPages = flickrPhotos.pages
            DispatchQueue.main.async { [unowned self] in
                self.view?.displayFlickrSearchImages(with: self.flickrSearchViewModel)
                self.view?.changeViewState(.content)
            }
        } else {
            insertMoreFlickrPhotos(with: flickrPhotoUrlList)
        }
    }
    
    
    //MARK: FlickrSearchInteractorOutput
    func flickrSearchError(_ error: NetworkError) {
        DispatchQueue.main.async {
            self.view?.changeViewState(.error(error.description))
        }
    }
    
    //MARK: Private Methods
    //Creating Image URL Array
    func buildFlickrPhotoUrlList(from photos: [FlickrPhoto]) -> [URL] {
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
        flickrSearchViewModel = nil
        view?.resetViews()
        view?.changeViewState(.none)
    }
    
}
