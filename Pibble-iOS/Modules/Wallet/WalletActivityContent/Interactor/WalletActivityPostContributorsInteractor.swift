//
//  WalletActivityPostContributorsInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 25.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

// MARK: - WalletActivityPostContributorsInteractor Class
final class WalletActivityPostContributorsInteractor: Interactor {
  fileprivate let coreDataStorage: CoreDataStorageServiceProtocol
  fileprivate var paginationController: PaginationControllerProtocol
  fileprivate let walletService: WalletServiceProtocol
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  
  let contentType: WalletActivityContent.ContentType
  
  
  fileprivate lazy var fetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy = {
    FetchedResultsControllerDelegateProxy(delegate: self)
  }()
  
  fileprivate var fetchResultsController: NSFetchedResultsController<BaseFundingDonateTransactionManagedObject>? = nil
  
  fileprivate var selectedItem: WalletActivityManagedObject?
  
  init(coreDataStorage: CoreDataStorageServiceProtocol,
       walletService: WalletServiceProtocol,
       accountProfileService: AccountProfileServiceProtocol,
       contentType: WalletActivityContent.ContentType) {
    self.coreDataStorage = coreDataStorage
    self.walletService = walletService
    self.accountProfileService = accountProfileService
    self.contentType = contentType
    
    self.paginationController = PaginationController(itemsPerPage: 10, requestItems: 15, shouldRefreshTop: false, shouldRefreshInTheMiddle: false)
    
    super.init()
    self.paginationController.delegate = self
  }
}

// MARK: - WalletActivityContentInteractor API

extension WalletActivityPostContributorsInteractor: WalletActivityContentInteractorApi {
  func selectItemAt(_ indexPath: IndexPath) {
    selectedItem = managedItemAt(indexPath)
  }
  
  func cancelSelectedInvoiceItem() {
    guard let item = selectedItem else {
      return
    }
    
    cancelInvoice(item)
  }
  
  func confirmSelectedInvoiceItem() {
    guard let item = selectedItem else {
      return
    }
    
    confirmInvoice(item)
  }
  
  var currentUserAccount: UserProtocol? {
    return accountProfileService.currentUserAccount
  }
  
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
  
  func itemAt(_ indexPath: IndexPath) -> WalletActivityEntity? {
    guard let item = fetchResultsController?.object(at: indexPath) else {
      return nil
    }
    return item.walletActivityEntity
  }
}

// MARK: - Interactor Viper Components Api
private extension WalletActivityPostContributorsInteractor {
  var presenter: WalletActivityContentPresenterApi {
    return _presenter as! WalletActivityContentPresenterApi
  }
}

//MARK:- Helpers

extension WalletActivityPostContributorsInteractor {
  fileprivate func managedItemAt(_ indexPath: IndexPath) -> WalletActivityManagedObject? {
    return fetchResultsController?.object(at: indexPath)
  }
  
  fileprivate func cancelInvoice(_ item: WalletActivityManagedObject) {
    guard let currentAccount = accountProfileService.currentUserAccount else {
      presenter.presentInvoiceActionPerfomedSuccefully(false)
      return
    }
    
    guard case let WalletActivityEntity.invoice(entity) = item.walletActivityEntity else {
      presenter.presentInvoiceActionPerfomedSuccefully(false)
      return
    }
    
    guard entity.isIncomingTo(account: currentAccount) else {
      presenter.presentInvoiceActionPerfomedSuccefully(false)
      return
    }
    
    walletService.rejectInvoice(item.identifier) { [weak self] in
      switch $0 {
      case .success(let invoice):
        //        let activity = PartialWalletActivityEntity(entity: invoice)
        //        let invoiceWithRelation = WalletActivitiesRelations.userActivity(activity: activity, user: currentAccount)
        self?.coreDataStorage.updateStorage(with: [invoice])
        self?.presenter.presentInvoiceActionPerfomedSuccefully(true)
      case .failure(let error):
        self?.presenter.presentInvoiceActionPerfomedSuccefully(false)
        self?.presenter.handleError(error)
      }
    }
  }
  
