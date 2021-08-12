//
//  APIEndPoint.swift
//  FlickrApiSearchApp
//
//  Created by Nitin Auti on 12/08/21.
//

import Foundation

enum HTTPMethod: String {
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
}

struct Body: Codable {}


///https://api.flickr.com/services/rest/?text=nature&api_key=e4ec25586b1907ed41c31cdfcd1ed19e&method=flickr.photos.search&format=json&nojsoncallback=1&safe_search=1&per_page=20&page=4

public enum ContentType: String {
    case key = "Content-Type", value = "application/json"
}

enum Endpoints: URLRequestConvertible {
    // setting base URL
    static let baseURL = "https://api.flickr.com/services/rest/"
  
    case getFlickrSearch(String,Int)

    var parameters: [String : Any] {
        switch self {
        case .getFlickrSearch(let imageName, let pageNum):
            return [
                "method": "flickr.photos.search",
                "api_key": APIConstants.flickrAPIKey,
                "format": "json",
                "nojsoncallback": 1,
                "safe_search": 1,
                "text": imageName,
                "page": pageNum,
                "per_page": Constants.defaultPageSize
            ]
        }
    }
    
    var urlRequest: URLRequest {
        switch self {
        case .getFlickrSearch(_, _) :
            var components = URLComponents(string: Endpoints.baseURL)
            components?.queryItems = self.queryItems(from: parameters)
            var request = URLRequest(url: (components?.url)!)
            request.addValue(ContentType.value.rawValue, forHTTPHeaderField: ContentType.key.rawValue)
            return request
        }
    }

}

protocol URLRequestConvertible {
    func queryItems(from params: [String: Any]) -> [URLQueryItem]
}

extension URLRequestConvertible{
    func queryItems(from params: [String: Any]) -> [URLQueryItem] {
        let queryItems: [URLQueryItem] = params.compactMap { parameter -> URLQueryItem? in
            var result: URLQueryItem?
            if let intValue = parameter.value as? Int {
                result = URLQueryItem(name: parameter.key, value: String(intValue))
            } else if let stringValue = parameter.value as? String {
                result = URLQueryItem(name: parameter.key, value: stringValue)
            } else if let boolValue = parameter.value as? Bool {
                let value = boolValue ? "1" : "0"
                result = URLQueryItem(name: parameter.key, value: value)
            } else {
                return nil
            }
            return result
        }
        return queryItems
    }
}

