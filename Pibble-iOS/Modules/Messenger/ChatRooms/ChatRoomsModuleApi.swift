//
//  ChatRoomsModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 16/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - ChatRoomsRouter API
protocol ChatRoomsRouterApi: RouterProtocol {
  func routeToChatRoom(_ room: ChatRoomProtocol)
}

//MARK: - ChatRoomsView API
protocol ChatRoomsViewControllerApi: ViewControllerProtocol {
  func reloadData()
  func updateCollection(_ updates: CollectionViewModelUpdate)
  
  func setNavigationBarViewModel(_ vm: ChatRoomsNavigationBarViewModelProtocol)
  
  func showConfirmLeaveAlert()
}

//MARK: - ChatRoomsPresenter API
protocol ChatRoomsPresenterApi: PresenterProtocol {
  func handleHideAction()
  func handleWillDisplayItem(_ indexPath: IndexPath)
  func handleDidEndDisplayItem(_ indexPath: IndexPath)
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> ChatRooms.ItemViewModel
  
  func handleSelectActionAt(_ indexPath: IndexPath)
  
  func handleMuteActionAt(_ indexPath: IndexPath)
  func handleLeaveRoomActionAt(_ indexPath: IndexPath)
  
  func handleConfirmLeaveCurrentSelectedRoom()
  
  func presentReload()
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate)
  func presentRoomsGroup(_ roomsGroup: ChatRoomsGroupProtocol)
}

//MARK: - ChatRoomsInteractor API
protocol ChatRoomsInteractorApi: InteractorProtocol {
  var currentUser: UserProtocol? { get }
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemAt(_ indexPath: IndexPath) -> ChatRoomProtocol?
  
  func markItemAsReadAt(_ indexPath: IndexPath)
  
  
  func performLeaveRoomAt(_ indexPath: IndexPath)
  func performMuteRoomAt(_ indexPath: IndexPath)
  
  
  func prepareItemFor(_ indexPath: Int)
  func cancelPrepareItemFor(_ indexPath: Int)
  func initialFetchData()
  func initialRefresh()
  
  func subscribeWebSocketUpdates()
  func unsubscribeWebSocketUpdates()
}

protocol ChatRoomItemViewModelProtocol {
  var title: String { get }
  var avatarPlaceholder: UIImage? { get }
  var avatarURLString: String { get }
  var lastMessage: String { get }
  var date: String { get }
  var unreadCount: String { get }
  var membersCount: String { get }
  
  var commercialIconImage: UIImage? { get }
  
  var canBeMuted: Bool { get }
  var canBeLeaved: Bool { get }
  
  var muteTitle: String { get }
  var leaveTitle: String { get }
}

protocol ChatRoomsNavigationBarViewModelProtocol {
  var userpicUrlString: String { get }
  var userpicPlaceholder: UIImage? { get }
  
  var title: String { get }
  var subtitle: String { get }
}
