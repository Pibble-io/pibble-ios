//
//  AboutHomePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - AboutHomePresenter Class
final class AboutHomePresenter: Presenter {
  fileprivate var settingsItems: [[AboutHome.AboutHomeItems]] = [[]] // = [AboutHome.AboutHomeItems.allCases]
  
  func handleHideAction() {
    router.dismiss()
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
    fetchItems()
  }
}

// MARK: - AboutHomePresenter API
extension AboutHomePresenter: AboutHomePresenterApi {
  func handleSelectionAt(_ indexPath: IndexPath) {
    let item = settingsItems[indexPath.section][indexPath.item]
    switch item {
    case .commerce:
      break
    case .croudFunding:
      break
    case .album:
      break
    case .event:
      break
    case .logout:
      interactor.performLogout()
      router.routeToLogin()
    case .notifications:
      break
    }
  }
  
  func numberOfSections() -> Int {
    return settingsItems.count
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return settingsItems[section].count
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> AboutHomeItemViewModelProtocol {
    return settingsItems[indexPath.section][indexPath.item]
  }
}

// MARK: - AboutHome Viper Components
fileprivate extension AboutHomePresenter {
  var viewController: AboutHomeViewControllerApi {
    return _viewController as! AboutHomeViewControllerApi
  }
  var interactor: AboutHomeInteractorApi {
    return _interactor as! AboutHomeInteractorApi
  }
  var router: AboutHomeRouterApi {
    return _router as! AboutHomeRouterApi
  }
}


//MARK:- Helpers

extension AboutHomePresenter {
  fileprivate func fetchItems() {
    settingsItems = [AboutHome.AboutHomeItems.allCases]
    viewController.updateCollection(.beginUpdates)
    
    let indexes = settingsItems
      .enumerated()
      .flatMap { sectionIdx, section in
        return section
          .enumerated()
          .map { itemIdx, item in IndexPath(item: itemIdx, section: sectionIdx) }
    }
    viewController.updateCollection(.insert(idx: indexes))
    viewController.updateCollection(.endUpdates)
  }
}

extension AboutHome.AboutHomeItems: AboutHomeItemViewModelProtocol {
  var isActive: Bool {
    switch self {
    case .commerce:
      return false
    case .croudFunding:
      return false
    case .album:
      return false
    case .event:
      return false
    case .notifications:
      return false
    case .logout:
      return true
    }
  }
  
  var image: UIImage {
    switch self {
    case .commerce:
      return #imageLiteral(resourceName: "Tabbar-Profile-button")
    case .croudFunding:
      return #imageLiteral(resourceName: "AboutHome-Croudfunding")
    case .album:
      return #imageLiteral(resourceName: "AboutHome-Album")
    case .event:
      return #imageLiteral(resourceName: "AboutHome-Event")
    case .logout:
      return #imageLiteral(resourceName: "AboutHome-Settings")
    case .notifications:
      return #imageLiteral(resourceName: "AboutHome-Notifications")
    }
  }

  var title: String {
    switch self {
    case .commerce:
      return AboutHome.Strings.commerce.localize().uppercased()
    case .croudFunding:
      return AboutHome.Strings.croudFunding.localize().uppercased()
    case .album:
      return AboutHome.Strings.album.localize().uppercased()
    case .event:
      return AboutHome.Strings.event.localize().uppercased()
    case .logout:
      return AboutHome.Strings.settings.localize().uppercased()
    case .notifications:
      return AboutHome.Strings.notifications.localize().uppercased()
    }
  }
}

extension AboutHome {
  enum Strings: String, LocalizedStringKeyProtocol {
    case commerce = "commerce"
    case croudFunding = "croud funding"
    case album = "album"
    case event = "event"
    case settings = "logout"
    case notifications = "notifications"
  }
}
