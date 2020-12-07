//
//  WalletInvoiceCreateFriendsContentInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 01.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 
import CoreData

// MARK: - WalletInvoiceCreateFriendsContentInteractor Class
final class WalletInvoiceCreateFriendsContentInteractor: Interactor {
  fileprivate let coreDataStorage: CoreDataStorageServiceProtocol
  fileprivate var paginationController: PaginationControllerProtocol
  fileprivate let walletService: WalletServiceProtocol
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  fileprivate let contentType: WalletInvoiceCreateFriendsContent.ContentType
  fileprivate let userInteractionService: UserInteractionServiceProtocol
  
  fileprivate lazy var fetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy = {
    FetchedResultsControllerDelegateProxy(delegate: self)
  }()
  
  fileprivate var fetchResultsController: NSFetchedResultsController<UserManagedObject>? = nil
  
  
  init(coreDataStorage: CoreDataStorageServiceProtocol,
       walletService: WalletServiceProtocol,
       accountProfileService: AccountProfileServiceProtocol,
       userInteractionService: UserInteractionServiceProtocol,
       contentType: WalletInvoiceCreateFriendsContent.ContentType) {
    self.coreDataStorage = coreDataStorage
    self.walletService = walletService
    self.accountProfileService = accountProfileService
    self.userInteractionService = userInteractionService
    self.contentType = contentType
    
    self.paginationController = PaginationController(itemsPerPage: 10, requestItems: 10, shouldRefreshTop: false, shouldRefreshInTheMiddle: false)
    
    super.init()
    self.paginationController.delegate = self
  }
}

// MARK: - WalletInvoiceCreateFriendsContentInteractor API
extension WalletInvoiceCreateFriendsContentInteractor: WalletInvoiceCreateFriendsContentInteractorApi {
  func initialFetchData() {
    if let profile = accountProfileService.currentUserAccount {
      performFetchFor(account: profile)
    } else {
      accountProfileService.getProfile { [weak self] in
        switch $0 {
        case .success(let profile):
          self?.performFetchFor(account: profile)
        case .failure(let err):
          self?.presenter.handleError(err)
        }
      }
    }
  }
  
  func initialRefresh() {
    paginationController.initialRequest()
  }
  
  func prepareItemFor(_ indexPath: Int) {
    paginationController.paginateByIndex(indexPath)
  }
  
  func cancelPrepareItemFor(_ indexPath: Int) {
    
  }
  
  func numberOfSections() -> Int {
    return fetchResultsController?.sections?.count ?? 0
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return fetchResultsController?.sections?[section].numberOfObjects ?? 0
  }
  
  func itemAt(_ indexPath: IndexPath) -> UserProtocol {
    return fetchResultsController!.object(at: indexPath)
  }
}

// MARK: - Interactor Viper Components Api
private extension WalletInvoiceCreateFriendsContentInteractor {
  var presenter: WalletInvoiceCreateFriendsContentPresenterApi {
    return _presenter as! WalletInvoiceCreateFriendsContentPresenterApi
  }
}

//MARK:- Helpers

extension WalletInvoiceCreateFriendsContentInteractor {
  fileprivate func performFetchFor(account: UserProtocol) {
    let predicate: NSPredicate
    switch contentType {
    case .friends:
      predicate = friendPredicateFor(account: account)
    case .recentFriends:
      predicate = sentFundsRecentlyPredicateFor(account: account)
    }
    
    fetchResultsController = setupFRCFor(account: account,
                                         predicate: predicate,
                                         sortDescriptors: sortDesriptors(),
                                         delegate: fetchedResultsControllerDelegateProxy)
    
    do {
      try fetchResultsController?.performFetch()
    } catch {
      presenter.handleError(error)
    }
    
    presenter.presentReload()
  }
  
