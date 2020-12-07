//
//  ChatModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum Chat {
  typealias MessageActionHandler = (UITableViewCell, Chat.MessageActions) -> Void
  
  typealias SystemMessageActionHandler = (UITableViewCell, SystemMessageAction) -> Void
  
  typealias HeaderDescriptionActionHandler = (UITableViewCell, HeaderDescriptionActions) -> Void
  
  
  typealias HeaderItemActionHandler = (UITableViewCell) -> Void
  typealias HeaderActionHandler = (UIView, Chat.ChatHeaderActions) -> Void
  
  enum SystemMessageActionState {
    case waiting
    case available(SystemMessageAction)
    case done
    case none
  }
  
  enum Errors: PibbleErrorProtocol {
    case invoiceRequestError
    case digitalGoodDownloadError
    case digitalGoodShowError
    case roomForPostIsNotFound
    
    var description: String {
      switch self {
      case .invoiceRequestError:
        return Strings.Errors.invoiceRequestError.localize()
      case .digitalGoodDownloadError:
        return Strings.Errors.digitalGoodDownloadError.localize()
      case .roomForPostIsNotFound:
        return Strings.Errors.roomForPostIsNotFound.localize()
      case .digitalGoodShowError:
        return Strings.Errors.digitalGoodShowError.localize()
      }
    }
  }
  
  enum RoomType {
    case roomForUser([UserProtocol])
    case roomForPost(PostingProtocol)
    case existingRoom(ChatRoomProtocol)
  }
  
  enum MessageActions {
    case download
    case buy
  }
  
  enum ChatHeaderActions {
    case download
    case buy
    case show(mediaItemIndex: Int)
  }
  
  enum SystemMessageAction {
    case approveReturn
  }
  
  enum HeaderDescriptionActions {
    case selectedMediItemAt(index: Int)
  }
  
  enum ChatMessageViewModelType {
    case incomingTextMessage(ChatTextMessageViewModelProtocol)
    case outcomingTextMessage(ChatTextMessageViewModelProtocol)
    case paymentMessage(ChatStatusMessageViewModelProtocol)
    case digitalGoodPostMessage(ChatDigitalGoodPostMessageViewModelProtocol)
    case loadingPlaceholder
    case unsupportedMessageType(ChatStatusMessageViewModelProtocol)
    
    init(message: ChatMessageEntity?, currentUser: UserProtocol?, room: ChatRoomProtocol?) {
      guard let currentUser = currentUser,
        let message = message
        else {
          self = .loadingPlaceholder
          return
      }
      
      switch message {
      case .text(let textMessage):
        let messageViewModel = Chat.TextMessageViewModel(message: textMessage)
        self = textMessage.isIncomingMessageToUser(currentUser) ?
          .incomingTextMessage(messageViewModel) :
          .outcomingTextMessage(messageViewModel)
      case .system(let systemMessage):
        let messageViewModel = Chat.SystemMessageViewModel(message: systemMessage, chatRoom: room)
        self = .paymentMessage(messageViewModel)
      case .post(let postMessage):
        //we won't support post messages in this version
        self = .unsupportedMessageType(UnsupportedMessageTypeMessageViewModel())
        return
        
        guard let post = postMessage.quotedPost else {
          self = .unsupportedMessageType(UnsupportedMessageTypeMessageViewModel())
          return
        }
        
        switch post.postingType {
        case .media, .goods:
          self = .unsupportedMessageType(UnsupportedMessageTypeMessageViewModel())
        case .funding, .charity, .crowdfundingWithReward:
          self = .unsupportedMessageType(UnsupportedMessageTypeMessageViewModel())
        case .commercial:
          guard let commerce = post.commerceInfo else {
            self = .unsupportedMessageType(UnsupportedMessageTypeMessageViewModel())
            return
          }
          
          self = .digitalGoodPostMessage(DigitalGoodPostMessageViewModel(message: postMessage,
                                                                         post: post,
                                                                         commerce: commerce,
                                                                         currentUser: currentUser))
        }
      }
    }
  }
  
  enum DigitalGoodPostMessageViewModelType {
    case invoiceStatus(ChatDigitalGoodPostMessageInvoiceStatusViewModelProtocol)
    case description(ChatDigitalGoodPostMessageDescriptionViewModelProtocol)
    case downloadAction
  }
  
  enum CommercialPostHeaderViewModelType {
    case digitalGoodDescription(ChatDigitalGoodPostHeaderDescriptionViewModelProtocol)
    case downloadAction(ChatDigitalGoodPostHeaderActionViewModelProtocol)
    case buyAction(ChatDigitalGoodPostHeaderActionViewModelProtocol)
    case showAction(ChatDigitalGoodPostHeaderActionViewModelProtocol)
    case purchaseStatus(ChatDigitalGoodPostHeaderActionViewModelProtocol)
    
    case goodsDescription(ChatGoodsPostHeaderDescriptionViewModelProtocol)
  }
  
  struct UnsupportedMessageTypeMessageViewModel: ChatStatusMessageViewModelProtocol {
    var messageTextColor: UIColor = UIColor.gray67
    
    var actionState: Chat.SystemMessageActionState = .none
    var actionTitle: String = ""
    
    var messageText: String = Chat.Strings.Messages.unsupportedMessageType.localize()
    var date: String = ""
  }
  
  struct NavigationBarViewModel: ChatNavigationBarViewModelProtocol {
    let title: String
    let subtitle: String
    let userpicUrlString: String
    let userpicPlaceholder: UIImage?
    
    init(title: String, subtitle: String, userpicUrlString: String, userpicPlaceholder: UIImage?) {
      self.title = title
      self.subtitle = subtitle
      self.userpicUrlString = userpicUrlString
      self.userpicPlaceholder = userpicPlaceholder
    }
    
    static func empty() -> NavigationBarViewModel {
      return NavigationBarViewModel(title: "",
                                    subtitle: "",
                                    userpicUrlString: "",
                                    userpicPlaceholder: nil)
    }
      
    
    static func commerceRoomViewModel(_ post: PostingProtocol, commerceInfo: CommerceInfoProtocol) -> NavigationBarViewModel {
      let title = commerceInfo.commerceItemTitle.capitalized
      
      let price = "\(commerceInfo.commerceItemPrice) \(commerceInfo.commerceItemCurrency.symbol)"
      
      let rewardAmount = commerceInfo.commerceReward * Double(commerceInfo.commerceItemPrice)
      let reward = String(format:"%.2f", rewardAmount)
      let rewardCurrency = "\(commerceInfo.commerceItemCurrency.symbol)"
      
      let priceTitle = "\(Chat.Strings.ChatNavigationBar.price): \(price)"
      let rewardTitle = "\(Chat.Strings.ChatNavigationBar.reward): \(reward) \(rewardCurrency)"
      
    
      let subtitle = "\(priceTitle) \(rewardTitle)"
      let userpicUrlString = post.postingMedia.first?.thumbnailUrl ?? ""
      let userpicPlaceholder = UIImage.avatarImageForTitleString(commerceInfo.commerceItemTitle)
      
      return NavigationBarViewModel(title: title,
                                        subtitle: subtitle,
                                        userpicUrlString: userpicUrlString,
                                        userpicPlaceholder: userpicPlaceholder)
      
    }
    
    static func plainRoomViewModel(_ chatRoom: ChatRoomProtocol, forCurrentUser: UserProtocol?) -> NavigationBarViewModel {
      
      let title: String
      let subtitle: String
      let userpicUrlString: String
      let userpicPlaceholder: UIImage?
      
      guard let forCurrentUser = forCurrentUser else {
        title = ""
        subtitle = ""
        userpicUrlString = ""
        userpicPlaceholder = nil
        return NavigationBarViewModel(title: title,
                                          subtitle: subtitle,
                                          userpicUrlString: userpicUrlString,
                                          userpicPlaceholder: userpicPlaceholder)
        
      }
      
      var firstUser: UserProtocol? = nil
      var roomUsersTitleString = ""
      chatRoom.chatRoomUsers
        .compactMap { $0.relatedUser }
        .forEach {
        if $0.identifier != forCurrentUser.identifier {
          let username = $0.userName.capitalized
          let usernameString = roomUsersTitleString.count == 0 ? username : ", \(username)"
          
          roomUsersTitleString.append(usernameString)
          
          if firstUser == nil {
            firstUser = $0
          }
        }
      }
      
      title = roomUsersTitleString
      subtitle = ""
      if let user = firstUser {
        userpicUrlString = user.userpicUrlString
        userpicPlaceholder = UIImage.avatarImageForNameString(user.userName)
      } else {
        userpicUrlString = ""
        userpicPlaceholder = nil
      }
      
      return NavigationBarViewModel(title: title,
                                        subtitle: subtitle,
                                        userpicUrlString: userpicUrlString,
                                        userpicPlaceholder: userpicPlaceholder)
    }
    
    
    init(chatRoom: ChatRoomProtocol?, forCurrentUser: UserProtocol?) {
      guard let room = chatRoom else {
        title = ""
        subtitle = ""
        userpicUrlString = ""
        userpicPlaceholder = nil
        return
      }
      
      switch room.roomType {
      case .plain:
        self = NavigationBarViewModel.plainRoomViewModel(room, forCurrentUser: forCurrentUser)
      case .commercial:
        self = NavigationBarViewModel.plainRoomViewModel(room, forCurrentUser: forCurrentUser)
//        guard let post = room.relatedPost,
//          let commercialInfo = post.commerceInfo
//        else {
//          self = NavigationBarViewModel.plainRoomViewModel(room, forCurrentUser: forCurrentUser)
//          return
//        }
//
//        self = NavigationBarViewModel.commerceRoomViewModel(post, commerceInfo: commercialInfo)
      }
    }
  }
  
  struct SystemMessageViewModel: ChatStatusMessageViewModelProtocol {
    fileprivate static let dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "h:mma"
      formatter.amSymbol = "am"
      formatter.pmSymbol = "pm"
      return formatter
    }()
    
    let actionState: Chat.SystemMessageActionState
    
    let actionTitle: String
    let messageTextColor: UIColor
    
    let messageText: String
    let date: String
    
    init(message: ChatSystemMessageProtocol, chatRoom: ChatRoomProtocol?) {
      messageText = message.messageText
     
      if let createdAt = message.messageCreatedAt.toDateWithCommonFormat() {
        date = SystemMessageViewModel.dateFormatter.string(from: createdAt)
      } else {
        date = ""
      }
      
      let isCurrentUserPostAuthor = chatRoom?.relatedPost?.isMyPosting
      
      guard let isCurrentUserPostOwner = isCurrentUserPostAuthor else {
        actionTitle = ""
        actionState = .none
        messageTextColor = UIColor.gray67
        return
      }
      
      switch message.chatSystemMessageType {
      case .text:
        actionTitle = ""
        actionState = .none
        messageTextColor = UIColor.gray67
      case .goodsReturnRequest:
        guard let order = message.relatedGoodsOrder else {
          actionTitle = ""
          actionState = .none
          messageTextColor = UIColor.gray67
          return
        }
        
        switch order.orderStatus {
        case .waiting:
          actionTitle = Chat.Strings.DigitalGoodPostHeaderActionsTitle.pendingBuyerApproval.localize()
          actionState = .waiting
          messageTextColor = UIColor.gray67
        case .returnRequested:
          actionTitle = isCurrentUserPostOwner ?
            Chat.Strings.DigitalGoodPostHeaderActionsTitle.approveReturn.localize() :
            Chat.Strings.DigitalGoodPostHeaderActionsTitle.pendingSellerApproval.localize()
          actionState = isCurrentUserPostOwner ? .available(.approveReturn) : .waiting
          messageTextColor = UIColor.red
        case .returned:
          actionTitle = Chat.Strings.DigitalGoodPostHeaderActionsTitle.returnApproved.localize()
          actionState = .done
          messageTextColor = UIColor.gray67
        case .confirmed:
          actionTitle = Chat.Strings.DigitalGoodPostHeaderActionsTitle.returnApproved.localize()
          actionState = .done
          messageTextColor = UIColor.gray67
        case .unsupportedStatus:
          actionTitle = ""
          actionState = .none
          messageTextColor = UIColor.gray67
        }
      }
    }
    
