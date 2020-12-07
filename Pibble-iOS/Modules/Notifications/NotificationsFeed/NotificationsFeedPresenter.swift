//
//  NotificationsFeedPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 26/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - NotificationsFeedPresenter Class
final class NotificationsFeedPresenter: Presenter {
  fileprivate let todayTimeInterval: TimeInterval = 60.0 * 60.0 * 24.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.initialFetchData()
    interactor.initialRefresh()
  }
}

// MARK: - NotificationsFeedPresenter API
extension NotificationsFeedPresenter: NotificationsFeedPresenterApi {
  func sectionHeaderViewModel(_ section: Int) -> NotificationsFeedSectionHeaderViewModelProtocol? {
    guard let item = interactor.itemAt(IndexPath(item: 0, section: section)) else {
      return nil
    }
   
    guard let viewModel = NotificationsFeed.SectionHeaderViewModel(notification: item.baseNotification) else {
      return nil
    }
    
    guard let previosSectionItem = interactor.itemAt(IndexPath(item: 0, section: section - 1)) else {
      return viewModel
    }
    
    guard let prevSectionViewModel = NotificationsFeed.SectionHeaderViewModel(notification: previosSectionItem.baseNotification) else {
      return viewModel
    }
    
    guard prevSectionViewModel.title == viewModel.title else {
      return viewModel
    }
    
    return nil
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func handleWillDisplayItem(_ indexPath: IndexPath) {
    interactor.prepareItemFor(indexPath)
  }
  
  func handleDidEndDisplayItem(_ indexPath: IndexPath) {
    interactor.cancelPrepareItemFor(indexPath)
  }
  
  func handleItemActionAt(_ indexPath: IndexPath, action: NotificationsFeed.ItemActions) {
    guard let item = interactor.itemAt(indexPath) else {
      return
    }
    
    switch action {
    case .showRelatedPost:
      switch item {
      case .post(let notificationEntity):
        guard let post = notificationEntity.relatedPostEntity else {
          return
        }
        
        router.routeToPostDetailFor(post)
      case .user(_):
        break
      case .plain(_):
        break
      }
    case .showRelatedUser:
      switch item {
      case .post(_):
        break
      case .user(let notificationEntity):
        guard let user = notificationEntity.relatedUserEntity else {
          return
        }
        
        router.routeToUserProfileFor(user)
      case .plain(_):
        break
      }
    case .follow:
      interactor.performFollowUserActionAt(indexPath)
    }
  }
  
  func handleSelectionAt(_ indexPath: IndexPath) {
    guard let item = interactor.itemAt(indexPath) else {
      return
    }
    
    guard let user = item.baseNotification.notificationFromUser else {
      return
    }
    
    router.routeToUserProfileFor(user)
  }
  
  func numberOfSections() -> Int {
    return interactor.numberOfSections()
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return interactor.numberOfItemsInSection(section)
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> NotificationsFeed.ItemViewModelType {
    guard let item = interactor.itemAt(indexPath) else {
      return .loadingPlaceholder
    }
    
    let viewModel = NotificationsFeed.ItemViewModelType(notification: item)
    return viewModel
  }
  
  func presentReload() {
    viewController.reloadData()
  }
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate) {
    viewController.updateCollection(updates)
  }
}

// MARK: - NotificationsFeed Viper Components
fileprivate extension NotificationsFeedPresenter {
  var viewController: NotificationsFeedViewControllerApi {
    return _viewController as! NotificationsFeedViewControllerApi
  }
  var interactor: NotificationsFeedInteractorApi {
    return _interactor as! NotificationsFeedInteractorApi
  }
  var router: NotificationsFeedRouterApi {
    return _router as! NotificationsFeedRouterApi
  }
}
