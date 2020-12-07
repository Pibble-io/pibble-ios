//
//  UserProfileContainerPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - UserProfileContainerPresenter Class
final class UserProfileContainerPresenter: Presenter {
  fileprivate var currentSegment: UserProfileContainer.UserPostsSegments = .grid
  
  fileprivate var targetuser: UserProfileContent.TargetUser {
    return interactor.targetUser
  }
  
  override func presentInitialState() {
    super.presentInitialState()
    viewController.scrollToTop()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    interactor.initialFetchData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if let containerView = viewController.topSectionContainerView {
      router.presentUserProfileIn(containerView, targetUser: targetuser)
    }
    
    viewController.setNavigationBarTitle("")
    
    switch targetuser {
    case .current:
      viewController.setSegmentEnabled(.listing, enabled: true)
      viewController.setSegmentEnabled(.grid, enabled: true)
      viewController.setSegmentEnabled(.favorites, enabled: true)
      viewController.setSegmentEnabled(.brushed, enabled: true)
    case .other(let user):
      viewController.setSegmentEnabled(.listing, enabled: true)
      viewController.setSegmentEnabled(.grid, enabled: true)
      viewController.setSegmentEnabled(.favorites, enabled: false)
      viewController.setSegmentEnabled(.brushed, enabled: true)
      
      if user.isBannedUser {
        viewController.setOverlayingContainerPresentationHidden(false, animated: false)
        viewController.setSettingsHidden(false)
        router.presentBannedUserProfileIn(viewController.overlayingSectionContainerView, user: user)
      }
    }
  }
}

// MARK: - UserProfileContainerPresenter API
extension UserProfileContainerPresenter: UserProfileContainerPresenterApi {
  func handleLogout() {
    interactor.performLogout()
    router.routeToLogin()
  }
  
  func handleMuteUserAction() {
    interactor.performMuteUser()
  }
  
  func handleReportUserAction() {
    interactor.performReportUser()
  }
  
  func handleSettingsAction() {
    router.routeToSettings()
  }
  
  func handleChatRoomsAction() {
    router.routeToChatRooms()
  }
  
  func handleChatRoomWithUserAction() {
    switch targetuser {
    case .current:
      break
    case .other(let user):
      router.routeToChatRoomForPost(user)
    }
  }
  
  func handleAdditionalAction() {
    switch targetuser {
    case .current:
      guard let user = interactor.currentUser else {
        viewController.showMyActionSheet()
        return
      }
      
      guard !user.isBannedUser else {
        viewController.showCurrentBannedUserActionSheet()
        return
      }
      
      viewController.showMyActionSheet()
    case .other(_):
      viewController.showOtherUserActionSheet()
    }
  }
  
  func handleSwitchTo(_ segment: UserProfileContainer.UserPostsSegments) {
    guard let user = interactor.currentUser else {
      return
    }
    switchTo(segment, user: user)
    viewController.setSegmentSelected(currentSegment)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  
  func presentUser(_ user: UserProtocol) {
    viewController.setNavigationBarTitle(user.userName.capitalized)
    guard !user.isBannedUser else {
      viewController.setOverlayingContainerPresentationHidden(false, animated: isPresented)
      
      switch targetuser {
      case .current:
        viewController.setSettingsHidden(false)
      case .other(_):
        viewController.setSettingsHidden(true)
      }
      
      router.presentBannedUserProfileIn(viewController.overlayingSectionContainerView, user: user)
      return
    }
    
    viewController.setOverlayingContainerPresentationHidden(true, animated: isPresented)
    switchTo(currentSegment, user: user)
    viewController.setSegmentSelected(currentSegment)
  }
}

// MARK: - UserProfileContainer Viper Components
fileprivate extension UserProfileContainerPresenter {
  var viewController: UserProfileContainerViewControllerApi {
    return _viewController as! UserProfileContainerViewControllerApi
  }
  var interactor: UserProfileContainerInteractorApi {
    return _interactor as! UserProfileContainerInteractorApi
  }
  var router: UserProfileContainerRouterApi {
    return _router as! UserProfileContainerRouterApi
  }
}


//MARK:- Helpers

extension UserProfileContainerPresenter {
  fileprivate func switchTo(_ segment: UserProfileContainer.UserPostsSegments, user: UserProtocol) {
    guard let containerView = viewController.bottomSectionContainerView else {
      return
    }
    
    currentSegment = segment
    switch segment {
    case .listing:
      router.presentUserPostsIn(containerView, user: user)
    case .grid:
      router.presentUserPostsGridIn(containerView, user: user)
    case .favorites:
      router.presentUserFavoritesPostsIn(containerView, user: user)
    case .brushed:
      router.presentUserBrushedPostsIn(containerView, user: user)
    }
  }
}
