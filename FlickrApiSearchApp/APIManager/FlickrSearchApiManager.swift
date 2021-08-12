//
//  FlickrSearchApiManager.swift
//  FlickrApiSearchApp
//
//  Created by Nitin Auti on 12/08/21.
//

import Foundation

class FlickrSearchApiManager: FlickrSearchAPIManagerProtocol {
    
    func getFlickrSearch(imageName: String, pageNum: Int, completionHandler: @escaping (Result<FlickrSearchPhoto, ErrorModel>) -> ()) {
        
        NetworkManager.connect(httpMethod: .get, request: Endpoints.getFlickrSearch(imageName, pageNum).urlRequest, responseType: FlickrSearchPhoto.self, body: Body()) { result in
            completionHandler(result)
        }
        
    }
}
