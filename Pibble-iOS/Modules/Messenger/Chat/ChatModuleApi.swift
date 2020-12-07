//
//  ChatModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//
import UIKit

//MARK: - ChatRouter API
protocol ChatRouterApi: RouterProtocol {
  func routeToUserProfileFor(_ user: UserProtocol)
  func routeToWallet()
  func routeToShareControlWith(_ urls: [URL], completion: @escaping ((UIActivity.ActivityType?, Bool) -> Void))
  func routeToPinCodeUnlock(delegate: WalletPinCodeUnlockDelegateProtocol)
  func routeToMediaDetails(_ post: PostingProtocol, media: MediaProtocol)
}

//MARK: - ChatView API
protocol ChatViewControllerApi: ViewControllerProtocol {
  func updateCollection(_ updates: CollectionViewModelUpdate)
  func reloadData()
  
  func cleanUpMessageInputField()
  func setCommentInputText(_ text: String)
  func scrollToBottom(animated: Bool)
  
  func showBuyItemActionSheet()
  
  func presentDownloadingStatusAlert()
  func hideDownloadingStatusAlert(_ complete: @escaping (() -> Void))
  
  func setHeaderViewModel(_ vm: ChatDigitalGoodPostHeaderViewModelProtocol?)
  
  func showConfirmInvoiceAlert(_ title: String)
  func showConfirmOrderAlert(_ title: String)
  
  func presentPurchaseFinishSuccessAlert()
  
  func setNavigationBarViewModel(_ vm: ChatNavigationBarViewModelProtocol)
  
  func setAdditionalButtonEnabled(_ enabled: Bool)
  
  func showGoodsBuyerAdditionalActionSheet()
  
  func showGoodsSellerAdditionalActionSheet()
  
  
//  func showDeleteAlert()
}

//MARK: - ChatPresenter API
protocol ChatPresenterApi: PresenterProtocol {
  func handleHideAction()
  
  func handleShowUserActionAt(_ indexPath: IndexPath)
  
  func handleWillDisplayItem(_ indexPath: IndexPath)
  func handleDidEndDisplayItem(_ indexPath: IndexPath)
  
  func handleMessageDraftTextChanged(_ text: String)
  func handleSendMessageAction(_ text: String)
  
  func handleMessageActionAt(_ indexPath: IndexPath, action: Chat.MessageActions)
  
  func handleSystemMessageActionAt(_ indexPath: IndexPath, action: Chat.SystemMessageAction)
  
  
  func handleHeaderAction(_ action: Chat.ChatHeaderActions)
  
  func handleBuyCurrentItemAction()
  
  func handleCancelDownloadAction()
  
  func handleCancelCurrentInvoiceAction()
  func handleConfirmCurrentInvoiceAction()
  
  func handleCancelCurrentOrderAction()
  func handleConfirmCurrentOrderAction()
  
  func handleAdditionalAction()
  
  func handleReturnGoodsApprovalActionAt(_ indexPath: IndexPath)
  func handleReturnGoodsApprovalAction()
  func handleReturnGoodsRequestAction()
  func handleConfirmGoodsAction()
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> Chat.ChatMessageViewModelType
  func titleForSection(_ section: Int) -> String? 
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate)
  func presentReload()
  func presentMesssageSendSuccess()
  func presentCleanedDraftMessageText(_ text: String)
  
  func presentInvoiceRequestSuccess(_ invoice: PartialInvoiceProtocol)
  func presentInvoiceRequestFailure()
  
  func presentPurchaseFinishSuccessful()
  
  func presentOrderConfirmationRequestFor(_ goodsInfo: GoodsProtocol)
  
  func presentDownloadedDigitalGoodsFilesURLs(_ fileURLs: [URL])
  func presentDownloadStarted()
  
  func presentRoom(_ room: ChatRoomProtocol?, forCurrentUser: UserProtocol?)
  func presentRoomRelatedPost(_ chatRoom: ChatRoomProtocol?, currentUser: UserProtocol?)
  
  func presentPostMedia(_ post: PostingProtocol, media: MediaProtocol)
  
  
  
//  func handleSelectReplyActionAt(_ indexPath: IndexPath)
//  func handleUpvoteActionAt(_ indexPath: IndexPath)
 
  
//  func handleDeleteItemActionAt(_ indexPath: IndexPath)
//  func handleDeleteCurrentItemAction()
}

//MARK: - ChatInteractor API
protocol ChatInteractorApi: InteractorProtocol {
  var currentUser: UserProtocol? { get }
  var currentRoom: ChatRoomProtocol? { get }
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemAt(_ indexPath: IndexPath) -> ChatMessageEntity?
  
  func sectionDataFor(_ indexPath: IndexPath) -> Date?

  func prepareItemFor(_ indexPath: IndexPath)
  func cancelPrepareItemFor(_ indexPath: IndexPath)
  
  func initialFetchData()
  
  func createMessageWith(_ text: String)
  func setDraftMessageText(_ text: String)
  
  func performDeleteItemAt(_ indexPath: IndexPath)
  
  func approveGoodsOrderReturnAt(_ indexPath: IndexPath)
  
