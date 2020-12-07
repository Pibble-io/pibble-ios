//
//  CommentsInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

// MARK: - CommentsInteractor Class

final class CommentsInteractor: Interactor {
  fileprivate let coreDataStorage: CoreDataStorageServiceProtocol
  fileprivate let postingService: PostingServiceProtocol
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  
  fileprivate var paginationController: PaginationControllerProtocol
  fileprivate var posting: PostingProtocol
  fileprivate let commentsLengthMax = 500
  fileprivate var selectedReplyItem: CommentManagedObject?
  
  fileprivate var selectedItem: CommentManagedObject?
  
  fileprivate let eventTrackingService: EventsTrackingServiceProtocol
  
  fileprivate lazy var fetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy = {
    FetchedResultsControllerDelegateProxy(delegate: self)
  }()
  
  fileprivate lazy var fetchResultController: NSFetchedResultsController<CommentManagedObject> = {
    let fetchRequest: NSFetchRequest<CommentManagedObject> = CommentManagedObject.fetchRequest()
    fetchRequest.predicate = fetchPredicate()
    fetchRequest.sortDescriptors = sortDesriptors()
    fetchRequest.fetchBatchSize = 30
    
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStorage.viewContext, sectionNameKeyPath: #keyPath(CommentManagedObject.rootParentCommentId), cacheName: nil)
    
    fetchedResultsController.delegate = fetchedResultsControllerDelegateProxy
    return fetchedResultsController
  }()
  
  init(coreDataStorage: CoreDataStorageServiceProtocol,
       accountProfileService: AccountProfileServiceProtocol,
       postingService: PostingServiceProtocol,
       eventTrackingService: EventsTrackingServiceProtocol,
       posting: PostingProtocol) {
    
    self.coreDataStorage = coreDataStorage
    self.postingService = postingService
    self.accountProfileService = accountProfileService
    self.eventTrackingService = eventTrackingService
    self.paginationController = PaginationController(itemsPerPage: 10, requestItems: 10, shouldRefreshTop: false, shouldRefreshInTheMiddle: false)
    self.posting = posting
    
    super.init()
    self.paginationController.delegate = self
  }
}

// MARK: - CommentsInteractor API

extension CommentsInteractor: CommentsInteractorApi {
  var indexPathForSelectedItem: IndexPath? {
    guard let selectedItem = selectedItem else {
      return nil
    }
    
    return fetchResultController.indexPath(forObject: selectedItem)
  }
  
  func selectItemAt(_ indexPath: IndexPath?) {
    guard let indexPath = indexPath else {
      selectedItem = nil
      return
    }
    
    selectedItem = fetchResultController.object(at: indexPath)
  }
  
  var currentPost: PostingProtocol {
    return posting
  }
  
  func performDeleteItemAt(_ indexPath: IndexPath) {
    let comment = fetchResultController.object(at: indexPath)
    guard comment.isMyComment else {
      return
    }
    
    comment.setLocallyDeleted(true)
    let commentWithPosting = CommentsRelations.commentForPost(comment: comment, posting: posting, isPreviewComment: false)
    
    coreDataStorage.batchUpdateStorage(with: [commentWithPosting])
    postingService.deleteComment(post: posting, comment: comment)  { [weak self] in
      if let error = $0 {
        self?.presenter.handleError(error)
      }
    }
  }
  
  func performUpVoteAt(_ indexPath: IndexPath, withAmount: Int) {
    let comment = fetchResultController.object(at: indexPath)
    guard !comment.isUpVotedByUser else {
      return
    }
    
    
    //change local state instantly
    comment.addUpvotesAmount(withAmount)
    comment.upVoted = true
    
    let completeBlock: CompleteHandler = { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      if let err = $0 {
        strongSelf.presenter.handleError(err)
        comment.addUpvotesAmount(-withAmount)
        comment.upVoted = false
        return
      }
      
      strongSelf.postingService.showComment(postId: strongSelf.posting.identifier, commentId: comment.identifier) { [weak self] in
        switch $0 {
        case .success(let comment):
          guard let strongSelf = self else {
            return
          }
          strongSelf.coreDataStorage.updateStorage(with: [comment])
        case .failure(let error):
          self?.presenter.handleError(error)
          comment.addUpvotesAmount(-withAmount)
          comment.upVoted = false
        }
      }
    }
    
    postingService.upVoteComment(postId: posting.identifier, commentId: comment.identifier, amount: withAmount, complete: completeBlock)
  }
  
  func isSelectedReplyItemAt(_ indexPath: IndexPath) -> Bool {
    guard let selected = selectedReplyItem else {
      return false
    }
    
    let selectedIndexPath = fetchResultController.indexPath(forObject: selected)
    return selectedIndexPath == indexPath
  }
  
