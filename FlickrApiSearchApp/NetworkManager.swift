//
//  NetworkAPIClient.swift
//  FlickrApiSearchApp
//
//  Created by Nitin Auti on 12/08/21.
//

import Foundation
import UIKit

enum ErrorTypes: String {
    case domainError = "Domain Error"
    case decodingError = "We are facing some issues. Please try again later"
    case noInternetError = "No internet connection. Please try again after some time"
}


public class NetworkManager {
    
    /// Api Base request called from each module
    static func connect<RequestType: Codable, ResponseType: Decodable>(httpMethod: HTTPMethod, request: URLRequest, responseType: ResponseType.Type, body: RequestType, completion: @escaping (Result<ResponseType, ErrorModel>) -> Void) {
        
        if !Reachability.isConnectedToNetwork() {
            DispatchQueue.main.async {
                completion(.failure(ErrorModel(message: ErrorTypes.noInternetError.rawValue)))
            }
            return
        }
        var request = request
        request.httpMethod = httpMethod.rawValue
        if httpMethod != .get {
            request.httpBody = try! JSONEncoder().encode(body)
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            data?.printJSON()
                        
        guard let data = data, error == nil else {
                if let error = error as NSError?, error.domain == NSURLErrorDomain {
                    DispatchQueue.main.async {
                        completion(.failure(ErrorModel(message: ErrorTypes.decodingError.rawValue)))
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
                        completion(.failure(ErrorModel(message: ErrorTypes.decodingError.rawValue)))
                    }
                    return
               }
            } else {
                    DispatchQueue.main.async {
                        completion(.failure(ErrorModel(message: ErrorTypes.decodingError.rawValue)))
                    }
                    return
            }
        }
        task.resume()
    }
    
    
    /// download  image form request called from each module
    static func downloadRequest(_ url: URL, size: CGSize, scale: CGFloat, completion: @escaping (Result<UIImage, NetworkError>) -> Void) -> URLSessionDownloadTask {
       
     let downloadTask = URLSession.shared.downloadTask(with: url) { (location: URL?, response: URLResponse?, error: Error?) in
            if let error = error {
                completion(.failure(.apiError(error)))
                return
            }
            guard let location = location else {
                completion(Result.failure(.emptyData))
                return
            }
            guard let downloadedImage = self.downsampleImage(from: location, pointSize: size, scale: scale) else {
                if let data = try? Data(contentsOf: location), let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    completion(.failure(.emptyData))
                }
                return
            }
            completion(.success(downloadedImage))
        }
        downloadTask.resume()
        return downloadTask
    }
    
    //MARK: Downsample Image to given Size
   static func downsampleImage(from url: URL, pointSize: CGSize, scale: CGFloat) -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, imageSourceOptions) else {
            return nil
        }
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        let downsampleOptions = [
             kCGImageSourceCreateThumbnailFromImageAlways: true,
             kCGImageSourceShouldCacheImmediately: true,
             kCGImageSourceCreateThumbnailWithTransform: true,
             kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary
        
        guard let downSampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        return UIImage(cgImage: downSampledImage)
    }
 
}

extension Data {
    func printJSON() {
        if let JSONString = String(data: self, encoding: String.Encoding.utf8) {
            print(JSONString)
        }
    }
}

struct ErrorModel: Error {
    let message: String
}