//    init(message: ChatSystemMessageProtocol) {
//      messageText = message.messageText
//      actionTitle = ""
//      actionState = .none
//      if let createdAt = message.messageCreatedAt.toDateWithCommonFormat() {
//        date = SystemMessageViewModel.dateFormatter.string(from: createdAt)
//      } else {
//        date = ""
//      }
//    }
    
    /*
    init(message: ChatTextMessageProtocol) {
      messageText = message.messageText
      actionTitle = ""
      actionState = .none
      
      if let createdAt = message.messageCreatedAt.toDateWithCommonFormat() {
        date = SystemMessageViewModel.dateFormatter.string(from: createdAt)
      } else {
        date = ""
      }
    }*/
  }
  
  struct TextMessageViewModel: ChatTextMessageViewModelProtocol {
    fileprivate static let dateFormatter: DateFormatter = {
      let formatter = DateFormatter()
      formatter.dateFormat = "h:mma"
      formatter.amSymbol = "am"
      formatter.pmSymbol = "pm"
      return formatter
    }()
    
    let messageText: String
    let date: String
    let userpicUrlString: String
    let userpicPlaceholder: UIImage?
    
    init(message: ChatTextMessageProtocol) {
      messageText = message.messageText
      if let user = message.messageFromUser {
        userpicUrlString = user.userpicUrlString
        userpicPlaceholder = UIImage.avatarImageForNameString(user.userName)
      } else {
        userpicUrlString = ""
        userpicPlaceholder = nil
      }
      
      if let createdAt = message.messageCreatedAt.toDateWithCommonFormat() {
        date = TextMessageViewModel.dateFormatter.string(from: createdAt)
      } else {
        date = ""
      }
    }
  }
  
  struct PostMessageContentMediaItemDescriptionViewModel: ChatDigitalGoodPostMessageDescriptionMediaItemViewModelProtocol {
    
    let itemImageViewURLString: String
    let resolution: String
    let dpi: String
    let format: String
    let size: String
    
    let originalMediaWidth: CGFloat
    let originalMediaHeight: CGFloat
    
    init(media: MediaProtocol) {
      let width = String(format:"%.0f", media.contentOriginalWidth)
      let height = String(format:"%.0f", media.contentOriginalHeight)
      
      itemImageViewURLString = media.mediaUrl
      resolution = "\(width) x \(height) pixel"
      
      let printWidth = String(format:"%.1f", media.printWidth)
      let printHeight = String(format:"%.1f", media.printHeight)
      let printSizeDPI = String(format:"%.0f", media.printSizeDPI)
      dpi = "\(printSizeDPI) dpi (\(printWidth)cm x \(printHeight)cm)"
      
      format = media.contentFileExtension.uppercased()
      size = "-"
      
      originalMediaWidth = CGFloat(media.contentWidth)
      originalMediaHeight = CGFloat(media.contentHeight)
    }
  }
  
  struct DigitalGoodPostHeaderDescriptionMediaItemViewModel: ChatDigitalGoodPostHeaderDescriptionMediaItemViewModelProtocol {
    
    let itemImageViewURLString: String
    let resolution: String
    let dpi: String
    let format: String
    let size: String
    
    let originalMediaWidth: CGFloat
    let originalMediaHeight: CGFloat
    
    init(media: MediaProtocol) {
      let width = String(format:"%.0f", media.contentOriginalWidth)
      let height = String(format:"%.0f", media.contentOriginalHeight)
      
      itemImageViewURLString = media.mediaUrl
      resolution = "\(width) x \(height) pixel"
      
      let printWidth = String(format:"%.1f", media.printWidth)
      let printHeight = String(format:"%.1f", media.printHeight)
      let printSizeDPI = String(format:"%.0f", media.printSizeDPI)
      dpi = "\(printSizeDPI) dpi (\(printWidth)cm x \(printHeight)cm)"
      
      format = media.contentFileExtension.uppercased()
      size = "-"
      
      originalMediaWidth = CGFloat(media.contentWidth)
      originalMediaHeight = CGFloat(media.contentHeight)
    }
  }
  
  struct GoodsPostHeaderDescriptionMediaItemViewModel: ChatGoodsPostHeaderDescriptionMediaItemViewModelProtocol {
    let itemImageViewURLString: String
    let originalMediaWidth: CGFloat
    let originalMediaHeight: CGFloat
    
    init(media: MediaProtocol) {
      let width = String(format:"%.0f", media.contentOriginalWidth)
      let height = String(format:"%.0f", media.contentOriginalHeight)
      
      itemImageViewURLString = media.mediaUrl
      
      originalMediaWidth = CGFloat(media.contentWidth)
      originalMediaHeight = CGFloat(media.contentHeight)
    }
  }
  
  struct DigitalGoodPostMessageDescriptionViewModelProtocol: ChatDigitalGoodPostMessageDescriptionViewModelProtocol {
    let userpicUrlString: String
    let userpicPlaceholder: UIImage?
    let date: String
    let checkoutStatus: String
    let checkoutStatusDescription: String
    
    let itemTitleLabel: String
    let price: String
    
    let reward: String
    let rewardCurrency: String
    let rewardCurrencyColor: UIColor
    
    var mediaItemsViewModel: [ChatDigitalGoodPostMessageDescriptionMediaItemViewModelProtocol]
    
    init(message: ChatMessageProtocol, post: PostingProtocol, commerceInfo: CommerceInfoProtocol) {
      userpicUrlString = post.postingUser?.userpicUrlString ?? ""
      if let username = post.postingUser?.userName {
        userpicPlaceholder = UIImage.avatarImageForNameString(username)
      } else {
        userpicPlaceholder = nil
      }
      
      date = message.messageCreatedAt.toDateWithCommonFormat()?.timeAgoSinceNow(useNumericDates: true) ?? ""
      
      checkoutStatus = "checkoutStatus"
      checkoutStatusDescription = "checkoutStatusDescription"
      
      itemTitleLabel = commerceInfo.commerceItemTitle
      price = "\(commerceInfo.commerceItemPrice) \(commerceInfo.commerceItemCurrency.symbol)"
      
      let rewardAmount = commerceInfo.commerceReward * Double(commerceInfo.commerceItemPrice)
      reward = String(format:"%.2f", rewardAmount)
      rewardCurrency = "\(commerceInfo.commerceItemCurrency.symbol)"
      rewardCurrencyColor = commerceInfo.commerceItemCurrency.colorForCurrency
      
      mediaItemsViewModel = post.postingMedia.map { PostMessageContentMediaItemDescriptionViewModel(media: $0)}
      
    }
    
    func numberOfSections() -> Int {
      return 1
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
      return mediaItemsViewModel.count
    }
    
    func itemViewModelAt(_ indexPath: IndexPath) -> ChatDigitalGoodPostMessageDescriptionMediaItemViewModelProtocol {
      return mediaItemsViewModel[indexPath.item]
    }
  }
  
  struct GoodsPostHeaderDescriptionViewModel: ChatGoodsPostHeaderDescriptionViewModelProtocol {
    let itemTitleLabel: String
    
    let price: String
    let urlString: String
    let mediaItemsViewModel: [ChatGoodsPostHeaderDescriptionMediaItemViewModelProtocol]
    
    func numberOfSections() -> Int {
      return 1
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
      return mediaItemsViewModel.count
    }
    
    func itemViewModelAt(_ indexPath: IndexPath) -> ChatGoodsPostHeaderDescriptionMediaItemViewModelProtocol {
      return mediaItemsViewModel[indexPath.item]
    }
    
    init(post: PostingProtocol, goodsInfo: GoodsProtocol) {
      itemTitleLabel = goodsInfo.goodsTitle
      let priceString = String(format:"%.0f", goodsInfo.goodsPrice)
      price = "\(priceString) \(goodsInfo.itemCurrency.symbol)"
      urlString = goodsInfo.goodsUrlString
      
      mediaItemsViewModel = post.postingMedia.map { GoodsPostHeaderDescriptionMediaItemViewModel(media: $0)}
    }
  }
  
  struct DigitalGoodPostHeaderDescriptionViewModel: ChatDigitalGoodPostHeaderDescriptionViewModelProtocol {
    let userpicUrlString: String
    let userpicPlaceholder: UIImage?
    
    let checkoutStatus: String
    let checkoutStatusDescription: String
    
    let itemTitleLabel: String
    let price: String
    
    let reward: String
    let rewardCurrency: String
    let rewardCurrencyColor: UIColor
    
    var mediaItemsViewModel: [ChatDigitalGoodPostHeaderDescriptionMediaItemViewModelProtocol]
    
    init(post: PostingProtocol, commerceInfo: CommerceInfoProtocol) {
      userpicUrlString = post.postingUser?.userpicUrlString ?? ""
      if let username = post.postingUser?.userName {
        userpicPlaceholder = UIImage.avatarImageForNameString(username)
      } else {
        userpicPlaceholder = nil
      }
      
      
      checkoutStatus = "checkoutStatus"
      checkoutStatusDescription = "checkoutStatusDescription"
      
      itemTitleLabel = commerceInfo.commerceItemTitle.capitalized
      price = "\(commerceInfo.commerceItemPrice) \(commerceInfo.commerceItemCurrency.symbol)"
      
      let rewardAmount = commerceInfo.commerceReward * Double(commerceInfo.commerceItemPrice)
      reward = String(format:"%.2f", rewardAmount)
      rewardCurrency = "\(commerceInfo.commerceItemCurrency.symbol)"
      rewardCurrencyColor = commerceInfo.commerceItemCurrency.colorForCurrency
      
      mediaItemsViewModel = post.postingMedia.map { DigitalGoodPostHeaderDescriptionMediaItemViewModel(media: $0)}
    }
    
    func numberOfSections() -> Int {
      return 1
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
      return mediaItemsViewModel.count
    }
    
    func itemViewModelAt(_ indexPath: IndexPath) -> ChatDigitalGoodPostHeaderDescriptionMediaItemViewModelProtocol {
      return mediaItemsViewModel[indexPath.item]
    }
  }
  
  struct ChatDigitalGoodPostMessageInvoiceStatusViewModel: ChatDigitalGoodPostMessageInvoiceStatusViewModelProtocol {
    var userpicUrlString: String
    var userpicPlaceholder: UIImage?
    var checkoutStatus: String
    var checkoutStatusDescription: String
    
    init(invoice: InvoiceProtocol) {
      userpicUrlString = invoice.activityToUser?.userpicUrlString ?? ""
      if let username = invoice.activityToUser?.userName {
        userpicPlaceholder = UIImage.avatarImageForNameString(username)
      } else {
        userpicPlaceholder = nil
      }
      
      checkoutStatus = Chat.Strings.checkoutStatusFor(invoice.walletActivityStatus)
      checkoutStatusDescription = Chat.Strings.checkoutStatusDescriptionFor(invoice.walletActivityStatus)
    }
  }
  
  /*struct DigitalGoodPostHeaderViewModel: ChatDigitalGoodPostMessageViewModelProtocol {
   let viewModels: [[Chat.DigitalGoodPostMessageViewModelType]]
   
   init(post: PostingProtocol, commerce: CommerceInfoProtocol, currentUser: UserProtocol) {
   let invoicesToShow: [InvoiceProtocol]
   let messageActionsSection: [Chat.DigitalGoodPostMessageViewModelType]
   
   let descriptionVM = DigitalGoodPostMessageDescriptionViewModelProtocol(message: message,
   post: post,
   commerceInfo: commerce)
   let postViewModels: [Chat.DigitalGoodPostMessageViewModelType] = [.description(descriptionVM)]
   
   guard post.postingUser?.identifier != currentUser.identifier else {
   viewModels = [postViewModels]
   return
   }
   
   if let attachedInvoice = message.attachedInvoice {
   invoicesToShow = [attachedInvoice]
   messageActionsSection = attachedInvoice.walletActivityStatus == .accepted ? [.downloadAction] : []
   } else {
   messageActionsSection = []
   invoicesToShow = []
   }
   
   let invoicesViewModels = invoicesToShow
   .map { ChatDigitalGoodPostMessageInvoiceStatusViewModel(invoice: $0) }
   .map { DigitalGoodPostMessageViewModelType.invoiceStatus($0) }
   
   
   viewModels = [invoicesViewModels,
   postViewModels,
   messageActionsSection]
   }
   
   func numberOfSections() -> Int {
   return viewModels.count
   }
   
   func numberOfItemsInSection(_ section: Int) -> Int {
   return viewModels[section].count
   }
   
   func itemAt(_ indexPath: IndexPath) -> Chat.DigitalGoodPostMessageViewModelType {
   return viewModels[indexPath.section][indexPath.item]
   }
   }*/
  
  struct DigitalGoodPostMessageViewModel: ChatDigitalGoodPostMessageViewModelProtocol {
    let viewModels: [[Chat.DigitalGoodPostMessageViewModelType]]
    
    init(message: ChatPostMessageProtocol, post: PostingProtocol, commerce: CommerceInfoProtocol, currentUser: UserProtocol) {
      let invoicesToShow: [InvoiceProtocol]
      let messageActionsSection: [Chat.DigitalGoodPostMessageViewModelType]
      
      let descriptionVM = DigitalGoodPostMessageDescriptionViewModelProtocol(message: message, post: post,
                                                                             commerceInfo: commerce)
      let postViewModels: [Chat.DigitalGoodPostMessageViewModelType] = [.description(descriptionVM)]
      
      guard post.postingUser?.identifier != currentUser.identifier else {
        viewModels = [postViewModels]
        return
      }
      
      if let attachedInvoice = message.attachedInvoice {
        invoicesToShow = [attachedInvoice]
        messageActionsSection = attachedInvoice.walletActivityStatus == .accepted ? [.downloadAction] : []
      } else {
        messageActionsSection = []
        invoicesToShow = []
      }
      
      let invoicesViewModels = invoicesToShow
        .map { ChatDigitalGoodPostMessageInvoiceStatusViewModel(invoice: $0) }
        .map { DigitalGoodPostMessageViewModelType.invoiceStatus($0) }
      
      
      viewModels = [invoicesViewModels,
                    postViewModels,
                    messageActionsSection]
    }
    
    func numberOfSections() -> Int {
      return viewModels.count
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
      return viewModels[section].count
    }
    
    func itemAt(_ indexPath: IndexPath) -> Chat.DigitalGoodPostMessageViewModelType {
      return viewModels[indexPath.section][indexPath.item]
    }
  }
  
  enum DigitalGoodPostHeaderActionViewModel: ChatDigitalGoodPostHeaderActionViewModelProtocol {
    case download
    case buy
    case show
    
    case pendingBuyerApproval
    case pendingSellerApproval
    
    case confirmed
    
    case booked
    case soldOut
    
    var title: String {
      switch self {
      case .download:
        return Chat.Strings.DigitalGoodPostHeaderActionsTitle.download.localize()
      case .buy:
        return Chat.Strings.DigitalGoodPostHeaderActionsTitle.buy.localize()
      case .show:
        return Chat.Strings.DigitalGoodPostHeaderActionsTitle.show.localize()
      case .pendingBuyerApproval:
        return Chat.Strings.DigitalGoodPostHeaderActionsTitle.pendingBuyerApproval.localize()
      case .pendingSellerApproval:
        return Chat.Strings.DigitalGoodPostHeaderActionsTitle.pendingSellerApproval.localize()
      case .booked:
        return Chat.Strings.DigitalGoodPostHeaderActionsTitle.booked.localize()
      case .soldOut:
        return Chat.Strings.DigitalGoodPostHeaderActionsTitle.soldOut.localize()
      case .confirmed:
        return Chat.Strings.DigitalGoodPostHeaderActionsTitle.confirmed.localize()
      }
    }
    
    var disabledTitle: String {
      switch self {
      case .download:
        return Chat.Strings.DigitalGoodPostHeaderActionsTitle.download.localize()
      case .buy:
        return Chat.Strings.DigitalGoodPostHeaderActionsTitle.invoiceRequesting.localize()
      case .show:
        return Chat.Strings.DigitalGoodPostHeaderActionsTitle.show.localize()
      case .pendingBuyerApproval:
        return Chat.Strings.DigitalGoodPostHeaderActionsTitle.pendingBuyerApproval.localize()
      case .pendingSellerApproval:
        return Chat.Strings.DigitalGoodPostHeaderActionsTitle.pendingSellerApproval.localize()
      case .booked:
        return Chat.Strings.DigitalGoodPostHeaderActionsTitle.booked.localize()
      case .soldOut:
        return Chat.Strings.DigitalGoodPostHeaderActionsTitle.soldOut.localize()
      case .confirmed:
        return Chat.Strings.DigitalGoodPostHeaderActionsTitle.confirmed.localize()
      }
    }
    
    var hasDisabledState: Bool {
      switch self {
      case .download:
        return false
      case .buy:
        return true
      case .show:
        return false
      case .pendingBuyerApproval:
        return false
      case .pendingSellerApproval:
        return false
      case .booked:
        return false
      case .soldOut:
        return false
      case .confirmed:
        return false
      }
    }
    
    var hasEnabledState: Bool {
      switch self {
      case .download:
        return true
      case .buy:
        return true
      case .show:
        return true
      case .pendingBuyerApproval:
        return false
      case .pendingSellerApproval:
        return false
      case .booked:
        return false
      case .soldOut:
        return false
      case .confirmed:
        return false
      }
    }
  }
  
  struct GoodsPostHeaderViewModel: ChatDigitalGoodPostHeaderViewModelProtocol {
    let hasAdditionalActions: Bool
    
    let isHighligthed: Bool
    
    let viewModels: [[Chat.CommercialPostHeaderViewModelType]]
    
    init?(post: PostingProtocol?, goodsInfo: GoodsProtocol?, currentUser: UserProtocol?, lastGoodsOrder: GoodsOrderProtocol?) {
      guard let post = post,
        let goodsInfo = goodsInfo,
        let currentUser = currentUser
      else {
        return nil
      }
      
      
      let messageActionsSection: [Chat.CommercialPostHeaderViewModelType]
      
      let descriptionVM = GoodsPostHeaderDescriptionViewModel(post: post, goodsInfo: goodsInfo)
      let postViewModels: [Chat.CommercialPostHeaderViewModelType] = [.goodsDescription(descriptionVM)]

      let isCurrrentUserBuyer = post.postingUser?.identifier != currentUser.identifier
      isHighligthed = false
      
      guard let lastGoodsOrder = lastGoodsOrder else {
        guard isCurrrentUserBuyer else {
          messageActionsSection = []
          viewModels = [postViewModels, messageActionsSection]
          hasAdditionalActions = false
          return
        }
        
        switch goodsInfo.availabilityStatus {
        case .available:
          messageActionsSection = [.buyAction(DigitalGoodPostHeaderActionViewModel.buy)]
        case .booked:
          messageActionsSection = [.buyAction(DigitalGoodPostHeaderActionViewModel.booked)]
        case .soldOut:
          messageActionsSection = [.buyAction(DigitalGoodPostHeaderActionViewModel.soldOut)]
        case .unsupportedStatus:
          messageActionsSection = [.buyAction(DigitalGoodPostHeaderActionViewModel.buy)]
        }
        
        viewModels = [postViewModels, messageActionsSection]
        hasAdditionalActions = false
        return
      }
      
      switch lastGoodsOrder.orderStatus {
      case .waiting:
        messageActionsSection = [.purchaseStatus(DigitalGoodPostHeaderActionViewModel.pendingBuyerApproval)]
        viewModels = [postViewModels, messageActionsSection]
        hasAdditionalActions = isCurrrentUserBuyer
      case .returnRequested:
        messageActionsSection = [.purchaseStatus(DigitalGoodPostHeaderActionViewModel.pendingSellerApproval)]
        viewModels = [postViewModels, messageActionsSection]
        hasAdditionalActions = !isCurrrentUserBuyer
      case .returned:
        messageActionsSection = isCurrrentUserBuyer ? [.buyAction(DigitalGoodPostHeaderActionViewModel.buy)] : []
        viewModels = [postViewModels, messageActionsSection]
        hasAdditionalActions = false
      case .confirmed:
        messageActionsSection = isCurrrentUserBuyer ? [.buyAction(DigitalGoodPostHeaderActionViewModel.confirmed)] : []
        viewModels = [postViewModels, messageActionsSection]
        hasAdditionalActions = false
      case .unsupportedStatus:
        messageActionsSection = isCurrrentUserBuyer ? [.buyAction(DigitalGoodPostHeaderActionViewModel.buy)] : []
        viewModels = [postViewModels, messageActionsSection]
        hasAdditionalActions = false
      }
    }
    
    func numberOfSections() -> Int {
      return viewModels.count
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
      return viewModels[section].count
    }
    
    func itemAt(_ indexPath: IndexPath) -> Chat.CommercialPostHeaderViewModelType {
      return viewModels[indexPath.section][indexPath.item]
    }
  }
  
  struct DigitalGoodPostHeaderViewModel: ChatDigitalGoodPostHeaderViewModelProtocol {
    let hasAdditionalActions: Bool
    let isHighligthed: Bool
    
    let viewModels: [[Chat.CommercialPostHeaderViewModelType]]
    
    init?(post: PostingProtocol?, commerce: CommerceInfoProtocol?, currentUser: UserProtocol?) {
      guard let post = post,
        let commerce = commerce,
        let currentUser = currentUser
      else {
        return nil
      }
      
      hasAdditionalActions = false
      let messageActionsSection: [Chat.CommercialPostHeaderViewModelType]
      
      let descriptionVM = DigitalGoodPostHeaderDescriptionViewModel(post: post,
                                                                    commerceInfo: commerce)
      let postViewModels: [Chat.CommercialPostHeaderViewModelType] = [.digitalGoodDescription(descriptionVM)]
      
      guard post.postingUser?.identifier != currentUser.identifier else {
        viewModels = [postViewModels]
        isHighligthed = false
        return
      }
       
//
//      let paidInvoice = post.digitalGoodPurchaseInvoices.first( where: {
//        $0.activityToUser?.identifier == currentUser.identifier && $0.walletActivityStatus == .accepted
//      })
//
      let hasPaidInvoice = post.currentUserDigitalGoodPurchaseInvoice?.walletActivityStatus == .accepted
      
      isHighligthed = hasPaidInvoice
      
      let isDownloadable = commerce.isDownloadAvailable
      
      if hasPaidInvoice {
        messageActionsSection = isDownloadable ?
          [.downloadAction(DigitalGoodPostHeaderActionViewModel.download)]:
          [.showAction(DigitalGoodPostHeaderActionViewModel.show)]
      } else {
         messageActionsSection = [.buyAction(DigitalGoodPostHeaderActionViewModel.buy)]
      }
      
      viewModels = [postViewModels,
                    messageActionsSection]
    }
    
    func numberOfSections() -> Int {
      return viewModels.count
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
      return viewModels[section].count
    }
    
    func itemAt(_ indexPath: IndexPath) -> Chat.CommercialPostHeaderViewModelType {
      return viewModels[indexPath.section][indexPath.item]
    }
  }
}

