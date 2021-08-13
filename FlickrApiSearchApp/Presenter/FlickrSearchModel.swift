//
//  flickrSearchModel.swift
//  FlickrApiSearchApp
//
//  Created by Nitin Auti on 12/08/21.
//

import Foundation

struct FlickrSearchModel {
    
    var photoUrlList: [URL] = []
    
    init(photoUrlList: [URL]) {
        self.photoUrlList = photoUrlList
    }
    
    
    var isEmpty: Bool {
        return photoUrlList.isEmpty
    }
    
    var photoCount: Int {
        return photoUrlList.count
    }
    
    /// append list of url to existing url array
    mutating func addMorePhotoUrls(_ photoUrls: [URL]) {
        self.photoUrlList += photoUrls
    }
}

extension FlickrSearchModel {
    
    func imageUrlAt(_ index: Int) -> URL {
        guard !photoUrlList.isEmpty else {
            fatalError("No imageUrls available")
        }
        return photoUrlList[index]
    }
    
}
