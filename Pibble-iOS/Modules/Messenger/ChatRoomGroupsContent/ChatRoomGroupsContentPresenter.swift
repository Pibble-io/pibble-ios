//
//  ChatRoomGroupsContentPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/04/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - ChatRoomGroupsContentPresenter Class
final class ChatRoomGroupsContentPresenter: Presenter {
  //MARK:- Overrides:
  
  override func viewDidLoad() {
    super.viewDidLoad()
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

// MARK: - ChatRoomGroupsContentPresenter API
extension ChatRoomGroupsContentPresenter: ChatRoomGroupsContentPresenterApi {
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
  
  func itemViewModelAt(_ indexPath: IndexPath) -> ChatRoomGroupsContent.ItemViewModel {
    guard let currentUser = interactor.currentUser,
      let item = interactor.itemAt(indexPath)
      else {
        return .loadingPlaceholder
    }
    
    let viewModel = ChatRoomGroupsContent.ChatRoomItemViewModel(chatRoomsGroup: item, currentUser: currentUser)
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
//    interactor.markItemAsReadAt(indexPath)
    
    router.routeToChatRoomsFor(item)
  }
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate) {
    viewController.updateCollection(updates)
  }
}

// MARK: - ChatRoomGroupsContent Viper Components
fileprivate extension ChatRoomGroupsContentPresenter {
  var viewController: ChatRoomGroupsContentViewControllerApi {
    return _viewController as! ChatRoomGroupsContentViewControllerApi
  }
  var interactor: ChatRoomGroupsContentInteractorApi {
    return _interactor as! ChatRoomGroupsContentInteractorApi
  }
  var router: ChatRoomGroupsContentRouterApi {
    return _router as! ChatRoomGroupsContentRouterApi
  }
}