  func confirmInvoice(_ item: WalletActivityManagedObject) {
    guard case let WalletActivityEntity.invoice(entity) = item.walletActivityEntity else {
      presenter.presentInvoiceActionPerfomedSuccefully(false)
      return
    }
    
    guard let currentAccount = accountProfileService.currentUserAccount else {
      presenter.presentInvoiceActionPerfomedSuccefully(false)
      return
    }
    
    guard entity.isIncomingTo(account: currentAccount) else {
      presenter.presentInvoiceActionPerfomedSuccefully(false)
      return
    }
    
    walletService.acceptInvoice(item.identifier) { [weak self] in
      switch $0 {
      case .success(let invoice):
        //        let activity = PartialWalletActivityEntity(entity: invoice)
        //        let invoiceWithRelation = WalletActivitiesRelations.userActivity(activity: activity, user: currentAccount)
        self?.coreDataStorage.updateStorage(with: [invoice])
        self?.presenter.presentInvoiceActionPerfomedSuccefully(true)
      case .failure(let error):
        self?.presenter.presentInvoiceActionPerfomedSuccefully(false)
        self?.presenter.handleError(error)
      }
    }
  }
  
  var hasPinCode: Bool {
    return walletService.hasPinCode
  }
  
  
  fileprivate func performFetchFor(account: UserProtocol) {
    
    let predicate = predicateFor(account: account, contentType: contentType)
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
  
  fileprivate func setupFRCFor(account: UserProtocol, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor], delegate: FetchedResultsControllerDelegateProxy) -> NSFetchedResultsController<BaseFundingDonateTransactionManagedObject> {
    
    let fetchRequest: NSFetchRequest<BaseFundingDonateTransactionManagedObject> = BaseFundingDonateTransactionManagedObject.fetchRequest()
    fetchRequest.predicate = predicate
    fetchRequest.sortDescriptors = sortDescriptors
    fetchRequest.fetchBatchSize = 30
    
    let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStorage.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    
    fetchResultsController.delegate = delegate
    return fetchResultsController
  }
  
  
  
