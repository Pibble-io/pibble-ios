//
//  BannedUserProfileContentPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 31/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - BannedUserProfileContentPresenter Class
final class BannedUserProfileContentPresenter: Presenter {
  override func viewDidLoad() {
    super.viewDidLoad()
    viewController.setBannedAccountViewModel(BannedUserProfileContent.AccountViewModel(user: interactor.user))
  }
}

// MARK: - BannedUserProfileContentPresenter API
extension BannedUserProfileContentPresenter: BannedUserProfileContentPresenterApi {
}

// MARK: - BannedUserProfileContent Viper Components
fileprivate extension BannedUserProfileContentPresenter {
  var viewController: BannedUserProfileContentViewControllerApi {
    return _viewController as! BannedUserProfileContentViewControllerApi
  }
  var interactor: BannedUserProfileContentInteractorApi {
    return _interactor as! BannedUserProfileContentInteractorApi
  }
  var router: BannedUserProfileContentRouterApi {
    return _router as! BannedUserProfileContentRouterApi
  }
}