  fileprivate func setupFRCFor(account: UserProtocol, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor], delegate: FetchedResultsControllerDelegateProxy) -> NSFetchedResultsController<UserManagedObject> {
    
    let fetchRequest: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
    fetchRequest.predicate = predicate
    fetchRequest.sortDescriptors = sortDescriptors
    fetchRequest.fetchBatchSize = 30
    
    let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStorage.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    
    fetchResultsController.delegate = delegate
    return fetchResultsController
  }
  
  fileprivate func performFetchFriendsAndSaveToStorage(user: UserProtocol, page: Int, perPage: Int) {
    userInteractionService.getFriendsForUser(username: user.userName,
                                             page: page,
                                             perPage: perPage) { [weak self] in
                                              switch $0 {
                                              case .success(let users):
                                                guard let strongSelf = self else {
                                                  return
                                                }
                                                let friendsRelations = users.0.map { return PartialUserRelations.friend($0, of: user) }
                                                
                                                strongSelf.coreDataStorage.updateTemporaryStorage(with: friendsRelations)
                                                strongSelf.paginationController.updatePaginationInfo(users.1)
                                              case .failure(let error):
                                                self?.presenter.handleError(error)
                                              }
    }
  }
  
  fileprivate func performFetchRecentSentFriendsAndSaveToStorage(user: UserProtocol, page: Int, perPage: Int) {
    userInteractionService.getRecentFundSentUsers(page: page,
                                                  perPage: perPage) { [weak self] in
                                                    switch $0 {
                                                    case .success(let users):
                                                      guard let strongSelf = self else {
                                                        return
                                                      }
                                                      let friendsRelations = users.0.map { return PartialUserRelations.sentFundsRecently(user, to: $0) }
                                                      
                                                      strongSelf.coreDataStorage.updateTemporaryStorage(with: friendsRelations)
                                                      strongSelf.paginationController.updatePaginationInfo(users.1)
                                                    case .failure(let error):
                                                      self?.presenter.handleError(error)
                                                    }
    }
  }
  
  fileprivate func performFetchAndSaveToStorage(page: Int, perPage: Int) {
    AppLogger.debug("performFetchFriendsAndSaveToStorage \(page)")
    
    let fetchingMethod: ((UserProtocol, Int, Int) -> Void)
    switch contentType {
    case .friends:
      fetchingMethod = performFetchFriendsAndSaveToStorage
    case .recentFriends:
      fetchingMethod = performFetchRecentSentFriendsAndSaveToStorage
    }
    
    if let user = accountProfileService.currentUserAccount {
      fetchingMethod(user, page, perPage)
    } else {
      accountProfileService.getProfile { [weak self] in
        switch $0 {
        case .success(let user):
          fetchingMethod(user, page, perPage)
        case .failure(let err):
          self?.presenter.handleError(err)
        }
      }
    }
  }
  
  fileprivate func friendPredicateFor(account: UserProtocol) -> NSPredicate {
    let friendPredicate = NSPredicate(format: "ANY friends.id == \(account.identifier)")
    return friendPredicate
  }
  
  fileprivate func sentFundsRecentlyPredicateFor(account: UserProtocol) -> NSPredicate {
    let recentfriendsPredicate = NSPredicate(format: "ANY receivedFundsRecently.id == \(account.identifier)")
    return recentfriendsPredicate
  }
  
  fileprivate func sortDesriptors() -> [NSSortDescriptor] {
    let sortDescriptor = NSSortDescriptor(key: #keyPath(UserManagedObject.name), ascending: true, selector: #selector(NSString.caseInsensitiveCompare))
    return [sortDescriptor]
  }
}

//MARK:- PaginationControllerDelegate

extension WalletInvoiceCreateFriendsContentInteractor: PaginationControllerDelegate {
  func request(page: Int, perPage: Int) {
    performFetchAndSaveToStorage(page: page, perPage: perPage)
  }
}

//MARK:- FetchedResultsControllerDelegate

extension WalletInvoiceCreateFriendsContentInteractor: FetchedResultsControllerDelegate {
  func updateItems(_ proxy: FetchedResultsControllerDelegateProxy, updates: CollectionViewModelUpdate) {
    presenter.presentCollectionUpdates(updates)
  }
}