  func performFetchAndSaveToStorage(page: Int, perPage: Int, currentUser: UserProtocol) {
    AppLogger.debug("performFetchActivitiesAndSaveToStorage \(page)")
    
    let isInitialFetch = page == 0
    switch contentType {
    case .walletActivities(let currencyType):
      walletService.fetchWalletActivity(page: page, perPage: perPage, currencyType: currencyType) { [weak self] in
        switch $0 {
        case .success(let activities):
          guard let strongSelf = self else {
            return
          }
          
          if isInitialFetch {
            strongSelf.performCacheInvalidationRequest(for: strongSelf.contentType, skip: activities.0)
          }
          
          let usersActivities = activities.0
            .map { return WalletActivitiesRelations.userActivity(activity: $0,
                                                                 user: currentUser,
                                                                 currencyType: currencyType) }
          
          strongSelf.coreDataStorage.updateStorage(with: usersActivities)
          strongSelf.paginationController.updatePaginationInfo(activities.1)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
    case .donationsForPost(let post):
      walletService.getDonationTransactionsForPost(post, page: page, perPage: perPage) { [weak self] in
        switch $0 {
        case .success(let activities):
          guard let strongSelf = self else {
            return
          }
          
          if isInitialFetch {
            strongSelf.performCacheInvalidationRequest(for: strongSelf.contentType, skip: activities.0)
          }
          
          let usersActivities = activities.0
            .map { return WalletActivitiesRelations.postFundingDonationActivities(activity: $0,
                                                                                  post: post) }
          
          strongSelf.coreDataStorage.updateStorage(with: usersActivities)
          strongSelf.paginationController.updatePaginationInfo(activities.1)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
    }
  }
  
  fileprivate func getUserPredicate(account: UserProtocol) -> NSPredicate {
    let userPredicate =  NSPredicate(format: "user.id = \(account.identifier)")
    return userPredicate
  }
  
  //  fileprivate func fetchPredicateFor(account: UserProtocol, currency: BalanceCurrency) -> NSPredicate {
  ////    let coinPredicate = NSPredicate(format: "currency = %@", currency.symbol)
  //    let coinPredicate = NSPredicate(format: "currency contains[c] %@", currency.symbol)
  //    let userPredicate = getUserPredicate(account: account)
  //
  //    return NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, coinPredicate])
  //  }
  //
  
  fileprivate func propertiesToUpdateForCacheInvalidation(for contentType: WalletActivityContent.ContentType) -> [String: Any]? {
    switch contentType {
    case .walletActivities(let currencyType):
      switch currencyType {
      case .coin(_):
        return ["isCoinCurrencyType": NSNumber(value: false)]
      case .brush:
        return ["isBrushCurrencyType": NSNumber(value: false)]
      }
    case .donationsForPost(_):
      return nil
    }
  }
  
  fileprivate func performCacheInvalidationRequest(for contentType: WalletActivityContent.ContentType, skip activities: [PartialWalletActivityEntity]) {
    AppLogger.debug("performOldObjectsCacheInvalidationRequest")
    guard let propertiesToUpdate = propertiesToUpdateForCacheInvalidation(for: contentType) else {
      return
    }
    
    let predicate: NSPredicate = contentPredicateFor(contentType: contentType)
    
    guard activities.count > 0 else {
      coreDataStorage.batchUpdateObjects(WalletActivityManagedObject.self, predicate: predicate, propertiesToUpdate: propertiesToUpdate)
      return
    }
    
    let skipObjectsPredicate = NSPredicate(format: "NOT (id IN %@)", activities.map { $0.identifier } )
    
    let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [skipObjectsPredicate, predicate])
    coreDataStorage.batchUpdateObjects(WalletActivityManagedObject.self,
                                       predicate: compoundPredicate,
                                       propertiesToUpdate: propertiesToUpdate)
    
  }
  
  
  fileprivate func contentPredicateFor(contentType: WalletActivityContent.ContentType) -> NSPredicate {
    switch contentType {
    case .walletActivities(let currencyType):
      switch currencyType {
      case .coin(let currency):
        let currencyType = NSPredicate(format: "isCoinCurrencyType == %@", NSNumber(value: true))
        let currencyPredicate = NSPredicate(format: "currency contains[c] %@", currency.symbol)
        return NSCompoundPredicate(andPredicateWithSubpredicates: [currencyPredicate, currencyType])
      case .brush:
        let pgbPredicate = NSPredicate(format: "currency contains[c] %@", BalanceCurrency.greenBrush.symbol)
        let prbPredicate = NSPredicate(format: "currency contains[c] %@", BalanceCurrency.redBrush.symbol)
        let currencyTypePredicate = NSPredicate(format: "isBrushCurrencyType == %@", NSNumber(value: true))
        
        let currencyPredicate =  NSCompoundPredicate(orPredicateWithSubpredicates: [pgbPredicate, prbPredicate])
        return NSCompoundPredicate(andPredicateWithSubpredicates: [currencyPredicate, currencyTypePredicate])
      }
    case .donationsForPost(let post):
      let charityDonations = NSPredicate(format: "activityType = %@", WalletActivityType.charityFundingDonateTransaction.rawValue)
      let crowdfundingDonations = NSPredicate(format: "activityType = %@", WalletActivityType.crowdFundingDonateTransaction.rawValue)
      let rewardCrowdfudningDonations = NSPredicate(format: "activityType = %@", WalletActivityType.crowdFundingWithRewardsDonateTransaction.rawValue)
      
      let postPredicate = NSPredicate(format: "posting.id = \(post.identifier)")
      
      let typePredicate =  NSCompoundPredicate(orPredicateWithSubpredicates: [charityDonations, crowdfundingDonations, rewardCrowdfudningDonations])
      
      return NSCompoundPredicate(andPredicateWithSubpredicates: [typePredicate, postPredicate])
    }
    
  }
  
  fileprivate func predicateFor(account: UserProtocol, contentType: WalletActivityContent.ContentType) -> NSPredicate {
    let contentPredicate = contentPredicateFor(contentType: contentType)
    switch contentType {
    case .walletActivities(_):
      let userPredicate = getUserPredicate(account: account)
      return NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, contentPredicate])
    case .donationsForPost(_):
      return contentPredicate
    }
    
    
  }
  
  fileprivate func sortDesriptors() -> [NSSortDescriptor] {
    let sortDescriptor = NSSortDescriptor(key: #keyPath(WalletActivityManagedObject.createdAtDate), ascending: false)
    return [sortDescriptor]
  }
}

//MARK:- PaginationControllerDelegate

extension WalletActivityPostContributorsInteractor: PaginationControllerDelegate {
  func request(page: Int, perPage: Int) {
    if let user = accountProfileService.currentUserAccount {
      performFetchAndSaveToStorage(page: page, perPage: perPage, currentUser: user)
    } else {
      accountProfileService.getProfile { [weak self] in
        switch $0 {
        case .success(let user):
          self?.performFetchAndSaveToStorage(page: page, perPage: perPage, currentUser: user)
        case .failure(let err):
          self?.presenter.handleError(err)
        }
      }
    }
  }
}

//MARK:- FetchedResultsControllerDelegate

extension WalletActivityPostContributorsInteractor: FetchedResultsControllerDelegate {
  func updateItems(_ proxy: FetchedResultsControllerDelegateProxy, updates: CollectionViewModelUpdate) {
    presenter.presentCollectionUpdates(updates)
  }
}
