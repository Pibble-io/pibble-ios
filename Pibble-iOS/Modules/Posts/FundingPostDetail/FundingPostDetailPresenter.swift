//
//  FundingPostDetailPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 06/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - FundingPostDetailPresenter Class

final class FundingPostDetailPresenter: Presenter {
  fileprivate enum Sections: Int {
    case info
    case actions
  }
  
  fileprivate enum Items {
    case description
    case licensing
    case agreement
    case messages
    case checkout
  }
  
  fileprivate let presentationType: FundingPostDetail.PresentationType
  
  fileprivate var sections: [(section: Sections, items: [FundingPostDetail.ViewModelType])] = []
  
  fileprivate weak var delegate: FundingDetailDelegateProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.fetchInitialData()
  }
  
  init(presentationType: FundingPostDetail.PresentationType, delegate: FundingDetailDelegateProtocol?) {
    self.presentationType = presentationType
    self.delegate = delegate
  }
}

// MARK: - FundingPostDetailPresenter API

extension FundingPostDetailPresenter: FundingPostDetailPresenterApi {
  func presentPost(_ post: PostingProtocol, currentUser: UserProtocol) {
    var infoSection: [FundingPostDetail.ViewModelType] = []
    
    if let viewModel = FundingPostDetail.FundingPostDetailTitleViewModel(post: post) {
      infoSection.append(.title(viewModel))
    }
    
    if let viewModel = FundingPostDetail.FundingPostDetailTeamViewModel(post: post) {
      infoSection.append(.teamInfo(viewModel))
    }
    
    if let viewModel = FundingPostDetail.FundingPostDetailContributorsInfoViewModel(post: post) {
      infoSection.append(.contriibutorsInfo(viewModel))
    }
    
    if let viewModel = FundingPostDetail.FundingPostDetailProgressStatusViewModel(post: post) {
      infoSection.append(.progressStatus(viewModel))
    }
    
    if let viewModel = FundingPostDetail.FundingPostDetailTimeProgressStatusViewModel(post: post) {
      infoSection.append(.timeProgressStatus(viewModel))
    }

    let rewardsInfoVM = FundingPostDetail.FundingPostDetailRewardsInfoViewModel(post: post)
    if let viewModel = rewardsInfoVM {
      infoSection.append(.rewardsInfo(viewModel))
    }
  
    if let viewModel = FundingPostDetail.FundingPostDetailFinishStatsViewModel(post: post, presentationType: presentationType) {
      infoSection.append(.finishStats(viewModel))
    }
    
    let finishVM = FundingPostDetail.FundingPostDetailCampaignFinishViewModel(post: post,
                                                                              currentUser: currentUser,
                                                                              presentationType: presentationType)
    let actionVM = FundingPostDetail.FundingPostDetailActionButtonViewModel(post: post,
                                                                           currentUser: currentUser,
                                                                           presentationType: presentationType)
    
    if finishVM == nil && (actionVM == nil || rewardsInfoVM == nil) {
      //add empty space for better look
      let vm = FundingPostDetail.FundingPostDetailCampaignFinishViewModel.empty()
      infoSection.append(.finishCampaign(vm))
    }
    
    if let viewModel = finishVM {
      infoSection.append(.finishCampaign(viewModel))
    }
    
    var actionsSection: [FundingPostDetail.ViewModelType] = []

    if let viewModel = actionVM {
      actionsSection.append(.actionButton(viewModel))
    }

    sections = [(.info, infoSection), (.actions, actionsSection)]
    viewController.reloadData()
  }
  
//  fileprivate func presentPostForGoodsOrderCreation(_ post: PostingProtocol) {
//    viewController.performHideAnimation() { [weak self] in
//      guard let strongSelf = self else {
//        return
//      }
//
//      strongSelf.router.dismiss()
//      strongSelf.delegate?.shouldCreateGoodsOrderFor()
//    }
//  }
  

