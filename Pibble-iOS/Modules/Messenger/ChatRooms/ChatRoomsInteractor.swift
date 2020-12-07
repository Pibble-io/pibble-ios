//
//  ChatRoomsInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 16/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

// MARK: - ChatRoomsInteractor Class
final class ChatRoomsInteractor: Interactor {
  fileprivate let coreDataStorage: CoreDataStorageServiceProtocol
  fileprivate let chatService: ChatServiceProtocol
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  fileprivate let webSocketsNotificationSubscribeService: WebSocketsNotificationSubscribeServiceProtocol
  fileprivate let contentType: ChatRooms.ContentType
  
  fileprivate var chatRoomsGroup: ChatRoomsGroupProtocol? {
    return observableChatRoomsGroup?.object
  }
  
  func createObservableChatRoomGroupIfNeeded(_ chatRoom: PartialChatRoomsGroupProtocol) {
    guard observableChatRoomsGroup == nil else {
      return
    }
    
    observableChatRoomsGroup = ChatRoomsGroupManagedObject.createObservable(with: chatRoom, in: coreDataStorage.viewContext)
    
    observableChatRoomsGroup?.observationHandler = { [weak self] in
      self?.presenter.presentRoomsGroup($0)
    }
    
    observableChatRoomsGroup?.performFetch { [weak self] in
      switch $0 {
      case .success(let chatRoomsGroup):
        guard let chatRoomsGroup = chatRoomsGroup else {
          return
        }
        self?.presenter.presentRoomsGroup(chatRoomsGroup)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  fileprivate var observableChatRoomsGroup: ObservableManagedObject<ChatRoomsGroupManagedObject>?
  
  
  fileprivate let paginationController: PaginationControllerProtocol
  
  fileprivate lazy var fetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy = {
    FetchedResultsControllerDelegateProxy(delegate: self)
  }()
  
  fileprivate var fetchResultController: NSFetchedResultsController<ChatRoomManagedObject>? = nil
  
  init(coreDataStorage: CoreDataStorageServiceProtocol,
       chatService: ChatServiceProtocol,
       accountProfileService: AccountProfileServiceProtocol,
       webSocketsNotificationSubscribeService: WebSocketsNotificationSubscribeServiceProtocol,
       contentType: ChatRooms.ContentType
    
    ) {
    self.coreDataStorage = coreDataStorage
    self.chatService = chatService
    self.accountProfileService = accountProfileService
    self.webSocketsNotificationSubscribeService = webSocketsNotificationSubscribeService
    self.contentType = contentType
    
    self.paginationController = PaginationController(itemsPerPage: 10, requestItems: 10, shouldRefreshTop: false, shouldRefreshInTheMiddle: false)
    
    super.init()
    self.paginationController.delegate = self
  }
}

// MARK: - ChatRoomsInteractor API
extension ChatRoomsInteractor: ChatRoomsInteractorApi {
  func performLeaveRoomAt(_ indexPath: IndexPath) {
    guard let item = mutalbeItemAt(indexPath) else {
      return
    }
    
    item.setLeft(true)
    coreDataStorage.batchUpdateStorage(with: [item])
    
    chatService.setLeaveStateForRoom(item, left: true) { [weak self] in
      if let error = $0 {
        self?.presenter.handleError(error)
      }
    }
  }
  
  func performMuteRoomAt(_ indexPath: IndexPath) {
    guard let item = mutalbeItemAt(indexPath) else {
      return
    }
    
    let newMuteState = !item.isMutedByCurrentUser
    item.setMuted(newMuteState)
    coreDataStorage.batchUpdateStorage(with: [item])
    
    chatService.setMuteStateForRoom(item, muted: newMuteState) { [weak self] in
      if let error = $0 {
        self?.presenter.handleError(error)
      }
    }
  }
  
  func subscribeWebSocketUpdates() {
    webSocketsNotificationSubscribeService.subscribe(self)
  }
  
  func unsubscribeWebSocketUpdates() {
    webSocketsNotificationSubscribeService.unsubscribe()
  }
  
  func markItemAsReadAt(_ indexPath: IndexPath) {
    guard let item = mutalbeItemAt(indexPath) else {
      return
    }
    
    item.readAllMessages()
    coreDataStorage.batchUpdateStorage(with: [item])
  }
  
  var currentUser: UserProtocol? {
     return accountProfileService.currentUserAccount
  }
  
  func numberOfSections() -> Int {
    return fetchResultController?.sections?.count ?? 0
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return fetchResultController?.sections?[section].numberOfObjects ?? 0
  }
  
  func itemAt(_ indexPath: IndexPath) -> ChatRoomProtocol? {
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
    switch contentType {
    case .personalChatRooms:
      break
    case .chatRoomsForExistingGroup(let group):
      presenter.presentRoomsGroup(group)
    case .chatRoomsForGroup(_):
      break
    }
    
    if let profile = accountProfileService.currentUserAccount {
      performFetchFor(account: profile, contentType: contentType)
    } else {
      accountProfileService.getProfile { [weak self] in
        guard let strongSelf = self else {
          return
        }
        switch $0 {
        case .success(let profile):
          self?.performFetchFor(account: profile, contentType: strongSelf.contentType)
        case .failure(let err):
          self?.presenter.handleError(err)
        }
      }
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension ChatRoomsInteractor {
  var presenter: ChatRoomsPresenterApi {
    return _presenter as! ChatRoomsPresenterApi
  }
}

// MARK: - Helpers
extension ChatRoomsInteractor {
  fileprivate func mutalbeItemAt(_ indexPath: IndexPath) -> MutableChatRoomProtocol? {
    guard let item = fetchResultController?.object(at: indexPath) else {
      return nil
    }
    return item
  }
  
  fileprivate func performFetchFor(account: UserProtocol, contentType: ChatRooms.ContentType) {
    let predicate = fetchPredicateFor(account, contentType: contentType)
    
    fetchResultController = setupFRCFor(account: account,
                                         predicate: predicate,
                                         sortDescriptors: sortDesriptors(contentType: contentType),
                                         delegate: fetchedResultsControllerDelegateProxy)
    
    do {
      try fetchResultController?.performFetch()
    } catch {
      presenter.handleError(error)
    }
    
    presenter.presentReload()
  }
  
  fileprivate func setupFRCFor(account: UserProtocol, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor], delegate: FetchedResultsControllerDelegateProxy) -> NSFetchedResultsController<ChatRoomManagedObject> {
    
    let fetchRequest: NSFetchRequest<ChatRoomManagedObject> = ChatRoomManagedObject.fetchRequest()
    fetchRequest.predicate = predicate
    fetchRequest.sortDescriptors = sortDescriptors
    fetchRequest.fetchBatchSize = 30
    
    let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStorage.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    
    fetchResultsController.delegate = delegate
    return fetchResultsController
  }
  
  fileprivate func performFetchItemsAndSaveToStorage(page: Int, perPage: Int) {
    switch contentType {
    case .personalChatRooms:
      chatService.getPrivateChatRooms(page: page, perPage: perPage) { [weak self] in
        switch $0 {
        case .success(let rooms, let pagination):
          self?.coreDataStorage.updateStorage(with: rooms)
          self?.paginationController.updatePaginationInfo(pagination)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
    case .chatRoomsForGroup(let post):
      chatService.getChatRoomsForPostGroup(post.identifier, page: page, perPage: perPage) { [weak self] in
        guard let strongSelf = self else {
          return
        }
        switch $0 {
        case .success(let group):
          strongSelf.createObservableChatRoomGroupIfNeeded(group)
          strongSelf.coreDataStorage.updateStorage(with: [group])
          //self?.paginationController.updatePaginationInfo(pagination)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
    case .chatRoomsForExistingGroup(let group):
      guard let postId = group.relatedPost?.identifier else {
        return
      }
      
      chatService.getChatRoomsForPostGroup(postId, page: page, perPage: perPage) { [weak self] in
        guard let strongSelf = self else {
          return
        }
        switch $0 {
        case .success(let obtainedGroup):
//          strongSelf.presenter.presentRoomsGroup(obtainedGroup)
          strongSelf.coreDataStorage.updateStorage(with: [obtainedGroup])
        //self?.paginationController.updatePaginationInfo(pagination)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
    }
  }
  
  fileprivate func fetchPredicateFor(_ user: UserProtocol, contentType: ChatRooms.ContentType) -> NSPredicate? {
    let notLeftPredicate = NSPredicate(format: "isLeft == %@", NSNumber(value: false))
    
    switch contentType {
    case .personalChatRooms:
      let roomType = ChatRoomType.plain.rawValue
      let typePredicate = NSPredicate(format: "type = %@", roomType)
      let memberPredicate = NSPredicate(format: "ANY members.user.id = \(user.identifier)")
      return NSCompoundPredicate(andPredicateWithSubpredicates: [typePredicate, memberPredicate, notLeftPredicate])
      
    case .chatRoomsForGroup(let post):
      let roomType = ChatRoomType.commercial.rawValue
      let typePredicate = NSPredicate(format: "type = %@", roomType)
      let groupPredicate = NSPredicate(format: "post.id = \(post.identifier)")
      return NSCompoundPredicate(andPredicateWithSubpredicates: [typePredicate, groupPredicate, notLeftPredicate])
      
    case .chatRoomsForExistingGroup(let group):
      let roomType = ChatRoomType.commercial.rawValue
      let typePredicate = NSPredicate(format: "type = %@", roomType)
      let groupPredicate = NSPredicate(format: "chatRoomsGroup.id = \(group.identifier)")
      return NSCompoundPredicate(andPredicateWithSubpredicates: [typePredicate, groupPredicate, notLeftPredicate])
    }
  }
  
  fileprivate func sortDesriptors(contentType: ChatRooms.ContentType) -> [NSSortDescriptor] {
    
    return [NSSortDescriptor(key: #keyPath(ChatRoomManagedObject.lastMessageCreatedAt), ascending: false),
            NSSortDescriptor(key: #keyPath(ChatRoomManagedObject.unreadMessageCount), ascending: false),
            NSSortDescriptor(key: #keyPath(ChatRoomManagedObject.id), ascending: false)]
  }
}


//MARK:- FetchedResultsControllerDelegate

extension ChatRoomsInteractor: FetchedResultsControllerDelegate {
  func updateItems(_ proxy: FetchedResultsControllerDelegateProxy, updates: CollectionViewModelUpdate) {
    presenter.presentCollectionUpdates(updates)
  }
}

//MARK:- WebSocketsNotificationDelegateProtocol

extension ChatRoomsInteractor: WebSocketsNotificationDelegateProtocol {
  func handleEvent(_ event: WebSocketsEvent) {
    switch event {
    case .newMessage:
      initialRefresh()
    }
  }
}

//MARK:- PaginationControllerDelegate

extension ChatRoomsInteractor: PaginationControllerDelegate {
  func request(page: Int, perPage: Int) {
    performFetchItemsAndSaveToStorage(page: page, perPage: perPage)
  }
}
