//
//  ChatRoom+StorageExtensions.swift
//  Pibble
//
//  Created by Sergey Kazakov on 13/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension ChatRoomManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  fileprivate func replace(with object: ChatRoomProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    unreadMessageCount = Int32(object.unreadMessegesCount)
    type = object.roomType.rawValue
    
    isMuted = object.isMutedByCurrentUser
    isLeft = object.isLeftByCurrentUser
    
    if let message = object.lastMessageInRoom {
      lastMessage = ChatMessageEntity.replaceOrCreate(with: message, in: context)
      lastMessage?.chatRoom = self
    }
    
    if let lastMessageDate = object.lastMessageInRoomCreatedAt {
      lastMessageCreatedAt = NSDate(timeIntervalSince1970: lastMessageDate.timeIntervalSince1970)
    }
    
    object.chatRoomUsers.forEach {
      let member = ChatRoomMemberManagedObject.replaceOrCreate(with: $0, in: context)
      member.chat = self
    }
    
    if let lastGoodsOrder = object.lastGoodsOrder {
      lastRelatedGoodsOrder = GoodsOrderManagedObject.replaceOrCreate(with: lastGoodsOrder, in: context)
    }
    
    let hadInvoice = post?.currentUserPurchaseInvoice != nil
    
    if let relatedPost = object.relatedPost {
      let managedPost = PostingManagedObject.replaceOrCreate(with: relatedPost, in: context)
      post = managedPost
      
      let isHavingInvoice = post?.currentUserPurchaseInvoice != nil
      if isHavingInvoice != hadInvoice {
        triggerRefresh()
      }
    }
    
    return self
  }
  
  fileprivate func update(with object: PartialChatRoomProtocol, in context: NSManagedObjectContext) -> Self {
    id = Int32(object.identifier)
    unreadMessageCount = Int32(object.unreadMessegesCount)
    type = object.roomType.rawValue
    
    isMuted = object.isMutedByCurrentUser
    isLeft = object.isLeftByCurrentUser
    
    if let message = object.lastMessageInRoom {
      lastMessage = PartialChatMessageEntity.updateOrCreate(with: message, in: context)
      lastMessage?.chatRoom = self
    }
    
    if let lastMessageDate = object.lastMessageInRoomCreatedAt {
      lastMessageCreatedAt = NSDate(timeIntervalSince1970: lastMessageDate.timeIntervalSince1970)
    }
    
    object.chatRoomUsers.forEach {
      let member = ChatRoomMemberManagedObject.replaceOrCreate(with: $0, in: context)
      member.chat = self
    }
    
    if let lastGoodsOrder = object.lastGoodsOrder {
      lastRelatedGoodsOrder = GoodsOrderManagedObject.replaceOrCreate(with: lastGoodsOrder, in: context)
    }
   
    let hadInvoice = post?.currentUserPurchaseInvoice != nil
    
    if let relatedPost = object.relatedPost {
      let managedPost = PostingManagedObject.updateOrCreate(with: relatedPost, in: context)
      post = managedPost
      
      let isHavingInvoice = managedPost.currentUserPurchaseInvoice != nil
      if isHavingInvoice != hadInvoice {
        triggerRefresh()
      }
    }
    
    return self
  }
  
  static func replaceOrCreate(with object: ChatRoomProtocol, in context: NSManagedObjectContext) -> ChatRoomManagedObject {
    let managedObject = ChatRoomManagedObject.findOrCreate(with: ChatRoomManagedObject.ID(object.identifier), in: context)
    return managedObject.replace(with: object, in: context)
  }
  
  static func updateOrCreate(with object: PartialChatRoomProtocol, in context: NSManagedObjectContext) -> ChatRoomManagedObject {
    
    let managedObject = ChatRoomManagedObject.findOrCreate(with: ChatRoomManagedObject.ID(object.identifier), in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension ChatRoomManagedObject {
  func triggerRefresh() {
    lastTriggeredUpdateDate = NSDate()
  }
}

extension ChatRoomManagedObject {
  static func createObservable(with object: ChatRoomProtocol, in context: NSManagedObjectContext) ->   ObservableManagedObject<ChatRoomManagedObject> {
    let id = Int32(object.identifier)
    let fetchRequest: NSFetchRequest<ChatRoomManagedObject> = ChatRoomManagedObject.fetchRequest()
    let observableManagedObject = ObservableManagedObject(id, fetchRequest: fetchRequest, context: context)
    return observableManagedObject
  }
  
  static func createObservable(with object: PartialChatRoomProtocol, in context: NSManagedObjectContext) -> ObservableManagedObject<ChatRoomManagedObject> {
    let id = Int32(object.identifier)
    let fetchRequest: NSFetchRequest<ChatRoomManagedObject> = ChatRoomManagedObject.fetchRequest()
    let observableManagedObject = ObservableManagedObject(id, fetchRequest: fetchRequest, context: context)
    return observableManagedObject
  }
}


//MARK:- MutableChatRoomProtocol

extension ChatRoomManagedObject: MutableChatRoomProtocol {
  func readAllMessages() {
    unreadMessageCount = 0
  }
  
  func setMuted(_ muted: Bool) {
    isMuted = muted
  }
  
  func setLeft(_ left: Bool) {
    isLeft = left
  }
}

extension ChatRoomManagedObject: ChatRoomProtocol {
  var lastGoodsOrder: GoodsOrderProtocol? {
    return lastRelatedGoodsOrder
  }
  
  var isMutedByCurrentUser: Bool {
    return isMuted
  }
  
  var isLeftByCurrentUser: Bool {
    return isLeft
  }
  
  var lastMessageInRoomCreatedAt: Date? {
    guard let lastMessageCreatedAt = lastMessageCreatedAt else {
      return nil
    }
    return Date(timeIntervalSince1970: lastMessageCreatedAt.timeIntervalSince1970)
  }
  
  var roomType: ChatRoomType {
    return ChatRoomType(rawValue: type ?? "") ?? .plain
  }
  
  var relatedPost: PostingProtocol? {
    return post
  }
  
  var relatedPostPreview: PartialPostingProtocol? {
    return nil
  }
  
  
  var identifier: Int {
    return Int(id)
  }
  
  var unreadMessegesCount: Int {
    return Int(unreadMessageCount)
  }
  
  var chatRoomUsers: [ChatRoomMemberProtocol] {
    return members?.allObjects as? [ChatRoomMemberManagedObject] ?? []
  }
  
  var lastMessageInRoom: ChatMessageEntity? {
    return lastMessage?.chatMessageEntity
  }
}

extension ChatRoomProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = ChatRoomManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = ChatRoomManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialChatRoomProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = ChatRoomManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = ChatRoomManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}