  func handleAction(_ action: FundingPostDetail.Actions) {
    switch action {
    case .postForTeam:
      guard let team = interactor.post.fundingCampaignTeam else {
        return
      }
      viewController.performHideAnimation() { [weak self] in
        guard let strongSelf = self else {
          return
        }
        
        strongSelf.router.dismiss()
        strongSelf.delegate?.shouldCreateFundingPostWithTeam(team)
      }
    case .donate:
      router.routeToDonate(delegate: self, donationAmountMinStep: interactor.post.fundingCampaign?
        .campaignRewards?
        .donationMinStepForCurrentReward)
    case .stopCampaign:
      viewController.performHideAnimation() { [weak self] in
        guard let strongSelf = self else {
          return
        }
        
        strongSelf.router.dismiss()
        strongSelf.delegate?.shouldStopFindingCampaign()
      }
    
    }
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  fileprivate func present(post: PostingProtocol, goodsInfo: GoodsProtocol) {
//    var infoSection: [FundingPostDetail.ViewModelType] = []
//
//    let goodsInfoVM = FundingPostDetail.GoodsInfoViewModel(goodsInfo: goodsInfo)
//    let goodsDescriptionVM = FundingPostDetail.GoodsDescriptionViewModel(goodsInfo: goodsInfo)
//
//    infoSection.append(.goodsInfo(goodsInfoVM))
//    if let goodsDescriptionVM = goodsDescriptionVM {
//      infoSection.append(.goodsDescription(goodsDescriptionVM))
//    }
//
//    var actionsSection: [FundingPostDetail.ViewModelType] = []
//
//    actionsSection.append(.messages)
//    actionsSection.append(.checkout(FundingPostDetail.CheckoutButtonViewModel(goodsInfo: goodsInfo)))
//    actionsSection.append(.goodsEscrowInfo)
//
//    sections = [(.info, infoSection), (.actions, actionsSection)]
//    viewController.reloadData()
  }
  
  fileprivate func present(post: PostingProtocol, commerceInfo: CommerceInfoProtocol) {
//    var infoSection: [FundingPostDetail.ViewModelType] = []
//
//    let mediaItemsVM = FundingPostDetail.FundingPostDetailDescriptionViewModel(post: post, commerceInfo: commerceInfo)
//    let licensingVM = FundingPostDetail.FundingPostDetailLicensingViewModel(commericalInfo: commerceInfo)
//    let agreementVM = FundingPostDetail.FundingPostDetailAgreementViewModel()
//
//    infoSection.append(.description(mediaItemsVM))
//    infoSection.append(.licensing(licensingVM))
//    infoSection.append(.agreement(agreementVM))
//
//    var actionsSection: [FundingPostDetail.ViewModelType] = []
//
//    actionsSection.append(.messages)
//    actionsSection.append(.checkout(FundingPostDetail.CheckoutButtonViewModel(digitalGoodInfo: commerceInfo)))
//    actionsSection.append(.digitalGoodsUsageInfo)
//
//    sections = [(.info, infoSection), (.actions, actionsSection)]
//    viewController.reloadData()
  }
  
  func numberOfSections() -> Int {
    return sections.count
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return sections[section].items.count
  }
  
  func viewModelAt(_ indexPath: IndexPath) -> FundingPostDetail.ViewModelType {
    return sections[indexPath.section].items[indexPath.item]
  }
}

// MARK: - FundingPostDetail Viper Components

fileprivate extension FundingPostDetailPresenter {
  var viewController: FundingPostDetailViewControllerApi {
    return _viewController as! FundingPostDetailViewControllerApi
  }
  var interactor: FundingPostDetailInteractorApi {
    return _interactor as! FundingPostDetailInteractorApi
  }
  var router: FundingPostDetailRouterApi {
    return _router as! FundingPostDetailRouterApi
  }
}

extension FundingPostDetailPresenter: DonateDelegateProtocol {
  func shouldDonateWithBalance(_ balance: BalanceProtocol, price: Double?) {
    viewController.performHideAnimation() { [weak self] in
      guard let strongSelf = self else {
        return
      }

      strongSelf.router.dismiss()
      strongSelf.delegate?.shouldDonateWithBalance(balance, price: price)
    }
  }
}
