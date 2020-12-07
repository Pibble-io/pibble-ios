//
//  MediaSourcePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 09.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - MediaSourcePresenter Class
final class MediaSourcePresenter: Presenter {
  
  fileprivate let postDraft: MutablePostDraftProtocol
  
  override func viewWillAppear() {
    super.viewWillAppear()
    
    switch postDraft.draftPostType {
    case .media, .charity, .crowdfunding, .crowdfundingWithReward, .goods:
      viewController.setSegmentEnabled(.library, enabled: true)
      viewController.setSegmentEnabled(.photo, enabled: true)
      viewController.setSegmentEnabled(.video, enabled: true)
    case .digitalGood:
      viewController.setSegmentEnabled(.library, enabled: true)
      viewController.setSegmentEnabled(.photo, enabled: true)
      viewController.setSegmentEnabled(.video, enabled: false)
      
    }
    
    viewController.setSegmentSelected(.library)
    handlePresentMediaSourceModeFor(.library)
  }
  
  init(postDraft: MutablePostDraftProtocol) {
    self.postDraft = postDraft
  }
}

// MARK: - MediaSourcePresenter API
extension MediaSourcePresenter: MediaSourcePresenterApi {
  func handlePresentMediaSourceModeFor(_ mode: MediaSource.Segments) {
    router.routeTo(mode, insideView: viewController.submoduleContainerView)
  }
}

// MARK: - MediaSource Viper Components
fileprivate extension MediaSourcePresenter {
    var viewController: MediaSourceViewControllerApi {
        return _viewController as! MediaSourceViewControllerApi
    }
    var interactor: MediaSourceInteractorApi {
        return _interactor as! MediaSourceInteractorApi
    }
    var router: MediaSourceRouterApi {
        return _router as! MediaSourceRouterApi
    }
}
