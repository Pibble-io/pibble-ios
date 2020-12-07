//
//  Notifications+StorageExtensions.swift
//  Pibble
//
//  Created by Sergey Kazakov on 27/06/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension NotificationManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  fileprivate func replace(with object: NotificationEntity, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.baseNotification.identifier)
    message = object.baseNotification.notificationMessage
    type = object.baseNotification.notificationType.rawValue
    let createdAtDate = object.baseNotification.notificationCreatedAt
    createdAt = createdAtDate.toNSDate
    createdAtDateComponent = createdAtDate.dateByRemovingTimeComponent().toNSDate
    
    if let user = object.baseNotification.notificationFromUser {
      fromUser = UserManagedObject.replaceOrCreate(with: user, in: context)
    }
    
    if let user = object.baseNotification.notificationToUser {
      toUser = UserManagedObject.replaceOrCreate(with: user, in: context)
    }
    
    switch object {
    case .post(let entity):
      if let post = entity.relatedPostEntity {
        relatedPost = PostingManagedObject.replaceOrCreate(with: post, in: context)
      }
    case .user(let entity):
      if let user = entity.relatedUserEntity {
        relatedUser = UserManagedObject.replaceOrCreate(with: user, in: context)
      }
    case .plain(_):
      break
    }
    return self
  }
  
  fileprivate func update(with object: PartialNotificationEntity, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.baseNotification.identifier)
    message = object.baseNotification.notificationMessage
    type = object.baseNotification.notificationType.rawValue
    let createdAtDate = object.baseNotification.notificationCreatedAt
    createdAt = createdAtDate.toNSDate
    createdAtDateComponent = createdAtDate.dateByRemovingTimeComponent().toNSDate
    
    if let user = object.baseNotification.notificationFromUser {
      fromUser = UserManagedObject.updateOrCreate(with: user, in: context)
    }
    
    if let user = object.baseNotification.notificationToUser {
      toUser = UserManagedObject.updateOrCreate(with: user, in: context)
    }
    
    switch object {
    case .post(let entity):
      if let post = entity.relatedPostEntity {
        relatedPost = PostingManagedObject.updateOrCreate(with: post, in: context)
      }
    case .user(let entity):
      if let user = entity.relatedUserEntity {
        relatedUser = UserManagedObject.updateOrCreate(with: user, in: context)
      }
    case .plain(_):
      break
    }
    return self
  }
  
  static func replaceOrCreate(with object: NotificationEntity, in context: NSManagedObjectContext) -> NotificationManagedObject {
    let managedObject = NotificationManagedObject.findOrCreate(with: NotificationManagedObject.ID(object.baseNotification.identifier), in: context)
    return managedObject.replace(with: object, in: context)
  }
  
  static func updateOrCreate(with object: PartialNotificationEntity, in context: NSManagedObjectContext) -> NotificationManagedObject {
    let managedObject = NotificationManagedObject.findOrCreate(with: NotificationManagedObject.ID(object.baseNotification.identifier), in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension NotificationManagedObject {
  func triggerRefresh() {
    lastTriggeredUpdateDate = NSDate()
  }
}

extension NotificationManagedObject {
  var notificationEntity: NotificationEntity {
    if let _ = relatedPost {
      return .post(self)
    }
    
    if let _ = relatedUser {
      return .user(self)
    }
    
    return .plain(self)
  }
}

extension NotificationManagedObject: BaseNotificationProtocol {
  var identifier: Int {
    return Int(id)
  }
  
  var notificationType: NotificationType {
    return NotificationType(rawValue: type ?? "")
  }
  
  var notificationCreatedAt: Date {
    return createdAt?.toDate ?? Date(timeIntervalSince1970: 0.0)
  }
  
  var notificationCreatedAtDateComponent: Date {
    return createdAtDateComponent?.toDate ?? Date(timeIntervalSince1970: 0.0)
  }
  
  
  var notificationFromUser: UserProtocol? {
    return fromUser
  }
  
  var notificationToUser: UserProtocol? {
    return toUser
  }
  
  var notificationMessage: String {
    return message ?? ""
  }
}

extension NotificationManagedObject: PostRelatedNotificationProtocol {
  var relatedPostEntity: PostingProtocol? {
    return relatedPost
  }
}

extension NotificationManagedObject: UserRelatedNotificationProtocol {
  var relatedUserEntity: UserProtocol? {
    return relatedUser
  }
}

extension PartialNotificationEntity {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = NotificationManagedObject.updateOrCreate(with: self, in: context)
  }

  func delete(in context: NSManagedObjectContext) {
    let managedObject = NotificationManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension NotificationEntity {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = NotificationManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = NotificationManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

enum PartialNotificationsRelations: CoreDataStorableRelation {
  case userNotificationsFeed(UserProtocol, notification: PartialNotificationEntity)
  
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    switch self {
    case .userNotificationsFeed(let user, let notification):
      let user = UserManagedObject.replaceOrCreate(with: user, in: context)
      let notification = NotificationManagedObject.updateOrCreate(with: notification, in: context)
      notification.feedUser = user
    }
  }
  
  func delete(in context: NSManagedObjectContext) {
    switch self {
    case .userNotificationsFeed(_, let notification):
      let notification = NotificationManagedObject.updateOrCreate(with: notification, in: context)
      notification.feedUser = nil
    }
  }
}

