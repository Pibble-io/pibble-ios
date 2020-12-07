//
//  Comments+StorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 08.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension CommentManagedObject: PartiallyUpdatable {
  
}

//MARK:- MappableManagedObject

extension CommentManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  static func replaceOrCreate(with object: CommentProtocol, parentComment: CommentManagedObject?, relatedPosting: PostingManagedObject?, isPreviewComment: Bool, in context: NSManagedObjectContext) -> CommentManagedObject {
    guard object.isDraftComment else {
      let managedObject = CommentManagedObject.findOrCreate(with: object.identifier, in: context)
      managedObject.replace(with: object, parentComment: parentComment, relatedPosting: relatedPosting, isPreviewComment: isPreviewComment, in: context)
      return managedObject
    }
    
    let uuidPredicate = NSPredicate(format: "uuid = %@", object.commentUUID)
    let managedObject = CommentManagedObject.findOrCreate(predicate: uuidPredicate, in: context)
    managedObject.replace(with: object, parentComment: parentComment, relatedPosting: relatedPosting, isPreviewComment: isPreviewComment, in: context)
    return managedObject
  }
  
  static func updateOrCreate(with object: PartialCommentProtocol, parentComment: CommentManagedObject?, relatedPosting: PostingManagedObject?, isPreviewComment: Bool, in context: NSManagedObjectContext) -> CommentManagedObject {
    guard object.isDraftComment else {
      let managedObject = CommentManagedObject.findOrCreate(with: object.identifier, in: context)
      managedObject.update(with: object, parentComment: parentComment, relatedPosting: relatedPosting, isPreviewComment: isPreviewComment, in: context)
      return managedObject
    }
    
    let uuidPredicate = NSPredicate(format: "uuid = %@", object.commentUUID)
    let managedObject = CommentManagedObject.findOrCreate(predicate: uuidPredicate, in: context)
    managedObject.update(with: object, parentComment: parentComment, relatedPosting: relatedPosting, isPreviewComment: isPreviewComment, in: context)
    return managedObject
  }
  
  static func replaceOrCreate(with object: CommentProtocol, in context: NSManagedObjectContext) -> CommentManagedObject {
    let managedObject = CommentManagedObject.replaceOrCreate(with: object, parentComment: nil, relatedPosting: nil, isPreviewComment: false, in: context)
    return managedObject
  }
  
  static func updateOrCreate(with object: PartialCommentProtocol, in context: NSManagedObjectContext) -> CommentManagedObject {
    let managedObject = CommentManagedObject.updateOrCreate(with: object, parentComment: nil, relatedPosting: nil, isPreviewComment: false, in: context)
    return managedObject
  }
}

//MARK:- Primary mapping methods

extension CommentManagedObject {
  fileprivate func replace(with object: CommentProtocol, parentComment: CommentManagedObject?, relatedPosting: PostingManagedObject?, isPreviewComment: Bool, in context: NSManagedObjectContext) {
    let managedObject = self
    
    managedObject.createdAt = object.createdAtDate.toNSDate
    managedObject.updatedAt = object.updatedAtDate.toNSDate
    managedObject.id = Int32(object.identifier)
    managedObject.body = object.commentBody
    managedObject.upVoted = object.isUpVotedByUser
    managedObject.isCurentUserComment = object.isMyComment
    managedObject.upVotesAmount = Int32(object.commentUpVotesAmount)
    managedObject.uuid = object.commentUUID
    managedObject.isDraft = object.isDraftComment
    
    managedObject.isLocallyDeletedComment = object.isCommentDeleted
    
    if let user = object.commentUser {
      managedObject.user = UserManagedObject.replaceOrCreate(with: user, in: context)
    }
    
    if let posting = relatedPosting {
      managedObject.posting = posting
      if isPreviewComment {
        managedObject.inPreviewOfPosting = posting
      }
    }
    
    if let parent = parentComment {
      managedObject.parentComment = parent
      managedObject.isReply = true
      if isPreviewComment {
        managedObject.previewParentComment = parent
      }
    }
    
    managedObject.rootParentCommentId = managedObject.parentComment?.rootParentCommentId ?? managedObject.id
    
    let replies = isPreviewComment ? object.repliesCommentsPreview : object.repliesComments
    for reply in replies {
      let _ = CommentManagedObject.replaceOrCreate(with: reply, parentComment: managedObject, relatedPosting: relatedPosting, isPreviewComment: isPreviewComment, in: context)
    }
  }
  
