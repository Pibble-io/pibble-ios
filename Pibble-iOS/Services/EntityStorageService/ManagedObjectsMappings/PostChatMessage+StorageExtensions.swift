//
//  PostChatMessage+StorageExtensions.swift
//  Pibble
//
//  Created by Sergey Kazakov on 18/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

//ChatPostMessageProtocol


import CoreData

extension PostChatMessageManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  fileprivate func replace(with object: ChatPostMessageProtocol, in context: NSManagedObjectContext) -> PostChatMessageManagedObject {
    id = Int32(object.identifier)
    messageType = object.chatMessageType.rawValue
    createdAt = object.messageCreatedAt
    
    if let parsedCreatedAtDate = object.messageCreatedAt.toDateWithCommonFormat() {
      createdAtDate = NSDate(timeIntervalSince1970: parsedCreatedAtDate.timeIntervalSince1970)
      
      if let createAtDateComponent = parsedCreatedAtDate.dateComponent() {
        dateComponent = NSDate(timeIntervalSince1970: createAtDateComponent.timeIntervalSince1970)
      }
    }
    
    if let quotedPost = object.quotedPost {
      post = PostingManagedObject.replaceOrCreate(with: quotedPost, in: context)
    }
    
    if let user = object.messageFromUser {
      fromUser = UserManagedObject.replaceOrCreate(with: user, in: context)
    }
    
    if let attachedInvoice = object.attachedInvoice {
      invoice = InvoiceManagedObject.replaceOrCreate(with: attachedInvoice, in: context)
    }
    
    return self
  }
  
  fileprivate func update(with object: PartialChatPostMessageProtocol, in context: NSManagedObjectContext) -> PostChatMessageManagedObject {
    id = Int32(object.identifier)
    messageType = object.chatMessageType.rawValue
    createdAt = object.messageCreatedAt
    
    if let parsedCreatedAtDate = object.messageCreatedAt.toDateWithCommonFormat() {
      createdAtDate = NSDate(timeIntervalSince1970: parsedCreatedAtDate.timeIntervalSince1970)
      
      if let createAtDateComponent = parsedCreatedAtDate.dateComponent() {
        dateComponent = NSDate(timeIntervalSince1970: createAtDateComponent.timeIntervalSince1970)
      }
    }
    
    if let quotedPost = object.quotedPost {
      post = PostingManagedObject.updateOrCreate(with: quotedPost, in: context)
    }
    
    if let user = object.messageFromUser {
      fromUser = UserManagedObject.updateOrCreate(with: user, in: context)
    }
    
    if let attachedInvoice = object.attachedInvoice {
      invoice = InvoiceManagedObject.updateOrCreate(with: attachedInvoice, in: context)
    }
    
    return self
  }
  
  
  
  static func replaceOrCreate(with object: ChatPostMessageProtocol, in context: NSManagedObjectContext) -> PostChatMessageManagedObject {
    let managedObject = PostChatMessageManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.replace(with: object, in: context)
  }
  
  static func updateOrCreate(with object: PartialChatPostMessageProtocol, in context: NSManagedObjectContext) -> PostChatMessageManagedObject {
    let managedObject = PostChatMessageManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension PostChatMessageManagedObject: ChatPostMessageProtocol {
  var attachedInvoice: InvoiceProtocol? {
    return invoice
  }
  
  var quotedPost: PostingProtocol? {
    return post
  }
}

extension ChatPostMessageProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = PostChatMessageManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = PostChatMessageManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialChatPostMessageProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = PostChatMessageManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = PostChatMessageManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
