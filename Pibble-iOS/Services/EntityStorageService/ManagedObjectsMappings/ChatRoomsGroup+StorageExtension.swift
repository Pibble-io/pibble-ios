//
//  ChatRoomsGroup+StorageExtension.swift
//  Pibble
//
//  Created by Sergey Kazakov on 11/04/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension ChatRoomsGroupManagedObject: MappableManagedObject {
  typealias ID = Int32

  fileprivate func replace(with object: ChatRoomsGroupProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    
    createdAt = NSDate(timeIntervalSince1970: object.groupCreatedAt.timeIntervalSince1970)
    updatedAt = NSDate(timeIntervalSince1970: object.groupUpdatedAt.timeIntervalSince1970)
   
    unreadMessageCount = Int32(object.groupUnreadMessegesCount)
    if let lastMessageInGroupCreatedAt = object.lastMessageInGroupCreatedAt {
      lastMessageCreatedAt = NSDate(timeIntervalSince1970: lastMessageInGroupCreatedAt.timeIntervalSince1970)
    }
    
    if let relatedPost = object.relatedPost {
      post = PostingManagedObject.replaceOrCreate(with: relatedPost, in: context)
    }
    
    object.chatRoomsInGroup.forEach {
      let room = ChatRoomManagedObject.replaceOrCreate(with: $0, in: context)
      room.chatRoomsGroup = self
      
      if let groupPost = post {
        room.post = groupPost
      }
    }
    
    if let message = object.lastMessageInGroup {
      lastMessage = ChatMessageEntity.replaceOrCreate(with: message, in: context)
    }
    
    roomsCount = Int32(object.chatRoomsCount)
    
    return self
  }
  
  fileprivate func update(with object: PartialChatRoomsGroupProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    
    createdAt = NSDate(timeIntervalSince1970: object.groupCreatedAt.timeIntervalSince1970)
    updatedAt = NSDate(timeIntervalSince1970: object.groupUpdatedAt.timeIntervalSince1970)
    
    unreadMessageCount = Int32(object.groupUnreadMessegesCount)
    if let lastMessageInGroupCreatedAt = object.lastMessageInGroupCreatedAt {
      lastMessageCreatedAt = NSDate(timeIntervalSince1970: lastMessageInGroupCreatedAt.timeIntervalSince1970)
    }
    
    if let relatedPost = object.relatedPost {
      post = PostingManagedObject.updateOrCreate(with: relatedPost, in: context)
    }
    
    object.chatRoomsInGroup.forEach {
      let room = ChatRoomManagedObject.updateOrCreate(with: $0, in: context)
      
      room.chatRoomsGroup = self
      
      if let groupPost = post {
        room.post = groupPost
      }
    }
    
    if let message = object.lastMessageInGroup {
      lastMessage = PartialChatMessageEntity.updateOrCreate(with: message, in: context)
    }
    
    roomsCount = Int32(object.chatRoomsCount)
    
    return self
  }
  
  static func replaceOrCreate(with object: ChatRoomsGroupProtocol, in context: NSManagedObjectContext) -> ChatRoomsGroupManagedObject {
    let managedObject = ChatRoomsGroupManagedObject.findOrCreate(with: ChatRoomsGroupManagedObject.ID(object.identifier), in: context)
    return managedObject.replace(with: object, in: context)
  }
  
  static func updateOrCreate(with object: PartialChatRoomsGroupProtocol, in context: NSManagedObjectContext) -> ChatRoomsGroupManagedObject {
    let managedObject = ChatRoomsGroupManagedObject.findOrCreate(with: ChatRoomsGroupManagedObject.ID(object.identifier), in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension ChatRoomsGroupManagedObject {
  static func createObservable(with object: ChatRoomsGroupProtocol, in context: NSManagedObjectContext) ->   ObservableManagedObject<ChatRoomsGroupManagedObject> {
    let id = Int32(object.identifier)
    let fetchRequest: NSFetchRequest<ChatRoomsGroupManagedObject> = ChatRoomsGroupManagedObject.fetchRequest()
    let observableManagedObject = ObservableManagedObject(id, fetchRequest: fetchRequest, context: context)
    return observableManagedObject
  }
  
  static func createObservable(with object: PartialChatRoomsGroupProtocol, in context: NSManagedObjectContext) ->   ObservableManagedObject<ChatRoomsGroupManagedObject> {
    let id = Int32(object.identifier)
    let fetchRequest: NSFetchRequest<ChatRoomsGroupManagedObject> = ChatRoomsGroupManagedObject.fetchRequest()
    let observableManagedObject = ObservableManagedObject(id, fetchRequest: fetchRequest, context: context)
    return observableManagedObject
  }
}


extension ChatRoomsGroupManagedObject: ChatRoomsGroupProtocol {
  var identifier: Int {
    return Int(id)
  }
  
  var relatedPost: PostingProtocol? {
    return post
  }
  
  var relatedPostPreview: PartialPostingProtocol? {
    return nil
  }
  
  var groupCreatedAt: Date {
    return Date(timeIntervalSince1970: createdAt?.timeIntervalSince1970 ?? 0.0)
  }
  
  var groupUpdatedAt: Date {
    return Date(timeIntervalSince1970: updatedAt?.timeIntervalSince1970 ?? 0.0)
  }
  
  var groupUnreadMessegesCount: Int {
    return Int(unreadMessageCount)
  }
  
  var lastMessageInGroupCreatedAt: Date? {
    guard let lastMessageCreatedAt = lastMessageCreatedAt else {
      return nil
    }
    
    return Date(timeIntervalSince1970: lastMessageCreatedAt.timeIntervalSince1970)
  }
  
  var chatRoomsInGroup: [ChatRoomProtocol] {
    return rooms?.allObjects as? [ChatRoomManagedObject] ?? []
  }
  
  var lastMessageInGroup: ChatMessageEntity? {
    return lastMessage?.chatMessageEntity
  }
  
  var chatRoomsCount: Int {
    return Int(roomsCount)
  }
}

extension ChatRoomsGroupProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = ChatRoomsGroupManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = ChatRoomsGroupManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialChatRoomsGroupProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = ChatRoomsGroupManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = ChatRoomsGroupManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

enum ChatRoomsGroupRelations: CoreDataStorableRelation {
  case chatRoomsGroupForUser(chatRoomsGroup: ChatRoomsGroupProtocol, user: UserProtocol)
  case partialChatRoomsGroupForUser(chatRoomsGroup: PartialChatRoomsGroupProtocol, user: UserProtocol)
  
  
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    switch self {
    case .chatRoomsGroupForUser(let chatRoomsGroup, let user):
      let managedChatRoomsGroup = ChatRoomsGroupManagedObject.replaceOrCreate(with: chatRoomsGroup, in: context)
      let user = UserManagedObject.replaceOrCreate(with: user, in: context)
      managedChatRoomsGroup.user = user
    case .partialChatRoomsGroupForUser(let chatRoomsGroup, let user):
      let managedChatRoomsGroup = ChatRoomsGroupManagedObject.updateOrCreate(with: chatRoomsGroup, in: context)
      let user = UserManagedObject.replaceOrCreate(with: user, in: context)
      managedChatRoomsGroup.user = user
    }
  }
  
  func delete(in context: NSManagedObjectContext) {
    switch self {
    case .chatRoomsGroupForUser(let chatRoomsGroup, let user):
      let managedChatRoomsGroup = ChatRoomsGroupManagedObject.replaceOrCreate(with: chatRoomsGroup, in: context)
      
      if managedChatRoomsGroup.user?.identifier == user.identifier {
        managedChatRoomsGroup.user = nil
      }
    case .partialChatRoomsGroupForUser(let chatRoomsGroup, let user):
      let managedChatRoomsGroup = ChatRoomsGroupManagedObject.updateOrCreate(with: chatRoomsGroup, in: context)
      if managedChatRoomsGroup.user?.identifier == user.identifier {
        managedChatRoomsGroup.user = nil
      }
    }
  }
}
