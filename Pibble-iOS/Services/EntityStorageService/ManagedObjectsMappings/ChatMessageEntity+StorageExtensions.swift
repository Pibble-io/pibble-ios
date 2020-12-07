//
//  ChatMessageEntity+StorageExtensions.swift
//  Pibble
//
//  Created by Sergey Kazakov on 13/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension BaseChatMessageManagedObject {
  var chatMessageEntity: ChatMessageEntity {
    switch chatMessageType {
    case .text:
      return ChatMessageEntity(entity: self as! TextChatMessageManagedObject)
    case .post:
      return ChatMessageEntity(entity: self as! PostChatMessageManagedObject)
    case .system:
      return ChatMessageEntity(entity: self as! ChatSystemMessageManagedObject)
    }
  }
}

extension BaseChatMessageManagedObject: ChatMessageProtocol {
  var identifier: Int {
    return Int(id)
  }
  
  var chatMessageType: ChatMessageType {
    return ChatMessageType(rawValue: messageType ?? "") ?? .text
  }
  
  var messageCreatedAt: String {
    return createdAt ?? ""
  }
  
  var messageFromUser: UserProtocol? {
    return fromUser
  }
}

extension ChatMessageEntity {
  static func replaceOrCreate(with object: ChatMessageEntity, in context: NSManagedObjectContext) -> BaseChatMessageManagedObject {
    switch object {
    case .text(let entity):
      return TextChatMessageManagedObject.replaceOrCreate(with: entity, in: context)
    case .post(let entity):
      return PostChatMessageManagedObject.replaceOrCreate(with: entity, in: context)
    case .system(let entity):
      return ChatSystemMessageManagedObject.replaceOrCreate(with: entity, in: context)
    }
  }
}

extension PartialChatMessageEntity {
  static func updateOrCreate(with object: PartialChatMessageEntity, in context: NSManagedObjectContext) -> BaseChatMessageManagedObject {
    switch object {
    case .text(let entity):
      return TextChatMessageManagedObject.updateOrCreate(with: entity, in: context)
    case .post(let entity):
      return PostChatMessageManagedObject.updateOrCreate(with: entity, in: context)
    case .system(let entity):
      return ChatSystemMessageManagedObject.updateOrCreate(with: entity, in: context)
    }
  }
}

extension PartialChatMessageEntity {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    switch self {
    case .text(let entity):
      let _ = TextChatMessageManagedObject.updateOrCreate(with: entity, in: context)
    case .post(let entity):
      let _ = PostChatMessageManagedObject.updateOrCreate(with: entity, in: context)
    case .system(let entity):
      let _ = ChatSystemMessageManagedObject.updateOrCreate(with: entity, in: context)
    }
  }
  
  func delete(in context: NSManagedObjectContext) {
    switch self {
    case .text(let entity):
      entity.delete(in: context)
    case .post(let entity):
      entity.delete(in: context)
    case .system(let entity):
      entity.delete(in: context)
    }
  }
}

extension ChatMessageEntity {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    switch self {
    case .text(let entity):
      let _ = TextChatMessageManagedObject.replaceOrCreate(with: entity, in: context)
    case .post(let entity):
      let _ = PostChatMessageManagedObject.replaceOrCreate(with: entity, in: context)
    case .system(let entity):
      let _ = ChatSystemMessageManagedObject.replaceOrCreate(with: entity, in: context)
    }
  }
  
  func delete(in context: NSManagedObjectContext) {
    switch self {
    case .text(let entity):
      entity.delete(in: context)
    case .post(let entity):
      entity.delete(in: context)
    case .system(let entity):
      entity.delete(in: context)
    }
  }
}

enum ChatMessagesRelations: CoreDataStorableRelation {
  case chatRoom(message: ChatMessageEntity, chatRoom: ChatRoomProtocol)
  case chatRoomWithPartial(message: PartialChatMessageEntity, chatRoom: ChatRoomProtocol)

  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    switch self {
    case .chatRoom(let message, let chatRoom):
      let managedChatRoom = ChatRoomManagedObject.replaceOrCreate(with: chatRoom, in: context)
      let menagedMessage = ChatMessageEntity.replaceOrCreate(with: message, in: context)
      menagedMessage.chatRoom = managedChatRoom
    case .chatRoomWithPartial(let message, let chatRoom):
      let managedChatRoom = ChatRoomManagedObject.replaceOrCreate(with: chatRoom, in: context)
      let menagedMessage = PartialChatMessageEntity.updateOrCreate(with: message, in: context)
      menagedMessage.chatRoom = managedChatRoom
    }
  }
  
  func delete(in context: NSManagedObjectContext) {
    switch self {
    case .chatRoom(let message, let chatRoom):
      let managedChatRoom = ChatRoomManagedObject.replaceOrCreate(with: chatRoom, in: context)
      let managedMessage = ChatMessageEntity.replaceOrCreate(with: message, in: context)
      managedChatRoom.removeFromMessages(managedMessage)
    case .chatRoomWithPartial(let message, let chatRoom):
      let managedChatRoom = ChatRoomManagedObject.replaceOrCreate(with: chatRoom, in: context)
      let managedMessage = PartialChatMessageEntity.updateOrCreate(with: message, in: context)
      managedChatRoom.removeFromMessages(managedMessage)
    }
  }
}
