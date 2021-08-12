//
//  flickrSearchViewModel.swift
//  FlickrApiSearchApp
//
//  Created by Nitin Auti on 12/08/21.
//

import Foundation

struct FlickrSearchViewModel {
    
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
    
    mutating func addMorePhotoUrls(_ photoUrls: [URL]) {
        self.photoUrlList += photoUrls
    }
}

extension FlickrSearchViewModel {
    
    func imageUrlAt(_ index: Int) -> URL {
        guard !photoUrlList.isEmpty else {
            fatalError("No imageUrls available")
        }
        return photoUrlList[index]
    }
    
}
