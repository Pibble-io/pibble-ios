//
//  ChatSystemMessage+StorageExtensions.swift
//  Pibble
//
//  Created by Sergey Kazakov on 27/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

import CoreData

extension ChatSystemMessageManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  fileprivate func replace(with object: ChatSystemMessageProtocol, in context: NSManagedObjectContext) -> ChatSystemMessageManagedObject {
    id = Int32(object.identifier)
    messageType = object.chatMessageType.rawValue
    systemMessageType = object.chatSystemMessageType.rawValue
    text = object.messageText
    createdAt = object.messageCreatedAt
    
    if let parsedCreatedAtDate = object.messageCreatedAt.toDateWithCommonFormat() {
      createdAtDate = NSDate(timeIntervalSince1970: parsedCreatedAtDate.timeIntervalSince1970)
      
      if let createAtDateComponent = parsedCreatedAtDate.dateComponent() {
        dateComponent = NSDate(timeIntervalSince1970: createAtDateComponent.timeIntervalSince1970)
      }
    }
    
    if let user = object.messageFromUser {
      fromUser = UserManagedObject.replaceOrCreate(with: user, in: context)
    }
    
    if let relatedGoodsOrder = object.relatedGoodsOrder {
      goodsOrder = GoodsOrderManagedObject.replaceOrCreate(with: relatedGoodsOrder, in: context)
      goodsOrder?.chatRoom?.triggerRefresh()
    }
    
    return self
  }
  
  fileprivate func update(with object: PartialChatSystemMessageProtocol, in context: NSManagedObjectContext) -> ChatSystemMessageManagedObject {
    id = Int32(object.identifier)
    messageType = object.chatMessageType.rawValue
    systemMessageType = object.chatSystemMessageType.rawValue
    text = object.messageText
    createdAt = object.messageCreatedAt
    
    if let parsedCreatedAtDate = object.messageCreatedAt.toDateWithCommonFormat() {
      createdAtDate = NSDate(timeIntervalSince1970: parsedCreatedAtDate.timeIntervalSince1970)
      
      if let createAtDateComponent = parsedCreatedAtDate.dateComponent() {
        dateComponent = NSDate(timeIntervalSince1970: createAtDateComponent.timeIntervalSince1970)
      }
    }
    
    if let user = object.messageFromUser {
      fromUser = UserManagedObject.updateOrCreate(with: user, in: context)
    }
    
    if let relatedGoodsOrder = object.relatedGoodsOrder {
      goodsOrder = GoodsOrderManagedObject.replaceOrCreate(with: relatedGoodsOrder, in: context)
      goodsOrder?.chatRoom?.triggerRefresh()
    }
    
    return self
  }
  
  static func replaceOrCreate(with object: ChatSystemMessageProtocol, in context: NSManagedObjectContext) -> ChatSystemMessageManagedObject {
    let managedObject = ChatSystemMessageManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.replace(with: object, in: context)
  }
  
  static func updateOrCreate(with object: PartialChatSystemMessageProtocol, in context: NSManagedObjectContext) -> ChatSystemMessageManagedObject {
    let managedObject = ChatSystemMessageManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension ChatSystemMessageManagedObject: ChatSystemMessageProtocol {
  var chatSystemMessageType: ChatSystemMessageType {
    return ChatSystemMessageType(rawValue: systemMessageType ?? "")
  }
  
  var relatedGoodsOrder: GoodsOrderProtocol? {
    return goodsOrder
  }
  
  var messageText: String {
    return text ?? ""
  }
}

extension ChatSystemMessageProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = ChatSystemMessageManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = ChatSystemMessageManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialChatSystemMessageProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = ChatSystemMessageManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = ChatSystemMessageManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
