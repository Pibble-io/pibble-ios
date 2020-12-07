//
//  WalletActivityInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

// MARK: - WalletActivityInteractor Class
final class WalletActivityInteractor: Interactor {
//  fileprivate let coreDataStorage: CoreDataStorageServiceProtocol
//  fileprivate var paginationController: PaginationControllerProtocol
//  fileprivate let walletService: WalletServiceProtocol
//  fileprivate let accountProfileService: AccountProfileServiceProtocol
//  
//  fileprivate lazy var pibFetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy = {
//    FetchedResultsControllerDelegateProxy(delegate: self)
//  }()
//  
//  fileprivate lazy var brushFetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy = {
//    FetchedResultsControllerDelegateProxy(delegate: self)
//  }()
//  
//  fileprivate var pibFetchResultsController: NSFetchedResultsController<WalletActivityManagedObject>? = nil
//  fileprivate var brushFetchResultsController: NSFetchedResultsController<WalletActivityManagedObject>? = nil
//  
//  fileprivate var currentFetchControllerSwitch: WalletActivity.SelectedSegment = .pibble 
//  
//  func initialFetchData() {
//    if let profile = accountProfileService.currentUserAccount {
//      performFetchFor(account: profile)
//    } else {
//      accountProfileService.getProfile { [weak self] in
//        switch $0 {
//        case .success(let profile):
//          self?.performFetchFor(account: profile)
//        case .failure(let err):
//          self?.presenter.handleError(err)
//        }
//      }
//    }
//  }
//  
//  fileprivate func performFetchFor(account: UserProtocol) {
//    pibFetchResultsController = setupFRCFor(account: account,
//                                            predicate: pibFetchPredicateFor(account: account),
//                                            sortDescriptors: sortDesriptors(),
//                                            delegate: pibFetchedResultsControllerDelegateProxy)
//    
//    brushFetchResultsController = setupFRCFor(account: account,
//                                              predicate: brushFetchPredicateFor(account: account),
//                                              sortDescriptors: sortDesriptors(),
//                                              delegate: brushFetchedResultsControllerDelegateProxy)
//    
//    do {
//      try pibFetchResultsController?.performFetch()
//      try brushFetchResultsController?.performFetch()
//    } catch {
//      presenter.handleError(error)
//    }
//  }
//  
//  fileprivate func setupFRCFor(account: UserProtocol, predicate: NSPredicate, sortDescriptors: [NSSortDescriptor], delegate: FetchedResultsControllerDelegateProxy) -> NSFetchedResultsController<WalletActivityManagedObject> {
//    
//    let fetchRequest: NSFetchRequest<WalletActivityManagedObject> = WalletActivityManagedObject.fetchRequest()
//    fetchRequest.predicate = predicate
//    fetchRequest.sortDescriptors = sortDescriptors
//    fetchRequest.fetchBatchSize = 30
//    
//    let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStorage.viewContext, sectionNameKeyPath: nil, cacheName: nil)
//    
//    fetchResultsController.delegate = delegate
//    return fetchResultsController
//  }
  
  init(coreDataStorage: CoreDataStorageServiceProtocol,
       walletService: WalletServiceProtocol,
       accountProfileService: AccountProfileServiceProtocol) {
//    self.coreDataStorage = coreDataStorage
//    self.walletService = walletService
//    self.accountProfileService = accountProfileService
//
//    self.paginationController = PaginationController(itemsPerPage: 10, requestItems: 10, shouldRefreshTop: false, shouldRefreshInTheMiddle: false)
//
//    super.init()
//    self.paginationController.delegate = self
  }
}

