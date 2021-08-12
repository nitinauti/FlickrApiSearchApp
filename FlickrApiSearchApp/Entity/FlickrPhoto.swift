//
//  FlickrPhoto.swift
//  FlickrAPIDemo
//
//  Created by Nitin Auti on 11/08/21.
//

import Foundation

struct FlickrPhoto: Codable {
    let farm: Int
    let id: String
    let owner: String
    let secret: String
    let server: String
    let title: String
}
