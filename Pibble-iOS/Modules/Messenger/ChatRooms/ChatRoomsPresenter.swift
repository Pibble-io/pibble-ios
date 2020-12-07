//
//  ChatRoomsPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 16/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - ChatRoomsPresenter Class
final class ChatRoomsPresenter: Presenter {
  //MARK:- Properties
  
  fileprivate var selectedItem: IndexPath?
  
  //MARK:- Overrides
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewController.setNavigationBarViewModel(ChatRooms.NavigationBarViewModel.empty())
    interactor.initialFetchData()
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    interactor.initialRefresh()
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
    interactor.subscribeWebSocketUpdates()
  }
  
  override func viewWillDisappear() {
    super.viewWillDisappear()
    interactor.unsubscribeWebSocketUpdates()
  }
}

// MARK: - ChatRoomsPresenter API
extension ChatRoomsPresenter: ChatRoomsPresenterApi {
  func handleMuteActionAt(_ indexPath: IndexPath) {
    interactor.performMuteRoomAt(indexPath)
  }
  
  func handleLeaveRoomActionAt(_ indexPath: IndexPath) {
    selectedItem = indexPath
    viewController.showConfirmLeaveAlert()
  }
  
  func handleConfirmLeaveCurrentSelectedRoom() {
    guard let indexPath = selectedItem else {
      return
    }
    
    interactor.performLeaveRoomAt(indexPath)
  }
  
  func presentRoomsGroup(_ roomsGroup: ChatRoomsGroupProtocol) {
    let viewModel = ChatRooms.NavigationBarViewModel(chatRoomsGroup: roomsGroup)
    viewController.setNavigationBarViewModel(viewModel)
  }
  
  func presentReload() {
    viewController.reloadData()
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func numberOfSections() -> Int {
    return interactor.numberOfSections()
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return interactor.numberOfItemsInSection(section)
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> ChatRooms.ItemViewModel {
    guard let currentUser = interactor.currentUser,
      let item = interactor.itemAt(indexPath)
    else {
      return .loadingPlaceholder
    }
    
    let viewModel = ChatRooms.ChatRoomItemViewModel(chatRoom: item, currentUser: currentUser)
    return .chatRoom(viewModel)
  }
  
  func handleWillDisplayItem(_ indexPath: IndexPath) {
    interactor.prepareItemFor(indexPath.item)
  }
  
  func handleDidEndDisplayItem(_ indexPath: IndexPath) {
    interactor.cancelPrepareItemFor(indexPath.item)
  }
  
  func handleSelectActionAt(_ indexPath: IndexPath) {
    guard let item = interactor.itemAt(indexPath) else {
      return
    }
    interactor.markItemAsReadAt(indexPath)
    router.routeToChatRoom(item)
  }
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate) {
    viewController.updateCollection(updates)
  }
}

// MARK: - ChatRooms Viper Components
fileprivate extension ChatRoomsPresenter {
  var viewController: ChatRoomsViewControllerApi {
    return _viewController as! ChatRoomsViewControllerApi
  }
  var interactor: ChatRoomsInteractorApi {
    return _interactor as! ChatRoomsInteractorApi
  }
  var router: ChatRoomsRouterApi {
    return _router as! ChatRoomsRouterApi
  }
}