// MARK: - WalletActivityInteractor API
extension WalletActivityInteractor: WalletActivityInteractorApi {
//  func isIncomingItemAt(_ indexPath: IndexPath, collection: WalletActivity.SelectedSegment) -> Bool? {
//    guard let item = itemAt(indexPath, collection: collection) else {
//      return nil
//    }
//
//    guard let account = accountProfileService.currentUserAccount else {
//      return nil
//    }
//
//    return account.identifier == item.activityToUser?.identifier
//  }
//
//  func numberOfSections(collection: WalletActivity.SelectedSegment) -> Int {
//    switch collection {
//    case .pibble:
//      return pibFetchResultsController?.sections?.count ?? 0
//    case .brush:
//      return brushFetchResultsController?.sections?.count ?? 0
//    }
//  }
//
//  func numberOfItemsInSection(_ section: Int, collection: WalletActivity.SelectedSegment) -> Int {
//    switch collection {
//    case .pibble:
//      return pibFetchResultsController?.sections?[section].numberOfObjects ?? 0
//    case .brush:
//      return brushFetchResultsController?.sections?[section].numberOfObjects ?? 0
//    }
//  }
//
//  func itemAt(_ indexPath: IndexPath, collection: WalletActivity.SelectedSegment) -> WalletActivityProtocol? {
//    switch collection {
//    case .pibble:
//      return pibFetchResultsController?.object(at: indexPath)
//    case .brush:
//      return brushFetchResultsController?.object(at: indexPath)
//    }
//  }
//
//  func switchFilterTo(_ segment: WalletActivity.SelectedSegment) {
//    currentFetchControllerSwitch = segment
//  }
  
  
}

// MARK: - Interactor Viper Components Api
private extension WalletActivityInteractor {
    var presenter: WalletActivityPresenterApi {
        return _presenter as! WalletActivityPresenterApi
    }
}

//MARK:- Helpers

extension WalletActivityInteractor {
//  func performFetchAndSaveToStorage(page: Int, perPage: Int) {
//    AppLogger.info("performFetchActivitiesAndSaveToStorage \(page)")
//
//    walletService.fetchWalletActivity(page: page, perPage: perPage) { [weak self] in
//      switch $0 {
//      case .success(let activities):
//        guard let strongSelf = self else {
//          return
//        }
//        strongSelf.coreDataStorage.updateStorage(with: activities.0, with: nil)
//        strongSelf.paginationController.updatePaginationInto(activities.1)
//      case .failure(let error):
//        self?.presenter.handleError(error)
//      }
//    }
//  }
//
//  fileprivate func pibFetchPredicateFor(account: UserProtocol) -> NSPredicate {
//    let toUserPredicate =  NSPredicate(format: "toUser.id = \(account.identifier)")
//    let fromUserPredicate =  NSPredicate(format: "fromUser.id = \(account.identifier)")
//
//    return NSCompoundPredicate(orPredicateWithSubpredicates: [toUserPredicate, fromUserPredicate])
//  }
//
//  fileprivate func brushFetchPredicateFor(account: UserProtocol) -> NSPredicate {
//    let toUserPredicate =  NSPredicate(format: "toUser.id = \(account.identifier)")
//    let fromUserPredicate =  NSPredicate(format: "fromUser.id = \(account.identifier)")
//
//    return NSCompoundPredicate(orPredicateWithSubpredicates: [toUserPredicate, fromUserPredicate])
//  }
//
//  fileprivate func sortDesriptors() -> [NSSortDescriptor] {
//    let sortDescriptor = NSSortDescriptor(key: #keyPath(WalletActivityManagedObject.id), ascending: false)
//    return [sortDescriptor]
//  }
}
//
//extension WalletActivityInteractor: PaginationControllerDelegate {
//  func request(page: Int, perPage: Int) {
//    performFetchAndSaveToStorage(page: page, perPage: perPage)
//  }
//}
//
////MARK:- FetchedResultsControllerDelegate
//
//extension WalletActivityInteractor: FetchedResultsControllerDelegate {
//  func updateItems(_ proxy: FetchedResultsControllerDelegateProxy, updates: CollectionViewModelUpdate) {
//    if proxy == pibFetchedResultsControllerDelegateProxy {
//      presenter.presentCollectionUpdates(.pibble, updates: updates)
//    }
//
//    if proxy == brushFetchedResultsControllerDelegateProxy {
//      presenter.presentCollectionUpdates(.brush, updates: updates)
//    }
//  }
//}
