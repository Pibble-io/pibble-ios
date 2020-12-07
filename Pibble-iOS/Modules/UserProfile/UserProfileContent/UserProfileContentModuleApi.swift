//
//  UserProfileContentModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import Photos

//MARK: - UserProfileContentRouter API
protocol UserProfileContentRouterApi: RouterProtocol {
  func routeToFollowersFor(_ user: UserProtocol)
  func routeToFollowingsFor(_ user: UserProtocol)
  func routeToFriendsFor(_ user: UserProtocol)
  func routeToPostingsFor(_ user: UserProtocol)
  
  func routeToMediaPickWith(_ delegate: MediaPickDelegateProtocol)
  func dismissMediaPick()
  
  func routeToDescriptionPickWith(_ delegate: UserProfilePickDelegateProtocol)
  func routeToUserProfileFor(_ user: UserProtocol)
  
  func routeToUserProfileURL(_ url: URL)
  
  func routeToPlayRoom(_ user: UserProtocol)
}

//MARK: - UserProfileContentView API
protocol UserProfileContentViewControllerApi: ViewControllerProtocol, EmbedableViewController {
  func reloadData()
  func updateCollection(_ updates: CollectionViewModelUpdate)
}

//MARK: - UserProfileContentPresenter API
protocol UserProfileContentPresenterApi: PresenterProtocol {
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelFor(_ indexPath: IndexPath) -> UserProfileContent.ItemViewModelType
  
  func presentReloadInfoFor(_ user: UserProtocol)
  func presentReloadFriendsFor(_ users: [UserProtocol])
  func presentReloadFriendsRequestsFor(_ users: [UserProtocol])
  func presentReloadHistoryRewards(_ rewardsHistory: UserProfileContent.BrushRewardsHistory)
  
  func handleFollowingAction()
  func handleFriendshipAction()
  
  func handleShowFollowersAction()
  func handleShowFollowingsAction()
  func handleShowFriendsAction()
  func handleShowPostingsAction()
  
  func handlePickMediaAction(_ action: UserProfileContent.UserAvavarActions)
  func handleEditCaptionAction()
  func handleShowWebsiteAction()
  
  func handleShowProfileActionAt(_ indexPath: IndexPath)
  
  func handleFriendRequestActionFor(_ indexPath: IndexPath, action: UserProfileContent.UserProfileFriendRequestActions)
  
  func handleSwitchChartPeriodAction()
}

//MARK: - UserProfileContentInteractor API
protocol UserProfileContentInteractorApi: InteractorProtocol {
  func initialFetchData()
  func initialRefreshData()
  
  func performFollowingAction()
  func performFriendshipAction()
  func performSwitchChartPeriodAction() 
  
  func uploadUserpicFromAsset(_ asset: LibraryAsset)
  func uploadWallFromAsset(_ asset: LibraryAsset)
  
  func updateUserProfile(_ profile: UserProfileProtocol)  
  
  var user: UserProtocol? { get }
  
  func denyFriendRequestActionFor(_ index: Int)
  func acceptFriendRequestActionFor(_ index: Int)
  func friendRequestUserAt(_ index: Int) -> UserProtocol?
  func friendUserAt(_ index: Int) -> UserProtocol?
}


protocol UserProfileAvatarViewModelProtocol: DiffableProtocol {
  var wallPlaceholder: UIImage? { get }
  var avatarPlaceholder: UIImage? { get }
  
  var wallURLString: String { get }
  var avatarURLString: String { get }
  var pibbleAmount: String { get }
  var redBrushAmount: String { get }
  var greenBrushAmount: String { get }
  var isPlaygroundVisible: Bool { get }
}

protocol UserProfileUsernameViewModelProtocol: DiffableProtocol {
  var username: String { get }
  var userLevel: String { get }
  
  var prizeIconImage: UIImage? { get }
  var prizeAmount: String { get }
}

protocol UserProfileFollowActionsViewModelProtocol: DiffableProtocol {
  var leftActionTitle: String { get }
  var isLeftActionHighlighted: Bool { get }
  var isLeftActionPromoted: Bool { get }
  
  var rightActionTitle: String { get }
  var isRightActionHighlighted: Bool { get }
  var isRightActionPromoted: Bool { get }
}

protocol UserProfileLevelViewModelProtocol: DiffableProtocol {
  var levelItems: [UserProfileLevelItemViewModelProtocol] { get }
}

protocol UserProfileLevelItemViewModelProtocol: DiffableProtocol {
  var statusTitle: String { get }
  var amount: String { get }
  var amountTarget: String { get }
  var progressPerCentAmount: String { get }
  var progressBarColor: UIColor { get }
  var progressBarValue: Double { get }
}


protocol UserProfileCountsStatusViewModelProtocol: DiffableProtocol {
  var countItems: [UserProfileCountItemStatusViewModelProtocol] { get }
}

protocol UserProfileCountItemStatusViewModelProtocol: DiffableProtocol {
  var title: String { get }
  var amount: String { get }
  var showStatAction: UserProfileContent.UserStatsShowActions { get }
}

protocol UserProfileCaptionViewModelProtocol: DiffableProtocol {
  var caption: String { get }
  var isEditButtonHidden: Bool { get }
  var hasCaption: Bool { get }
  var hasWebsite: Bool { get }
  var website: String { get }
}

protocol UserProfileFriendViewModelProtocol: DiffableProtocol {
  var avatarPlaceholder: UIImage? { get }
  var avatarURLString: String { get }
  var username: String { get }
  var userLevel: String { get }
}

protocol UserProfileUsersSectionHeaderViewModelProtocol: DiffableProtocol {
  var title: String { get }
  var isShowAllButtonHidden: Bool { get }
}

protocol UserProfileFriendRequestViewModelProtocol: DiffableProtocol {
  var avatarPlaceholder: UIImage? { get }
  var avatarURLString: String { get }
  var username: String { get }
  var userLevel: String { get }
  
  var requestStatus: UserProfileContent.FriendRequestStatus { get }
  var statusTitle: String { get }
}

protocol UserProfileRewardsChartViewModelProtocol: DiffableProtocol {
  var points: [(UIColor, [(Double, Date)])] { get }
  var labels: [String] { get }
  var labelsIndexes: [Double] { get }
  var periodTitle: String { get }
}
