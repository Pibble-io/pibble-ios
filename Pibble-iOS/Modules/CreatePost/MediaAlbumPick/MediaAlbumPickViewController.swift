//
//  MediaAlbumPickViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import Photos

//MARK: MediaAlbumPickView Class
final class MediaAlbumPickViewController: ViewController {
  //MARK:- IBOutlets
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupLayout()
  }
  
  //MARK:- properties
  
  fileprivate lazy var imageConfig = {
    return ImageRequestConfig(size: mediaItemSize, contentMode: PHImageContentMode.aspectFill)
  }()
}

//MARK: - MediaAlbumPickView API
extension MediaAlbumPickViewController: MediaAlbumPickViewControllerApi {
  func reloadCollection() {
    collectionView.reloadData()
  }
}

// MARK: - MediaAlbumPickView Viper Components API
fileprivate extension MediaAlbumPickViewController {
    var presenter: MediaAlbumPickPresenterApi {
        return _presenter as! MediaAlbumPickPresenterApi
    }
}

//MARK:- UICollectionViewDataSourcePrefetching

extension MediaAlbumPickViewController: UICollectionViewDataSourcePrefetching {
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    presenter.handlePrefetchingItemsAt(indexPaths, config: imageConfig)
  }
  
  func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    presenter.handleCancelPrefetchingItemsAt(indexPaths, config: imageConfig)
  }
}


//MARK:- UICollectionViewDelegate, UICollectionViewDataSource
extension MediaAlbumPickViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    presenter.handleItemSelectionAt(indexPath)
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return presenter.numberOfSections()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let viewModel = presenter.itemViewModelFor(indexPath, config: imageConfig)
    let cell = collectionView.dequeueReusableCell(cell: MediaAlbumPickCollectionViewCell.self, for: indexPath)
    cell.setViewModel(viewModel)
    return cell
  }
}


//MARK:- Helpers

extension MediaAlbumPickViewController {
  fileprivate var mediaItemSize: CGSize {
    let space = UIConstants.MediaCollectionView.mediaColumnsInnerSpacing * CGFloat(UIConstants.MediaCollectionView.numberOfColumns - 1)
    
    let width = (collectionView.bounds.width - space) / CGFloat(UIConstants.MediaCollectionView.numberOfColumns)
    return CGSize(width: width, height: width)
  }
  
  func setupView() {
    collectionView.registerCell(MediaAlbumPickCollectionViewCell.self)
    
    collectionView.dataSource = self
    collectionView.delegate = self
    collectionView.prefetchDataSource = self
    collectionView.isPrefetchingEnabled = true
  }
  
  func setupLayout() {
    let layout = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout)
    
    layout.itemSize = mediaItemSize
    layout.minimumLineSpacing = UIConstants.MediaCollectionView.mediaColumnsInnerSpacing
    
    layout.minimumInteritemSpacing = UIConstants.MediaCollectionView.mediaColumnsInnerSpacing
    
    view.clipsToBounds = true
  }
}

fileprivate enum UIConstants {
  enum MediaCollectionView {
    static let mediaColumnsInnerSpacing: CGFloat = 1.0
    static let numberOfColumns = 2
  }
}
