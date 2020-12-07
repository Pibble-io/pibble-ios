//
//  PostHelpAnswersInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

// MARK: - PostHelpAnswersInteractor Class
final class PostHelpAnswersInteractor: Interactor {
  fileprivate let coreDataStorage: CoreDataStorageServiceProtocol
  fileprivate let postHelpService: PostHelpServiceProtocol
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  
  fileprivate var paginationController: PaginationControllerProtocol
  fileprivate var initialPostHelpRequest: PostHelpRequestProtocol
  
  fileprivate lazy var observablePostHelpRequest: ObservableManagedObject<PostHelpRequestManagedObject> = {
    let observablePostHelpRequest = PostHelpRequestManagedObject.createObservable(with: initialPostHelpRequest, in: coreDataStorage.viewContext)
    
    observablePostHelpRequest.observationHandler = { [weak self] in
      self?.presenter.presentPostHelpRequest($0)
    }
    
    observablePostHelpRequest.performFetch { [weak self] in
      switch $0 {
      case .success(let postHelpRequest):
        if let postHelpRequest = postHelpRequest {
          self?.presenter.presentPostHelpRequest(postHelpRequest)
        }
        
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
    
    return observablePostHelpRequest
  }()

  
  fileprivate let answerLengthMax = 500
  fileprivate var selectedReplyItem: PostHelpAnswerManagedObject?
  
  fileprivate var selectedItem: PostHelpAnswerManagedObject?
  
  fileprivate let eventTrackingService: EventsTrackingServiceProtocol
  
  fileprivate lazy var fetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy = {
    FetchedResultsControllerDelegateProxy(delegate: self)
  }()
  
  fileprivate lazy var fetchResultController: NSFetchedResultsController<PostHelpAnswerManagedObject> = {
    let fetchRequest: NSFetchRequest<PostHelpAnswerManagedObject> = PostHelpAnswerManagedObject.fetchRequest()
    fetchRequest.predicate = fetchPredicate()
    fetchRequest.sortDescriptors = sortDesriptors()
    fetchRequest.fetchBatchSize = 30
    
    let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStorage.viewContext, sectionNameKeyPath: #keyPath(CommentManagedObject.rootParentCommentId), cacheName: nil)
    
    fetchedResultsController.delegate = fetchedResultsControllerDelegateProxy
    return fetchedResultsController
  }()
  
  init(coreDataStorage: CoreDataStorageServiceProtocol,
       accountProfileService: AccountProfileServiceProtocol,
       postHelpService: PostHelpServiceProtocol, eventTrackingService: EventsTrackingServiceProtocol,
       postHelpRequest: PostHelpRequestProtocol) {
    self.coreDataStorage = coreDataStorage
    self.postHelpService = postHelpService
    self.accountProfileService = accountProfileService
    self.eventTrackingService = eventTrackingService
    self.paginationController = PaginationController(itemsPerPage: 10, requestItems: 10, shouldRefreshTop: false, shouldRefreshInTheMiddle: false)
    self.initialPostHelpRequest = postHelpRequest
    
    super.init()
    self.paginationController.delegate = self
  }
}

// MARK: - PostHelpAnswersInteractor API
extension PostHelpAnswersInteractor: PostHelpAnswersInteractorApi {
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
  
  func performPickAnswerItemAt(_ indexPath: IndexPath) {
    let answer = fetchResultController.object(at: indexPath)
    guard !answer.isPickedAnswer else {
      return
    }
    
    answer.setPickedAsHelp(true)
    
    let completeBlock: CompleteHandler = { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      if let err = $0 {
        strongSelf.presenter.handleError(err)
        answer.setPickedAsHelp(false)
        return
      }
      
      strongSelf.postHelpService.showAnswer(postHelpId: strongSelf.initialPostHelpRequest.identifier, answerId: answer.identifier) { [weak self] in
        switch $0 {
        case .success(let answerResponse):
          guard let strongSelf = self else {
            return
          }
          strongSelf.coreDataStorage.updateStorage(with: [answerResponse])
        case .failure(let error):
          self?.presenter.handleError(error)
          answer.setPickedAsHelp(false)
        }
      }
    }
    
    postHelpService.pickAnswer(postHelpId: initialPostHelpRequest.identifier, answerId: answer.identifier, complete: completeBlock)
  }
  
  var currentPostHelpRequest: PostHelpRequestProtocol {
    return observablePostHelpRequest.object ?? initialPostHelpRequest
  }
  
  func performDeleteItemAt(_ indexPath: IndexPath) {
    let answer = fetchResultController.object(at: indexPath)
    guard answer.isMyAnswer else {
      return
    }
    
    answer.setLocallyDeleted(true)
    
    let answerWithPostHelpRequest = PostHelpAnswerRelations.answerForPostHelpRequest(answer: answer, postHelpRequest: initialPostHelpRequest)
    
    coreDataStorage.batchUpdateStorage(with: [answerWithPostHelpRequest])
    postHelpService.deleteAnswer(postHelpId: initialPostHelpRequest.identifier, answerId: answer.identifier)  { [weak self] in
      if let error = $0 {
        self?.presenter.handleError(error)
      }
    }
  }
  
  
  func performUpVoteAt(_ indexPath: IndexPath, withAmount: Int) {
    let answer = fetchResultController.object(at: indexPath)
    guard !answer.isUpVotedByUser else {
      return
    }
    
    let upVoteAmount = Int32(withAmount)
    answer.upVotesAmount += upVoteAmount
    answer.upVoted = true
    
    let completeBlock: CompleteHandler = { [weak self] in
      guard let strongSelf = self else {
        return
      }
      if let err = $0 {
        strongSelf.presenter.handleError(err)
        answer.upVotesAmount -= upVoteAmount
        answer.upVoted = false
        return
      }
      
      strongSelf.postHelpService.showAnswer(postHelpId: strongSelf.initialPostHelpRequest.identifier, answerId: answer.identifier) { [weak self] in
        switch $0 {
        case .success(let answerResponse):
          guard let strongSelf = self else {
            return
          }
          strongSelf.coreDataStorage.updateStorage(with: [answerResponse])
        case .failure(let error):
          self?.presenter.handleError(error)
          answer.upVotesAmount -= upVoteAmount
          answer.upVoted = false
        }
      }
    }
    
    postHelpService.upvoteAnswer(postHelpId: initialPostHelpRequest.identifier, answerId: answer.identifier, amount: withAmount, complete: completeBlock)
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
  
  func setAnswerText(_ text: String) {
    guard text.count >= answerLengthMax else {
      return
    }
    
    let indexEndOfText = text.index(text.startIndex, offsetBy: answerLengthMax)
    let cutText = String(text[..<indexEndOfText])
    presenter.presentCleanedAnswerText(cutText)
  }
  
  func createAnswerWith(_ text: String) {
    guard let parentComment = selectedReplyItem else {
      postAnswertWith(text)
      return
    }
    
    postReplyAnswerWith(text, parentAnswer: parentComment)
  }
  
  fileprivate func postAnswertWith(_ text: String) {
    let answerBody = text.cleanedFromExtraNewLines()
    let answerDraft = PostHelpAnswerDraft(user: accountProfileService.currentUserAccount, body: answerBody)
    
    let answerDraftWithPostHelpRequest = PostHelpAnswerRelations.answerForPostHelpRequest(answer: answerDraft, postHelpRequest: initialPostHelpRequest)
    coreDataStorage.updateStorage(with: [answerDraftWithPostHelpRequest])
    presenter.presentAnswerSendSuccess()
    //keep reference to storage service
    let storageService = coreDataStorage
    
    postHelpService.createAnswerFor(postHelpId: initialPostHelpRequest.identifier, body: answerBody) { [weak self] in
      //remove draft
      answerDraft.setLocallyDeleted(true)
      
      guard let strongSelf = self else {
        storageService.updateStorage(with: [answerDraft])
        return
      }
      
      switch $0 {
      case .success(let answer):
        let answerWithPostHelpRequest = PartialPostHelpAnswerRelations.answerForPostHelpRequest(answer: answer, postHelpRequest: strongSelf.initialPostHelpRequest)
        
        storageService.updateStorage(with: [answerWithPostHelpRequest, answerDraft])
      case .failure(let error):
        storageService.updateStorage(with: [answerDraft])
        strongSelf.presenter.handleError(error)
      }
    }
  }
  
  fileprivate func postReplyAnswerWith(_ text: String, parentAnswer: PostHelpAnswerProtocol) {
    let answerBody = text.cleanedFromExtraNewLines()
    let answerDraft = PostHelpAnswerDraft(user: accountProfileService.currentUserAccount, body: answerBody)
    
    let answerDraftReplyWithPost = PostHelpAnswerRelations.replyForAnswer(answer: answerDraft, parentAnswer: parentAnswer, postHelpRequest: initialPostHelpRequest)
    coreDataStorage.updateStorage(with: [answerDraftReplyWithPost])
    presenter.presentAnswerSendSuccess()
    
    if let selected = selectedReplyItem,
      let indexPath = fetchResultController.indexPath(forObject: selected) {
      changeSelectedReplyStateForItemAt(indexPath)
    }
    
    //keep reference to storage service
    let storageService = coreDataStorage
    
    postHelpService.createAnswerReplyFor(postHelpId: initialPostHelpRequest.identifier,
                                         answerId: parentAnswer.identifier,
                                         body: answerBody) { [weak self] in
                                          
                                          
        //remove draft
        answerDraft.setLocallyDeleted(true)
        
        guard let strongSelf = self else {
          storageService.updateStorage(with: [answerDraft])
          return
        }
        
        switch $0 {
        case .success(let answer):
          let answerReplyWithPostHelpRequest = PartialPostHelpAnswerRelations.replyForAnswer(answer: answer, parentAnswer: parentAnswer, postHelpRequest: strongSelf.initialPostHelpRequest)
          
          storageService.updateStorage(with: [answerReplyWithPostHelpRequest, answerDraft])
        case .failure(let error):
          storageService.updateStorage(with: [answerDraft])
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
  
  func itemAt(_ indexPath: IndexPath) -> PostHelpAnswerProtocol {
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
    
    presenter.presentPostHelpRequest(observablePostHelpRequest.object)
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
    
    postHelpService.showPostHelp(postHelpId: initialPostHelpRequest.identifier) { [weak self] in
      switch $0 {
      case .success(let postHelp):
        self?.coreDataStorage.updateStorage(with: [postHelp])
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  func refreshPostHelpRequestItem() {
//    postingService.showPosting(postId: posting.identifier) { [weak self] in
//      switch $0 {
//      case .success(let posting):
//        self?.coreDataStorage.updateStorage(with: [posting])
//      case .failure(let error):
//        self?.presenter.handleError(error)
//      }
//    }
  }
}

// MARK: - Interactor Viper Components Api
private extension PostHelpAnswersInteractor {
  var presenter: PostHelpAnswersPresenterApi {
    return _presenter as! PostHelpAnswersPresenterApi
  }
}

extension PostHelpAnswersInteractor {
  fileprivate func performFetchPostHelpAnswersAndSaveToStorage(posting: PostHelpRequestProtocol, page: Int, perPage: Int) {
    AppLogger.debug("performFetchPostHelpAnswersAndSaveToStorage \(page)")
    postHelpService.getAnswersFor(postHelpId: initialPostHelpRequest.identifier, page: page, perPage: perPage) { [weak self] in
      switch $0 {
      case .success(let comments):
        guard let strongSelf = self else {
          return
        }
        
        let commentsWithPosting = comments.0.map {
          return PartialPostHelpAnswerRelations.answerForPostHelpRequest(answer: $0, postHelpRequest: posting)
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
    let postPredicate = NSPredicate(format: "postHelpRequest.id = \(initialPostHelpRequest.identifier)")
    
    return NSCompoundPredicate(andPredicateWithSubpredicates: [isDeletedPredicate, postPredicate])
  }
  
  fileprivate func sortDesriptors() -> [NSSortDescriptor] {
    let rootIdSortDescriptor = NSSortDescriptor(key: #keyPath(PostHelpAnswerManagedObject.rootParentCommentId), ascending: false)
    
    let idSortDescriptor = NSSortDescriptor(key: #keyPath(PostHelpAnswerManagedObject.id), ascending: false)
    let dateSortDescriptor = NSSortDescriptor(key: #keyPath(PostHelpAnswerManagedObject.createdAt), ascending: false)
    return [rootIdSortDescriptor, idSortDescriptor, dateSortDescriptor]
  }
}

//MARK:- FetchedResultsControllerDelegate

extension PostHelpAnswersInteractor: FetchedResultsControllerDelegate {
  func updateItems(_ proxy: FetchedResultsControllerDelegateProxy, updates: CollectionViewModelUpdate) {
    presenter.presentCollectionUpdates(updates)
  }
}

//MARK:- PaginationControllerDelegate

extension PostHelpAnswersInteractor: PaginationControllerDelegate {
  func request(page: Int, perPage: Int) {
    performFetchPostHelpAnswersAndSaveToStorage(posting: initialPostHelpRequest, page: page, perPage: perPage)
  }
}
