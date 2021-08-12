//
//  FlickrImageCell.swift
//  FlickrApiSearchApp
//
//  Created by Nitin Auti on 12/08/21.
//

import UIKit

final class FlickrImageCell: UICollectionViewCell, Reusable {
    
    lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder:) not implemented")
    }
    

    private func setupViews() {
        addSubview(photoImageView)
        photoImageView.edges(to: self)
    }
    
    func configure(imageURL: URL, size: CGSize, indexPath: IndexPath) {
        photoImageView.loadImage(with: imageURL, size: size)
    }
}
