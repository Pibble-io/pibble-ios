//
//  DiscoverFeedRootContainerInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 18.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - DiscoverFeedRootContainerInteractor Class
final class DiscoverFeedRootContainerInteractor: Interactor {
  fileprivate var performSearchObject = DelayBlockObject()
}

// MARK: - DiscoverFeedRootContainerInteractor API
extension DiscoverFeedRootContainerInteractor: DiscoverFeedRootContainerInteractorApi {
  func performSearch(_ text: String) {
    performSearchObject.cancel()
    presenter.presentSearch(text)
  }
  
  func scheduleSearch(_ text: String) {
    performSearchObject.cancel()
    guard text.count > 0 else {
      presenter.presentSearch(text)
      return
    }
    
    performSearchObject.scheduleAfter(delay: 0.3) { [weak self] in
      self?.presenter.presentSearch(text)
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension DiscoverFeedRootContainerInteractor {
    var presenter: DiscoverFeedRootContainerPresenterApi {
        return _presenter as! DiscoverFeedRootContainerPresenterApi
    }
}
