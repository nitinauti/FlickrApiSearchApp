//
//  NetworkAPIClient.swift
//  FlickrApiSearchApp
//
//  Created by Nitin Auti on 12/08/21.
//

import Foundation
import UIKit

protocol NetworkProtocol {
    @discardableResult
    func connect<RequestType: Codable, ResponseType: Decodable>(httpMethod: HTTPMethod, request: URLRequest, responseType: ResponseType.Type, body: RequestType, completion: @escaping (Result<ResponseType, NetworkError>) -> Void) -> URLSessionDataTask
    
    func downloadImageRequest(_ url: URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void) -> URLSessionDownloadTask

}

public class NetworkManager: NetworkProtocol {
    
    /// Api Base request called from each module
    @discardableResult
    func connect<RequestType: Codable, ResponseType: Decodable>(httpMethod: HTTPMethod, request: URLRequest, responseType: ResponseType.Type, body: RequestType, completion: @escaping (Result<ResponseType, NetworkError>) -> Void) -> URLSessionDataTask {
        
        
        var request = request
        request.httpMethod = httpMethod.rawValue
        if httpMethod != .get {
            request.httpBody = try! JSONEncoder().encode(body)
        }
        print("current Request URL:  ",request)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
        data?.printJSON()
                        
             guard let data = data, error == nil else {
                if let error = error as NSError?, error.domain == NSURLErrorDomain {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.apiError(error)))
                    }
                }
                return
            }
            
            if (response as? HTTPURLResponse)?.statusCode == 200 {
                do {
                    let decodedResult = try JSONDecoder().decode(ResponseType.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(decodedResult))
                    }
                    return
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.decodingError))
                    }
                    return
               }
            } else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.somethingWentWrong))
                    }
                return
            }
        }
        task.resume()
        return task
    }
    
    
    /// download  image form request called from each module
    func downloadImageRequest(_ url: URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void) -> URLSessionDownloadTask {
       
       let downloadTask = URLSession.shared.downloadTask(with: url) { (imageUrl: URL?, response: URLResponse?, error: Error?) in
            
            if let error = error {
                completion(.failure(.apiError(error)))
                return
            }
           
            guard let imageurl = imageUrl else {
                completion(Result.failure(.emptyData))
                return
            }
               
            if let data = try? Data(contentsOf: imageurl), let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    completion(.failure(.imageFail))
            }
            return
        }
        downloadTask.resume()
        return downloadTask
    }
     
}

extension Data {
    func printJSON() {
        if let JSONString = String(data: self, encoding: String.Encoding.utf8) {
            print("Response ", JSONString)
        }
    }
}

struct urlRequest {
    
    func urlRequest()->URLRequest{
        var urlRequest = URLRequest(url: URL(string: "")!)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest.addValue(ContentType.value.rawValue, forHTTPHeaderField: ContentType.key.rawValue)
        
        return urlRequest
    }
}
