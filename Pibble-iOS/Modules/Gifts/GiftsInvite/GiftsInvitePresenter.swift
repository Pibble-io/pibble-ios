//
//  GiftsInvitePresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - GiftsInvitePresenter Class
final class GiftsInvitePresenter: Presenter {
  override func viewDidLoad() {
    super.viewDidLoad()
    viewController.setNavigationBarTitle(GiftsInvite.Strings.navBarTitle.localize())
    interactor.initialFetchData()
  }
}

// MARK: - GiftsInvitePresenter API
extension GiftsInvitePresenter: GiftsInvitePresenterApi {
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

// MARK: - GiftsInvite Viper Components
fileprivate extension GiftsInvitePresenter {
  var viewController: GiftsInviteViewControllerApi {
    return _viewController as! GiftsInviteViewControllerApi
  }
  var interactor: GiftsInviteInteractorApi {
    return _interactor as! GiftsInviteInteractorApi
  }
  var router: GiftsInviteRouterApi {
    return _router as! GiftsInviteRouterApi
  }
}

extension GiftsInvitePresenter {
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
