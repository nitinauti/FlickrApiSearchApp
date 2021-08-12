//
//  FlickrSearchWireframe.swift
//  FlickrApiSearchApp
//
//  Created by Nitin Auti on 12/08/21.
//

import Foundation
import UIKit

class FlickrSearchWireframe: FlickrSearchWireFrameProtocol {
  
    static func presentFlickrSearchModule(fromView:AnyObject) {
        let view : FlickrSearchViewProtocol = FlickrSearchViewController()
        let presenter: FlickrSearchPresenterProtocol  = FlickrSearchPresenter()
        let interactor: FlickrSearchInteractorProtocol = FlickrSearchInteractor()
        let APIDataManager: FlickrSearchAPIManagerProtocol = FlickrSearchApiManager()
        let wireFrame: FlickrSearchWireFrameProtocol = FlickrSearchWireframe()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.wireFrame = wireFrame
        interactor.presenter = presenter
        interactor.APIManager = APIDataManager
        guard let viewController = view as? FlickrSearchViewController else { return }
        NavaigationContoller.setRootViewController(ViewController:viewController)
     }
    
}
