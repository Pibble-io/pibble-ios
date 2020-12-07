//
//  Tag+StorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 05.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension TagManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  static func replaceOrCreate(with object: TagProtocol, in context: NSManagedObjectContext) -> TagManagedObject {
    let managedObject = TagManagedObject.findOrCreate(with: object.identifier, in: context)
    
    managedObject.id = Int32(object.identifier)
    managedObject.tagString = object.cleanTagString
    managedObject.posted = Int32(object.postedCount)
    if let isFollowedByCurrentUser = object.isFollowedByCurrentUser {
      managedObject.isFollowed = isFollowedByCurrentUser
    }
    
    return managedObject
  }
}

extension TagManagedObject: ObservableManagedObjectProtocol {
  static func createObservable(with object: TagProtocol, in context: NSManagedObjectContext) ->   ObservableManagedObject<TagManagedObject> {
    let id = Int32(object.identifier)
    let fetchRequest: NSFetchRequest<TagManagedObject> = TagManagedObject.fetchRequest()
    let observableManagedObject = ObservableManagedObject(id, fetchRequest: fetchRequest, context: context)
    return observableManagedObject
  }
}

extension TagManagedObject: MutableTagProtocol {
  var cleanTagString: String {
    return tagString ?? ""
  }
  
  func setFollowingStateTo(_ following: Bool) {
    isFollowed = following
  }
  
  var isFollowedByCurrentUser: Bool? {
    return isFollowed
  }
  
  var identifier: Int {
    return Int(id)
  }
  
  var postedCount: Int {
    return Int(posted)
  }
}

enum TagsRelations: CoreDataStorableRelation {
  case related(tag: TagProtocol, to: [TagProtocol])
  case tagPosts(tag: TagProtocol, posts: [PartialPostingProtocol])
  case followedBy(tag: TagProtocol, user: UserProtocol)
 
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    switch self {
    case .related(let tag, let toTags):
      let managedTag = TagManagedObject.replaceOrCreate(with: tag, in: context)
      let managedRelatedTags = toTags.map { TagManagedObject.replaceOrCreate(with: $0, in: context) }
      
      managedRelatedTags.forEach {
        $0.addToRelatedTags(managedTag)
      }
      
      
    case .tagPosts(let tag, let posts):
      let managedTag = TagManagedObject.replaceOrCreate(with: tag, in: context)
      
      let managedPosts = posts.map { PostingManagedObject.updateOrCreate(with: $0, in: context) }
      
      managedPosts.forEach {
        $0.addToTags(managedTag)
      }
    case .followedBy(let tag, let user):
      let managedTag = TagManagedObject.replaceOrCreate(with: tag, in: context)
      let user = UserManagedObject.replaceOrCreate(with: user, in: context)
      managedTag.addToFollowedBy(user)
    }
  }
  
  func delete(in context: NSManagedObjectContext) {
    switch self {
    case .related(let tag, let toTags):
      let managedTag = TagManagedObject.replaceOrCreate(with: tag, in: context)
      let managedRelatedTags = toTags.map { TagManagedObject.replaceOrCreate(with: $0, in: context) }
      
      managedRelatedTags.forEach {
        $0.removeFromRelatedTags(managedTag)
      }
      
    case .tagPosts(let tag, let posts):
      let managedTag = TagManagedObject.replaceOrCreate(with: tag, in: context)
      
      let managedPosts = posts.map { PostingManagedObject.updateOrCreate(with: $0, in: context) }
      
      managedPosts.forEach {
        $0.removeFromTags(managedTag)
      }
    case .followedBy(let tag, let user):
      let managedTag = TagManagedObject.replaceOrCreate(with: tag, in: context)
      let user = UserManagedObject.replaceOrCreate(with: user, in: context)
      managedTag.removeFromFollowedBy(user)
    }
  }
}

extension TagProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = TagManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = TagManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
