//
//  FlickrSearchViewController.swift
//  FlickrApiSearchApp
//
//  Created by Nitin Auti on 12/08/21.
//

import Foundation
import UIKit



final class FlickrSearchViewController: UIViewController, FlickrSearchViewProtocol, FlickrSearchEventDelegate {
   
    var presenter: FlickrSearchPresenterProtocol?
    var viewState: ViewState = .none
    var flickrSearchModel: FlickrSearchModel?
    let spacing = Constants.defaultSpacing
    var searchText = ""
    
    lazy var itemSize: CGFloat = {
        var itemsize =  CGFloat()
         itemsize = (UIScreen.main.bounds.width - (Constants.numberOfColumns - spacing) - 2) / Constants.numberOfColumns
         return itemsize
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var searchController: UISearchController = {
        let searchVC = SearchViewController()
        searchVC.searchDelegate = self
        let controller = UISearchController(searchResultsController: searchVC)
        controller.obscuresBackgroundDuringPresentation = true
        controller.searchResultsUpdater = nil
        controller.searchBar.placeholder = Strings.placeholder
        controller.searchBar.delegate = searchVC
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationItem.title = Strings.flickrSearchTitle
        configureCollectionView()
        configureSearchController()
    }
    
    private func configureSearchController() {
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        //collectionView.edgesToSuperView()
        collectionView.register(FlickrImageCell.self, forCellWithReuseIdentifier: FlickrImageCell.reuseIdentifier)
    }
    
    /// maintain diffrent state of api
    func changeViewState(_ state: ViewState) {
        viewState = state
        switch state {
        case .loading:
            if flickrSearchModel == nil {
                showSpinner()
            }
        case .content:
            hideSpinner()
            dissmissAlertView()

        case .error(let message):
            hideSpinner()
            dissmissAlertView()
            showAlert(title: Strings.error, message: message, retryAction: { [unowned self] in
                self.presenter?.getSearchedFlickrPhotos(SearchImageName: self.searchText)
            })
        default:
            break
        }
    }

    /// Recvied image array From API and passed in model class and reload Collectionview
    func displayFlickrSearchImages(with viewModel: FlickrSearchModel) {
        flickrSearchModel = viewModel
        collectionView.reloadData()
    }
    
    func resetViews() {
        searchController.searchBar.text = nil
        flickrSearchModel = nil
        collectionView.reloadData()
    }
    
    //MARK: FlickrSearchEventDelegate
    // called after searching text using serchViewController:
    func didTapSearchBar(withText searchText: String) {
        searchController.isActive = false
        guard !searchText.isEmpty || searchText != self.searchText else { return }
        presenter?.clearData()
        self.searchText = searchText
        searchController.searchBar.text = searchText
        presenter?.getSearchedFlickrPhotos(SearchImageName: searchText)

        /// called cancel api loading
        if Reachability.isConnectedToNetwork() {
            self.showAlertView(message: Strings.cancelLoading, Action: { [unowned self] in
                self.cancelDownloading()
            })
        }
    }
    
    func cancelDownloading(){
        ImageDownloader.shared.cancelAll()
    }
    
}

//MARK: UICollectionViewDataSource & UICollectionViewDelegate
extension FlickrSearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = self.flickrSearchModel, !viewModel.isEmpty else {
            return 0
        }
        return viewModel.photoCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = FlickrImageCell()
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickrImageCell.reuseIdentifier, for: indexPath) as! FlickrImageCell
        guard let viewModel = flickrSearchModel else {
            return cell
        }
        let imageURL = viewModel.imageUrlAt(indexPath.row)
        cell.configure(imageURL: imageURL, size: CGSize(width: itemSize, height: itemSize), indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
      {
          return CGSize(width: itemSize, height: itemSize)
      }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
       {
           return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
       }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let viewModel = flickrSearchModel else { return }
        guard viewState != .loading, indexPath.row == (viewModel.photoCount - 1) else {
            return
        }
        presenter?.getSearchedFlickrPhotos(SearchImageName: searchText)
        self.showAlertView(message: Strings.cancelLoading, Action: { [unowned self] in
            self.cancelDownloading()
        })

    }
    
}