  func changeSelectedReplyStateForItemAt(_ indexPath: IndexPath) {
    guard let selected = selectedReplyItem else {
      selectedReplyItem = fetchResultController.object(at: indexPath)
      presenter.presentCollectionUpdates(CollectionViewModelUpdate.beginUpdates)
      presenter.presentCollectionUpdates(CollectionViewModelUpdate.update(idx: [indexPath]))
      presenter.presentCollectionUpdates(CollectionViewModelUpdate.endUpdates)
      return
    }
    
    let itemToSelect = itemAt(indexPath)
    
    guard itemToSelect.identifier != selected.identifier else {
      selectedReplyItem = nil
      presenter.presentCollectionUpdates(CollectionViewModelUpdate.beginUpdates)
      presenter.presentCollectionUpdates(CollectionViewModelUpdate.update(idx: [indexPath]))
      presenter.presentCollectionUpdates(CollectionViewModelUpdate.endUpdates)
      return
    }
    
    presenter.presentCollectionUpdates(CollectionViewModelUpdate.beginUpdates)
    
    guard let oldIndexPath = fetchResultController.indexPath(forObject: selected) else {
      selectedReplyItem = fetchResultController.object(at: indexPath)
      presenter.presentCollectionUpdates(CollectionViewModelUpdate.update(idx: [indexPath]))
      presenter.presentCollectionUpdates(CollectionViewModelUpdate.endUpdates)
      return
    }
    
    selectedReplyItem = fetchResultController.object(at: indexPath)
    presenter.presentCollectionUpdates(CollectionViewModelUpdate.update(idx: [oldIndexPath, indexPath]))
    presenter.presentCollectionUpdates(CollectionViewModelUpdate.endUpdates)
  }
  
  func setCommentText(_ text: String) {
    guard text.count >= commentsLengthMax else {
      return
    }
    
    let indexEndOfText = text.index(text.startIndex, offsetBy: commentsLengthMax)
    let cutText = String(text[..<indexEndOfText])
    presenter.presentCleanedCommentText(cutText)
  }
  
  func createCommentWith(_ text: String) {
    guard let parentComment = selectedReplyItem else {
      postCommentWith(text)
      return
    }
    
    postReplyCommentWith(text, parentComment: parentComment)
  }
  
  fileprivate func postCommentWith(_ text: String) {
    let commentBody = text.cleanedFromExtraNewLines()
    let commentDraft = CommentDraft(commentUser: accountProfileService.currentUserAccount, commentBody: commentBody)
    
    let commentDraftWithPost = CommentsRelations.commentForPost(comment: commentDraft, posting: posting, isPreviewComment: false)
    coreDataStorage.updateStorage(with: [commentDraftWithPost])
    presenter.presentCommentSendSuccess()
    //keep reference to storage service
    let storageService = coreDataStorage
    
    postingService.createCommentFor(postId: posting.identifier, body: commentBody) { [weak self] in
      //remove draft
      commentDraft.setLocallyDeleted(true)
      
      guard let strongSelf = self else {
        storageService.updateStorage(with: [commentDraft])
        return
      }
      
      switch $0 {
      case .success(let comment):
        let commentWithPosting = PartialCommentsRelations.commentForPost(comment: comment, posting: strongSelf.posting, isPreviewComment: false)
        
        storageService.updateStorage(with: [commentWithPosting, commentDraft])
      case .failure(let error):
        storageService.updateStorage(with: [commentDraft])
        strongSelf.presenter.handleError(error)
      }
    }
    
    trackPostCommentEvent()
  }
  
  fileprivate func trackPostCommentEvent() {
    guard let currentUser = accountProfileService.currentUserAccount else {
      accountProfileService.getProfile { [weak self] in
        guard let strongSelf = self else {
          return
        }
        
        switch $0 {
        case .success(let user):
          let event = InteractionEvent(type: .comment,
                                       postId: strongSelf.currentPost.identifier,
                                       userId: user.identifier,
                                       promoId: strongSelf.currentPost.postPromotion?.identifier)
          strongSelf.eventTrackingService.trackEvent(event)
        case .failure(let err):
          self?.presenter.handleError(err)
        }
      }
      
      return
    }
    
    let event = InteractionEvent(type: .comment,
                                 postId: currentPost.identifier,
                                 userId: currentUser.identifier,
                                 promoId: currentPost.postPromotion?.identifier)
    eventTrackingService.trackEvent(event)
  }
  
