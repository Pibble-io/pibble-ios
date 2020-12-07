//
//  MediaEditPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - MediaEditPresenter Class
final class MediaEditPresenter: Presenter {
  fileprivate weak var delegate: MediaEditDelegateProtocol?
  
  fileprivate let editModes:   [[MediaEdit.EditMode]] = [[
    .filter, .crop, .rotate, .sticker, .drawing, .text
  ]]
  
  override func viewWillAppear() {
    super.viewWillAppear()
    switch interactor.inputMedia {
    case .video:
      interactor.initialFetchMedia(.video)
    case .image:
      interactor.initialFetchMedia(.image)
    case .libraryMediaItem:
      let config = viewController.selectedImageConfig
      let request = MediaEdit.MediaFetchRequest.libraryMediaItem(config)
      interactor.initialFetchMedia(request)
    }
    
    viewController.setNextStepTitle(delegate?.nextStepTitle ?? "")
  }
  
  init(delegate: MediaEditDelegateProtocol) {
    self.delegate = delegate
  }
}

// MARK: - MediaEditPresenter API
extension MediaEditPresenter: MediaEditPresenterApi {
  func presentOutput(_ outputAsset: MediaType) {
    delegate?.handleMediaEditNextStepActionFor(self, outputAsset: outputAsset)
  }
  
  func handleNextStepAction() {
    interactor.getOutputMedia()
  }
  
  func numberOfEditModeSections() -> Int {
    return editModes.count
  }
  
  func numberOfEditModeItemsInSection(_ section: Int) -> Int {
    return editModes[section].count
  }
  
  func editModeItemViewModelAt(_ indexPath: IndexPath) -> MediaEditModeViewModel {
    return editModes[indexPath.section][indexPath.item]
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func presentMedia(_ media: MediaEdit.PresentableMedia) {
    switch media {
    case .video(let layer):
      viewController.setVideoLayer(layer)
    case .image(let image):
      viewController.setImage(image)
    }
  }
  
}

// MARK: - MediaEdit Viper Components
fileprivate extension MediaEditPresenter {
    var viewController: MediaEditViewControllerApi {
        return _viewController as! MediaEditViewControllerApi
    }
    var interactor: MediaEditInteractorApi {
        return _interactor as! MediaEditInteractorApi
    }
    var router: MediaEditRouterApi {
        return _router as! MediaEditRouterApi
    }
}

extension MediaEdit.EditMode: MediaEditModeViewModel {
  var image: UIImage {
    switch self {
    case .filter:
      return #imageLiteral(resourceName: "MediaEditFilter")
    case .crop:
      return #imageLiteral(resourceName: "MediaEditCrop")
    case .rotate:
      return #imageLiteral(resourceName: "MediaEditRotate")
    case .sticker:
      return #imageLiteral(resourceName: "MediaEditSticker")
    case .drawing:
      return #imageLiteral(resourceName: "MediaEditDraw")
    case .text:
      return #imageLiteral(resourceName: "MediaEditTitle")
    }
  }
 
}
