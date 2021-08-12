//
//  Photos.swift
//  FlickrAPIDemo
//
//  Created by Nitin Auti on 11/08/21.
//

import Foundation

struct FlickrPhotos: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photo: [FlickrPhoto]
}
