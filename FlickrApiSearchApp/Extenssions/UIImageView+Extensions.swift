//
//  UIImageView+Extensions.swift
//  FlickrApiSearchApp
//
//  Created by Nitin Auti on 12/08/21.
//

import UIKit

struct AssociatedKeys {
    static var imageUrlKey: UInt64 = 0
}

extension UIImageView {
    
    private(set) var downloadImageURL: URL? {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.imageUrlKey) as? URL else {
                return nil
            }
            return value
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.imageUrlKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    /// load image from remote url
    func loadImage(
        with imageURL: URL,
        placeholder: UIImage? = UIImage(color: .black),
        size: CGSize
    ) {
        image = placeholder
        downloadImageURL = imageURL
        ImageDownloader.shared.downloadImage(
            withURL: imageURL,
            size: size,
            completion: { [weak self] (image, isCached, url, error) in
                guard let self = self, let downloadURL = self.downloadImageURL, imageURL == downloadURL else {
                    return
                }
                DispatchQueue.main.async {
                    if let downloadedImage = image, let isCached = isCached {
                        if isCached {
                            self.image = downloadedImage
                        } else {
                            self.image = downloadedImage
                        }
                    } else {
                        self.image = placeholder
                    }
                }
            }
        )
    }
    
}
