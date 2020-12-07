//
//  PostHelpAnswer+StorageExtensions.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 02/10/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//
import Foundation
import CoreData

extension PostHelpAnswerManagedObject: PartiallyUpdatable {
  
}

//MARK:- MappableManagedObject

extension PostHelpAnswerManagedObject: MappableManagedObject {
  typealias ID = Int32
  
  static func replaceOrCreate(with object: PostHelpAnswerProtocol, parentComment: PostHelpAnswerManagedObject?, relatedPosting: PostHelpRequestManagedObject?, in context: NSManagedObjectContext) -> PostHelpAnswerManagedObject {
    guard object.isDraftAnswer else {
      let managedObject = PostHelpAnswerManagedObject.findOrCreate(with: object.identifier, in: context)
      managedObject.replace(with: object, parentComment: parentComment, relatedPosting: relatedPosting, in: context)
      return managedObject
    }
    
    let uuidPredicate = NSPredicate(format: "uuid = %@", object.answerUUID)
    let managedObject = PostHelpAnswerManagedObject.findOrCreate(predicate: uuidPredicate, in: context)
    managedObject.replace(with: object, parentComment: parentComment, relatedPosting: relatedPosting, in: context)
    return managedObject
  }
  
  static func updateOrCreate(with object: PartialPostHelpAnswerProtocol, parentComment: PostHelpAnswerManagedObject?, relatedPosting: PostHelpRequestManagedObject?, in context: NSManagedObjectContext) -> PostHelpAnswerManagedObject {
    guard object.isDraftAnswer else {
      let managedObject = PostHelpAnswerManagedObject.findOrCreate(with: object.identifier, in: context)
      managedObject.update(with: object, parentComment: parentComment, relatedPosting: relatedPosting, in: context)
      return managedObject
    }
    
    let uuidPredicate = NSPredicate(format: "uuid = %@", object.answerUUID)
    let managedObject = PostHelpAnswerManagedObject.findOrCreate(predicate: uuidPredicate, in: context)
    managedObject.update(with: object, parentComment: parentComment, relatedPosting: relatedPosting, in: context)
    return managedObject
  }
  
  static func replaceOrCreate(with object: PostHelpAnswerProtocol, in context: NSManagedObjectContext) -> PostHelpAnswerManagedObject {
    let managedObject = PostHelpAnswerManagedObject.replaceOrCreate(with: object, parentComment: nil, relatedPosting: nil, in: context)
    return managedObject
  }
  
  static func updateOrCreate(with object: PartialPostHelpAnswerProtocol, in context: NSManagedObjectContext) -> PostHelpAnswerManagedObject {
    let managedObject = PostHelpAnswerManagedObject.updateOrCreate(with: object, parentComment: nil, relatedPosting: nil, in: context)
    return managedObject
  }
}

//MARK:- Primary mapping methods

extension PostHelpAnswerManagedObject {
  fileprivate func replace(with object: PostHelpAnswerProtocol, parentComment: PostHelpAnswerManagedObject?, relatedPosting: PostHelpRequestManagedObject?, in context: NSManagedObjectContext) {
    let managedObject = self
    
    managedObject.createdAt = object.createdAtDate.toNSDate
    managedObject.updatedAt = object.updatedAtDate.toNSDate
    managedObject.id = Int32(object.identifier)
    managedObject.body = object.answerBody
    managedObject.upVoted = object.isUpVotedByUser
    managedObject.isCurentUserComment = object.isMyAnswer
    managedObject.upVotesAmount = Int32(object.answerUpVotesAmount)
    managedObject.uuid = object.answerUUID
    managedObject.isDraft = object.isDraftAnswer
    managedObject.isPicked = object.isPickedAnswer
    
    managedObject.isLocallyDeletedComment = object.isAnswerDeleted
    
    if let user = object.answerUser {
      managedObject.user = UserManagedObject.replaceOrCreate(with: user, in: context)
    }
    
    if let posting = relatedPosting {
      managedObject.postHelpRequest = posting
    }
    
    if let parent = parentComment {
      managedObject.parentAnswer = parent
      managedObject.isReply = true
    }
    
    managedObject.rootParentCommentId = managedObject.parentAnswer?.rootParentCommentId ?? managedObject.id
    
    for reply in object.repliesAnswers {
      let _ = PostHelpAnswerManagedObject.replaceOrCreate(with: reply, parentComment: managedObject, relatedPosting: relatedPosting, in: context)
    }
  }
  
