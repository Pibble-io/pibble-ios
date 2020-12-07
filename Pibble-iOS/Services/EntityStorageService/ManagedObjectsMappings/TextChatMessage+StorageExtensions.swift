//
//  TextChatMessage+StorageExtensions.swift
//  Pibble
//
//  Created by Sergey Kazakov on 13/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension TextChatMessageManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  fileprivate func replace(with object: ChatTextMessageProtocol, in context: NSManagedObjectContext) -> TextChatMessageManagedObject {
    id = Int32(object.identifier)
    messageType = object.chatMessageType.rawValue
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
    
    return self
  }
  
  fileprivate func update(with object: PartialChatTextMessageProtocol, in context: NSManagedObjectContext) -> TextChatMessageManagedObject {
    id = Int32(object.identifier)
    messageType = object.chatMessageType.rawValue
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
    
    return self
  }
  
  static func replaceOrCreate(with object: ChatTextMessageProtocol, in context: NSManagedObjectContext) -> TextChatMessageManagedObject {
    let managedObject = TextChatMessageManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.replace(with: object, in: context)
  }
  
  static func updateOrCreate(with object: PartialChatTextMessageProtocol, in context: NSManagedObjectContext) -> TextChatMessageManagedObject {
    let managedObject = TextChatMessageManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension TextChatMessageManagedObject: ChatTextMessageProtocol {
  var messageText: String {
    return text ?? ""
  }
}


extension ChatTextMessageProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = TextChatMessageManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = TextChatMessageManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialChatTextMessageProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = TextChatMessageManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = TextChatMessageManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
