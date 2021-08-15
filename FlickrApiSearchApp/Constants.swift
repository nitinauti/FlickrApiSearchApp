//
//  Constants.swift
//  FlickrApiSearchApp
//
//  Created by Nitin Auti on 12/08/21.
//

import Foundation
import UIKit

enum Strings {
    static let flickrSearchTitle = "Flickr Search"
    static let placeholder = "Search Flickr images..."
    static let cancel = "Cancel"
    static let cancelLoading = "Cancel API DownLoading...."
    static let ok = "Ok"
    static let retry = "Retry"
    static let error = "Error"
    static let close = "close"
    static let placeholderImage = "imageNotFound"
}

enum Constants {
    static let screenWidth: CGFloat = UIScreen.main.bounds.width
    static let defaultSpacing: CGFloat = 1
    static let numberOfColumns: CGFloat = 2
    static let defaultPageNum: Int = 0
    static let defaultTotalCount: Int = 0
    static let defaultPageSize: Int = 100
}

enum APIConstants {
    static let flickrAPIKey = "e4ec25586b1907ed41c31cdfcd1ed19e" //Change the API Key here
}

public enum ViewState: Equatable {
    case none
    case loading
    case error(String)
    case content
}
