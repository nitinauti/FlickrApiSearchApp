//
//  FlickrSearchViewController.swift
//  FlickrApiSearchApp
//
//  Created by Nitin Auti on 12/08/21.
//

import Foundation
import UIKit

//MARK: ViewState
public enum ViewState: Equatable {
    case none
    case loading
    case error(String)
    case content
}


//MARK: FlickrSearchViewController
final class FlickrSearchViewController: UIViewController, FlickrSearchViewProtocol, FlickrSearchEventDelegate {
   
    var presenter: FlickrSearchPresenterProtocol?
    var viewState: ViewState = .none
    var flickrSearchViewModel: FlickrSearchViewModel?
    var searchText = ""
    
    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let spacing = Constants.defaultSpacing
        let itemSize: CGFloat = (UIScreen.main.bounds.width - (Constants.numberOfColumns - spacing) - 2) / Constants.numberOfColumns
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
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
        navigationItem.title = Strings.flickrSearchTitle
        setupViews()
        themeViews()
    }
    
    private func setupViews() {
        configureCollectionView()
        configureSearchController()
    }
    
    private func themeViews() {
        view.backgroundColor = .backgroundColor
        collectionView.backgroundColor = .backgroundColor
    }
    
    private func configureSearchController() {
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.edgesToSuperView()
        collectionView.register(FlickrImageCell.self, forCellWithReuseIdentifier: FlickrImageCell.reuseIdentifier)
    }
    
    /// maintain diffrent state of api
    func changeViewState(_ state: ViewState) {
        viewState = state
        switch state {
        case .loading:
            if flickrSearchViewModel == nil {
                showSpinner()
                showAlertView(title: Strings.cancelLoading, retryAction: { [weak self] in
                    ImageDownloader.shared.cancelAll()
                })
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
    

    /// Recvied image array From API and passed in model class
    func displayFlickrSearchImages(with viewModel: FlickrSearchViewModel) {
        flickrSearchViewModel = viewModel
        collectionView.reloadData()
    }
    
    
    func insertFlickrSearchImages(with viewModel: FlickrSearchViewModel, at indexPaths: [IndexPath]) {
        collectionView.performBatchUpdates({
            self.flickrSearchViewModel = viewModel
            self.collectionView.insertItems(at: indexPaths)
        })
    }
    
    func resetViews() {
        searchController.searchBar.text = nil
        flickrSearchViewModel = nil
        collectionView.reloadData()
    }
    
    //MARK: FlickrSearchEventDelegate
    // called after searching text using serch view controller
    func didTapSearchBar(withText searchText: String) {
        searchController.isActive = false
        guard !searchText.isEmpty || searchText != self.searchText else { return }
        presenter?.clearData()
        
        self.searchText = searchText
        searchController.searchBar.text = searchText
        ImageDownloader.shared.cancelAll()
        presenter?.getSearchedFlickrPhotos(SearchImageName: searchText)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
           themeViews()
        }
    }
}

//MARK: UICollectionViewDataSource & UICollectionViewDelegate
extension FlickrSearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = self.flickrSearchViewModel, !viewModel.isEmpty else {
            return 0
        }
        return viewModel.photoCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = FlickrImageCell()
        
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlickrImageCell.reuseIdentifier, for: indexPath) as! FlickrImageCell
        guard let viewModel = flickrSearchViewModel else {
            return cell
        }
        let imageURL = viewModel.imageUrlAt(indexPath.row)
        cell.configure(imageURL: imageURL, size: collectionViewLayout.itemSize, indexPath: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let viewModel = flickrSearchViewModel else { return }
        guard viewState != .loading, indexPath.row == (viewModel.photoCount - 1) else {
            return
        }
        presenter?.getSearchedFlickrPhotos(SearchImageName: searchText)
    }
    
}

