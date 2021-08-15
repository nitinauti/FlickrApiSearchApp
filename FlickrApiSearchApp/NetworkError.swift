//
//  NetworkError.swift
//  FlickrApiSearchApp
//
//  Created by Nitin Auti on 12/08/21.
//

import Foundation

enum NetworkError: Swift.Error, CustomStringConvertible {
    
    case apiError(Swift.Error)
    case noInternetError
    case emptyData
    case decodingError
    case somethingWentWrong
    case imageFail
    case invalidStatus(Int)

    
    public var description: String {
        switch self {
        case let .apiError(error):
            return "Network Error: \(error.localizedDescription)"
        case .decodingError:
            return "Json Decoding Error."
        case .emptyData:
            return "Empty response from the server"
        case .somethingWentWrong:
            return "Something went wrong."
        case .noInternetError:
             return "No internet connection. Please try again after some time"
        case .imageFail:
             return "image failed to download from url"
        case let .invalidStatus(stausCode):
             return "return invalid status code:  \(stausCode)"
        }
    }
}
