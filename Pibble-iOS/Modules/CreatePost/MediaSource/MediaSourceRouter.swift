//
//  MediaSourceRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 09.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import Photos

// MARK: - MediaSourceRouter class


final class MediaSourceRouter: Router {
  fileprivate let postDraft: MutablePostDraftProtocol
  fileprivate var currentModule: Module?
  
  fileprivate var preBuiltModules: [MediaSource.Segments: Module] = [:]
  fileprivate lazy var modules: [MediaSource.Segments: (ConfigurableModule, ModuleConfigurator)] = {
    let config: MediaPick.Config
    
    switch postDraft.draftPostType {
    case .media, .charity, .crowdfunding, .crowdfundingWithReward, .goods:
      config = .multipleItems(limit: 20)
    case .digitalGood:
      config = .images(limit: 20)
    }
    
    let library: (ConfigurableModule, ModuleConfigurator) =
      (AppModules.CreatePost.mediaPick(self, config), MediaPickModuleConfigurator.defaultConfig(AppModules.servicesContainer, self, config))
    
    let photo: (ConfigurableModule, ModuleConfigurator) =
      (AppModules.CreatePost.cameraCapture, CameraCaptureModuleConfigurator.photoConfig(AppModules.servicesContainer, self))
    
    let video: (ConfigurableModule, ModuleConfigurator) =
      (AppModules.CreatePost.cameraCapture, CameraCaptureModuleConfigurator.videoConfig(AppModules.servicesContainer, self))
    
    return [.library: library, .photo: photo, .video: video]
  }()
  
  init(postDraft: MutablePostDraftProtocol) {
    self.postDraft = postDraft
  }
  
  fileprivate func routeToPostingWith(_ assets: [LibraryAsset], postingType: MutablePostDraftProtocol) {
    postingType.attachedMedia = assets.map { MediaType.libraryMediaItem($0) }
    
    let module = AppModules
      .CreatePost
      .mediaPosting(postingType)
      .build()
    
    module?.view.transitionsController.presentationAnimator = FadeAnimationController(presenting: true)
    module?.view.transitionsController.dismissalAnimator = FadeAnimationController(presenting: false)
    module?.router.present(withPushfrom: presenter._viewController)
  }
  
  fileprivate func routeToPostingScreenWith(_ videoFileURL: URL, postingType: MutablePostDraftProtocol) {
    postingType.attachedMedia = [MediaType.video(videoFileURL)]
    
    let module = AppModules
      .CreatePost
      .mediaPosting(postingType)
      .build()
    
    module?.view.transitionsController.presentationAnimator = FadeAnimationController(presenting: true)
    module?.view.transitionsController.dismissalAnimator = FadeAnimationController(presenting: false)
    module?.router.present(withPushfrom: presenter._viewController)
  }
  
  fileprivate func routeToPostingScreenWith(_ images: [UIImage], postingType: MutablePostDraftProtocol) {
    postingType.attachedMedia = images.map { MediaType.image(ImageAsset(asset: $0))}
    
    let module = AppModules
      .CreatePost
      .mediaPosting(postingType)
      .build()
    
    module?.view.transitionsController.presentationAnimator = FadeAnimationController(presenting: true)
    module?.view.transitionsController.dismissalAnimator = FadeAnimationController(presenting: false)
    module?.router.present(withPushfrom: presenter._viewController)
  }
}

// MARK: - MediaSourceRouter API
extension MediaSourceRouter: MediaSourceRouterApi {
  func routeTo(_ sourceModeItem: MediaSource.Segments, insideView: UIView) {
    guard let moduleToBePresented = getModuleFor(sourceModeItem) else {
      return
    }
    
    currentModule?.router.removeFromContainerView()
    currentModule = moduleToBePresented
    moduleToBePresented.router.show(from: presenter._viewController, insideView: insideView)
  }
}

// MARK: - MediaSource Viper Components
fileprivate extension MediaSourceRouter {
    var presenter: MediaSourcePresenterApi {
        return _presenter as! MediaSourcePresenterApi
    }
}

extension MediaSourceRouter {
  fileprivate func getModuleFor(_ tabBarItem: MediaSource.Segments) -> Module? {
    if let builtModule = preBuiltModules[tabBarItem] {
      return builtModule
    }
    
    if let moduleSetup = modules[tabBarItem] {
      let configurableModule = moduleSetup.0
      let configurator = moduleSetup.1
      
      if let module = configurableModule.build(configurator: configurator) {
        preBuiltModules[tabBarItem] = module
        return module
      }
    }
    
    return nil
  }
}

extension MediaSourceRouter: MediaCaptureDelegateProtocol {
  func didCaptureVideo(_ videoFileURL: URL) {
    routeToPostingScreenWith(videoFileURL, postingType: postDraft)
  }
  
  func didCaptureImages(_ images: [UIImage]) {
    routeToPostingScreenWith(images, postingType: postDraft)
  }
}

extension MediaSourceRouter: MediaPickDelegateProtocol {
  func didSelectedMediaAssets(_ assets: [LibraryAsset]) {
    routeToPostingWith(assets, postingType: postDraft)
  }
  
  func presentationStyle() -> MediaPick.PresentationStyle {
    return .push
  }
}
