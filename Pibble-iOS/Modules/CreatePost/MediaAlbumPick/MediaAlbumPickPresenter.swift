//
//  MediaAlbumPickPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - MediaAlbumPickPresenter Class
final class MediaAlbumPickPresenter: Presenter {
  fileprivate weak var delegate: MediaAlbumPickDelegateProtocol?
  
  init(delegate: MediaAlbumPickDelegateProtocol) {
    self.delegate = delegate
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initalFetchData()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    viewController.reloadCollection()
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
  }
  
  override func viewDidDisappear() {
    super.viewDidDisappear()
    interactor.dropCachedData()
  }
}

// MARK: - MediaAlbumPickPresenter API
extension MediaAlbumPickPresenter: MediaAlbumPickPresenterApi {
  func numberOfSections() -> Int {
    return interactor.numberOfSections()
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return interactor.numberOfItemsInSection(section)
  }
  
  
  func itemViewModelFor(_ indexPath: IndexPath, config: ImageRequestConfig) -> MediaAlbumPickItemViewModelProtocol {
    let assetCollection = interactor.itemAt(indexPath)
    let itemsCount = interactor.albumItemsCountAt(indexPath)
    let previewImageRequest: MediaAlbumPickRequest = { [weak self] complete in
      self?.interactor.requestImageFor(indexPath, config: config, result: complete)
    }
    
    let vm = MediaAlbumPick
      .MediaAlbumPickItemViewModel(assetCollection: assetCollection,
                                   albumItemsCount: itemsCount,
                                   indexPath: indexPath,
                                   previewImageRequest: previewImageRequest)
    return vm
  }
  
  func handleItemSelectionAt(_ indexPath: IndexPath) {
    guard interactor.albumItemsCountAt(indexPath) > 0 else {
      return
    }
    
    let pickedItem = interactor.pickedItemAt(indexPath)
    delegate?.didSelectMediaAlbum(pickedItem)
  }
  
  func handlePrefetchingItemsAt(_ indexPaths: [IndexPath], config: ImageRequestConfig) {
    interactor.prepareItemsAt(indexPaths, config: config)
  }
  
  func handleCancelPrefetchingItemsAt(_ indexPaths: [IndexPath], config: ImageRequestConfig) {
    interactor.dropPreparedItemsAt(indexPaths, config: config)
  }
  
  func presentReload() {
    viewController.reloadCollection()
  }
  
}

// MARK: - MediaAlbumPick Viper Components
fileprivate extension MediaAlbumPickPresenter {
    var viewController: MediaAlbumPickViewControllerApi {
        return _viewController as! MediaAlbumPickViewControllerApi
    }
    var interactor: MediaAlbumPickInteractorApi {
        return _interactor as! MediaAlbumPickInteractorApi
    }
    var router: MediaAlbumPickRouterApi {
        return _router as! MediaAlbumPickRouterApi
    }
}


extension MediaAlbumPickPresenter {
//  fileprivate func requestItemViewModelFor(_ indexPath: IndexPath, config: ImageRequestConfig, result: @escaping MediaAlbumPickItemCompletion) {
//    let assetCollection = interactor.itemAt(indexPath)
//    let itemsCount = interactor.albumItemsCountAt(indexPath)
//    interactor.requestImageFor(indexPath, config: config) { [weak self] (image, idx) in
//      let vm = MediaAlbumPick
//        .MediaAlbumPickItemViewModel(assetCollection: assetCollection, albumItemsCount: itemsCount, previewImage: image)
//      result(vm, idx)
//    }
//  }
}
