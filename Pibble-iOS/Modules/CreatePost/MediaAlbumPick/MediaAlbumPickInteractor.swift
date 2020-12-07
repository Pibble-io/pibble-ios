//
//  MediaAlbumPickInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import Photos

fileprivate enum Sections: Int {
  case smart = 0
  case collections
}


// MARK: - MediaAlbumPickInteractor Class
final class MediaAlbumPickInteractor: Interactor {
  fileprivate var sections: [Sections] =  []
  fileprivate var cachedLastAssetsForCollectionId: [String: PHAsset] = [:]
  fileprivate var cachedAssetsCountsForCollectionId: [String: Int] = [:]
  
  fileprivate lazy var assets: (PHFetchResult<PHAssetCollection>, PHFetchResult<PHCollection>) = {
    let smartAlbumsOptions = PHFetchOptions()
   
    //smartAlbumsOptions.sortDescriptors = [NSSortDescriptor(key: "localIdentifier", ascending: true)]
    let smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum,
                                                              subtype: .any, options: smartAlbumsOptions)
    
    let userColllectionsOptions = PHFetchOptions()
    //userColllectionsOptions.sortDescriptors = [NSSortDescriptor(key: "localIdentifier", ascending: true)]
    let userColllections = PHCollectionList.fetchTopLevelUserCollections(with: userColllectionsOptions)
    return (smartAlbums, userColllections)
  }()
  
  fileprivate lazy var imageManager = {
    return PHCachingImageManager()
  }()
  
  fileprivate lazy var imageRequestOptions: PHImageRequestOptions = {
    let opt = PHImageRequestOptions()
    opt.resizeMode = .fast
    opt.deliveryMode = .highQualityFormat
    opt.isNetworkAccessAllowed = true
    return opt
  }()
}

// MARK: - MediaAlbumPickInteractor API
extension MediaAlbumPickInteractor: MediaAlbumPickInteractorApi {
  func pickedItemAt(_ indexPath: IndexPath) -> MediaAlbumPick.Album {
    let section = sections[indexPath.section]
    switch section {
    case .smart:
      return .smartAlbum(assets.0.object(at: indexPath.item))
    case .collections:
      return .userCollection(assets.1.object(at: indexPath.item))
    }
  }
  
  func itemAt(_ indexPath: IndexPath) -> PHCollection {
    let section = sections[indexPath.section]
    switch section {
    case .smart:
      return assets.0.object(at: indexPath.item)
    case .collections:
      return assets.1.object(at: indexPath.item)
    }
  }
  
  func albumItemsCountAt(_ indexPath: IndexPath) -> Int {
    guard let assetCollection = itemAt(indexPath) as? PHAssetCollection else {
      return 0
    }
    
    guard let itemsCount = cachedAssetsCountsForCollectionId[assetCollection.localIdentifier] else {
      let fetchOptions = PHFetchOptions()
      
      let fetchResult = PHAsset.fetchAssets(in: assetCollection, options: fetchOptions)
      cachedAssetsCountsForCollectionId[assetCollection.localIdentifier] = fetchResult.count
      return fetchResult.count
    }
    
    return itemsCount
  }
  
  func dropCachedData() {
 
  }
  
  
  
  func requestImageFor(_ indexPath: IndexPath, config: ImageRequestConfig, result: @escaping ImageRequestResult) {
    guard let assetCollection = itemAt(indexPath)  as? PHAssetCollection else {
      return
    }
    
    guard let asset = lastMediaAssetForCollection(assetCollection) else {
      result(nil, indexPath)
      return
    }
    
    imageManager.requestImage(for: asset, targetSize: config.size, contentMode: config.contentMode, options: imageRequestOptions) { (image, _) in
      result(image, indexPath)
    }
  }
  
  func prepareItemsAt(_ indexPaths: [IndexPath], config: ImageRequestConfig) {

  }
  
  func dropPreparedItemsAt(_ indexPaths: [IndexPath], config: ImageRequestConfig) {

  }
  
  func numberOfSections() -> Int {
    return sections.count
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    let section = sections[section]
    switch section {
    case .smart:
      return assets.0.count
    case .collections:
      return assets.1.count
    }
  }
  
  func initalFetchData() {
    authotizeAndFetch()
  }
  
  func fetchData() {
    DispatchQueue.main.async { [weak self] in
     
      self?.sections = [.smart, .collections]
      self?.presenter.presentReload()
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension MediaAlbumPickInteractor {
    var presenter: MediaAlbumPickPresenterApi {
        return _presenter as! MediaAlbumPickPresenterApi
    }
}

extension MediaAlbumPickInteractor {
  fileprivate func lastMediaAssetForCollection(_ collection: PHAssetCollection) -> PHAsset? {
    guard let asset = cachedLastAssetsForCollectionId[collection.localIdentifier] else {
      let fetchOptions = PHFetchOptions()
      fetchOptions.fetchLimit = 1
      let fetchResult = PHAsset.fetchAssets(in: collection, options: fetchOptions)
      cachedLastAssetsForCollectionId[collection.localIdentifier] = fetchResult.firstObject
      return fetchResult.firstObject
    }
    
    return asset
  }
  
  fileprivate func authotizeAndFetch(){
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
    case .authorized:
      fetchData()
    case .denied:
      presenter.handleError(MediaPick.MediaPickError.access)
    case .notDetermined:
      PHPhotoLibrary.requestAuthorization({ [weak self] (status) in
        if status == PHAuthorizationStatus.authorized {
          self?.fetchData()
        }else{
          self?.presenter.handleError(MediaPick.MediaPickError.access)
        }
      })
    case .restricted:
      presenter.handleError(MediaPick.MediaPickError.access)
    }
  }
}
