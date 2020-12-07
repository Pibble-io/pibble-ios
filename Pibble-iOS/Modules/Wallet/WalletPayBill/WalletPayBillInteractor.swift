//
//  WalletPayBillInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

// MARK: - WalletPayBillInteractor Class
final class WalletPayBillInteractor: Interactor {
  fileprivate let coreDataStorage: CoreDataStorageServiceProtocol
  fileprivate var paginationController: PaginationControllerProtocol
  fileprivate let walletService: WalletServiceProtocol
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  
  fileprivate var fetchResultsController: NSFetchedResultsController<InvoiceManagedObject>? = nil
  fileprivate lazy var fetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy = {
    FetchedResultsControllerDelegateProxy(delegate: self)
  }()
  
  fileprivate var selectedItem: InvoiceManagedObject?
  
  init(coreDataStorage: CoreDataStorageServiceProtocol,
       walletService: WalletServiceProtocol,
       accountProfileService: AccountProfileServiceProtocol) {
    self.coreDataStorage = coreDataStorage
    self.walletService = walletService
    self.accountProfileService = accountProfileService
    
    self.paginationController = PaginationController(itemsPerPage: 10, requestItems: 10, shouldRefreshTop: false, shouldRefreshInTheMiddle: true)
    
    super.init()
    self.paginationController.delegate = self
  }
}

// MARK: - WalletPayBillInteractor API
extension WalletPayBillInteractor: WalletPayBillInteractorApi {
  func selectItemAt(_ indexPath: IndexPath) {
    selectedItem = managedItemAt(indexPath)
  }
  
  func cancelSelectedItem() {
    guard let item = selectedItem else {
      return
    }
    
    cancelInvoice(item)
  }
  
  func confirmSelectedItem() {
    guard let item = selectedItem else {
      return
    }
    
    confirmInvoice(item)
  }
  
