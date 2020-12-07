//
//  TabBarModulePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 15.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - TabBarModulePresenter Class
final class TabBarPresenter: Presenter {
  fileprivate var menuPresentation = TabBar.MenuPresentationType.hidden
  fileprivate var firstAppearance = true
  
  fileprivate let availableMenuItems = [TabBar.MenuItems.creationMenuItemsUpperSection,
                                        TabBar.MenuItems.creationMenuItemsLowerSection]
  fileprivate let availableSideMenuItems = [TabBar.MenuItems.sideMenuItemsUpperSection, TabBar.MenuItems.sideMenuItemsLowerSection]
  
  fileprivate var presentedMenuItems: [[TabBar.MenuItems]] = [[],[]] {
    didSet {
      let oldIndexes = oldValue
        .enumerated()
        .flatMap { sectionIdx, section in
          return section
            .enumerated()
            .map { itemIdx, item in IndexPath(item: itemIdx, section: sectionIdx) }
      }
  
      let newIndexes = presentedMenuItems
        .enumerated()
        .flatMap { sectionIdx, section in
          return section
            .enumerated()
            .map { itemIdx, item in IndexPath(item: itemIdx, section: sectionIdx) }
      }
      
      let collectionAddNewUpdate = CollectionViewUpdate(insertAt: newIndexes,
                                                        removeAt:oldIndexes)
      viewController.updateMenuCollectionView(update: collectionAddNewUpdate)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let firstTabBarItem = TabBar.MainItems(rawValue: 0) {
      router.routeTo(firstTabBarItem, insideView: viewController.submoduleContainerView)
    }
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    
    viewController.setMenuHidden(true)
    viewController.setSideMenuHidden(true)
    presentedMenuItems = [[], []]
    menuPresentation = .hidden
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
    guard firstAppearance else {
      return
    }
    
    firstAppearance = false
    interactor.registerForPushNotifications()
  }
}

// MARK: - TabBarModulePresenter API
extension TabBarPresenter: TabBarPresenterApi {
  func handleMenuItemSelectionAt(_ indexPath: IndexPath) {
    let item = presentedMenuItems[indexPath.section][indexPath.item]
   
    //not implemented alerts
    switch item {
    case .camera:
      break
    case .commerce:
      break
    case .charity:
      break
    case .album:
      viewController.showNotImplementedAlert()
      return
    case .goods:
      break
    case .funding:
      break
    case .gift:
      break
    case .wallet:
      break
    case .notifications:
      break
    case .settings:
      break
    }
    
    router.routeTo(item)
  }
  
  func menuItemFor(_ indexPath: IndexPath) -> TabBarMenuItemViewModelProtocol {
    return presentedMenuItems[indexPath.section][indexPath.item]
  }
  
  func numberOfMenuSections() -> Int {
    return presentedMenuItems.count
  }
  
  func numberOfMenuItemsInSection(_ section: Int) -> Int {
    return presentedMenuItems[section].count
  }
  
  func handleMenuButtonAction() {
    if menuPresentation == .creationMenu {
      menuPresentation = .hidden
    } else {
      menuPresentation = .creationMenu
    }
    
    
    viewController.setMenuHidden(menuPresentation.isHidden)
    presentedMenuItems = menuPresentation.isHidden ? [[], []] : availableMenuItems
  }
  
  func handleSideMenuButtonAction() {
    if menuPresentation == .sideMenu {
      menuPresentation = .hidden
    } else {
      menuPresentation = .sideMenu
    }
    
    viewController.setSideMenuHidden(menuPresentation.isHidden)
    presentedMenuItems = menuPresentation.isHidden ? [[], []] : availableSideMenuItems
  }
  
  func handlePresentTabBarItemActionFor(_ tabBarItem: TabBar.MainItems) {
    switch tabBarItem {
    case .first:
      router.routeTo(tabBarItem, insideView: viewController.submoduleContainerView)
    case .second:
      router.routeTo(tabBarItem, insideView: viewController.submoduleContainerView)
    case .third:
      router.routeTo(tabBarItem, insideView: viewController.submoduleContainerView)
    case .fourth:
      handleSideMenuButtonAction()
    }
    
  }
}

// MARK: - TabBarModule Viper Components

fileprivate extension TabBarPresenter {
  var viewController: TabBarViewControllerApi {
    return _viewController as! TabBarViewControllerApi
  }
  var interactor: TabBarInteractorApi {
    return _interactor as! TabBarInteractorApi
  }
  var router: TabBarRouterApi {
    return _router as! TabBarRouterApi
  }
}

extension TabBar.MenuItems: TabBarMenuItemViewModelProtocol {
  var image: UIImage {
    switch self {      
    case .camera:
      return UIImage(imageLiteralResourceName: "Tabbar-menu-camera")
    case .commerce:
      return UIImage(imageLiteralResourceName: "Tabbar-menu-commerce")
    case .funding:
      return UIImage(imageLiteralResourceName: "Tabbar-menu-funding")
    case .charity:
      return UIImage(imageLiteralResourceName: "Tabbar-menu-charity")
    case .album:
      return UIImage(imageLiteralResourceName: "Tabbar-menu-album")
    case .goods:
      return UIImage(imageLiteralResourceName: "Tabbar-menu-goods")
    case .gift:
      return UIImage(imageLiteralResourceName: "Tabbar-SideMenu-Gift")
    case .wallet:
      return UIImage(imageLiteralResourceName: "Tabbar-SideMenu-Wallet")
    case .notifications:
      return UIImage(imageLiteralResourceName: "Tabbar-SideMenu-Notifications")
    case .settings:
      return UIImage(imageLiteralResourceName: "Tabbar-SideMenu-Settings")
    }
  }
  
  var title: String {
    switch self {
    case .camera:
      return TabBar.Strings.MenuItems.camera.localize()
    case .commerce:
      return TabBar.Strings.MenuItems.commerce.localize()
    case .charity:
      return TabBar.Strings.MenuItems.charity.localize()
    case .album:
      return TabBar.Strings.MenuItems.album.localize()
    case .goods:
      return TabBar.Strings.MenuItems.goods.localize()
    case .funding:
      return TabBar.Strings.MenuItems.funding.localize()
    case .gift:
      return TabBar.Strings.SideMenuItems.gift.localize()
    case .wallet:
      return TabBar.Strings.SideMenuItems.wallet.localize()
    case .notifications:
      return TabBar.Strings.SideMenuItems.notifications.localize()
    case .settings:
      return TabBar.Strings.SideMenuItems.settings.localize()
    }
  }
}


extension TabBar {
  enum Strings {
    enum Alerts: String, LocalizedStringKeyProtocol  {
      case notImplementedAlertOkActionTitle = "Ok"
      case notImplementedAlertTitle = "Thanks for your patience"
      case notImplementedAlertMessage = "This menu item is under construction. Will be available in the next version."
    }
    
    enum MenuItems: String, LocalizedStringKeyProtocol {
      case camera = "Media"
      case commerce = "Commerce"
      case charity = "Charity"
      case album = "Album"
      case goods = "Goods"
      case funding = "Funding"
    }
    
    enum SideMenuItems: String, LocalizedStringKeyProtocol {
      case gift = "Gift"
      case wallet = "Wallet"
      case notifications = "Notifications"
      case settings = "Settings"
    }
  }
}
