//
//  PlayRoomPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - PlayRoomPresenter Class
final class PlayRoomPresenter: Presenter {
  override func viewDidLoad() {
    super.viewDidLoad()
    viewController.setNavigationBarTitle(PlayRoom.Strings.NavigationBarTitles.playroom.localize())
    interactor.intitialFetchData()
  }
}

// MARK: - PlayRoomPresenter API
extension PlayRoomPresenter: PlayRoomPresenterApi {
  func handleHideAction() {
    router.dismiss()
  }
  
  func presentURL(_ url: URL, user: UserProtocol) {
    viewController.setNavigationBarTitle(PlayRoom.Strings.NavigationBarTitles.playroomFor.localize(value: user.userName))
    viewController.setWebViewUrl(url)
  }
}

// MARK: - PlayRoom Viper Components
fileprivate extension PlayRoomPresenter {
  var viewController: PlayRoomViewControllerApi {
    return _viewController as! PlayRoomViewControllerApi
  }
  var interactor: PlayRoomInteractorApi {
    return _interactor as! PlayRoomInteractorApi
  }
  var router: PlayRoomRouterApi {
    return _router as! PlayRoomRouterApi
  }
}

extension PlayRoomPresenter {
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