  func performDownloadItemAt(_ indexPath: IndexPath)
  func performPurchaseForRelatedCommercialPost()
  
  func performRequestInvoiceForItemAt(_ indexPath: IndexPath)
  func performDownloadChatRoomDigitalGood()
  
  func requestChatRoomDigitalGoodMediaItemAt(_ mediaItemIndex: Int)
  
  func cancelCurrentPurchase()
  func confirmCurrentPurchase()
  
  func performMarkMessagesAsRead()
  
  func subscribeWebSocketUpdates()
  func unsubscribeWebSocketUpdates()
  
  func confirmGoodsOrder()
  func requestGoodsOrderReturn()
  func approveGoodsOrderReturn()
}

protocol ChatTextMessageViewModelProtocol { 
  var messageText: String { get }
  var date: String { get }
  var userpicUrlString: String { get }
  var userpicPlaceholder: UIImage? { get }
}


protocol ChatStatusMessageViewModelProtocol {
  var messageText: String { get }
  var date: String { get }
  
  var actionState: Chat.SystemMessageActionState { get }
  
  var actionTitle: String { get }
  
  var messageTextColor: UIColor { get }
}

protocol ChatDigitalGoodPostMessageViewModelProtocol {
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemAt(_ indexPath: IndexPath) -> Chat.DigitalGoodPostMessageViewModelType
}

protocol ChatDigitalGoodPostHeaderViewModelProtocol {
  var isHighligthed: Bool { get }
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemAt(_ indexPath: IndexPath) -> Chat.CommercialPostHeaderViewModelType
  
  var hasAdditionalActions: Bool { get }
}

protocol ChatDigitalGoodPostMessageInvoiceStatusViewModelProtocol {
  var userpicUrlString: String { get }
  var userpicPlaceholder: UIImage? { get }
  
  var checkoutStatus: String { get }
  var checkoutStatusDescription: String { get }
}

protocol ChatDigitalGoodPostMessageDescriptionViewModelProtocol {
  var userpicUrlString: String { get }
  var userpicPlaceholder: UIImage? { get }
  
  var date: String { get }
  
  var checkoutStatus: String { get }
  var checkoutStatusDescription: String { get }
  
  var itemTitleLabel: String { get }
  var price: String { get }
  var reward: String { get }
  var rewardCurrency: String { get }
  var rewardCurrencyColor: UIColor { get }
  
  var mediaItemsViewModel: [ChatDigitalGoodPostMessageDescriptionMediaItemViewModelProtocol] { get }
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> ChatDigitalGoodPostMessageDescriptionMediaItemViewModelProtocol
}

protocol ChatDigitalGoodPostHeaderDescriptionViewModelProtocol {
  var userpicUrlString: String { get }
  var userpicPlaceholder: UIImage? { get }
  
  var checkoutStatus: String { get }
  var checkoutStatusDescription: String { get }
  
  var itemTitleLabel: String { get }
  var price: String { get }
  var reward: String { get }
  var rewardCurrency: String { get }
  var rewardCurrencyColor: UIColor { get }
  
  var mediaItemsViewModel: [ChatDigitalGoodPostHeaderDescriptionMediaItemViewModelProtocol] { get }
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> ChatDigitalGoodPostHeaderDescriptionMediaItemViewModelProtocol
}

protocol ChatGoodsPostHeaderDescriptionViewModelProtocol {
  var itemTitleLabel: String { get }
  var price: String { get }
  var urlString: String { get }
  
  var mediaItemsViewModel: [ChatGoodsPostHeaderDescriptionMediaItemViewModelProtocol] { get }
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> ChatGoodsPostHeaderDescriptionMediaItemViewModelProtocol
}

protocol ChatDigitalGoodPostHeaderActionViewModelProtocol {
  var title: String { get }
  var disabledTitle: String { get }
  
  var hasDisabledState: Bool { get }
  var hasEnabledState: Bool { get }
}

protocol ChatDigitalGoodPostMessageDescriptionMediaItemViewModelProtocol {
  var itemImageViewURLString: String { get }
  var resolution: String { get }
  var dpi: String { get }
  var format: String { get }
  var size: String { get }
  
  var originalMediaWidth: CGFloat { get }
  var originalMediaHeight: CGFloat { get }
}

protocol ChatDigitalGoodPostHeaderDescriptionMediaItemViewModelProtocol {
  var itemImageViewURLString: String { get }
  var resolution: String { get }
  var dpi: String { get }
  var format: String { get }
  var size: String { get }
  
  var originalMediaWidth: CGFloat { get }
  var originalMediaHeight: CGFloat { get }
}

protocol ChatGoodsPostHeaderDescriptionMediaItemViewModelProtocol {
  var itemImageViewURLString: String { get }
  
  var originalMediaWidth: CGFloat { get }
  var originalMediaHeight: CGFloat { get }
}

protocol ChatNavigationBarViewModelProtocol {
  var userpicUrlString: String { get }
  var userpicPlaceholder: UIImage? { get }
  
  var title: String { get }
  var subtitle: String { get }
}
