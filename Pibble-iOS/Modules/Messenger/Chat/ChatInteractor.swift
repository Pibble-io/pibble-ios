//
//  ChatInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

// MARK: - ChatInteractor Class
final class ChatInteractor: Interactor {
  fileprivate let coreDataStorage: CoreDataStorageServiceProtocol
  fileprivate let chatService: ChatServiceProtocol
  fileprivate let accountService: AccountProfileServiceProtocol
  fileprivate let walletService: WalletServiceProtocol
  fileprivate let mediaDownloadService: MediaDownloadServiceProtocol
  fileprivate let webSocketsNotificationSubscribeService: WebSocketsNotificationSubscribeServiceProtocol
  
  fileprivate let targetRoomType: Chat.RoomType
  
  fileprivate var chatRoom: ChatRoomProtocol? {
    return observableChatRoom?.object
  }
  
  func createObservableChatRoomIfNeeded(_ chatRoom: PartialChatRoomProtocol) {
    guard observableChatRoom == nil else {
      return
    }
    
    observableChatRoom = ChatRoomManagedObject.createObservable(with: chatRoom, in: coreDataStorage.viewContext)
    
    observableChatRoom?.observationHandler = { [weak self] in
      self?.presenter.presentRoom($0, forCurrentUser: self?.currentUser)
    }
    
    observableChatRoom?.performFetch { [weak self] in
      switch $0 {
      case .success(let chatRoom):
        self?.presenter.presentRoom(chatRoom, forCurrentUser: self?.currentUser)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  fileprivate var observableChatRoom: ObservableManagedObject<ChatRoomManagedObject>?
 
  fileprivate var paginationController: PaginationControllerProtocol
  fileprivate let messageLengthMax = 500
  fileprivate var selectedReplyItem: CommentManagedObject?
  
  fileprivate var requestedInvoice: PartialInvoiceProtocol?
  
  fileprivate lazy var fetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy = {
    FetchedResultsControllerDelegateProxy(delegate: self)
  }()

  fileprivate var fetchResultController: NSFetchedResultsController<BaseChatMessageManagedObject>?

  init(coreDataStorage: CoreDataStorageServiceProtocol,
       chatService: ChatServiceProtocol,
       accountService: AccountProfileServiceProtocol,
       walletService: WalletServiceProtocol,
       mediaDownloadService: MediaDownloadServiceProtocol,
       webSocketsNotificationSubscribeService: WebSocketsNotificationSubscribeServiceProtocol,
       roomType: Chat.RoomType) {
    self.coreDataStorage = coreDataStorage
    self.chatService = chatService
    self.accountService = accountService
    self.walletService = walletService
    self.mediaDownloadService = mediaDownloadService
    self.webSocketsNotificationSubscribeService = webSocketsNotificationSubscribeService
    self.targetRoomType = roomType
    
    self.paginationController = PaginationController(itemsPerPage: 10, requestItems: 10, shouldRefreshTop: false, shouldRefreshInTheMiddle: true)
    
    super.init()
    self.paginationController.delegate = self
  }
}

// MARK: - ChatInteractor API
extension ChatInteractor: ChatInteractorApi {
  func confirmGoodsOrder() {
    guard let currentRoom = currentRoom,
      let goodsOrder = currentRoom.lastGoodsOrder
    else {
      return
    }
    
    guard case GoodsOrderStatus.waiting = goodsOrder.orderStatus else {
      return
    }
    
    walletService.confirmGoodsOrder(goodsOrder) { [weak self] in
      if let error = $0 {
        self?.presenter.handleError(error)
        return
      }
      
      self?.refreshRoomData()
    }
  }
  
  func requestGoodsOrderReturn() {
    guard let currentRoom = currentRoom,
      let goodsOrder = currentRoom.lastGoodsOrder
      else {
        return
    }
    
    guard case GoodsOrderStatus.waiting = goodsOrder.orderStatus else {
      return
    }
    
    walletService.requestGoodsOrderReturn(goodsOrder) { [weak self] in
      if let error = $0 {
        self?.presenter.handleError(error)
        return
      }
      
      self?.refreshRoomData()
    }
  }
  
  func approveGoodsOrderReturn() {
    guard let currentRoom = currentRoom,
      let goodsOrder = currentRoom.lastGoodsOrder
    
      else {
        return
    }
    
    guard currentRoom.relatedPost?.postingUser?.identifier == currentUser?.identifier else {
      return
    }
    
    guard case GoodsOrderStatus.returnRequested = goodsOrder.orderStatus else {
      return
    }
    
    walletService.approveGoodsOrderReturn(goodsOrder) { [weak self] in
      if let error = $0 {
        self?.presenter.handleError(error)
        return
      }
      
      self?.refreshRoomData()
    }
  }
  
  func requestChatRoomDigitalGoodMediaItemAt(_ mediaItemIndex: Int) {
    performRequestChatRoomDigitalGoodMediaItemFor(currentRoom, mediaItemIndex: mediaItemIndex)
  }
  
  func performDownloadChatRoomDigitalGood() {
    performDownloadItemFor(currentRoom)
  }
  
  func performPurchaseForRelatedCommercialPost() {
    initPurchaseProcessFor(currentRoom)
  }
  
  var currentRoom: ChatRoomProtocol?  {
    return chatRoom
  }
  
  func subscribeWebSocketUpdates() {
    webSocketsNotificationSubscribeService.subscribe(self)
  }
  
  func unsubscribeWebSocketUpdates() {
    webSocketsNotificationSubscribeService.unsubscribe()
  }
  
  func performMarkMessagesAsRead() {
    guard let room = chatRoom else {
      return
    }
    
    chatService.markAllMessagesAsRead(room) { [weak self] in
      if let error = $0 {
        self?.presenter.handleError(error)
      }
    }
  }
  
  func performRequestInvoiceForItemAt(_ indexPath: IndexPath) {

  }
  
  fileprivate func performDownloadItemFor(_ room: ChatRoomProtocol?) {
    guard let room = room,
      let post = room.relatedPost,
      let _ = post.postingUser,
      let _ = post.commerceInfo
    else {
        presenter.handleError(Chat.Errors.digitalGoodDownloadError)
        return
    }
    
    presenter.presentDownloadStarted()
    mediaDownloadService.downloadDigitalGoodForPostAndGetContentFiles(post) { [weak self] in
      switch $0 {
      case .success(let urls):
        self?.presenter.presentDownloadedDigitalGoodsFilesURLs(urls)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  fileprivate func performRequestChatRoomDigitalGoodMediaItemFor(_ room: ChatRoomProtocol?, mediaItemIndex: Int)  {
    guard let room = room,
      let post = room.relatedPost,
      let _ = post.postingUser,
      let _ = post.commerceInfo,
      let invoice = post.currentUserDigitalGoodPurchaseInvoice,
      invoice.walletActivityStatus == InvoiceStatus.accepted,
      mediaItemIndex < post.postingMedia.count
      
      else {
        presenter.handleError(Chat.Errors.digitalGoodShowError)
        return
    }
    
    presenter.presentPostMedia(post, media: post.postingMedia[mediaItemIndex])
  }
  
  
  func performDownloadItemAt(_ indexPath: IndexPath) {
    guard let message = itemAt(indexPath) else {
      presenter.handleError(Chat.Errors.invoiceRequestError)
      return
    }
    
    switch message {
    case .text:
      presenter.handleError(Chat.Errors.invoiceRequestError)
      return
    case .system:
      presenter.handleError(Chat.Errors.invoiceRequestError)
      return
    case .post(let postMessage):
      guard let post = postMessage.quotedPost,
        let _ = post.postingUser,
        let _ = post.commerceInfo
        else {
          presenter.handleError(Chat.Errors.digitalGoodDownloadError)
          return
      }
      
      presenter.presentDownloadStarted()
      mediaDownloadService.downloadDigitalGoodForPostAndGetContentFiles(post) { [weak self] in
                                        switch $0 {
                                        case .success(let urls):
                                          self?.presenter.presentDownloadedDigitalGoodsFilesURLs(urls)
                                        case .failure(let error):
                                          self?.presenter.handleError(error)
                                        }
      }
    }
  }
  
  func approveGoodsOrderReturnAt(_ indexPath: IndexPath) {
    guard let item = itemAt(indexPath) else {
      return
    }
    
    let order: GoodsOrderProtocol?
    
    switch item {
    case .text(_):
      return
    case .post(_):
      return
    case .system(let systemMessage):
      order = systemMessage.relatedGoodsOrder
    }
    
    guard let currentRoom = currentRoom,
      let goodsOrder = order
    else {
        return
    }
    
    guard currentRoom.relatedPost?.postingUser?.identifier == currentUser?.identifier else {
      return
    }
    
    guard case GoodsOrderStatus.returnRequested = goodsOrder.orderStatus else {
      return
    }
    
    walletService.approveGoodsOrderReturn(goodsOrder) { [weak self] in
      if let error = $0 {
        self?.presenter.handleError(error)
        return
      }
      
      self?.refreshRoomData()
    }
  }
  
  var currentUser: UserProtocol? {
    return accountService.currentUserAccount
  }
  
  func performDeleteItemAt(_ indexPath: IndexPath) {

  }
  
  func setDraftMessageText(_ text: String) {
    guard text.count >= messageLengthMax else {
      return
    }
    
    let indexEndOfText = text.index(text.startIndex, offsetBy: messageLengthMax)
    let cutText = String(text[..<indexEndOfText])
    presenter.presentCleanedDraftMessageText(cutText)
  }
  
  func createMessageWith(_ text: String) {
    guard let room = chatRoom else {
      return
    }
    
    postMessageWith(text, chatRoom: room)
  }
  
  fileprivate func postMessageWith(_ text: String, chatRoom: ChatRoomProtocol) {
    let messageBody = text.cleanedFromExtraNewLines().trimmingCharacters(in: .whitespacesAndNewlines)
    
    chatService.createTextMessageFor(chatRoom, text: messageBody) { [weak self] in
      switch $0 {
      case .success(let message):
        guard let strongSelf = self else {
          return
        }
        strongSelf.presenter.presentMesssageSendSuccess()
        let commentWithPosting = ChatMessagesRelations.chatRoomWithPartial(message: message, chatRoom: chatRoom)
        strongSelf.coreDataStorage.updateStorage(with: [commentWithPosting])
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  func numberOfSections() -> Int {
    return fetchResultController?.sections?.count ?? 0
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return fetchResultController?.sections?[section].numberOfObjects ?? 0
  }
  
  func itemAt(_ indexPath: IndexPath) -> ChatMessageEntity? {
    return fetchResultController?.object(at: indexPath).chatMessageEntity
  }
  
  func sectionDataFor(_ indexPath: IndexPath) -> Date? {
    guard indexPath.section < numberOfSections(),
      indexPath.item < numberOfItemsInSection(indexPath.section) else {
        return nil
    }
    
    return fetchResultController?.object(at: indexPath).dateComponent as Date?
  }
  
  func prepareItemFor(_ indexPath: IndexPath) {
    paginationController.paginateByIndex(indexPath.item)
  }
  
  func cancelPrepareItemFor(_ indexPath: IndexPath) {
    
  }
  
  func initialFetchData() {
    if let currentUser = accountService.currentUserAccount {
      requestRoomAndFetchMessagesFor(currentUser)
    } else {
      accountService.getProfile { [weak self] in
        switch $0 {
        case .success(let currentUser):
          self?.requestRoomAndFetchMessagesFor(currentUser)
        case .failure(let err):
          self?.presenter.handleError(err)
        }
      }
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension ChatInteractor {
  var presenter: ChatPresenterApi {
    return _presenter as! ChatPresenterApi
  }
}

extension ChatInteractor {
  fileprivate func refreshRoomData() {
    guard let chatRoom = chatRoom else {
      return
    }
    
    chatService.showChatRoom(chatRoom.identifier) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      switch $0 {
      case .success(let room):
        strongSelf.coreDataStorage.batchUpdateStorage(with: [room])
      case .failure(let error):
        strongSelf.presenter.handleError(error)
      }
    }
  }
  
  fileprivate func setupFRCFor(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor], delegate: FetchedResultsControllerDelegateProxy) -> NSFetchedResultsController<BaseChatMessageManagedObject> {
    
    let fetchRequest: NSFetchRequest<BaseChatMessageManagedObject> = BaseChatMessageManagedObject.fetchRequest()
    fetchRequest.predicate = predicate
    fetchRequest.sortDescriptors = sortDescriptors
    fetchRequest.fetchBatchSize = 30
    
    let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStorage.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    
    fetchResultsController.delegate = delegate
    return fetchResultsController
  }
  
  fileprivate func requestRoomAndFetchMessagesFor(_ currentUser: UserProtocol) {
    switch targetRoomType {
    case .roomForUser(let users):
      chatService.createChatRoomFor(users) { [weak self] in
        guard let strongSelf = self else {
          return
        }
        
        switch $0 {
        case .success(let room):
        
          strongSelf.createObservableChatRoomIfNeeded(room)
          strongSelf.coreDataStorage.batchUpdateStorage(with: [room])
          strongSelf.performMessagesFetchFor(account: currentUser, chatRoomId: room.identifier)
        case .failure(let error):
          strongSelf.presenter.handleError(error)
        }
      }
    case .roomForPost(let post):
      chatService.createChatRoomFor(post) { [weak self] in
        guard let strongSelf = self else {
          return
        }
        
        switch $0 {
        case .success(let room):
          strongSelf.createObservableChatRoomIfNeeded(room)
          strongSelf.coreDataStorage.batchUpdateStorage(with: [room])
          strongSelf.performMessagesFetchFor(account: currentUser, chatRoomId: room.identifier)
        case .failure(let error):
          strongSelf.presenter.handleError(error)
        }
      } 
    case .existingRoom(let existingRoom):
      chatService.showChatRoom(existingRoom.identifier) { [weak self] in
        guard let strongSelf = self else {
          return
        }
        
        switch $0 {
        case .success(let room):
          strongSelf.createObservableChatRoomIfNeeded(room)
          strongSelf.coreDataStorage.batchUpdateStorage(with: [room])
          strongSelf.performMessagesFetchFor(account: currentUser, chatRoomId: room.identifier)
        case .failure(let error):
          strongSelf.presenter.handleError(error)
        }
      }
    }
  }
  
  
  fileprivate func performMessagesFetchFor(account: UserProtocol, chatRoomId: Int) {
    fetchResultController = setupFRCFor(predicate: fetchPredicateForRoom(chatRoomId),
                                         sortDescriptors: sortDesriptors(),
                                         delegate: fetchedResultsControllerDelegateProxy)
    
    do {
      try fetchResultController?.performFetch()
    } catch {
      presenter.handleError(error)
    }
    
    presenter.presentReload()
    paginationController.initialRequest()
  }
  
//  fileprivate func performFetchData() {
//    do {
//      try fetchResultController?.performFetch()
//    } catch {
//      presenter.handleError(error)
//    }
//  }
  
  fileprivate func performFetchItemsAndSaveToStorage(chatRoom: ChatRoomProtocol, page: Int, perPage: Int) {
    AppLogger.debug("performFetchItemsAndSaveToStorage \(page)")
    chatService.getMessagesForRoom(chatRoom, page: page, perPage: perPage) { [weak self] in
      switch $0 {
      case .success(let messages, let pagination):
        guard let strongSelf = self else {
          return
        }
        
        let messagesForRoom = messages.map { ChatMessagesRelations.chatRoomWithPartial(message: $0,
                                                                                chatRoom: chatRoom) }
        
        strongSelf.coreDataStorage.updateStorage(with: messagesForRoom)
        strongSelf.paginationController.updatePaginationInfo(pagination)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  fileprivate func fetchPredicateForRoom(_ chatRoomId: Int) -> NSPredicate? {
    let roomPredicate = NSPredicate(format: "chatRoom.id = \(chatRoomId)")
    return roomPredicate
//    let isDeletedPredicate = NSPredicate(format: "isLocallyDeletedComment == %@", NSNumber(value: false))
//    let postPredicate = NSPredicate(format: "posting.id = \(posting.identifier)")
//
//    return NSCompoundPredicate(andPredicateWithSubpredicates: [isDeletedPredicate, postPredicate])
  }
  
  fileprivate func sortDesriptors() -> [NSSortDescriptor] {
    return [
      NSSortDescriptor(key: #keyPath(BaseChatMessageManagedObject.dateComponent), ascending: false),
      NSSortDescriptor(key: #keyPath(BaseChatMessageManagedObject.id), ascending: false)
    ]
  }
}

//MARK:- FetchedResultsControllerDelegate

extension ChatInteractor: FetchedResultsControllerDelegate {
  func updateItems(_ proxy: FetchedResultsControllerDelegateProxy, updates: CollectionViewModelUpdate) {
    presenter.presentCollectionUpdates(updates)
  }
}


//MARK:- WebSocketsNotificationDelegateProtocol

extension ChatInteractor: WebSocketsNotificationDelegateProtocol {
  func handleEvent(_ event: WebSocketsEvent) {
    switch event {
    case .newMessage:
      request(page: 0, perPage: 3)
    }
  }
}

//MARK:- PaginationControllerDelegate

extension ChatInteractor: PaginationControllerDelegate {
  func request(page: Int, perPage: Int) {
    guard let room = chatRoom else {
      return
    }
    performFetchItemsAndSaveToStorage(chatRoom: room, page: page, perPage: perPage)
  }
}

//MARK:- Helpers

extension ChatInteractor {
  func confirmCurrentPurchase() {
    guard let room = currentRoom,
      let post = room.relatedPost
    else {
      presenter.handleError(Chat.Errors.invoiceRequestError)
      return
    }
    
    
    switch post.postingType {
    case .media, .funding, .charity, .crowdfundingWithReward:
      return
    case .commercial:
      guard let сurrentInvoice = requestedInvoice else {
        presenter.handleError(Chat.Errors.invoiceRequestError)
        return
      }
      requestedInvoice = nil
      walletService.acceptInvoice(сurrentInvoice.identifier) { [weak self] in
        guard let strongSelf = self else {
          return
        }
        
        switch $0 {
        case .success(_):
          strongSelf.refreshRoomData()
          strongSelf.presenter.presentPurchaseFinishSuccessful()
        case .failure(let error):
          strongSelf.presenter.handleError(error)
        }
      }
    case .goods:
      guard let goodsInfo = post.goodsInfo else {
        presenter.handleError(Chat.Errors.invoiceRequestError)
        return
      }
      
      walletService.createOrderFor(post: post, goodsInfo: goodsInfo) { [weak self] in
        guard let strongSelf = self else {
          return
        }
        
        switch $0 {
        case .success(_):
          strongSelf.refreshRoomData()
          strongSelf.presenter.presentPurchaseFinishSuccessful()
        case .failure(let error):
          strongSelf.presenter.handleError(error)
        }
      }
    }
  }
  
  func cancelCurrentPurchase() {
    requestedInvoice = nil
    presenter.presentRoomRelatedPost(currentRoom, currentUser: currentUser)
  }
  
  fileprivate func initPurchaseProcessFor(_ room: ChatRoomProtocol?) {
    guard let room = room,
      let post = room.relatedPost
    else {
      presenter.presentInvoiceRequestFailure()
      presenter.handleError(Chat.Errors.invoiceRequestError)
      return
    }
    
    switch post.postingType {
    case .media, .funding, .charity, .crowdfundingWithReward:
      presenter.presentInvoiceRequestFailure()
      presenter.handleError(Chat.Errors.invoiceRequestError)
      return
    case .commercial:
      guard let commerceInfo = post.commerceInfo,
        let postAuthor = post.postingUser
        else {
          presenter.presentInvoiceRequestFailure()
          presenter.handleError(Chat.Errors.invoiceRequestError)
          return
      }
      
      walletService.requestInvoiceFor(post: post,
                                      commerce: commerceInfo,
                                      user: postAuthor) { [weak self] in
                                        guard let strongSelf = self else {
                                          return
                                        }
                                        
                                        switch $0 {
                                        case .success(let invoice):
                                          strongSelf.requestedInvoice = invoice
                                          strongSelf.presenter.presentRoomRelatedPost(room, currentUser: strongSelf.currentUser)
                                          strongSelf.presenter.presentInvoiceRequestSuccess(invoice)
                                        case .failure(let error):
                                          strongSelf.presenter.presentInvoiceRequestFailure()
                                          strongSelf.presenter.handleError(error)
                                        }
      }
    case .goods:
      guard let goodsInfo = post.goodsInfo else {
        presenter.presentInvoiceRequestFailure()
        presenter.handleError(Chat.Errors.invoiceRequestError)
        return
      }
      
      presenter.presentOrderConfirmationRequestFor(goodsInfo)
    }
    
    
  }
}
