//
//  LeaderboardContentModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/04/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum LeaderboardContent {
  enum ItemViewModel {
    case loadingPlaceholder
    case leaderboardEntry(LeaderboardEntryViewModelProtocol)
  }
  
  typealias LeaderboardTopActionsHandler = (UIView, LeaderboardActions) -> Void
  
  typealias LeaderboardItemsActionsHandler = (UITableViewCell, LeaderboardActions) -> Void
  

  enum LeaderboardActions {
    case showTopUser(Int)
    case showTopUserPosts(Int)
    case showUser
    case showUserPosts
  }
  
  struct LeaderboardEntryItemViewModel: LeaderboardEntryViewModelProtocol {
    static let numberToStringsFormatter: NumberFormatter = {
      let formatter = NumberFormatter()
      formatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
      formatter.numberStyle = NumberFormatter.Style.decimal
      return formatter
    }()
    
    static func toStringWithFormatter(_ number: Double) -> String {
      let number = NSNumber(value: number)
      return numberToStringsFormatter.string(from: number) ?? ""
    }
    
    let username: String
    let avatarPlaceholder: UIImage?
    let avatarURLString: String
    let leaderboardValue: String
    let leaderboardPlace: String
    
    init(leaderboardEntry: LeaderboardEntryProtocol, place: Int) {
      if let user = leaderboardEntry.leaderboardUser {
        avatarURLString = user.userpicUrlString
        avatarPlaceholder = UIImage.avatarImageForNameString(user.userName)
        username = user.userName
      } else {
        avatarURLString = ""
        avatarPlaceholder = nil
        username = ""
      }
      
      leaderboardValue = LeaderboardEntryItemViewModel.toStringWithFormatter(leaderboardEntry.leaderboardValue)
      leaderboardPlace = "\(place)"
    }
    
  }
  
//  struct ChatRoomItemViewModel: ChatRoomItemViewModelProtocol {
//    var leaveTitle: String = LeaderboardContent.Strings.leaveButton.localize()
//    let muteTitle: String = LeaderboardContent.Strings.muteButton.localize()
//
//    let canBeMuted: Bool = false
//    let canBeLeaved: Bool = false
//
//    let avatarPlaceholder: UIImage?
//    let avatarURLString: String
//
//    let title: String
//    let lastMessage: String
//    let date: String
//    let unreadCount: String
//    let isCommerce: Bool
//    let membersCount: String
//
//    init(chatRoomsGroup: ChatRoomsGroupProtocol, currentUser: UserProtocol) {
//      if chatRoomsGroup.groupUnreadMessegesCount > 0 {
//        unreadCount = String(chatRoomsGroup.groupUnreadMessegesCount)
//      } else {
//        unreadCount = ""
//      }
//
//      if chatRoomsGroup.chatRoomsCount > 0 {
//        membersCount = "\(chatRoomsGroup.chatRoomsCount)"
//      } else {
//        membersCount = ""
//      }
//
//      if let lastMessageDate = chatRoomsGroup.lastMessageInGroupCreatedAt {
//        date = lastMessageDate.timeAgoSinceNow(useNumericDates: true)
//      } else {
//        date = chatRoomsGroup.groupCreatedAt.timeAgoSinceNow(useNumericDates: true)
//      }
//
//      if let last = chatRoomsGroup.lastMessageInGroup {
//        switch last {
//        case .text(let message):
//          lastMessage = message.messageText
//        case .system(let message):
//          lastMessage = message.messageText
//        case .post(let postMessage):
//          let title = postMessage.quotedPost?.commerceInfo?.commerceItemTitle ?? ""
//          lastMessage = title.count > 0 ?
//            "\(LeaderboardContent.Strings.postAttachmentMessage): \(title)":
//          "\(LeaderboardContent.Strings.postAttachmentMessage)"
//        }
//      } else {
//        lastMessage = ""
//      }
//
//      isCommerce = true
//      guard let post = chatRoomsGroup.relatedPost,
//        let commercialInfo = post.commerceInfo
//        else {
//          title = ""
//          avatarPlaceholder = nil
//          avatarURLString = ""
//          return
//      }
//
//      title = commercialInfo.commerceItemTitle.capitalized
//      avatarPlaceholder = UIImage.avatarImageForTitleString(commercialInfo.commerceItemTitle)
//      avatarURLString = post.postingMedia.first?.thumbnailUrl ?? ""
//    }
//  }
}

extension LeaderboardContent {
  enum Strings: String, LocalizedStringKeyProtocol {
    case postAttachmentMessage = "Attached post"
    case muteButton = "Mute"
    case leaveButton = "Leave"
  }
}