extension Chat {
  enum Strings {
    enum ChatNavigationBar: String, LocalizedStringKeyProtocol {
      case price = "Price"
      case reward = "Reward"
    }
    
    enum DigitalGoodPostHeaderActionsTitle: String, LocalizedStringKeyProtocol {
      case download = "Download your order"
      case buy = "Buy Item"
      case show = "View Your Order"
      case invoiceRequesting = "Invoice requesting"
      
      case booked = "Booked"
      case soldOut = "Sold Out"
      
      case pendingBuyerApproval = "Waiting for buyer's approval"
      case confirmed = "Confirmed"
      
      case pendingSellerApproval = "Waiting for seller's approval"
      case approveReturn = "Approve Return"
      case returnApproved = "Return Approved"
    }
    
    enum CheckoutStatusDescriptionFor: String, LocalizedStringKeyProtocol {
      case requested = "Waiting for buyer's confirmation"
      case accepted =  "Good can be delivered"
      case rejected = ""
      case empty = "Waiting for confirmation"
    }
    
    enum CheckoutStatusFor: String, LocalizedStringKeyProtocol {
      case requested = "Invoice is requested"
      case accepted = "Invoice is accepted"
      case rejected = "Invoice is rejected"
      case empty = ""
    }
    
    enum Messages: String, LocalizedStringKeyProtocol {
      case unsupportedMessageType = "Message type is not supported in this version"
    }
    
