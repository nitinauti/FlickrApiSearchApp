//
//  FlickrSearchProtocols.swift
//  FlickrApiSearchApp
//
//  Created by Nitin Auti on 12/08/21.
//

import Foundation
import UIKit



//MARK: BaseViewInput
protocol BaseViewInput: AnyObject {
    func showSpinner()
    func hideSpinner()
}

extension BaseViewInput where Self: UIViewController {
    func showSpinner() {
        view.showSpinner()
    }
    
    func hideSpinner() {
        view.hideSpinner()
    }
}

//MARK: Reusable
protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

//MARK: NibLoadable
protocol NibLoadable: AnyObject {
    static var nib: UINib { get }
}

extension NibLoadable {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

typealias NibReusable = Reusable & NibLoadable

extension NibLoadable where Self: UIView {
    static func loadFromNib(withOwner owner: Any? = nil) -> UIView {
        guard let view = nib.instantiate(withOwner: owner, options: nil).first as? UIView else {
            fatalError("the nib \(nib) is not found")
        }
        return view
    }
}

protocol FlickrSearchViewProtocol: BaseViewInput {
    var presenter: FlickrSearchPresenterProtocol? { get set }

    /**
    * Add here your methods for communication PRESENTER -> VIEW
    */
    func displayFlickrSearchImages(with viewModel: FlickrSearchModel)
    func resetViews()
    func changeViewState(_ state: ViewState)    
}

protocol FlickrSearchWireFrameProtocol: class {
    
    /**
    * Add here your methods for communication PRESENTER -> WIREFRAME
    */
     func presentFlickrSearchModule(fromView:AnyObject)
   
}

protocol FlickrSearchPresenterProtocol: AnyObject {
    var view: FlickrSearchViewProtocol? { get set }
    var interactor: FlickrSearchInteractorProtocol? { get set }
    var wireFrame: FlickrSearchWireFrameProtocol? { get set }

    /**
    * Add here your methods for communication VIEW -> PRESENTER
    */
    
    func clearData()
    func getSearchedFlickrPhotos(SearchImageName: String)
    func flickrSearchSuccess(flickrPhotos: FlickrPhotos)
    func flickrSearchError(_ error: NetworkError)

    /**
    * Add here your methods for communication INTERACTOR -> PRESENTER
    */
  
}

protocol FlickrSearchInteractorProtocol: class{
    var presenter: FlickrSearchPresenterProtocol? { get set }

    /**
    * Add here your methods for communication PRESENTER -> INTERACTOR
    */
    func loadFlickrPhotos(imageName: String, pageNum: Int)

}

