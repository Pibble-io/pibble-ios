//
//  NotificationsFeedModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 26/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum NotificationsFeed {
  enum ItemViewModelType {
    case postRelated(NotificationsFeedPostRelatedItemViewModelProtocol)
    case following(NotificationsFeedFollowItemViewModelProtocol)
    case userRelated(NotificationsFeedUserRelatedItemViewModelProtocol)
    case plain(NotificationsFeedPlainItemViewModelProtocol)
    case loadingPlaceholder
    
    init(notification: NotificationEntity?) {
      guard let notification = notification else {
        self = .loadingPlaceholder
        return
      }
      
      switch notification {
      case .post(let entity):
        self = .postRelated(PostRelatedItemViewModel(notification: entity))
      case .user(let entity):
        self = .userRelated(UserRelatedItemViewModel(notification: entity))
      case .plain(let entity):
        switch entity.notificationType {
        case .addFollower:
          self = .following(FollowingItemViewModel(notification: entity))
        default:
          self = .plain(PlainItemViewModel(notification: entity))
        }
      }
    }
  }
  
  typealias ItemActionsHandler = (UITableViewCell, ItemActions) -> Void

  enum ItemActions {
    case showRelatedPost
    case showRelatedUser
    case follow
  }
  
  struct PlainItemViewModel: NotificationsFeedPlainItemViewModelProtocol {
    let avatarPlaceholder: UIImage?
    let avatarURLString: String
    let message: String
    let attributedMessage: NSAttributedString
    
    init(notification: BaseNotificationProtocol) {
      if let username = notification.notificationFromUser?.userName {
        avatarPlaceholder = UIImage.avatarImageForNameString(username)
      } else {
        avatarPlaceholder = nil
      }
     
      avatarURLString = notification.notificationFromUser?.userpicUrlString ?? ""
      message = notification.notificationMessage
      
      let mutableString = NSMutableAttributedString()
      let attributedMessageString = NSAttributedString(string: message,
                                                       attributes: [
                                                        NSAttributedString.Key.font: UIConstants.messageFont,
                                                        NSAttributedString.Key.foregroundColor: UIConstants.messageColor])
      mutableString.append(attributedMessageString)
      
      if let username = notification.notificationFromUser?.userName {
        let usernameRange = (mutableString.string as NSString).range(of: username)
        mutableString.setAttributes([NSAttributedString.Key.font: UIConstants.usernameFont,
                                     NSAttributedString.Key.foregroundColor: UIConstants.usernameColor],
                                    range: usernameRange)
      }
      
      let attributedDate = NSAttributedString(string: notification.notificationCreatedAt.timeAgoSinceNow(useNumericDates: true, useCompactDates: true),
                                              attributes: [
                                                NSAttributedString.Key.font: UIConstants.dateFont,
                                                NSAttributedString.Key.foregroundColor: UIConstants.dateColor])
      
      mutableString.append(NSAttributedString(string: " "))
      mutableString.append(attributedDate)
    
      attributedMessage = mutableString
    }
  }
  
  struct PostRelatedItemViewModel: NotificationsFeedPostRelatedItemViewModelProtocol {
    let postPreviewUrlString: String
    let avatarPlaceholder: UIImage?
    let avatarURLString: String
    let message: String
    let attributedMessage: NSAttributedString
    
    init(notification: PostRelatedNotificationProtocol) {
      if let username = notification.notificationFromUser?.userName {
        avatarPlaceholder = UIImage.avatarImageForNameString(username)
      } else {
        avatarPlaceholder = nil
      }
      
      avatarURLString = notification.notificationFromUser?.userpicUrlString ?? ""
      message = notification.notificationMessage
      let mutableString = NSMutableAttributedString()
      let attributedMessageString = NSAttributedString(string: message,
                                                       attributes: [
                                                        NSAttributedString.Key.font: UIConstants.messageFont,
                                                        NSAttributedString.Key.foregroundColor: UIConstants.messageColor])
      mutableString.append(attributedMessageString)
      
      if let username = notification.notificationFromUser?.userName {
        let usernameRange = (mutableString.string as NSString).range(of: username)
        mutableString.setAttributes([NSAttributedString.Key.font: UIConstants.usernameFont,
                                    NSAttributedString.Key.foregroundColor: UIConstants.usernameColor],
                                    range: usernameRange)
      }

      let attributedDate = NSAttributedString(string: notification.notificationCreatedAt.timeAgoSinceNow(useNumericDates: true, useCompactDates: true),
                                              attributes: [
                                                NSAttributedString.Key.font: UIConstants.dateFont,
                                                NSAttributedString.Key.foregroundColor: UIConstants.dateColor])
      mutableString.append(NSAttributedString(string: " "))
      mutableString.append(attributedDate)

      attributedMessage = mutableString
      postPreviewUrlString = notification.relatedPostEntity?.postingMedia.first?.thumbnailUrl ?? ""
    }
  }
  
  struct UserRelatedItemViewModel: NotificationsFeedUserRelatedItemViewModelProtocol {
    let avatarPlaceholder: UIImage?
    let avatarURLString: String
    let message: String
    
    let relatedUserAvatarUrlString: String
    let relatedUserAvatarPlaceholder: UIImage?
    let attributedMessage: NSAttributedString
    
    init(notification: UserRelatedNotificationProtocol) {
      if let username = notification.notificationFromUser?.userName {
        avatarPlaceholder = UIImage.avatarImageForNameString(username)
      } else {
        avatarPlaceholder = nil
      }
      
      avatarURLString = notification.notificationFromUser?.userpicUrlString ?? ""
      message = notification.notificationMessage
      
      if let username = notification.relatedUserEntity?.userName {
        relatedUserAvatarPlaceholder = UIImage.avatarImageForNameString(username)
      } else {
        relatedUserAvatarPlaceholder = nil
      }
      
      relatedUserAvatarUrlString = notification.relatedUserEntity?.userpicUrlString ?? ""
      
      let mutableString = NSMutableAttributedString()
      let attributedMessageString = NSAttributedString(string: message,
                                                       attributes: [
                                                        NSAttributedString.Key.font: UIConstants.messageFont,
                                                        NSAttributedString.Key.foregroundColor: UIConstants.messageColor])
      mutableString.append(attributedMessageString)
      
      if let username = notification.notificationFromUser?.userName {
        let usernameRange = (mutableString.string as NSString).range(of: username)
        mutableString.setAttributes([NSAttributedString.Key.font: UIConstants.usernameFont,
                                     NSAttributedString.Key.foregroundColor: UIConstants.usernameColor],
                                    range: usernameRange)
      }
      
      let attributedDate = NSAttributedString(string: notification.notificationCreatedAt.timeAgoSinceNow(useNumericDates: true, useCompactDates: true),
                                              attributes: [
                                                NSAttributedString.Key.font: UIConstants.dateFont,
                                                NSAttributedString.Key.foregroundColor: UIConstants.dateColor])
      mutableString.append(NSAttributedString(string: " "))
      mutableString.append(attributedDate)
      attributedMessage = mutableString
    }
  }
  
  struct SectionHeaderViewModel: NotificationsFeedSectionHeaderViewModelProtocol {
    let title: String
    
    init?(notification: BaseNotificationProtocol)  {
      let currentDate = Date()
      let notificationDate = notification.notificationCreatedAt.dateByRemovingTimeComponent()
      
      let notificationDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: notificationDate)
      let currentDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
      
      guard let notificationDateComponentsYear = notificationDateComponents.year,
        let notificationDateComponentsMonth = notificationDateComponents.month,
        let notificationDateComponentsDay = notificationDateComponents.day else {
          return nil
      }
      
      guard let currentDateComponentsYear = currentDateComponents.year,
        let currentDateComponentsMonth = currentDateComponents.month,
        let currentDateComponentsDay = currentDateComponents.day else {
          return nil
      }
      
      if notificationDateComponentsYear == currentDateComponentsYear &&
        notificationDateComponentsMonth == currentDateComponentsMonth &&
        notificationDateComponentsDay == currentDateComponentsDay  {
        
        title = NotificationsFeed.Strings.SectionsHeaders.today.localize()
        return
      }
      
      if notificationDateComponentsYear == currentDateComponentsYear &&
        notificationDateComponentsMonth == currentDateComponentsMonth &&
        notificationDateComponentsDay == currentDateComponentsDay - 1 {
        
        title = NotificationsFeed.Strings.SectionsHeaders.yesterday.localize()
        return
      }
      
      if notificationDateComponentsYear == currentDateComponentsYear &&
        notificationDateComponentsMonth == currentDateComponentsMonth {
        
        title = NotificationsFeed.Strings.SectionsHeaders.thisMonth.localize()
        return
      }
      
      title = NotificationsFeed.Strings.SectionsHeaders.earlier.localize()
    }
  
  }
  
  struct FollowingItemViewModel: NotificationsFeedFollowItemViewModelProtocol {
    let isActionAvailable: Bool
    let actionTitle: String
    let isActionHighlighted: Bool
    
    let avatarPlaceholder: UIImage?
    let avatarURLString: String
    let message: String
    
    let attributedMessage: NSAttributedString
    
    init(notification: BaseNotificationProtocol) {
      if let username = notification.notificationFromUser?.userName {
        avatarPlaceholder = UIImage.avatarImageForNameString(username)
      } else {
        avatarPlaceholder = nil
      }
      
      avatarURLString = notification.notificationFromUser?.userpicUrlString ?? ""
      message = notification.notificationMessage
      
      
      
      let mutableString = NSMutableAttributedString()
      let attributedMessageString = NSAttributedString(string: message,
                                                       attributes: [
                                                        NSAttributedString.Key.font: UIConstants.messageFont,
                                                        NSAttributedString.Key.foregroundColor: UIConstants.messageColor])
      mutableString.append(attributedMessageString)
      
      if let username = notification.notificationFromUser?.userName {
        let usernameRange = (mutableString.string as NSString).range(of: username)
        mutableString.setAttributes([NSAttributedString.Key.font: UIConstants.usernameFont,
                                     NSAttributedString.Key.foregroundColor: UIConstants.usernameColor],
                                    range: usernameRange)
      }
      
      let attributedDate = NSAttributedString(string: notification.notificationCreatedAt.timeAgoSinceNow(useNumericDates: true, useCompactDates: true),
                                              attributes: [
                                                NSAttributedString.Key.font: UIConstants.dateFont,
                                                NSAttributedString.Key.foregroundColor: UIConstants.dateColor])
      mutableString.append(NSAttributedString(string: " "))
      mutableString.append(attributedDate)
      attributedMessage = mutableString
      
      guard let user = notification.notificationFromUser else {
        isActionHighlighted = false
        isActionAvailable = false
        actionTitle = ""
        return
      }
      
      isActionHighlighted = !user.isFollowedByCurrentUser
      isActionAvailable = true
      
      actionTitle = user.isFollowedByCurrentUser ?
        NotificationsFeed.Strings.unfollowAction.localize() :
        NotificationsFeed.Strings.followAction.localize()
    }
  }
}

fileprivate enum UIConstants {
  static let usernameFont = UIFont.AvenirNextDemiBold(size: 15.0)
  static let messageFont = UIFont.AvenirNextMedium(size: 15.0)
  static let dateFont = UIFont.AvenirNextMedium(size: 15.0)
  
  static let usernameColor = UIColor.gray70
  static let messageColor = UIColor.gray70
  static let dateColor = UIColor.gray168
}


extension NotificationsFeed {
  enum Strings: String, LocalizedStringKeyProtocol {
    case followAction = "Follow"
    case unfollowAction = "Following"
    
    enum SectionsHeaders: String, LocalizedStringKeyProtocol {
      case today = "TODAY"
      case yesterday = "YESTERDAY"
      case thisMonth = "THIS MONTH"
      case earlier = "EARLIER"
    }
  }
}
