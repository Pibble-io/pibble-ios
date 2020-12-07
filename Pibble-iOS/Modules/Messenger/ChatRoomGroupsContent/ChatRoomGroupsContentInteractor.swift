//
//  ChatRoomGroupsContentInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/04/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

// MARK: - ChatRoomGroupsContentInteractor Class
final class ChatRoomGroupsContentInteractor: Interactor {
  fileprivate let coreDataStorage: CoreDataStorageServiceProtocol
  fileprivate let chatService: ChatServiceProtocol
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  fileprivate let webSocketsNotificationSubscribeService: WebSocketsNotificationSubscribeServiceProtocol
  
  fileprivate var paginationController: PaginationControllerProtocol
  
  fileprivate lazy var fetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy = {
    FetchedResultsControllerDelegateProxy(delegate: self)
  }()
  
  fileprivate var fetchResultController: NSFetchedResultsController<ChatRoomsGroupManagedObject>? = nil
  
  init(coreDataStorage: CoreDataStorageServiceProtocol,
       chatService: ChatServiceProtocol,
       accountProfileService: AccountProfileServiceProtocol,
       webSocketsNotificationSubscribeService: WebSocketsNotificationSubscribeServiceProtocol) {
    self.coreDataStorage = coreDataStorage
    self.chatService = chatService
    self.accountProfileService = accountProfileService
    self.webSocketsNotificationSubscribeService = webSocketsNotificationSubscribeService
    
    self.paginationController = PaginationController(itemsPerPage: 10, requestItems: 10, shouldRefreshTop: false, shouldRefreshInTheMiddle: false)
    
    super.init()
    self.paginationController.delegate = self
  }
}

// MARK: - ChatRoomGroupsContentInteractor API
extension ChatRoomGroupsContentInteractor: ChatRoomGroupsContentInteractorApi {
  func subscribeWebSocketUpdates() {
    webSocketsNotificationSubscribeService.subscribe(self)
  }
  
  func unsubscribeWebSocketUpdates() {
    webSocketsNotificationSubscribeService.unsubscribe()
  }
  
//  func markItemAsReadAt(_ indexPath: IndexPath) {
//    guard let item = mutalbeItemAt(indexPath) else {
//      return
//    }
//
//    item.readAllMessages()
//    coreDataStorage.batchUpdateStorage(with: [item])
//  }
  
  var currentUser: UserProtocol? {
    return accountProfileService.currentUserAccount
  }
  
  func numberOfSections() -> Int {
    return fetchResultController?.sections?.count ?? 0
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return fetchResultController?.sections?[section].numberOfObjects ?? 0
  }
  
  func itemAt(_ indexPath: IndexPath) -> ChatRoomsGroupProtocol? {
    guard let item = fetchResultController?.object(at: indexPath) else {
      return nil
    }
    return item
  }
  
  func prepareItemFor(_ indexPath: Int) {
    paginationController.paginateByIndex(indexPath)
  }
  
  func cancelPrepareItemFor(_ indexPath: Int) {
    
  }
  
  func initialRefresh() {
    paginationController.initialRequest()
  }
  
  func initialFetchData() {
    if let profile = accountProfileService.currentUserAccount {
      performFetchFor(account: profile)
    } else {
      accountProfileService.getProfile { [weak self] in
        switch $0 {
        case .success(let profile):
          self?.performFetchFor(account: profile)
        case .failure(let err):
          self?.presenter.handleError(err)
        }
      }
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension ChatRoomGroupsContentInteractor {
  var presenter: ChatRoomGroupsContentPresenterApi {
    return _presenter as! ChatRoomGroupsContentPresenterApi
  }
}

// MARK: - Helpers
extension ChatRoomGroupsContentInteractor {
//  fileprivate func mutalbeItemAt(_ indexPath: IndexPath) -> MutableChatRoomProtocol? {
//    guard let item = fetchResultController?.object(at: indexPath) else {
//      return nil
//    }
//    return item
//  }
  
  fileprivate func performFetchFor(account: UserProtocol) {
    let predicate = fetchPredicateFor(account)
    
    fetchResultController = setupFRCFor(account: account,
                                        predicate: predicate,
                                        sortDescriptors: sortDesriptors(),
                                        delegate: fetchedResultsControllerDelegateProxy)
    
    do {
      try fetchResultController?.performFetch()
    } catch {
      presenter.handleError(error)
    }
    
    presenter.presentReload()
  }
  
  fileprivate func setupFRCFor(account: UserProtocol, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor], delegate: FetchedResultsControllerDelegateProxy) -> NSFetchedResultsController<ChatRoomsGroupManagedObject> {
    
    let fetchRequest: NSFetchRequest<ChatRoomsGroupManagedObject> = ChatRoomsGroupManagedObject.fetchRequest()
    fetchRequest.predicate = predicate
    fetchRequest.sortDescriptors = sortDescriptors
    fetchRequest.fetchBatchSize = 30
    
    let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStorage.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    
    fetchResultsController.delegate = delegate
    return fetchResultsController
  }
  
  fileprivate func performFetchItemsAndSaveToStorage(page: Int, perPage: Int) {
    chatService.getCommerceRoomsGroups(page: page, perPage: perPage) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      switch $0 {
      case .success(let groups, let pagination):
        guard let user =  strongSelf.currentUser else {
          strongSelf.coreDataStorage.updateStorage(with: groups)
          strongSelf.paginationController.updatePaginationInfo(pagination)
          return
        }
        
        let userGroups = groups.map { ChatRoomsGroupRelations.partialChatRoomsGroupForUser(chatRoomsGroup: $0, user: user) }
        strongSelf.coreDataStorage.updateStorage(with: userGroups)
        strongSelf.paginationController.updatePaginationInfo(pagination)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  fileprivate func fetchPredicateFor(_ user: UserProtocol) -> NSPredicate? {
    return NSPredicate(format: "user.id = \(user.identifier)")
  }
  
  fileprivate func sortDesriptors() -> [NSSortDescriptor] {
    return [NSSortDescriptor(key: #keyPath(ChatRoomsGroupManagedObject.lastMessageCreatedAt), ascending: false),
            NSSortDescriptor(key: #keyPath(ChatRoomsGroupManagedObject.unreadMessageCount), ascending: false),
            NSSortDescriptor(key: #keyPath(ChatRoomsGroupManagedObject.id), ascending: false)]
  }
}


//MARK:- FetchedResultsControllerDelegate

extension ChatRoomGroupsContentInteractor: FetchedResultsControllerDelegate {
  func updateItems(_ proxy: FetchedResultsControllerDelegateProxy, updates: CollectionViewModelUpdate) {
    presenter.presentCollectionUpdates(updates)
  }
}

//MARK:- WebSocketsNotificationDelegateProtocol

extension ChatRoomGroupsContentInteractor: WebSocketsNotificationDelegateProtocol {
  func handleEvent(_ event: WebSocketsEvent) {
    switch event {
    case .newMessage:
      initialRefresh()
    }
  }
}

//MARK:- PaginationControllerDelegate

extension ChatRoomGroupsContentInteractor: PaginationControllerDelegate {
  func request(page: Int, perPage: Int) {
    performFetchItemsAndSaveToStorage(page: page, perPage: perPage)
  }
}
