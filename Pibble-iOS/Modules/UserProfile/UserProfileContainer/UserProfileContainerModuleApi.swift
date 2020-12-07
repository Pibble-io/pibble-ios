//
//  UserProfileContainerModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//
import UIKit

//MARK: - UserProfileContainerRouter API
protocol UserProfileContainerRouterApi: RouterProtocol {
  func presentUserProfileIn(_ container: UIView, targetUser: UserProfileContent.TargetUser)
  func presentUserPostsIn(_ container: UIView, user: UserProtocol)
  func presentUserPostsGridIn(_ container: UIView, user: UserProtocol)
  func presentUserFavoritesPostsIn(_ container: UIView, user: UserProtocol)
  func presentUserBrushedPostsIn(_ container: UIView, user: UserProtocol)
  
  func presentBannedUserProfileIn(_ container: UIView, user: UserProtocol)
  
  func removeBottomContainer()
  
  func routeToChatRoomForPost(_ user: UserProtocol)
  func routeToChatRooms()
  func routeToSettings()
  
  func routeToLogin()
}

//MARK: - UserProfileContainerView API
protocol UserProfileContainerViewControllerApi: ViewControllerProtocol, EmbedableViewControllerDelegate {
  var topSectionContainerView: UIView? { get }
  var bottomSectionContainerView: UIView? { get }
  
  var overlayingSectionContainerView: UIView { get }
  
  var topSectionEmbeddableViewController: EmbedableViewController? { get set }
  var bottmoSectionEmbeddableViewController: EmbedableViewController? { get set }
  
  func setOverlayingContainerPresentationHidden(_ hidden: Bool, animated: Bool)
  func setSettingsHidden(_ hidden: Bool)
  
//  func setHideButtonHidden(_ hidden: Bool)
  func setNavigationBarTitle(_ title: String) 
  func setSegmentEnabled(_ segment: UserProfileContainer.UserPostsSegments, enabled: Bool)
  func setSegmentSelected(_ segment: UserProfileContainer.UserPostsSegments)
  
  func scrollToTop()
  
  func showMyActionSheet()
  func showOtherUserActionSheet()
  func showCurrentBannedUserActionSheet()
}

//MARK: - UserProfileContainerPresenter API
protocol UserProfileContainerPresenterApi: PresenterProtocol {
  func handleLogout()
  
  func handleHideAction()
  func presentUser(_ user: UserProtocol)
  func handleSwitchTo(_ segment: UserProfileContainer.UserPostsSegments)
  
  func handleAdditionalAction()
  
  func handleChatRoomsAction()
  
  func handleSettingsAction()
  
  func handleChatRoomWithUserAction()
  
  func handleMuteUserAction()
  
  func handleReportUserAction()
}

//MARK: - UserProfileContainerInteractor API
protocol UserProfileContainerInteractorApi: InteractorProtocol {
  var currentUser: UserProtocol? { get }
  func initialFetchData()
  var targetUser: UserProfileContent.TargetUser { get }
  
  func performReportUser()
  func performMuteUser()
  
  func performLogout()
}

protocol EmbedableViewControllerDelegate: class {
  func handleContentSizeChange(_ viewController: EmbedableViewController, contentSize: CGSize)
  
  func handleDidScroll(_ viewController: EmbedableViewController, childScrollView: UIScrollView)
}

protocol EmbedableViewController: class, NSObjectProtocol {
  var contentSize: CGSize { get }
  var embedableDelegate: EmbedableViewControllerDelegate? { get set }
  func setScrollingEnabled(_ enabled: Bool)
  func setBouncingEnabled(_ enabled: Bool)
}
