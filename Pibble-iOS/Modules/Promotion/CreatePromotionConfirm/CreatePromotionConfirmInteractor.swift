//
//  CreatePromotionConfirmInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 05/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - CreatePromotionConfirmInteractor Class
final class CreatePromotionConfirmInteractor: Interactor {
  let promotionDraft: PromotionDraft
  
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  fileprivate let promotionService: PromotionServiceProtocol
  fileprivate let postingService: PostingServiceProtocol
  fileprivate let storageService: CoreDataStorageServiceProtocol
  
  init(promotionService: PromotionServiceProtocol,
       accountProfileService: AccountProfileServiceProtocol,
       promotionDraft: PromotionDraft,
       postingService: PostingServiceProtocol,
       storageService: CoreDataStorageServiceProtocol) {
    self.accountProfileService = accountProfileService
    self.promotionDraft = promotionDraft
    self.promotionService = promotionService
    self.postingService = postingService
    self.storageService = storageService
    super.init()
  }
}

// MARK: - CreatePromotionConfirmInteractor API
extension CreatePromotionConfirmInteractor: CreatePromotionConfirmInteractorApi {
  var impressionsBudget: Double {
    return promotionService.impressionsBudgetPerCent
  }
  
  var interactionsBudget: Double {
    return promotionService.interactionsBudgetPerCent
  }
  
  func performPromotionCreation() {
    let postId = promotionDraft.post.identifier
    promotionService.createPromotionFor(promotionDraft.post, promotionDraft: promotionDraft) { [weak self] in
      if let error = $0 {
        self?.presenter.handleError(error)
        return
      }
      
      self?.postingService.showPosting(postId: postId) { [weak self] in
        guard let strongSelf = self else {
          return
        }
        switch $0 {
        case .success(let post):
          strongSelf.storageService.updateStorage(with: [post])
        case .failure(let error):
          strongSelf.presenter.handleError(error)
        }
        
        strongSelf.presenter.presentPromotionCreationSuccess()
      }
    }
  }
  
  func initialFetchData() {
    guard let _ = promotionDraft.dailyBudget else {
      presenter.handleError(CreatePromotionConfirm.CreatePromotionConfirmError.budgetMissing)
      return
    }
    
    guard let _ = promotionDraft.promotionDuration else {
      presenter.handleError(CreatePromotionConfirm.CreatePromotionConfirmError.durationMissing)
      return
    }
    
    guard let totalBudget = promotionDraft.totalBudget else {
      presenter.handleError(CreatePromotionConfirm.CreatePromotionConfirmError.budgetMissing)
      return
    }
    
    let reach = promotionService.reachForTotalBudget(totalBudget)
    presenter.presentUsersReach(reach)
  }
  
  func initialRefreshData() {
    guard let destination = promotionDraft.destination else {
      presenter.handleError(CreatePromotionConfirm.CreatePromotionConfirmError.destinationMissing)
      return
    }
    
    guard let _ = promotionDraft.dailyBudget else {
      presenter.handleError(CreatePromotionConfirm.CreatePromotionConfirmError.budgetMissing)
      return
    }
    
    guard let duration = promotionDraft.promotionDuration else {
      presenter.handleError(CreatePromotionConfirm.CreatePromotionConfirmError.durationMissing)
      return
    }
    
    guard let totalBudget = promotionDraft.totalBudget else {
      presenter.handleError(CreatePromotionConfirm.CreatePromotionConfirmError.budgetMissing)
      return
    }
   
    switch destination {
    case .userProfile(let action):
      guard let profile = accountProfileService.currentUserAccount else {
        accountProfileService.getProfile { [weak self] in
          guard let strongSelf = self else {
            return
          }
          switch $0 {
          case .success(let profile):
            let draftModel = CreatePromotionConfirm.PromotionDraftModel(destination: .profile(profile, action),
                                                                        totalBudget: totalBudget,
                                                                        duration: duration)
            
            strongSelf.presenter.presentPromotionDraft(draftModel)
          case .failure(let error):
            strongSelf.presenter.handleError(error)
          }
        }
        
        return
      }
      
      let draftModel = CreatePromotionConfirm.PromotionDraftModel(destination: .profile(profile, action),
                                                                  totalBudget: totalBudget,
                                                                  duration: duration)
      
      presenter.presentPromotionDraft(draftModel)
    case .url(let url, let action):
      let draftModel = CreatePromotionConfirm.PromotionDraftModel(destination: .url(url, action),
                                                                  totalBudget: totalBudget,
                                                                  duration: duration)
      presenter.presentPromotionDraft(draftModel)
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension CreatePromotionConfirmInteractor {
  var presenter: CreatePromotionConfirmPresenterApi {
    return _presenter as! CreatePromotionConfirmPresenterApi
  }
}