  fileprivate func cancelInvoice(_ item: InvoiceProtocol) {
    guard let currentAccount = accountProfileService.currentUserAccount else {
      presenter.presentInvoiceActionPerfomedSuccefully(false)
      return
    }
    
    walletService.rejectInvoice(item.identifier) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      switch $0 {
      case .success(let invoice):
        let activity = PartialWalletActivityEntity(entity: invoice)
        let invoiceWithRelation = WalletActivitiesRelations.userActivity(activity: activity, user: currentAccount, currencyType: nil)
        strongSelf.coreDataStorage.updateStorage(with: [invoiceWithRelation])
        strongSelf.presenter.presentInvoiceActionPerfomedSuccefully(true)
      case .failure(let error):
        strongSelf.presenter.presentInvoiceActionPerfomedSuccefully(false)
        strongSelf.presenter.handleError(error)
      }
    }
  }
  
  fileprivate func confirmInvoice(_ item: InvoiceProtocol) {
    guard let currentAccount = accountProfileService.currentUserAccount else {
      presenter.presentInvoiceActionPerfomedSuccefully(false)
      return
    }
    
    walletService.acceptInvoice(item.identifier) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      switch $0 {
      case .success(let invoice):
        let activity = PartialWalletActivityEntity(entity: invoice)
        let invoiceWithRelation = WalletActivitiesRelations.userActivity(activity: activity, user: currentAccount, currencyType: nil)
        strongSelf.coreDataStorage.updateStorage(with: [invoiceWithRelation])
        strongSelf.presenter.presentInvoiceActionPerfomedSuccefully(true)
      case .failure(let error):
        strongSelf.presenter.presentInvoiceActionPerfomedSuccefully(false)
        strongSelf.presenter.handleError(error)
      }
    }
  }
  
  var hasPinCode: Bool {
    return walletService.hasPinCode
  }
  
  var hasDataToPresent: Bool {
    return fetchResultsController?.hasData ?? false
  }
  
  var currentUser: UserProtocol? {
    return accountProfileService.currentUserAccount
  }
  
  func numberOfSections() -> Int {
    return fetchResultsController?.sections?.count ?? 0
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return fetchResultsController?.sections?[section].numberOfObjects ?? 0
  }
  
  func itemAt(_ indexPath: IndexPath) -> InvoiceProtocol? {
    return managedItemAt(indexPath)
  }
  
 
  func prepareItemFor(_ indexPath: IndexPath) {
    paginationController.paginateByIndex(indexPath.item)
  }
  
  func cancelPrepareItemFor(_ indexPath: IndexPath) {
    
  }
  
  func initialFetchData() {
    presenter.presentUserProfile(accountProfileService.currentUserAccount)
    if let profile = accountProfileService.currentUserAccount {
      performFetchFor(account: profile)
    } else {
      accountProfileService.getProfile { [weak self] in
        switch $0 {
        case .success(let profile):
          self?.presenter.presentUserProfile(profile)
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
  
}

// MARK: - Interactor Viper Components Api
private extension WalletPayBillInteractor {
    var presenter: WalletPayBillPresenterApi {
        return _presenter as! WalletPayBillPresenterApi
    }
}


//MARK:- Helpers

extension WalletPayBillInteractor {
  fileprivate func managedItemAt(_ indexPath: IndexPath) -> InvoiceManagedObject? {
    return fetchResultsController?.object(at: indexPath)
  }
  
  fileprivate func performFetchFor(account: UserProtocol) {
    fetchResultsController = setupFRCFor(account: account,
                                         predicate: fetchPredicatePredicate(account: account),
                                         sortDescriptors: sortDesriptors(),
                                         delegate: fetchedResultsControllerDelegateProxy)
    
    do {
      try fetchResultsController?.performFetch()
    } catch {
      presenter.handleError(error)
    }
    
    presenter.presentReload()
  }
  
  fileprivate func setupFRCFor(account: UserProtocol, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor], delegate: FetchedResultsControllerDelegateProxy) -> NSFetchedResultsController<InvoiceManagedObject> {
    
    let fetchRequest: NSFetchRequest<InvoiceManagedObject> = InvoiceManagedObject.fetchRequest()
    fetchRequest.predicate = predicate
    fetchRequest.sortDescriptors = sortDescriptors
    fetchRequest.fetchBatchSize = 30
    
    let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStorage.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    
    fetchResultsController.delegate = delegate
    return fetchResultsController
  }
  
  fileprivate func performFetchAndSaveToStorage(page: Int, perPage: Int, currentUser: UserProtocol) {
    AppLogger.debug("performFetchActivitiesAndSaveToStorage \(page)")
    
    let isInitialFetch = page == 0
    
    walletService.getInvoices(page: page, perPage: perPage, filter: .requested) { [weak self] in
      switch $0 {
      case .success(let response):
        guard let strongSelf = self else {
          return
        }
        
        if isInitialFetch {
          strongSelf.performCacheInvalidationRequest(skip: response.0)
        }
        
        let activitiesWithRelations = response.0
          .map { return PartialWalletActivityEntity(entity: $0) }
          .map { return  WalletActivitiesRelations.userActivity(activity: $0, user: currentUser, currencyType: nil) }
        
        strongSelf.coreDataStorage.updateStorage(with: activitiesWithRelations)
        strongSelf.paginationController.updatePaginationInfo(response.1)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  fileprivate func propertiesToUpdateForCacheInvalidation() -> [String: Any]? {
    return ["isHidden": NSNumber(value: true)]
  }
  
  
  fileprivate func performCacheInvalidationRequest(skip invoices: [PartialInvoiceProtocol]) {
    AppLogger.debug("performOldObjectsCacheInvalidationRequest")
    guard let propertiesToUpdate = propertiesToUpdateForCacheInvalidation() else {
      return
    }
    
    let predicate: NSPredicate = plainPredicate()
    
    guard invoices.count > 0 else {
      coreDataStorage.batchUpdateObjects(InvoiceManagedObject.self, predicate: predicate, propertiesToUpdate: propertiesToUpdate)
      return
    }
    
    let skipObjectsPredicate = NSPredicate(format: "NOT (id IN %@)", invoices.map { $0.identifier } )
    
    let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [skipObjectsPredicate, predicate])
    coreDataStorage.batchUpdateObjects(InvoiceManagedObject.self,
                                       predicate: compoundPredicate,
                                       propertiesToUpdate: propertiesToUpdate)
    
  }
  
  fileprivate func plainPredicate() -> NSPredicate {
    let statusPredicate = NSPredicate(format: "activityStatus = %@", InvoiceStatus.requested.rawValue)
    let notHiddenPredicate = NSPredicate(format: "isHidden == %@", NSNumber(value: false))
    return NSCompoundPredicate(andPredicateWithSubpredicates: [statusPredicate, notHiddenPredicate])
  }
  
  fileprivate func fetchPredicatePredicate(account: UserProtocol) -> NSPredicate {
    let toUserPredicate =  NSPredicate(format: "toUser.id = \(account.identifier)")
    let basePredicate = plainPredicate()
    
    return NSCompoundPredicate(andPredicateWithSubpredicates: [toUserPredicate, basePredicate])
  }
  
  fileprivate func sortDesriptors() -> [NSSortDescriptor] {
    let sortDescriptor = NSSortDescriptor(key: #keyPath(InvoiceManagedObject.createdAtDate), ascending: false)
    return [sortDescriptor]
  }
}

//MARK:- PaginationControllerDelegate

extension WalletPayBillInteractor: PaginationControllerDelegate {
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

extension WalletPayBillInteractor: FetchedResultsControllerDelegate {
  func updateItems(_ proxy: FetchedResultsControllerDelegateProxy, updates: CollectionViewModelUpdate) {
    presenter.presentCollectionUpdates(updates)
  }
}
