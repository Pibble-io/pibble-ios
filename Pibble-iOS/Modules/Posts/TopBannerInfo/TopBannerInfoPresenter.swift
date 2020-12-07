//
//  TopBannerInfoPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - TopBannerInfoPresenter Class
final class TopBannerInfoPresenter: Presenter {
  override func viewDidLoad() {
    super.viewDidLoad()
    viewController.setNavigationBarTitle(TopBannerInfo.Strings.navBarTitle.localize())
    interactor.initialFetchData()
  }
}

// MARK: - TopBannerInfoPresenter API
extension TopBannerInfoPresenter: TopBannerInfoPresenterApi {
  func presentUrl(_ url: URL) {
    guard let url = validatedUrlFor(url) else {
      return
    }

    viewController.setWebViewUrl(url)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
}

// MARK: - TopBannerInfo Viper Components
fileprivate extension TopBannerInfoPresenter {
  var viewController: TopBannerInfoViewControllerApi {
    return _viewController as! TopBannerInfoViewControllerApi
  }
  var interactor: TopBannerInfoInteractorApi {
    return _interactor as! TopBannerInfoInteractorApi
  }
  var router: TopBannerInfoRouterApi {
    return _router as! TopBannerInfoRouterApi
  }
}

extension TopBannerInfoPresenter {
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
