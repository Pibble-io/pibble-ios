//
//  ChatPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

// MARK: - ChatPresenter Class
final class ChatPresenter: Presenter {
  static let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEE, MMM d"
    return formatter
  }()
  
  fileprivate var currentSelectedItemIndexPath: IndexPath?
  fileprivate var shouldPresentSuccessfulDownload = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewController.setNavigationBarViewModel(Chat.NavigationBarViewModel.empty())
    interactor.initialFetchData()
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
    viewController.scrollToBottom(animated: true)
    interactor.subscribeWebSocketUpdates()
  }
  
  override func viewWillDisappear() {
    super.viewWillDisappear()
    interactor.performMarkMessagesAsRead()
    interactor.unsubscribeWebSocketUpdates()
  }
}

// MARK: - ChatPresenter API
extension ChatPresenter: ChatPresenterApi {
  func handleReturnGoodsApprovalAction() {
    interactor.approveGoodsOrderReturn()
  }
  
  func handleReturnGoodsRequestAction() {
    interactor.requestGoodsOrderReturn()
  }
  
  func handleConfirmGoodsAction() {
    interactor.confirmGoodsOrder()
  }
  
  func handleAdditionalAction() {
    guard let room = interactor.currentRoom,
      let post = room.relatedPost,
      let currentUser = interactor.currentUser
    else {
      return
    }
    
    let isBuyer = post.postingUser?.identifier != currentUser.identifier
    
    switch post.postingType {
    case .media:
      return
    case .funding, .charity, .crowdfundingWithReward:
      return
    case .commercial:
      return
    case .goods:
      guard let goodsOrder = room.lastGoodsOrder else {
        return
      }
      
      switch goodsOrder.orderStatus {
      case .waiting:
        if isBuyer {
          viewController.showGoodsBuyerAdditionalActionSheet()
        }
      case .returnRequested:
        if !isBuyer {
          viewController.showGoodsSellerAdditionalActionSheet()
        }
      case .returned:
        return
      case .confirmed:
        return
      case .unsupportedStatus:
        return
      }
    }
    
  }
  
  func presentPostMedia(_ post: PostingProtocol, media: MediaProtocol) {
    router.routeToMediaDetails(post, media: media)
  }
  
  func handleCancelCurrentInvoiceAction() {
    interactor.cancelCurrentPurchase()
  }
  
  func handleConfirmCurrentInvoiceAction() {
    router.routeToPinCodeUnlock(delegate: self)
  }
  
  func handleCancelCurrentOrderAction() {
    interactor.cancelCurrentPurchase()
  }
  
  func handleConfirmCurrentOrderAction() {
    router.routeToPinCodeUnlock(delegate: self)
  }
  
  func presentPurchaseFinishSuccessful() {
    viewController.presentPurchaseFinishSuccessAlert()
  }
  
  func presentRoomRelatedPost(_ chatRoom: ChatRoomProtocol?, currentUser: UserProtocol?) {
    guard let post = chatRoom?.relatedPost,
      let currentUser = currentUser
      else {
        viewController.setAdditionalButtonEnabled(false)
        viewController.setHeaderViewModel(nil)
        return
    }
    
    switch post.postingType {
    case .media, .funding, .charity, .crowdfundingWithReward:
      viewController.setAdditionalButtonEnabled(false)
      viewController.setHeaderViewModel(nil)
    case .commercial:
      let headerViewModel = Chat.DigitalGoodPostHeaderViewModel(post: chatRoom?.relatedPost,
                                                                commerce: chatRoom?.relatedPost?.commerceInfo,
                                                                currentUser: currentUser)
      viewController.setHeaderViewModel(headerViewModel)
      viewController.setAdditionalButtonEnabled(headerViewModel?.hasAdditionalActions ?? false)
    case .goods:
      let headerViewModel = Chat.GoodsPostHeaderViewModel(post: chatRoom?.relatedPost,
                                                          goodsInfo: chatRoom?.relatedPost?.goodsInfo,
                                                          currentUser: currentUser,
                                                          lastGoodsOrder: chatRoom?.lastGoodsOrder)
      viewController.setHeaderViewModel(headerViewModel)
      viewController.setAdditionalButtonEnabled(headerViewModel?.hasAdditionalActions ?? false)
    }
  }
  
  func presentInvoiceRequestFailure() {
    presentRoomRelatedPost(interactor.currentRoom,
                    currentUser: interactor.currentUser)
  }
  
  func handleHeaderAction(_ action: Chat.ChatHeaderActions) {
    switch action {
    case .download:
      shouldPresentSuccessfulDownload = true
      interactor.performDownloadChatRoomDigitalGood()
    case .buy:
      interactor.performPurchaseForRelatedCommercialPost()
    case .show(let mediaItemIndex):
      interactor.requestChatRoomDigitalGoodMediaItemAt(mediaItemIndex)
    }
  }
  
  func presentRoom(_ room: ChatRoomProtocol?, forCurrentUser: UserProtocol?) {
    let viewModel = Chat.NavigationBarViewModel(chatRoom: room, forCurrentUser: forCurrentUser)
    viewController.setNavigationBarViewModel(viewModel)
    
    guard let room = room,
      let forCurrentUser = forCurrentUser
    else {
        return
    }
    
    presentRoomRelatedPost(room, currentUser: forCurrentUser)
  }
  
