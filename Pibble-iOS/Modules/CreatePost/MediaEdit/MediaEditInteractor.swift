//
//  MediaEditInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import Photos

// MARK: - MediaEditInteractor Class
final class MediaEditInteractor: Interactor {
  private(set) var inputMedia: MediaType
  fileprivate var outputAsset: MediaType?
  
  fileprivate lazy var imageManager = {
    return PHCachingImageManager()
  }()
  
  init(inputAsset: MediaType) {
    self.inputMedia = inputAsset
  }
}

// MARK: - MediaEditInteractor API
extension MediaEditInteractor: MediaEditInteractorApi {
  func getOutputMedia() {
    guard let outputAsset = outputAsset else {
      presenter.handleError(MediaEdit.MediaEditError.couldNotLoadMedia)
      return
    }
    
    presenter.presentOutput(outputAsset)
  }
  
//  var inputMedia: InputMediaType {
//    return inputMediaAsset
//  }
  
  func initialFetchMedia(_ request: MediaEdit.MediaFetchRequest) {
    switch request {
    case .video:
      if case let MediaType.video(assetURL) = inputMedia {
        let asset = AVAsset(url: assetURL)
        outputAsset = .video(assetURL)
        requestMediaFor(asset)
      }
    case .image:
      if case let MediaType.image(image) = inputMedia {
        outputAsset = .image(image)
        presenter.presentMedia(.image(image.underlyingAsset))
      }
    case .libraryMediaItem(let requestConfig):
      if case let MediaType.libraryMediaItem(asset) = inputMedia  {
        outputAsset = .libraryMediaItem(asset)
        requestMediaFor(asset.underlyingAsset, requestConfig: requestConfig)
      }
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension MediaEditInteractor {
    var presenter: MediaEditPresenterApi {
        return _presenter as! MediaEditPresenterApi
    }
}

extension MediaEditInteractor {
  fileprivate func requestMediaFor(_ asset: AVAsset) {
    DispatchQueue.global(qos: .userInteractive).async {
      let playerItem = AVPlayerItem(asset: asset)
      let player = AVPlayer(playerItem: playerItem)
      let layer = AVPlayerLayer(player: player)
      
      DispatchQueue.main.async { [weak self] in
        //self?.outputAsset = .video(asset)
        self?.presenter.presentMedia(.video(layer))
        player.play()
      }
    }
  }
  
  fileprivate func requestMediaFor(_ asset: PHAsset, requestConfig: ImageRequestConfig) {
    if asset.mediaType == .video {
      imageManager.requestAVAsset(forVideo: asset, options: nil) { [weak self] (videoAsset, audio, _) in
        guard let videoAsset = videoAsset else  {
          self?.presenter.handleError(MediaEdit.MediaEditError.couldNotLoadMedia)
          return
        }
       
        self?.requestMediaFor(videoAsset)
      }
//
//      imageManager.requestPlayerItem(forVideo: asset, options: nil) { [weak self] (playerItem, _) in
//        guard let playerItem = playerItem else {
//          self?.presenter.handleError(MediaEditModule.MediaEditError.couldNotLoadMedia)
//          return
//        }
//        DispatchQueue.global(qos: .userInteractive).async {
//          let player = AVPlayer(playerItem: playerItem)
//          let layer = AVPlayerLayer(player: player)
//
//          DispatchQueue.main.async { [weak self] in
//            self?.presenter.presentMedia(.video(layer))
//            player.play()
//          }
//        }
//      }
    } else {
      imageManager.requestImage(for: asset, targetSize: requestConfig.size, contentMode: requestConfig.contentMode, options: nil) { [weak self] (image, _) in
        if let image = image {
          DispatchQueue.main.async { [weak self] in
//            self?.outputAsset = .image(image)
            self?.presenter.presentMedia(.image(image))
          }
        }
      }
    }
  }
}
