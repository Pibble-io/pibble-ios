//
//  MediaAlbumPickModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import Photos

typealias MediaAlbumPickItemCompletion = (MediaAlbumPickItemViewModelProtocol, IndexPath) -> Void
typealias MediaAlbumPickRequest = (@escaping ImageRequestResult) -> Void


//MARK: - MediaAlbumPickRouter API
protocol MediaAlbumPickRouterApi: RouterProtocol {
}

//MARK: - MediaAlbumPickView API
protocol MediaAlbumPickViewControllerApi: ViewControllerProtocol {
   func reloadCollection()
}

//MARK: - MediaAlbumPickPresenter API
protocol MediaAlbumPickPresenterApi: PresenterProtocol {
  func numberOfSections() -> Int
  
  func numberOfItemsInSection(_ section: Int) -> Int
  
  func itemViewModelFor(_ indexPath: IndexPath, config: ImageRequestConfig) -> MediaAlbumPickItemViewModelProtocol
  
  func handleItemSelectionAt(_ indexPath: IndexPath)
  
  func handlePrefetchingItemsAt(_ indexPaths: [IndexPath], config: ImageRequestConfig)
  
  func handleCancelPrefetchingItemsAt(_ indexPaths: [IndexPath], config: ImageRequestConfig)
  
  func presentReload()
}

//MARK: - MediaAlbumPickInteractor API
protocol MediaAlbumPickInteractorApi: InteractorProtocol {
  func initalFetchData()
  
  func dropCachedData()
  
  func numberOfSections() -> Int
  
  func numberOfItemsInSection(_ section: Int) -> Int
  
  func albumItemsCountAt(_ indexPath: IndexPath) -> Int
  
  func requestImageFor(_ indexPath: IndexPath, config: ImageRequestConfig, result: @escaping ImageRequestResult)
 
  func prepareItemsAt(_ indexPaths: [IndexPath], config: ImageRequestConfig)
  
  func dropPreparedItemsAt(_ indexPaths: [IndexPath], config: ImageRequestConfig)
  
  func itemAt(_ indexPath: IndexPath) -> PHCollection
  
  func pickedItemAt(_ indexPath: IndexPath) -> MediaAlbumPick.Album
  
}

protocol MediaAlbumPickItemViewModelProtocol {
  var indexPath: IndexPath { get }
  var previewImageRequest: (@escaping ImageRequestResult) -> Void { get }
  var albumItemsCount: String { get }
  var albumTitle: String { get }
}

protocol MediaAlbumPickDelegateProtocol: class {
  func didSelectMediaAlbum(_ album: MediaAlbumPick.Album)
}