  fileprivate func postReplyCommentWith(_ text: String, parentComment: CommentProtocol) {
    let commentBody = text.cleanedFromExtraNewLines()
    let commentDraft = CommentDraft(commentUser: accountProfileService.currentUserAccount, commentBody: commentBody)
    
    let commentDraftReplyWithPost = CommentsRelations.replyForComment(comment: commentDraft, parentComment: parentComment, posting: posting, isPreviewComment: false)
    
    coreDataStorage.updateStorage(with: [commentDraftReplyWithPost])
    presenter.presentCommentSendSuccess()
    
    if let selected = selectedReplyItem,
      let indexPath = fetchResultController.indexPath(forObject: selected) {
      changeSelectedReplyStateForItemAt(indexPath)
    }
    
    //keep reference to storage service
    let storageService = coreDataStorage
    
    postingService.createCommentReplyFor(postId: posting.identifier,
                                         commentId: parentComment.identifier,
                                         body: commentBody) { [weak self] in
                                          
                                          
                                          //remove draft
                                          commentDraft.setLocallyDeleted(true)
                                          
                                          guard let strongSelf = self else {
                                            storageService.updateStorage(with: [commentDraft])
                                            return
                                          }
                                          
                                          switch $0 {
                                          case .success(let comment):
                                            let commentReplyWithPosting = PartialCommentsRelations.replyForComment(comment: comment, parentComment: parentComment, posting: strongSelf.posting, isPreviewComment: false)
                                            
                                            storageService.updateStorage(with: [commentReplyWithPosting, commentDraft])
                                          case .failure(let error):
                                            storageService.updateStorage(with: [commentDraft])
                                            self?.presenter.handleError(error)
                                          }
    }
  }
  
  func numberOfSections() -> Int {
    return fetchResultController.sections?.count ?? 0
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return fetchResultController.sections?[section].numberOfObjects ?? 0
  }
  
  func itemAt(_ indexPath: IndexPath) -> CommentProtocol {
    return fetchResultController.object(at: indexPath)
  }
  
  func prepareItemFor(_ indexPath: Int) {
    paginationController.paginateByIndex(indexPath)
  }
  
  func cancelPrepareItemFor(_ indexPath: Int) {
    
  }
  
  func initialFetchData() {
    do {
      try fetchResultController.performFetch()
    } catch {
      presenter.handleError(error)
    }
  }
  
  func initialRefresh() {
    paginationController.initialRequest()
    accountProfileService.getProfile { [weak self] in
      switch $0 {
      case .success(let user):
        self?.presenter.presentUserProfile(user)
      case .failure(let err):
        self?.presenter.handleError(err)
      }
    }
  }
  
  func refreshPostingItem() {
    postingService.showPosting(postId: posting.identifier) { [weak self] in
      switch $0 {
      case .success(let posting):
        self?.coreDataStorage.updateStorage(with: [posting])
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
}

// MARK: - Interactor Viper Components Api

fileprivate extension CommentsInteractor {
  var presenter: CommentsPresenterApi {
    return _presenter as! CommentsPresenterApi
  }
}

// MARK: - Helpers

extension CommentsInteractor {
  fileprivate func performFetchCommentsAndSaveToStorage(posting: PostingProtocol, page: Int, perPage: Int) {
    AppLogger.debug("performFetchCommentsAndSaveToStorage \(page)")
    
    postingService.fetchCommentsFor(postId: posting.identifier, page: page, perPage: perPage) { [weak self] in
      switch $0 {
      case .success(let comments):
        guard let strongSelf = self else {
          return
        }
        
        let commentsWithPosting = comments.0.map {
          return PartialCommentsRelations.commentForPost(comment: $0, posting: posting, isPreviewComment: false)
        }
        
        strongSelf.coreDataStorage.updateStorage(with: commentsWithPosting)
        strongSelf.paginationController.updatePaginationInfo(comments.1)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  fileprivate func fetchPredicate() -> NSPredicate? {
    let isDeletedPredicate = NSPredicate(format: "isLocallyDeletedComment == %@", NSNumber(value: false))
    let postPredicate = NSPredicate(format: "posting.id = \(posting.identifier)")
    
    return NSCompoundPredicate(andPredicateWithSubpredicates: [isDeletedPredicate, postPredicate])
  }
  
  fileprivate func sortDesriptors() -> [NSSortDescriptor] {
    let rootIdSortDescriptor = NSSortDescriptor(key: #keyPath(CommentManagedObject.rootParentCommentId), ascending: false)
    
    let idSortDescriptor = NSSortDescriptor(key: #keyPath(CommentManagedObject.id), ascending: false)
    let dateSortDescriptor = NSSortDescriptor(key: #keyPath(CommentManagedObject.createdAt), ascending: false)
    return [rootIdSortDescriptor, idSortDescriptor, dateSortDescriptor]
  }
}

//MARK:- FetchedResultsControllerDelegate

extension CommentsInteractor: FetchedResultsControllerDelegate {
  func updateItems(_ proxy: FetchedResultsControllerDelegateProxy, updates: CollectionViewModelUpdate) {
    presenter.presentCollectionUpdates(updates)
  }
}

//MARK:- PaginationControllerDelegate

extension CommentsInteractor: PaginationControllerDelegate {
  func request(page: Int, perPage: Int) {
    performFetchCommentsAndSaveToStorage(posting: posting, page: page, perPage: perPage)
  }
}
