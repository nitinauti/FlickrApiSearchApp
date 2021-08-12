//
//  UIViewController+Extensions.swift
//  FlickrApiSearchApp
//
//  Created by Nitin Auti on 12/08/21.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, retryAction: (() -> Void)? = nil) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if retryAction != nil {
            alertViewController.addAction(UIAlertAction(title: Strings.cancel, style: .default))
        }
        let title = (retryAction == nil) ? Strings.ok : Strings.retry
        alertViewController.addAction(UIAlertAction(title: title, style: .default) { _ in
            retryAction?()
        })
        present(alertViewController, animated: true)
    }
    
}
