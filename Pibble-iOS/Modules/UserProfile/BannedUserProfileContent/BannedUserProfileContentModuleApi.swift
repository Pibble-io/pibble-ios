//
//  BannedUserProfileContentModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 31/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - BannedUserProfileContentRouter API
protocol BannedUserProfileContentRouterApi: RouterProtocol {
}

//MARK: - BannedUserProfileContentView API
protocol BannedUserProfileContentViewControllerApi: ViewControllerProtocol {
  func setBannedAccountViewModel(_ vm: BannedUserProfileContentAccountViewModelProtocol)
}

//MARK: - BannedUserProfileContentPresenter API
protocol BannedUserProfileContentPresenterApi: PresenterProtocol {
  
}

//MARK: - BannedUserProfileContentInteractor API
protocol BannedUserProfileContentInteractorApi: InteractorProtocol {
  var user: UserProtocol { get }
}




protocol BannedUserProfileContentAccountViewModelProtocol {
  var wallPlaceholder: UIImage? { get }
  var avatarPlaceholder: UIImage? { get }
  
  var wallURLString: String { get }
  var avatarURLString: String { get }
  
  var username: String { get }
  var blockStatus: String { get }
  var blockStatusColor: UIColor { get }
}
