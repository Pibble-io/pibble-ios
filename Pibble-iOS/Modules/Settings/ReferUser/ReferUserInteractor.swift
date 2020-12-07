//
//  ReferUserInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 17/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import CoreData

// MARK: - ReferUserInteractor Class

final class ReferUserInteractor: Interactor {
  fileprivate let coreDataStorage: CoreDataStorageServiceProtocol
  fileprivate let referralUserService: ReferralUserServiceProtocol
  fileprivate let targetUser: AccountProfileProtocol
  fileprivate var paginationController: PaginationControllerProtocol
  
  fileprivate lazy var fetchResultsController: NSFetchedResultsController<UserManagedObject> = {
    return setupFRCFor(predicate: contentPredicate(),
                       sortDescriptors: sortDesriptors(),
                       delegate: fetchedResultsControllerDelegateProxy)
  }()
  
  fileprivate lazy var fetchedResultsControllerDelegateProxy: FetchedResultsControllerDelegateProxy = {
    FetchedResultsControllerDelegateProxy(delegate: self)
  }()
  
  fileprivate var registerUserName: String = ""
  
  init(coreDataStorage: CoreDataStorageServiceProtocol,
       referralUserService: ReferralUserServiceProtocol, targetUser: AccountProfileProtocol) {
    self.coreDataStorage = coreDataStorage
    self.referralUserService = referralUserService
    self.targetUser = targetUser
   
    self.paginationController = PaginationController(itemsPerPage: 10, requestItems: 10, shouldRefreshTop: false, shouldRefreshInTheMiddle: false)
    
    super.init()
    self.paginationController.delegate = self
  }
}

// MARK: - ReferUserInteractor API
extension ReferUserInteractor: ReferUserInteractorApi {
  var currentUser: AccountProfileProtocol {
    return targetUser
  }
  
  func performReferralUserRegistration() {
    referralUserService.registerUnderRefferal(referralId: registerUserName) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      guard let error = $0 else {
        strongSelf.presenter.presentReferralUserRegistrationSuccessWith(strongSelf.referralUserService.referralBonus)
        strongSelf.refreshReferralOwnerUser()
        return
      }
      
      strongSelf.presenter.handleError(error)
    }
  }
  
  func updateRegistrationUserName(_ text: String) {
    registerUserName = text
  }
  
  func numberOfSections() -> Int {
    return fetchResultsController.sections?.count ?? 0
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return fetchResultsController.sections?[section].numberOfObjects ?? 0
  }
  
  func itemAt(_ indexPath: IndexPath) -> UserProtocol {
    return fetchResultsController.object(at: indexPath)
  }
  
  func prepareItemFor(_ index: Int) {
    paginationController.paginateByIndex(index)
  }
  
  func cancelPrepareItemFor(_ index: Int) {
    
  }
  
  func initialFetchData() {
    performFetchFor()
    presenter.presentReferralInfo(referralUserService.referralBonus, forCurrentUser: targetUser)
  }

  func initialRefresh() {
    paginationController.initialRequest()
    refreshReferralOwnerUser()
  }
}

// MARK: - Interactor Viper Components Api
private extension ReferUserInteractor {
  var presenter: ReferUserPresenterApi {
    return _presenter as! ReferUserPresenterApi
  }
}


extension ReferUserInteractor {
  fileprivate func refreshReferralOwnerUser() {
    referralUserService.getReferralUserId { [weak self] in
      guard let strongSelf = self else {
        return
      }
      switch $0 {
      case .success(let referralOwnerUserId):
        strongSelf.presenter.presentReferralOwnerUserId(referralOwnerUserId)
      case .failure(let error):
        strongSelf.presenter.handleError(error)
      }
    }
  }
  
  fileprivate func performFetchFor() {
    do {
      try fetchResultsController.performFetch()
    } catch {
      presenter.handleError(error)
    }
    
    presenter.presentReload()
  }
  
  fileprivate func setupFRCFor(predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor], delegate: FetchedResultsControllerDelegateProxy) -> NSFetchedResultsController<UserManagedObject> {
    
    let fetchRequest: NSFetchRequest<UserManagedObject> = UserManagedObject.fetchRequest()
    
    fetchRequest.predicate = predicate
    fetchRequest.sortDescriptors = sortDescriptors
    fetchRequest.fetchBatchSize = 30
    
    let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStorage.viewContext, sectionNameKeyPath: nil, cacheName: nil)
    
    fetchResultsController.delegate = delegate
    return fetchResultsController
  }
  
  fileprivate func performFetchAndSaveToStorage(page: Int, perPage: Int) {
    AppLogger.debug("performFetchUpvotesAndSaveToStorage \(page)")
    referralUserService.getRegisteredReferralUsers(page: page, perPage: perPage) { [weak self] in
      switch $0 {
      case .success(let upvotes):
        guard let strongSelf = self else {
          return
        }

        let relations = upvotes.0
          .map { return  PartialUserRelations.registeredReferralUsers($0, referralOwner: strongSelf.targetUser) }
        
        strongSelf.coreDataStorage.updateStorage(with: relations)
        strongSelf.paginationController.updatePaginationInfo(upvotes.1)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  fileprivate func contentPredicate() -> NSPredicate {
    return NSPredicate(format: "referralOwnerUser.id = \(targetUser.identifier)")
  }
  
  fileprivate func sortDesriptors() -> [NSSortDescriptor] {
    let sortDescriptor = NSSortDescriptor(key: #keyPath(UpvoteManagedObject.id), ascending: false)
    return [sortDescriptor]
  }
}


//MARK:- PaginationControllerDelegate

extension ReferUserInteractor: PaginationControllerDelegate {
  func request(page: Int, perPage: Int) {
    performFetchAndSaveToStorage(page: page, perPage: perPage)
  }
}

//MARK:- FetchedResultsControllerDelegate

extension ReferUserInteractor: FetchedResultsControllerDelegate {
  func updateItems(_ proxy: FetchedResultsControllerDelegateProxy, updates: CollectionViewModelUpdate) {
    presenter.presentCollectionUpdates(updates)
  }
}
