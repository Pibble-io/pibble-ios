//
//  MediaSourceModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 09.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

//MARK: - MediaSourceRouter API
import UIKit

protocol MediaSourceRouterApi: RouterProtocol {
  func routeTo(_ sourceModeItem: MediaSource.Segments, insideView: UIView)
}

//MARK: - MediaSourceView API
protocol MediaSourceViewControllerApi: ViewControllerProtocol {
  var submoduleContainerView: UIView { get }
  
  func setSegmentEnabled(_ segment: MediaSource.Segments, enabled: Bool)
  func setSegmentSelected(_ segment: MediaSource.Segments)
}

//MARK: - MediaSourcePresenter API
protocol MediaSourcePresenterApi: PresenterProtocol {
  func handlePresentMediaSourceModeFor(_ mode: MediaSource.Segments)
}

//MARK: - MediaSourceInteractor API
protocol MediaSourceInteractorApi: InteractorProtocol {
}
