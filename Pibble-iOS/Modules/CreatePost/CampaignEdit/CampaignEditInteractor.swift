//
//  CampaignEditInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import Photos

// MARK: - CampaignEditInteractor Class
final class CampaignEditInteractor: Interactor {
  fileprivate let postingService: PostingServiceProtocol
  
  fileprivate let createPostService: CreatePostServiceProtocol
  let postingDraft: MutablePostDraftProtocol
  
  fileprivate let campaignType: CampaignType
  fileprivate lazy var imageManager = {
    return PHCachingImageManager()
  }()
  
  let amountLimitations: (min: Double, max: Double) = (min: 5000, max: 10000000)
  
  fileprivate var draftCapmaign: MutableCampaignDraftProtocol {
    return postingDraft.campaignDraft
  }
  
  fileprivate(set) var categories: [CategoryProtocol]  = []
  
  var recipients: [FundRaiseRecipient] {
    switch postingDraft.draftPostType {
    case .media:
      return []
    case .charity:
      return []
    case .crowdfunding, .crowdfundingWithReward:
      return FundRaiseRecipient.allCases
    case .digitalGood:
      return []
    case .goods:
      return []
    }
  }
  
  var crowdFundingPostTypes: [PostingType] {
    switch postingDraft.draftPostType {
    case .media:
      return []
    case .charity:
      return []
    case .crowdfunding, .crowdfundingWithReward:
      return [.crowdfunding, .crowdfundingWithReward]
    case .digitalGood:
      return []
    case .goods:
      return []
    }
  }
  
  var teamTypes: [DraftCampaignTeamType] {
    guard let selectedTeam = draftCapmaign.team,
        case let DraftCampaignTeamType.team(teamEntity) = selectedTeam,
        let selectedTeamEntity = teamEntity else {
      return [.individual, .team(CampaignEdit.DraftCampaignTeam())]
    }
    
    return [.individual, .team(selectedTeamEntity)]
  }
  
  init(postingService: PostingServiceProtocol,
       createPostService: CreatePostServiceProtocol,
       postingDraft: MutablePostDraftProtocol,
       campaignType: CampaignType) {
    self.postingService = postingService
    self.createPostService = createPostService
    self.campaignType = campaignType
    self.postingDraft = postingDraft
  }
}

// MARK: - CampaignEditInteractor API
extension CampaignEditInteractor: CampaignEditInteractorApi {
  
  
  
  var canBePosted: Bool {
    return postingDraft.canBePosted
//    guard postingDraft.canBePosted else {
//      return false
//    }
    
//    guard postingDraft.postingType == .commercial else {
//      return true
//    }
//
//    guard let profile = accountService.currentUserAccount else {
//      return false
//    }
//
//    guard let pickedPrice = postingDraft.commerceDraftAttributes?.price else {
//      return false
//    }
//
//    guard profile.digitalGoodPriceLimits.min.value.isLessThanOrEqualTo(pickedPrice),
//      pickedPrice.isLessThanOrEqualTo(profile.digitalGoodPriceLimits.max.value)
//      else {
//        return false
//    }
    
//    return true
  }
  
  
  var campaign: MutableCampaignDraftProtocol {
    return draftCapmaign
  }
  
  var fundingRewards: MutableFundingRewardDraftProtocol {
    return postingDraft.fundingRewards
  }
  
  func initialFetchData() {
    postingService.getCategories(campaignType) { [weak self] in
      switch $0 {
      case .success(_ , let all):
        self?.categories = all
        self?.presenter.presentCategoriesReload()
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  func updateTitle(_ text: String) {
    draftCapmaign.title = text
  }
  
  func updateGoalAmount(_ value: Double) {
    let amount =  max(min(value, amountLimitations.max), amountLimitations.min)
    draftCapmaign.goal = amount
  }
  
  func updateSelectedCategory(_ category: CategoryProtocol) {
    draftCapmaign.category = category
  }
  
  func updateSelectedRecipient(_ recipient: FundRaiseRecipient) {
    draftCapmaign.raisingFor = recipient
  }
  
  func updateSelectedTeam(_ team: DraftCampaignTeamType) {
    draftCapmaign.team = team
  }
  
  
  
  func updateSelectedTeamLogo(_ asset: PHAsset, config: ImageRequestConfig) {
    imageManager.requestImage(for: asset,
                              targetSize: config.size,
                              contentMode: config.contentMode, options: nil)
    { [weak self]  (image, _) in
      guard let strongSelf = self else {
        return
      }
      
      guard let selectedTeam = strongSelf.draftCapmaign.team,
        case let DraftCampaignTeamType.team(teamEntity) = selectedTeam,
        let selectedTeamEntity = teamEntity else {
          let campaignTeamDraft = CampaignEdit.DraftCampaignTeam()
          campaignTeamDraft.logo = image
          strongSelf.draftCapmaign.team = .team(campaignTeamDraft)
          strongSelf.presenter.presentTeamsReload()
          return
      }
      
      let campaignTeamDraft = CampaignEdit.DraftCampaignTeam(draft: selectedTeamEntity)
      campaignTeamDraft.logo = image
      strongSelf.draftCapmaign.team = .team(campaignTeamDraft)
      strongSelf.presenter.presentTeamsReload()
    }
  }
  
  func updateTeamName(_ text: String) {
    guard let selectedTeam = draftCapmaign.team,
      case let DraftCampaignTeamType.team(teamEntity) = selectedTeam,
      let selectedTeamEntity = teamEntity else {
        let campaignTeamDraft = CampaignEdit.DraftCampaignTeam()
        campaignTeamDraft.name = text
        draftCapmaign.team = .team(campaignTeamDraft)
        return
    }
    
    let campaignTeamDraft = CampaignEdit.DraftCampaignTeam(draft: selectedTeamEntity)
    campaignTeamDraft.name = text
    draftCapmaign.team = .team(campaignTeamDraft)
  }
  
  func performPosting() {
    guard let team = draftCapmaign.team else {
      return
    }
    
    switch team {
    case .individual:
      createPostService.performPosting(draft: postingDraft)
      
    case .team(let teamDraft):
      guard let name = teamDraft?.name,
        name.count > 0
      else {
        presenter.handleError(CampaignEdit.Errors.emptyTeamName)
        return
      }
      
      postingService.checkTeamNameIsAvailable(teamName: name) { [weak self] in
        switch $0 {
        case .success(let isAvailable):
          guard let strongSelf = self else {
            return
          }
          guard isAvailable else {
            strongSelf.presenter.handleError(CampaignEdit.Errors.teamNameAlreadyTaken)
            return
          }
          
         strongSelf.createPostService.performPosting(draft: strongSelf.postingDraft)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension CampaignEditInteractor {
    var presenter: CampaignEditPresenterApi {
        return _presenter as! CampaignEditPresenterApi
    }
}
