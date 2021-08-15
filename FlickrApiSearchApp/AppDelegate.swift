//
//  AppDelegate.swift
//  FlickrApiSearchApp
//
//  Created by Nitin Auti on 12/08/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureURLCache()
        FlickrSearchWireframe().presentFlickrSearchModule(fromView:FlickrSearchViewController())
        return true
    }

    /// Configure URLCache for Image Caching
    fileprivate func configureURLCache() {
        let memoryCapacity = 500 * 1024 * 1024 // 500 MB Memory Cache
        let diskCapacity = 500 * 1024 * 1024 // 500 MB Disk Cache
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "DataCachePath")
        URLCache.shared = cache
    }
    

}

