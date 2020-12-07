//
//  MediaPickRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 02.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import Photos

// MARK: - MediaPickRouter class
final class MediaPickRouter: Router {
  fileprivate var mediaAlbumPick: Module?
}

// MARK: - MediaPickRouter API
extension MediaPickRouter: MediaPickRouterApi {
  func routeToMediaAlbumPick(with delegate: MediaAlbumPickDelegateProtocol, in container: UIView) {
    guard let _ = mediaAlbumPick else {
      mediaAlbumPick = AppModules
        .CreatePost
        .mediaAlbumPick(delegate)
        .build()
      
      mediaAlbumPick?.router.show(from: presenter._viewController, insideView: container)
      return
    }
  }
  
  func routeToCameraCapture() {
    let module = AppModules.CreatePost.cameraCapture.build()
    module?.router.present(withPushfrom: presenter._viewController)
  }
  
  func routeToMediaEditWith(_ asset: PHAsset) {

  }
}

// MARK: - MediaPick Viper Components
fileprivate extension MediaPickRouter {
    var presenter: MediaPickPresenterApi {
        return _presenter as! MediaPickPresenterApi
    }
}