    enum Alerts: String, LocalizedStringKeyProtocol {
      case alertTitleForInvoiceWithValueSymbolUsername = "Checkout % % % to buy this item"
      
      case alertTitleForGoodsOrderWithValueSymbolUsername = "Checkout % % to buy this item. Your payment will be escrowed by system until you confirm."
      
      case deleteCommentMessage = "Delete Comment?"
      case deleteCommentAction = "Delete"
      case buyAction = "Buy Item"
      case cancelAction = "Cancel"
      
      case okAction = "Ok"
      case invoicePaymentSuccessAlertTitle = "Thank you"
      case invoicePaymentSuccessAlertMessage = "Your payment was successful"
      
      case downloading = "Downloading..."
      
      
      case confirmGoodsItemAction = "Confirm Item"
      case returnGoodsItemAction = "Return Item"
      case approveReturnGoodsItemAction = "Approve Return"
      
      
      case confirmGoodsItemMessage = "Would you like to confirm your purchase? Once confirmed, you can not cancel your purchase."
      case returnRequestGoodsItemMessage = "Before requesting return Item, be sure to check with the seller in advance. Refunds will be made after the seller confirms your request."
      
      case returnGoodsItemMessage = "Are you sure you want to approve the buyer's return request? If you accept the return, the escrowed amount will be refunded to the buyer."
      
    }
    