  func handleCancelDownloadAction() {
    shouldPresentSuccessfulDownload = false
  }
  
  func presentDownloadStarted() {
    viewController.presentDownloadingStatusAlert()
  }
  
  func presentDownloadedDigitalGoodsFilesURLs(_ fileURLs: [URL]) {
    guard shouldPresentSuccessfulDownload else {
      return
    }
    
    viewController.hideDownloadingStatusAlert() { [weak self] in
      self?.router.routeToShareControlWith(fileURLs) {_,_ in  }
    }
  }

  func presentInvoiceRequestSuccess(_ invoice: PartialInvoiceProtocol) {
    let alertTitle = Chat.Strings.alertTitleForInvoice(invoice)
    viewController.showConfirmInvoiceAlert(alertTitle) 
  }
  
  func presentOrderConfirmationRequestFor(_ goodsInfo: GoodsProtocol) {
    let alertTitle = Chat.Strings.alertTitleForGoodsInfo(goodsInfo)
    viewController.showConfirmOrderAlert(alertTitle)
  }
  
  func handleBuyCurrentItemAction() {
    guard let indexPath = currentSelectedItemIndexPath else {
      return
    }
    
    interactor.performRequestInvoiceForItemAt(indexPath)
  }
  
  func handleReturnGoodsApprovalActionAt(_ indexPath: IndexPath) {
    interactor.approveGoodsOrderReturnAt(indexPath)
  }
  
  func handleSystemMessageActionAt(_ indexPath: IndexPath, action: Chat.SystemMessageAction) {
    switch action {
    case .approveReturn:
      interactor.approveGoodsOrderReturnAt(indexPath)
    }
  }
  
  func handleMessageActionAt(_ indexPath: IndexPath, action: Chat.MessageActions) {
    switch action {
    case .download:
      shouldPresentSuccessfulDownload = true
      interactor.performDownloadItemAt(indexPath)
    case .buy:
      currentSelectedItemIndexPath = indexPath
      viewController.showBuyItemActionSheet()
    }
  }
  
  func presentReload() {
    viewController.reloadData()
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> Chat.ChatMessageViewModelType {
    return Chat.ChatMessageViewModelType(message: interactor.itemAt(indexPath),
                                         currentUser: interactor.currentUser, room: interactor.currentRoom)

  }
  
  func handleShowUserActionAt(_ indexPath: IndexPath) {
//    let item = interactor.itemAt(indexPath)
//    guard let user = item.commentUser else {
//      return
//    }
//
//    router.routeToUserProfileFor(user)
  }
  
//  func handleUpvoteActionAt(_ indexPath: IndexPath) {
//    upVoteIndexPath = indexPath
//    router.routeToUpVote(delegate: self)
//  }
//
//  func handleSelectReplyActionAt(_ indexPath: IndexPath) {
//    interactor.changeSelectedReplyStateForItemAt(indexPath)
//    guard interactor.isSelectedReplyItemAt(indexPath) else {
//      viewController.cleanUpCommentInputField()
//      return
//    }
//
//    let item = interactor.itemAt(indexPath)
//    viewController.setBeginEditingAndScrollTo(indexPath)
//    guard let user = item.commentUser else {
//      return
//    }
//
//    viewController.setCommentInputText("@\(user.username) ")
//  }
  
  func handleMessageDraftTextChanged(_ text: String) {
    interactor.setDraftMessageText(text)
  }
  
  func presentCleanedDraftMessageText(_ text: String) {
    viewController.setCommentInputText(text)
  }
  
  func presentMesssageSendSuccess() {
    viewController.cleanUpMessageInputField()
  }
  
  func handleSendMessageAction(_ text: String) {
    interactor.createMessageWith(text)
  }
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate) {
    viewController.updateCollection(updates)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func titleForSection(_ section: Int) -> String? {
    let indexPath = IndexPath(item: 0, section: section)
    guard let date = interactor.sectionDataFor(indexPath) else {
      return nil
    }
    
    return ChatPresenter.dateFormatter.string(from: date)
  }
  
  func numberOfSections() -> Int {
    return interactor.numberOfSections()
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return interactor.numberOfItemsInSection(section)
  }
  
  func handleWillDisplayItem(_ indexPath: IndexPath) {
    interactor.prepareItemFor(indexPath)
  }
  
  func handleDidEndDisplayItem(_ indexPath: IndexPath) {
    interactor.cancelPrepareItemFor(indexPath)
  }
}

extension ChatPresenter: WalletPinCodeUnlockDelegateProtocol {
  func walletDidUnlockWith(_ pinCode: String) {
    interactor.confirmCurrentPurchase()
  }
  
  func walletDidFailToUnlock() {
    interactor.cancelCurrentPurchase()
  }
}

// MARK: - Chat Viper Components
fileprivate extension ChatPresenter {
  var viewController: ChatViewControllerApi {
    return _viewController as! ChatViewControllerApi
  }
  var interactor: ChatInteractorApi {
    return _interactor as! ChatInteractorApi
  }
  var router: ChatRouterApi {
    return _router as! ChatRouterApi
  }
}
 
 
