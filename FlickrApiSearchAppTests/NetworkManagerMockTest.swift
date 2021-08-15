//
//  NetworkManagerMockTest.swift
//  FlickrApiSearchAppTests
//
//  Created by Nitin Auti on 14/08/21.
//

import XCTest
@testable import FlickrApiSearchApp

final class NetworkingTests: XCTestCase {

    var network : NetworkManagerMock?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        network = NetworkManagerMock()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        network = nil
    }
    
    func testNetworkConnectRequestSuccess() {
       
        network?.connect(httpMethod:.get, request:Endpoints.getFlickrSearch("nature", 1).urlRequest, responseType:FlickrSearchPhoto.self, body: Body()) { (result) in
            
            switch result {
            case let .success(photos):
                XCTAssertTrue(photos.photos.photo.count == 2)
                XCTAssertFalse(photos.photos.page == 0)
            case .failure:
                break
            }
        }
    }
        
    func testNetworkConnectRequestFailure() {
       
        network?.connect(httpMethod:.get, request:Endpoints.getFlickrSearch("Notfound", 1).urlRequest, responseType:FlickrSearchPhoto.self, body: Body()) { (result) in
            
            switch result {
            case let .success(photos):
                XCTAssertTrue(photos.photos.photo.count == 2)
                XCTAssertFalse(photos.photos.page == 0)
            case .failure:
                break
            }
        }
    }
    
    func testImageDownloadSuccess() {
        let imageUrl = URL(string: "https://farm2.static.flickr.com/100/12345_/12345.jpg")!
        _ = network?.downloadImageRequest(imageUrl, completion: { (result) in
            switch result {
            case let .success(image):
                XCTAssertFalse(image == UIImage(color: .black))
            case .failure:
                XCTFail("Should go to success")
            }
        })
    }
    
    func testImageDownloadFailure() {
        let imageUrl = URL(string: "https://farm2.static.flickr.com/101/123_/123.jpg")!
        _ = network?.downloadImageRequest(imageUrl, completion: { (result: Result<UIImage, NetworkError>) in
            switch result {
            case let .failure(networkError):
                 XCTAssertTrue(networkError.description == "Something went wrong.")
            case .success:
                XCTFail("Should go to failure")
            }
        })
    }
    
    
}
    
 class NetworkManagerMock: NetworkProtocol {

    @discardableResult
    func downloadImageRequest(_ url: URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void) -> URLSessionDownloadTask {
   
        let downloadTask = URLSession.shared.downloadTask(with:URL(string: "https://farm2.static.flickr.com/100/12345_/12345.jpg")!) { (imageUrl: URL?, response: URLResponse?, error: Error?) in
             
            XCTAssertNotNil(error)
            
            XCTAssertNotNil(imageUrl)
            
           guard let httpResponse = response as? HTTPURLResponse else {
               XCTFail("unexpected response")
               return
           }
           XCTAssertEqual(200, httpResponse.statusCode)
         }
         downloadTask.resume()
         return downloadTask
    }
    
    
    func connect<RequestType, ResponseType>(httpMethod: HTTPMethod, request: URLRequest, responseType: ResponseType.Type, body: RequestType, completion: @escaping (Result<ResponseType, NetworkError>) -> Void) -> URLSessionDataTask where ResponseType : Decodable {
        
        let str = (request.url?.absoluteString ?? "")
      
        if  (str.contains("nature")) {
            let fileUrl = Bundle.main.url(forResource: "FlickerAPISearchTestData", withExtension: "json")
            let data = try! Data(contentsOf: fileUrl!)
            let json = try! JSONDecoder().decode(ResponseType.self, from: data)
            completion(Result.success(json))
       
        } else if (str.contains("NotFound")) {
            completion(Result.failure(.invalidStatus(401)))
       
        }
        return URLSessionDataTask()
    }
    
}
