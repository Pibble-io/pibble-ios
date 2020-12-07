//
//  ChatRoomGroupsContentModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/04/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum ChatRoomGroupsContent {
  enum ItemViewModel {
    case loadingPlaceholder
    case chatRoom(ChatRoomItemViewModelProtocol)
  }
  
  struct ChatRoomItemViewModel: ChatRoomItemViewModelProtocol {
    let commercialIconImage: UIImage?
    
    let leaveTitle: String = ChatRoomGroupsContent.Strings.leaveButton.localize()
    let muteTitle: String = ChatRoomGroupsContent.Strings.muteButton.localize()
    
    let canBeMuted: Bool = false
    let canBeLeaved: Bool = false
    
    let avatarPlaceholder: UIImage?
    let avatarURLString: String
    
    let title: String
    let lastMessage: String
    let date: String
    let unreadCount: String 
    let membersCount: String
    
    init(chatRoomsGroup: ChatRoomsGroupProtocol, currentUser: UserProtocol) {
      if chatRoomsGroup.groupUnreadMessegesCount > 0 {
        unreadCount = String(chatRoomsGroup.groupUnreadMessegesCount)
      } else {
        unreadCount = ""
      }
      
      if chatRoomsGroup.chatRoomsCount > 0 {
        membersCount = "\(chatRoomsGroup.chatRoomsCount)"
      } else {
        membersCount = ""
      }
      
      if let lastMessageDate = chatRoomsGroup.lastMessageInGroupCreatedAt {
        date = lastMessageDate.timeAgoSinceNow(useNumericDates: true)
      } else {
        date = chatRoomsGroup.groupCreatedAt.timeAgoSinceNow(useNumericDates: true)
      }
  
      if let last = chatRoomsGroup.lastMessageInGroup {
        switch last {
        case .text(let message):
          lastMessage = message.messageText
        case .system(let message):
          lastMessage = message.messageText
        case .post(let postMessage):
          let title = postMessage.quotedPost?.commerceInfo?.commerceItemTitle ?? ""
          lastMessage = title.count > 0 ?
            "\(ChatRoomGroupsContent.Strings.postAttachmentMessage): \(title)":
          "\(ChatRoomGroupsContent.Strings.postAttachmentMessage)"
        }
      } else {
        lastMessage = ""
      }
     
      guard let post = chatRoomsGroup.relatedPost
        else {
          title = ""
          avatarPlaceholder = nil
          avatarURLString = ""
          commercialIconImage = nil
          return
      }
      
      switch post.postingType {
      case .media, .funding, .charity, .crowdfundingWithReward:
        title = ""
        avatarPlaceholder = nil
        avatarURLString = ""
        commercialIconImage = nil
      case .commercial:
        guard let commercialInfo = post.commerceInfo
          else {
            title = ""
            avatarPlaceholder = nil
            avatarURLString = ""
            commercialIconImage = nil
            return
        }
        
        title = commercialInfo.commerceItemTitle.capitalized
        avatarPlaceholder = UIImage.avatarImageForTitleString(commercialInfo.commerceItemTitle)
        avatarURLString = post.postingMedia.first?.thumbnailUrl ?? ""
        commercialIconImage = UIImage(imageLiteralResourceName: "ChatRooms-DigitialGoodItemIcon")
      case .goods:
        guard let goodsInfo = post.goodsInfo
          else {
            title = ""
            avatarPlaceholder = nil
            avatarURLString = ""
            commercialIconImage = nil
            return
        }
        
        title = goodsInfo.goodsTitle.capitalized
        avatarPlaceholder = UIImage.avatarImageForTitleString(goodsInfo.goodsTitle)
        avatarURLString = post.postingMedia.first?.thumbnailUrl ?? ""
        commercialIconImage = UIImage(imageLiteralResourceName: "ChatRooms-GoodsItemIcon")
      }
      
      
    }
  }
}

extension ChatRoomGroupsContent {
  enum Strings: String, LocalizedStringKeyProtocol {
    case postAttachmentMessage = "Attached post"
    case muteButton = "Mute"
    case leaveButton = "Leave"
  }
}