  fileprivate func update(with object: PartialPostHelpAnswerProtocol, parentComment: PostHelpAnswerManagedObject?, relatedPosting: PostHelpRequestManagedObject?, in context: NSManagedObjectContext) {
    let managedObject = self
    
    managedObject.createdAt = object.createdAtDate?.toNSDate
    managedObject.updatedAt = object.updatedAtDate?.toNSDate
    managedObject.id = Int32(object.identifier)
    managedObject.body = object.answerBody
    managedObject.uuid = object.answerUUID
    managedObject.isDraft = object.isDraftAnswer
    managedObject.isPicked = object.isPickedAnswer
    
    managedObject.setValueIfNotNil(\PostHelpAnswerManagedObject.upVoted , value: object.isUpVotedByUser)
    managedObject.setValueIfNotNil(\PostHelpAnswerManagedObject.isCurentUserComment , value: object.isMyAnswer)
    managedObject.setValueIfNotNil(\PostHelpAnswerManagedObject.upVotesAmount , value: object.answerUpVotesAmount.map { Int32($0) })
    
    managedObject.setValueIfNotNil(\PostHelpAnswerManagedObject.isLocallyDeletedComment , value: object.isAnswerDeleted)
    
    
    if let user = object.answerUser {
      managedObject.user = UserManagedObject.updateOrCreate(with: user, in: context)
    }
    
    if let posting = relatedPosting {
      managedObject.postHelpRequest = posting
    }
    
    if let parent = parentComment {
      managedObject.parentAnswer = parent
      managedObject.isReply = true
    }
    
    managedObject.rootParentCommentId = managedObject.parentAnswer?.rootParentCommentId ?? managedObject.id
   
    if let replies = object.repliesAnswers {
      for reply in replies {
        let _ = PostHelpAnswerManagedObject.updateOrCreate(with: reply, parentComment: managedObject, relatedPosting: relatedPosting, in: context)
      }
    }
  }
}

extension PostHelpAnswerManagedObject {
  fileprivate func triggerRepliesUpdate() {
    let repliesObjects = replies?.allObjects as? [PostHelpAnswerManagedObject] ?? []
    repliesObjects.forEach {
      $0.shouldTriggerUpdate = !$0.shouldTriggerUpdate
      $0.triggerRepliesUpdate()
    }
  }
  
  func setLocallyDeleted(_ deleted: Bool) {
    isLocallyDeletedComment = deleted
    triggerRepliesUpdate()
  }
}

extension PostHelpAnswerManagedObject: PostHelpAnswerProtocol {
  var isPickedAnswer: Bool {
    return isPicked
  }
  
  var isDraftAnswer: Bool {
    return isDraft
  }
  
  var isAnswerDeleted: Bool {
    return isLocallyDeletedComment
  }
  
  var isParentAnswerDeleted: Bool? {
    return parentAnswer?.isLocallyDeletedComment ?? false
  }
  
  var answerUpVotesAmount: Int {
    return Int(upVotesAmount)
  }
  
  var isMyAnswer: Bool {
    return isCurentUserComment
  }
  
  var isUpVotedByUser: Bool {
    return upVoted
  }
  
  var isReplyAnswer: Bool? {
    return isReply
  }
  
  var repliesAnswers: [PostHelpAnswerProtocol] {
    return replies?.allObjects as? [PostHelpAnswerManagedObject] ?? []
  }
  
  var identifier: Int {
    return Int(id)
  }
  
  var answerUUID: String {
    return uuid ?? ""
  }
  
  var answerBody: String {
    return body ?? ""
  }
  
  var createdAtDate: Date {
    return createdAt?.toDate ?? Date(timeIntervalSince1970: 0.0)
  }
  
  var updatedAtDate: Date {
    return updatedAt?.toDate ?? Date(timeIntervalSince1970: 0.0)
  }
  