  fileprivate func update(with object: PartialCommentProtocol, parentComment: CommentManagedObject?, relatedPosting: PostingManagedObject?, isPreviewComment: Bool, in context: NSManagedObjectContext) {
    let managedObject = self
    
    managedObject.createdAt = object.createdAtDate?.toNSDate
    managedObject.updatedAt = object.updatedAtDate?.toNSDate
    managedObject.id = Int32(object.identifier)
    managedObject.body = object.commentBody
    managedObject.uuid = object.commentUUID
    managedObject.isDraft = object.isDraftComment
    
    managedObject.setValueIfNotNil(\CommentManagedObject.upVoted , value: object.isUpVotedByUser)
    managedObject.setValueIfNotNil(\CommentManagedObject.isCurentUserComment , value: object.isMyComment)
    managedObject.setValueIfNotNil(\CommentManagedObject.upVotesAmount , value: object.commentUpVotesAmount.map { Int32($0) })
    
    managedObject.setValueIfNotNil(\CommentManagedObject.isLocallyDeletedComment , value: object.isCommentDeleted)
    
    
    if let user = object.commentUser {
      managedObject.user = UserManagedObject.updateOrCreate(with: user, in: context)
    }
    
    if let posting = relatedPosting {
      managedObject.posting = posting
      if isPreviewComment {
        managedObject.inPreviewOfPosting = posting
      }
    }
    
    if let parent = parentComment {
      managedObject.parentComment = parent
      managedObject.isReply = true
      if isPreviewComment {
        managedObject.previewParentComment = parent
      }
    }
    
    managedObject.rootParentCommentId = managedObject.parentComment?.rootParentCommentId ?? managedObject.id
    
    if let replies = isPreviewComment ? object.repliesCommentsPreview : object.repliesComments {
      for reply in replies {
        let _ = CommentManagedObject.updateOrCreate(with: reply, parentComment: managedObject, relatedPosting: relatedPosting, isPreviewComment: isPreviewComment, in: context)
      }
    }
  }
}

extension CommentManagedObject {
  fileprivate func triggerRepliesUpdate() {
    let repliesObjects = replies?.allObjects as? [CommentManagedObject] ?? []
    repliesObjects.forEach {
      $0.shouldTriggerUpdate = !$0.shouldTriggerUpdate
      $0.triggerRepliesUpdate()
    }
  }
  
  func setLocallyDeleted(_ deleted: Bool) {
    isLocallyDeletedComment = deleted
    triggerRepliesUpdate()
  }
  
  func addUpvotesAmount(_ amount: Int) {
    upVotesAmount += Int32(upVotesAmount)
  }
}

extension CommentManagedObject: CommentProtocol {
  var isDraftComment: Bool {
    return isDraft
  }
  
  var isCommentDeleted: Bool {
    return isLocallyDeletedComment
  }
  
  var isParentCommentDeleted: Bool? {
    return parentComment?.isLocallyDeletedComment ?? false
  }
  
  var repliesCommentsPreview: [CommentProtocol] {
    return previewReplies?.allObjects as? [CommentManagedObject] ?? []
  }
  
  var commentUpVotesAmount: Int {
    return Int(upVotesAmount)
  }
  
  var isMyComment: Bool {
    return isCurentUserComment
  }
  
  var isUpVotedByUser: Bool {
    return upVoted
  }
  
  var isReplyComment: Bool? {
    return isReply
  }
  
  var repliesComments: [CommentProtocol] {
    return replies?.allObjects as? [CommentManagedObject] ?? []
  }
  
