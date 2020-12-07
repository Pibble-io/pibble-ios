//
//  MediaAlbumPickModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import Photos

enum MediaAlbumPick {
  enum Album {
    case none
    case smartAlbum(PHAssetCollection)
    case userCollection(PHCollection)
  }
  
  struct MediaAlbumPickItemViewModel: MediaAlbumPickItemViewModelProtocol {
    let indexPath: IndexPath
    let albumItemsCount: String
    let albumTitle: String
    let previewImageRequest: MediaAlbumPickRequest
    
    init(assetCollection: PHCollection, albumItemsCount: Int, indexPath: IndexPath, previewImageRequest: @escaping MediaAlbumPickRequest) {
      self.indexPath = indexPath
      self.previewImageRequest = previewImageRequest
      self.albumItemsCount = String(albumItemsCount)
      albumTitle = assetCollection.localizedTitle ?? ""
    }
  }
}
