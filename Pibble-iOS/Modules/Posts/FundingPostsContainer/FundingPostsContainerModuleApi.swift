//
//  FundingPostsContainerModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 10/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - FundingPostsContainerRouter API
protocol FundingPostsContainerRouterApi: RouterProtocol {
  func routeTo(_ segment: FundingPostsContainer.SelectedSegment, accountProfile: AccountProfileProtocol, insideView: UIView)
}

//MARK: - FundingPostsContainerView API
protocol FundingPostsContainerViewControllerApi: ViewControllerProtocol {
  var submoduleContainerView: UIView  { get }
}

//MARK: - FundingPostsContainerPresenter API
protocol FundingPostsContainerPresenterApi: PresenterProtocol {
  func handleSwitchTo(_ segment: FundingPostsContainer.SelectedSegment)
  func handleHideAction()
}

//MARK: - FundingPostsContainerInteractor API
protocol FundingPostsContainerInteractorApi: InteractorProtocol {
  var currentUserProfile: AccountProfileProtocol { get }
}
