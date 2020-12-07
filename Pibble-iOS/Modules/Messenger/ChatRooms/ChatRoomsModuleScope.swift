//
//  ChatRoomsModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 16/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum ChatRooms {
  enum ContentType {
    case personalChatRooms
    case chatRoomsForExistingGroup(ChatRoomsGroupProtocol)
    case chatRoomsForGroup(PostingProtocol)
  }
  
  enum ItemViewModel {
    case loadingPlaceholder
    case chatRoom(ChatRoomItemViewModelProtocol)
  }
  
  struct ChatRoomItemViewModel: ChatRoomItemViewModelProtocol {
    let commercialIconImage: UIImage?
    
    let leaveTitle: String
    let muteTitle: String
    
    let canBeMuted: Bool
    let canBeLeaved: Bool
    
    let membersCount: String
    
    let avatarPlaceholder: UIImage?
    let avatarURLString: String
    
    let title: String
    let lastMessage: String
    let date: String
    let unreadCount: String
    
    
    init(chatRoom: ChatRoomProtocol, currentUser: UserProtocol) {
      leaveTitle = ChatRooms.Strings.ChatRoomItem.leaveAction.localize()
      
      muteTitle = chatRoom.isMutedByCurrentUser ?
        ChatRooms.Strings.ChatRoomItem.umMuteAction.localize() :
        ChatRooms.Strings.ChatRoomItem.muteAction.localize()
      
      canBeMuted = true
      canBeLeaved = true
      if chatRoom.unreadMessegesCount > 0 {
        unreadCount = String(chatRoom.unreadMessegesCount)
      } else {
        unreadCount = ""
      }
      
      membersCount = ""
      
      date = chatRoom.lastMessageInRoomCreatedAt?
        .timeAgoSinceNow(useNumericDates: true) ?? ""
      
      if let last = chatRoom.lastMessageInRoom {
        switch last {
        case .text(let message):
          lastMessage = message.messageText
        case .system(let message):
          lastMessage = message.messageText
        case .post(let postMessage):
          let title = postMessage.quotedPost?.commerceInfo?.commerceItemTitle ?? ""
          lastMessage = title.count > 0 ?
            "\(ChatRooms.Strings.Post.postAttachmentMessage.localize()): \(title)":
            "\(ChatRooms.Strings.Post.postAttachmentMessage.localize())"
        }
      } else {
        lastMessage = ""
      }
      
      commercialIconImage = nil
      let users = chatRoom.chatRoomUsers.compactMap { $0.relatedUser }
      guard let user = users.first(where: { $0.identifier != currentUser.identifier }) else {
        title = ""
        avatarPlaceholder = nil
        avatarURLString = ""
        return
      }
      
      title = user.userName.capitalized
      avatarPlaceholder = UIImage.avatarImageForNameString(user.userName)
      avatarURLString = user.userpicUrlString
      
//      switch chatRoom.roomType {
//      case .plain:
//
//        let users = chatRoom.chatRoomUsers.compactMap { $0.relatedUser }
//        guard let user = users.first(where: { $0.identifier != currentUser.identifier }) else {
//          title = ""
//          avatarPlaceholder = nil
//          avatarURLString = ""
//          return
//        }
//
//        title = user.username.capitalized
//        avatarPlaceholder = UIImage.avatarImageForNameString(user.username)
//        avatarURLString = user.userpicUrlString
//
//      case .commercial:
//        guard let post = chatRoom.relatedPost,
//          let commercialInfo = post.commerceInfo
//        else {
//          title = ""
//          avatarPlaceholder = nil
//          avatarURLString = ""
//          return
//        }
//
//        title = commercialInfo.commerceItemTitle.capitalized
//        avatarPlaceholder = UIImage.avatarImageForTitleString(commercialInfo.commerceItemTitle)
//        avatarURLString = post.postingMedia.first?.thumbnailUrl ?? ""
//      }
      
      
    }
  }
  
  struct NavigationBarViewModel: ChatRoomsNavigationBarViewModelProtocol {
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
    
    init(chatRoomsGroup: ChatRoomsGroupProtocol) {
      if let post = chatRoomsGroup.relatedPost, let commerceInfo = post.commerceInfo {
        self = NavigationBarViewModel.commerceRoomsGroupViewModel(chatRoomsGroup, post: post, commerceInfo: commerceInfo)
        return
      }
    
      self = NavigationBarViewModel.empty()
    }
    
    static func empty() -> NavigationBarViewModel {
      return NavigationBarViewModel(title: "",
                                    subtitle: "",
                                    userpicUrlString: "",
                                    userpicPlaceholder: nil)
    }
    
    static func commerceRoomsGroupViewModel(_ group: ChatRoomsGroupProtocol, post: PartialPostingProtocol, commerceInfo: CommerceInfoProtocol) -> NavigationBarViewModel {
      let membersCount = group.chatRoomsCount > 0 ? "(\(group.chatRoomsCount))" : ""
      let title = "\(commerceInfo.commerceItemTitle.capitalized) \(membersCount)"
      
      let price = "\(commerceInfo.commerceItemPrice) \(commerceInfo.commerceItemCurrency.symbol)"
      
      let rewardAmount = commerceInfo.commerceReward * Double(commerceInfo.commerceItemPrice)
      let reward = String(format: commerceInfo.commerceItemCurrency.stringFormat, rewardAmount)
      let rewardCurrency = "\(commerceInfo.commerceItemCurrency.symbol)"
      
      let priceTitle = "\(ChatRooms.Strings.ChatNavigationBar.price.localize()): \(price)"
      let rewardTitle = "\(ChatRooms.Strings.ChatNavigationBar.reward.localize()): \(reward) \(rewardCurrency)"
      
      
      let subtitle = "\(priceTitle) \(rewardTitle)"
      let userpicUrlString = post.postingMedia?.first?.thumbnailUrl ?? ""
      let userpicPlaceholder = UIImage.avatarImageForTitleString(commerceInfo.commerceItemTitle)
      
      return NavigationBarViewModel(title: title,
                                    subtitle: subtitle,
                                    userpicUrlString: userpicUrlString,
                                    userpicPlaceholder: userpicPlaceholder)
      
    }
    
    static func commerceRoomsGroupViewModel(_ group: ChatRoomsGroupProtocol, post: PostingProtocol, commerceInfo: CommerceInfoProtocol) -> NavigationBarViewModel {
      let membersCount = group.chatRoomsCount > 0 ? "(\(group.chatRoomsCount))" : ""
      let title = "\(commerceInfo.commerceItemTitle.capitalized) \(membersCount)"
      
      let price = "\(commerceInfo.commerceItemPrice) \(commerceInfo.commerceItemCurrency.symbol)"
      
      let rewardAmount = commerceInfo.commerceReward * Double(commerceInfo.commerceItemPrice)
      let reward = String(format: commerceInfo.commerceItemCurrency.stringFormat, rewardAmount)
      let rewardCurrency = "\(commerceInfo.commerceItemCurrency.symbol)"
      
      let priceTitle = "\(ChatRooms.Strings.ChatNavigationBar.price.localize()): \(price)"
      let rewardTitle = "\(ChatRooms.Strings.ChatNavigationBar.reward.localize()): \(reward) \(rewardCurrency)"
      
      
      let subtitle = "\(priceTitle) \(rewardTitle)"
      let userpicUrlString = post.postingMedia.first?.thumbnailUrl ?? ""
      let userpicPlaceholder = UIImage.avatarImageForTitleString(commerceInfo.commerceItemTitle)
      
      return NavigationBarViewModel(title: title,
                                    subtitle: subtitle,
                                    userpicUrlString: userpicUrlString,
                                    userpicPlaceholder: userpicPlaceholder)
      
    }
  }
}

fileprivate enum UIConstants {
 
}


extension ChatRooms {
  enum Strings {
    enum Post: String, LocalizedStringKeyProtocol {
      case postAttachmentMessage = "Attached post"
    }
    
    enum ChatRoomItem: String, LocalizedStringKeyProtocol {
      case muteAction = "Mute"
      case umMuteAction = "Unmute"
      
      case leaveAction = "Leave"
    }
    
    enum ChatNavigationBar: String, LocalizedStringKeyProtocol {
      case price = "Price"
      case reward = "Reward"
    }
    
    enum Alerts: String, LocalizedStringKeyProtocol  {
      case leaveRoomAlertTitle = ""
      case leaveRoomAlertMessage = "Are you sure want to leave this chatroom?"
      
      case leaveRoomAlertConfirm = "Yes"
      case leaveRoomAlertCancel = "No"
    }
  }
}
