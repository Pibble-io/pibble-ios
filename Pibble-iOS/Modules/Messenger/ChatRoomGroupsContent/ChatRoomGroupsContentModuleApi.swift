//
//  ChatRoomGroupsContentModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/04/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//
import UIKit

//MARK: - ChatRoomGroupsContentRouter API
protocol ChatRoomGroupsContentRouterApi: RouterProtocol {
  func routeToChatRoomsFor(_ group: ChatRoomsGroupProtocol)
}

//MARK: - ChatRoomGroupsContentView API
protocol ChatRoomGroupsContentViewControllerApi: ViewControllerProtocol {
  func reloadData()
  func updateCollection(_ updates: CollectionViewModelUpdate)
}

//MARK: - ChatRoomGroupsContentPresenter API
protocol ChatRoomGroupsContentPresenterApi: PresenterProtocol {
  func handleHideAction()
  func handleWillDisplayItem(_ indexPath: IndexPath)
  func handleDidEndDisplayItem(_ indexPath: IndexPath)
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> ChatRoomGroupsContent.ItemViewModel
  
  func handleSelectActionAt(_ indexPath: IndexPath)
  
  func presentReload()
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate)
}

//MARK: - ChatRoomGroupsContentInteractor API
protocol ChatRoomGroupsContentInteractorApi: InteractorProtocol {
  var currentUser: UserProtocol? { get }
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemAt(_ indexPath: IndexPath) -> ChatRoomsGroupProtocol?
  
//  func markItemAsReadAt(_ indexPath: IndexPath)
//  
  func prepareItemFor(_ indexPath: Int)
  func cancelPrepareItemFor(_ indexPath: Int)
  func initialFetchData()
  func initialRefresh()
  
  func subscribeWebSocketUpdates()
  func unsubscribeWebSocketUpdates()
}
