//
//  ChatRoomMember+StorageExtensions.swift
//  Pibble
//
//  Created by Sergey Kazakov on 11/04/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

extension ChatRoomMemberManagedObject: MappableManagedObject {
  typealias ID = String?
  
  fileprivate func update(with object: ChatRoomMemberProtocol, in context: NSManagedObjectContext) -> ChatRoomMemberManagedObject {
    id = object.identifier
    deletedAt = object.memberDeletedAt
    
    if let relatedUser = object.relatedUser {
      user = UserManagedObject.replaceOrCreate(with: relatedUser, in: context)
    }
    
    return self
  }
  
  static func replaceOrCreate(with object: ChatRoomMemberProtocol, in context: NSManagedObjectContext) -> ChatRoomMemberManagedObject {
    let managedObject = ChatRoomMemberManagedObject.findOrCreate(with: object.identifier, in: context)
    return managedObject.update(with: object, in: context)
  }
}

extension ChatRoomMemberManagedObject: ChatRoomMemberProtocol {
  var identifier: String {
    return id ?? ""
  }
  
  var memberDeletedAt: String? {
    return deletedAt
  }
  
  var relatedUser: UserProtocol? {
    return user
  }
}

extension ChatRoomMemberProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = ChatRoomMemberManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = ChatRoomMemberManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