  var identifier: Int {
    return Int(id)
  }
  
  var commentUUID: String {
    return uuid ?? ""
  }
  
  var commentBody: String {
    return body ?? ""
  }
  
  var createdAtDate: Date {
    return createdAt?.toDate ?? Date(timeIntervalSince1970: 0.0)
  }
  
  var updatedAtDate: Date {
    return updatedAt?.toDate ?? Date(timeIntervalSince1970: 0.0)
  }
  
  var commentUser: UserProtocol? {
    return user
  }
}

enum PartialCommentsRelations: CoreDataStorableRelation {
  case commentForPost(comment: PartialCommentProtocol, posting: PostingProtocol, isPreviewComment: Bool)
  case replyForComment(comment: PartialCommentProtocol, parentComment: CommentProtocol, posting: PostingProtocol, isPreviewComment: Bool)
  
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    switch self {
    case .commentForPost(let comment, let posting, let isPreviewComment):
      let managedPosting = PostingManagedObject.replaceOrCreate(with: posting, in: context)
      let _ = CommentManagedObject.updateOrCreate(with: comment, parentComment: nil, relatedPosting: managedPosting, isPreviewComment: isPreviewComment, in: context)
      
    case .replyForComment(let comment, let parentComment, let posting, let isPreviewComment):
      let managedPosting = PostingManagedObject.replaceOrCreate(with: posting, in: context)
      let managedParentComment = CommentManagedObject.replaceOrCreate(with: parentComment, parentComment: nil, relatedPosting: managedPosting, isPreviewComment: false, in: context)
      let _ = CommentManagedObject.updateOrCreate(with: comment, parentComment: managedParentComment, relatedPosting: managedPosting, isPreviewComment: isPreviewComment, in: context)
    }
  }
  
  func delete(in context: NSManagedObjectContext) {
    switch self {
    case .commentForPost(let comment, _, _):
      let managedComment = CommentManagedObject.updateOrCreate(with: comment, in: context)
      context.delete(managedComment)
    case .replyForComment(let comment, _, _, _):
      let managedComment = CommentManagedObject.updateOrCreate(with: comment, in: context)
      context.delete(managedComment)
    }
  }
}

enum CommentsRelations: CoreDataStorableRelation {
  case commentForPost(comment: CommentProtocol, posting: PostingProtocol, isPreviewComment: Bool)
  case replyForComment(comment: CommentProtocol, parentComment: CommentProtocol, posting: PostingProtocol, isPreviewComment: Bool)
  
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    switch self {
    case .commentForPost(let comment, let posting, let isPreviewComment):
      let managedPosting = PostingManagedObject.replaceOrCreate(with: posting, in: context)
      let _ = CommentManagedObject.replaceOrCreate(with: comment, parentComment: nil, relatedPosting: managedPosting, isPreviewComment: isPreviewComment, in: context)
      
     case .replyForComment(let comment, let parentComment, let posting, let isPreviewComment):
      let managedPosting = PostingManagedObject.replaceOrCreate(with: posting, in: context)
      let managedParentComment = CommentManagedObject.replaceOrCreate(with: parentComment, parentComment: nil, relatedPosting: managedPosting, isPreviewComment: false, in: context)
      let _ = CommentManagedObject.replaceOrCreate(with: comment, parentComment: managedParentComment, relatedPosting: managedPosting, isPreviewComment: isPreviewComment, in: context)
    }
  }
  
  func delete(in context: NSManagedObjectContext) {
    switch self {
    case .commentForPost(let comment, _, _):
      let managedComment = CommentManagedObject.replaceOrCreate(with: comment, in: context)
      context.delete(managedComment)
    case .replyForComment(let comment, _, _, _):
      let managedComment = CommentManagedObject.replaceOrCreate(with: comment, in: context)
      context.delete(managedComment)
    }
  }
}

extension CommentProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = CommentManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = CommentManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialCommentProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = CommentManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = CommentManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
