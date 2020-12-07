//
//  Upvote+StorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 28.09.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import CoreData

extension UpvoteManagedObject: PartiallyUpdatable {
  
}

extension UpvoteManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  fileprivate func update(with object: UpvoteProtocol, in context: NSManagedObjectContext) {
    let managedObject = self
    
    managedObject.id = Int32(object.identifier)
    managedObject.amount = Int32(object.upvoteAmount)
   
    managedObject.setValueIfNotNil(\UpvoteManagedObject.upvoteBackAmount, value: object.profileUpvoteBackAmount.map { Int32($0) })
    
    if let user = object.upvotedUser {
      managedObject.fromUser = UserManagedObject.replaceOrCreate(with: user, in: context)
    }
  }
  
  static func replaceOrCreate(with object: UpvoteProtocol, in context: NSManagedObjectContext) -> UpvoteManagedObject {
    let managedObject = UpvoteManagedObject.findOrCreate(with: UpvoteManagedObject.ID(object.identifier), in: context)
    managedObject.update(with: object, in: context)
    return managedObject
  }
}

extension UpvoteManagedObject {
  func triggerRefresh() {
    lastTriggeredUpdateDate = NSDate()
  }
}

extension UpvoteManagedObject: UpvoteProtocol {
  var profileUpvoteBackAmount: Int? {
    return Int(upvoteBackAmount)
  }
  
  var upvoteAmount: Int {
    return Int(amount)
  }
  
  var identifier: Int {
    return Int(id)
  }
  
  var upvotedUser: UserProtocol? {
    return fromUser
  }
}

extension UpvoteProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = UpvoteManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = UpvoteManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

enum UpvotesRelations: CoreDataStorableRelation {
  case posting(upvote: UpvoteProtocol, posting: PostingProtocol)
  
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    switch self {
    case .posting(let upvote, let posting):
      let managedPosting = PostingManagedObject.replaceOrCreate(with: posting, in: context)
      let managedUpvote = UpvoteManagedObject.replaceOrCreate(with: upvote, in: context)
      managedUpvote.posting = managedPosting
      
    }
  }
   
  func delete(in context: NSManagedObjectContext) {
    switch self {
    case .posting(let upvote, _):
      let managedComment = UpvoteManagedObject.replaceOrCreate(with: upvote, in: context)
      context.delete(managedComment)
    }
  }
}