  var answerUser: UserProtocol? {
    return user
  }
}

enum PartialPostHelpAnswerRelations: CoreDataStorableRelation {
  case answerForPostHelpRequest(answer: PartialPostHelpAnswerProtocol, postHelpRequest: PostHelpRequestProtocol)
  case replyForAnswer(answer: PartialPostHelpAnswerProtocol, parentAnswer: PostHelpAnswerProtocol, postHelpRequest: PostHelpRequestProtocol)
  
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    switch self {
    case .answerForPostHelpRequest(let answer, let postHelpRequest):
      let managedPosting = PostHelpRequestManagedObject.replaceOrCreate(with: postHelpRequest, in: context)
      let _ = PostHelpAnswerManagedObject.updateOrCreate(with: answer, parentComment: nil, relatedPosting: managedPosting, in: context)
      
    case .replyForAnswer(let answer, let parentAnswer, let postHelpRequest):
      let managedPosting = PostHelpRequestManagedObject.replaceOrCreate(with: postHelpRequest, in: context)
      let managedParentComment = PostHelpAnswerManagedObject.replaceOrCreate(with: parentAnswer, parentComment: nil, relatedPosting: managedPosting, in: context)
      let _ = PostHelpAnswerManagedObject.updateOrCreate(with: answer, parentComment: managedParentComment, relatedPosting: managedPosting, in: context)
    }
  }
  
  func delete(in context: NSManagedObjectContext) {
    switch self {
    case .answerForPostHelpRequest(let comment, _):
      let managedComment = PostHelpAnswerManagedObject.updateOrCreate(with: comment, in: context)
      context.delete(managedComment)
    case .replyForAnswer(let comment, _, _):
      let managedComment = PostHelpAnswerManagedObject.updateOrCreate(with: comment, in: context)
      context.delete(managedComment)
    }
  }
}

enum PostHelpAnswerRelations: CoreDataStorableRelation {
  case answerForPostHelpRequest(answer: PostHelpAnswerProtocol, postHelpRequest: PostHelpRequestProtocol)
  case replyForAnswer(answer: PostHelpAnswerProtocol, parentAnswer: PostHelpAnswerProtocol, postHelpRequest: PostHelpRequestProtocol)
  
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    switch self {
    case .answerForPostHelpRequest(let answer, let postHelpRequest):
      let managedPosting = PostHelpRequestManagedObject.replaceOrCreate(with: postHelpRequest, in: context)
      let _ = PostHelpAnswerManagedObject.replaceOrCreate(with: answer, parentComment: nil, relatedPosting: managedPosting, in: context)
      
    case .replyForAnswer(let answer, let parentAnswer, let postHelpRequest):
      let managedPosting = PostHelpRequestManagedObject.replaceOrCreate(with: postHelpRequest, in: context)
      let managedParentComment = PostHelpAnswerManagedObject.replaceOrCreate(with: parentAnswer, parentComment: nil, relatedPosting: managedPosting, in: context)
      let _ = PostHelpAnswerManagedObject.replaceOrCreate(with: answer, parentComment: managedParentComment, relatedPosting: managedPosting, in: context)
    }
  }
  
  func delete(in context: NSManagedObjectContext) {
    switch self {
    case .answerForPostHelpRequest(let comment, _):
      let managedComment = PostHelpAnswerManagedObject.replaceOrCreate(with: comment, in: context)
      context.delete(managedComment)
    case .replyForAnswer(let comment, _, _):
      let managedComment = PostHelpAnswerManagedObject.replaceOrCreate(with: comment, in: context)
      context.delete(managedComment)
    }
  }
}

extension PostHelpAnswerProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = PostHelpAnswerManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = PostHelpAnswerManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

extension PartialPostHelpAnswerProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = PostHelpAnswerManagedObject.updateOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = PostHelpAnswerManagedObject.updateOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}

protocol MutablePostHelpAnswerProtocol {
  func setPickedAsHelp(_ picked: Bool)
}


extension PostHelpAnswerManagedObject: MutablePostHelpAnswerProtocol {
  func setPickedAsHelp(_ picked: Bool) {
    isPicked = picked
  }
}
