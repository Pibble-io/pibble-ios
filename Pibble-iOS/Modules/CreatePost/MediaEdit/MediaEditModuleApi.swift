//
//  MediaEditModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import AVFoundation
import UIKit

//MARK: - MediaEditRouter API
protocol MediaEditRouterApi: RouterProtocol {
}

//MARK: - MediaEditView API
protocol MediaEditViewControllerApi: ViewControllerProtocol {
  var selectedImageConfig: ImageRequestConfig { get }
  
  func setVideoLayer(_ layer: CALayer)
  func setImage(_ image: UIImage)
  func setNextStepTitle(_ title: String)
}

//MARK: - MediaEditPresenter API
protocol MediaEditPresenterApi: PresenterProtocol {
  func handleHideAction()
  func handleNextStepAction()
  
  func presentMedia(_ media: MediaEdit.PresentableMedia)
  func presentOutput(_ outputAsset: MediaType)
  
  func numberOfEditModeSections() -> Int
  func numberOfEditModeItemsInSection(_ section: Int) -> Int
  func editModeItemViewModelAt(_ indexPath: IndexPath) -> MediaEditModeViewModel
}

//MARK: - MediaEditInteractor API
protocol MediaEditInteractorApi: InteractorProtocol {
  var inputMedia: MediaType { get }
  func initialFetchMedia(_ request: MediaEdit.MediaFetchRequest)
  
  func getOutputMedia()
}

protocol MediaEditModeViewModel {
  var image: UIImage { get }
}

protocol MediaEditDelegateProtocol: class {
  var nextStepTitle: String { get }
  
  func handleMediaEditNextStepActionFor(_ presenter: PresenterProtocol, outputAsset: MediaType)
}