    enum Errors: String, LocalizedStringKeyProtocol {
      case invoiceRequestError = "Invoice Request Error"
      case digitalGoodDownloadError = "Download Error"
      case roomForPostIsNotFound = "Chat room is not found"
      case digitalGoodShowError = "Show order Error"
    }
    
    static func alertTitleForInvoice(_ invoice: PartialInvoiceProtocol) -> String {
      let value = String(format:"%.0f", invoice.activityValue)
      let currencySymbol = invoice.activityCurrency.symbol
      let username = invoice.activityFromUser?.userName.asUsername.withSpaceAsSuffix ?? ""
      return Alerts.alertTitleForInvoiceWithValueSymbolUsername.localize(values: value, currencySymbol, username)
    }
    
    static func alertTitleForGoodsInfo(_ goodsIndo: GoodsProtocol) -> String {
      let value = String(format:"%.0f", goodsIndo.goodsPrice)
      let currencySymbol = goodsIndo.itemCurrency.symbol
      return Alerts.alertTitleForGoodsOrderWithValueSymbolUsername.localize(values: value, currencySymbol)
    }
    
    static func checkoutStatusFor(_ invoiceStatus: InvoiceStatus) -> String {
      switch invoiceStatus {
      case .requested:
        return CheckoutStatusFor.requested.localize()
      case .accepted:
        return CheckoutStatusFor.accepted.localize()
      case .rejected:
        return CheckoutStatusFor.rejected.localize()
      case .empty:
        return CheckoutStatusFor.empty.localize()
      }
    }
    
    static func checkoutStatusDescriptionFor(_ invoiceStatus: InvoiceStatus) -> String {
      switch invoiceStatus {
      case .requested:
        return CheckoutStatusDescriptionFor.requested.localize()
      case .accepted:
        return CheckoutStatusDescriptionFor.accepted.localize()
      case .rejected:
        return CheckoutStatusDescriptionFor.rejected.localize()
      case .empty:
        return CheckoutStatusDescriptionFor.empty.localize()
      }
    }
  }
}

extension String {
  var asUsername: String {
    return "@\(self.capitalized)"
  }
  
  var withSpaceAsSuffix: String {
    return "\(self) "
  }
}
