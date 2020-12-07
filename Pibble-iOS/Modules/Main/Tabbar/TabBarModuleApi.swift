//
//  TabBarModuleModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 15.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

//MARK: - TabBarModuleRouter API
import UIKit

protocol TabBarRouterApi: RouterProtocol {
  func routeTo(_ menuItem: TabBar.MenuItems)
  func routeTo(_ tabBarItem: TabBar.MainItems, insideView: UIView)
}

//MARK: - TabBarModuleView API
protocol TabBarViewControllerApi: ViewControllerProtocol {
  var submoduleContainerView: UIView { get }
  func setMenuHidden(_ hidden: Bool)
  func setSideMenuHidden(_ hidden: Bool)
  func reloadMenuCollectionView()
  func updateMenuCollectionView(update: CollectionViewUpdate)
  
  func showNotImplementedAlert()
}

//MARK: - TabBarModulePresenter API
protocol TabBarPresenterApi: PresenterProtocol {
  func handlePresentTabBarItemActionFor(_ tabBarItem: TabBar.MainItems)
  
  func handleMenuButtonAction()
  func numberOfMenuSections() -> Int
  func numberOfMenuItemsInSection(_ section: Int) -> Int
  func handleMenuItemSelectionAt(_ indexPath: IndexPath)
  func menuItemFor(_ indexPath: IndexPath) -> TabBarMenuItemViewModelProtocol
  
}

//MARK: - TabBarModuleInteractor API
protocol TabBarInteractorApi: InteractorProtocol {
  func registerForPushNotifications()
}

protocol TabBarMenuItemViewModelProtocol {
  var title: String { get }
  var image: UIImage { get }
}
