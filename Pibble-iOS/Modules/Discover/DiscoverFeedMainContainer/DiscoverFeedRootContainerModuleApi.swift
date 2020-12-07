//
//  DiscoverFeedRootContainerModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 18.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit


//MARK: - DiscoverFeedRootContainerRouter API
protocol DiscoverFeedRootContainerRouterApi: RouterProtocol {
  func routeToDiscoverPostsGrid(_ insideView: UIView)
  func routeTo(_ segment: DiscoverFeedRootContainer.Segments, insideView: UIView, delegate: DiscoverSearchContentDelegate) -> DiscoverFeedRootContainerSearchDelegate?
  func routeToSearchHistory(insideView: UIView, delegate: DiscoverSearchContentDelegate) -> DiscoverFeedRootContainerSearchDelegate?
}

//MARK: - DiscoverFeedRootContainerView API
protocol DiscoverFeedRootContainerViewControllerApi: ViewControllerProtocol {
  var containerView: UIView { get }
  var searchResultsContainerView: UIView { get }
  func setDiscoverContainerHidden(_ hidden: Bool, animated: Bool)
  
  func setButtonSelectedStateFor(_ segment: DiscoverFeedRootContainer.Segments)
  func setSegmentsDeselected()
  func setHistoryButtonSelected(_ selected: Bool)
  func setSearchString(_ text: String)
}

//MARK: - DiscoverFeedRootContainerPresenter API
protocol DiscoverFeedRootContainerPresenterApi: PresenterProtocol {
  func handleSwitchTo(_ segment: DiscoverFeedRootContainer.Segments)
  func handleSearchHistoryAction()
  
  
  func handleSearchTextChange(_ text: String)
  func handleSearchTextBeginEditingWith(_ text: String)
  func handleSearchTextEndEditingWith(_ text: String)
  
  func presentSearch(_ text: String)
}

//MARK: - DiscoverFeedRootContainerInteractor API
protocol DiscoverFeedRootContainerInteractorApi: InteractorProtocol {
  func scheduleSearch(_ text: String)
  func performSearch(_ text: String)
}


protocol DiscoverFeedRootContainerSearchDelegate: class {
  func handleSearch(_ text: String)
}
