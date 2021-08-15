//
//  ImageOperation.swift
//  FlickrApiSearchApp
//
//  Created by Nitin Auti on 12/08/21.
//

import UIKit

final class ImageOperation: Operation {
    
    var imageDownloadCompletionHandler: ((Result<UIImage, NetworkError>) -> Void)?
    
    public let imageURL: URL
    private var downloadTask: URLSessionDownloadTask?
    let networkProtocol : NetworkProtocol

    init(imageURL: URL, network:NetworkProtocol) {
        self.imageURL = imageURL
        self.networkProtocol = network
    }
    
    
//    /// opration sate
    private enum OperationState: String, Equatable {
        case ready = "isReady"
        case executing = "isExecuting"
        case finished = "isFinished"
    }

    private var _state = OperationState.ready {
        willSet {
            willChangeValue(forKey: newValue.rawValue)
            willChangeValue(forKey: _state.rawValue)
        }
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: _state.rawValue)
        }
    }

    private var state: OperationState {
        get {
            return _state
        }
        set {
            _state = newValue
        }
    }

    // MARK: - Various `Operation` properties
    override var isReady: Bool {
        return state == .ready && super.isReady
    }

    override var isExecuting: Bool {
        return state == .executing
    }

    override var isFinished: Bool {
        return state == .finished
    }


    // MARK: - Start
    override func start() {
        if isCancelled {
            print("opration cancelled 2222")

            finish()
            return
        }

        if !isExecuting {
            state = .executing
        }

        main()
    }

    // MARK: - Finish
        func finish() {
        if isExecuting {
            state = .finished
        }
    }

    // MARK: - Cancel
    override func cancel() {
        downloadTask?.cancel()
        print("opration cancelled")
        finish()
        super.cancel()
    }
    
    //MARK: - Main
    override func main() {
        downloadImage()
    }
    
    private func downloadImage() {
        print("image url in opration", imageURL)
        print("opration cancelled 11111")
 
        downloadTask = self.networkProtocol.downloadImageRequest(imageURL, completion: { [weak self] (result: Result<UIImage, NetworkError>) in
            self?.imageDownloadCompletionHandler?(result)
            self?.finish()
        })
    }
}

