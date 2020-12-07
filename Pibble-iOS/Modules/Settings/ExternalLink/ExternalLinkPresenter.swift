//
//  ExternalLinkPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - ExternalLinkPresenter Class
final class ExternalLinkPresenter: Presenter {
  fileprivate let url: URL
  fileprivate let title: String
  
  init(url: URL, title: String) {
    self.url = url
    self.title = title
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewController.setNavigationBarTitle(title)
    guard let url = validatedUrlFor(url) else {
      return
    }
    
    viewController.setWebViewUrl(url)
  }
}

// MARK: - ExternalLinkPresenter API
extension ExternalLinkPresenter: ExternalLinkPresenterApi {
  func handleHideAction() {
    router.dismiss()
  }
}

// MARK: - ExternalLink Viper Components
fileprivate extension ExternalLinkPresenter {
  var viewController: ExternalLinkViewControllerApi {
    return _viewController as! ExternalLinkViewControllerApi
  }
  var interactor: ExternalLinkInteractorApi {
    return _interactor as! ExternalLinkInteractorApi
  }
  var router: ExternalLinkRouterApi {
    return _router as! ExternalLinkRouterApi
  }
}

extension ExternalLinkPresenter {
  func validatedUrlFor(_ url: URL) -> URL? {
    guard url.absoluteString.hasHttpPrefix else {
      guard let correctedUrl = URL(string: url.absoluteString.stringByAddingHttpPrefix) else {
        return nil
      }
      
      return correctedUrl
    }
    
    return url
  }
}
