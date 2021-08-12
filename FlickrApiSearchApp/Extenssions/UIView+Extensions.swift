//
//  UIView+Extensions.swift
//  FlickrApiSearchApp
//
//  Created by Nitin Auti on 12/08/21.
//

import Foundation
import UIKit

extension UIView {
    
    //MARK: AutoLayout
    func edgesToSuperView(constant: CGFloat = 0) {
        guard let superview = superview else {
            preconditionFailure("superview is missing for this view")
        }
        translatesAutoresizingMaskIntoConstraints = false
        edges(to: superview, constant: constant)

    }

    func edges(to view: UIView, constant: CGFloat = 0) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func showSpinner() {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = UIColor.activityIndicatorColor
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func hideSpinner() {
        guard let spinner = self.subviews.last as? UIActivityIndicatorView else { return }
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }
}
