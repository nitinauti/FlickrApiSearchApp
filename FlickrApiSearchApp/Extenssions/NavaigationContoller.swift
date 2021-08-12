//
//  NavaigationContoller+Extenssion.swift
//  FlickrApiSearchApp
//
//  Created by Nitin Auti on 12/08/21.
//

import Foundation
import UIKit

public class NavaigationContoller:UINavigationController {
    static private var window: UIWindow?
    static var RootViewController = UINavigationController()

    
    static func setRootViewController(ViewController: UIViewController){
        window = UIWindow(frame: UIScreen.main.bounds)
        RootViewController = UINavigationController(rootViewController: ViewController)
        window?.rootViewController = RootViewController
        window?.makeKeyAndVisible()
    }
    
    static func PushViewController(ViewController: UIViewController){
        RootViewController.pushViewController(ViewController, animated: true)
    }
    
}
