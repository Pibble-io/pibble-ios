//
//  FundingPostDetailModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 06/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - FundingPostDetailRouter API
protocol FundingPostDetailRouterApi: RouterProtocol {
  func routeToEULAForPost(_ post: PostingProtocol)
  func routeToChatRoomForPost(_ post: PostingProtocol)
  func routeToExternalLinkAt(_ url: URL)
  
  func routeToDonate(delegate: DonateDelegateProtocol, donationAmountMinStep: Double?) 
}

//MARK: - FundingPostDetailView API
protocol FundingPostDetailViewControllerApi: ViewControllerProtocol {
  func reloadData()
  func performHideAnimation(_ complete: @escaping () -> Void)
}

//MARK: - FundingPostDetailPresenter API
protocol FundingPostDetailPresenterApi: PresenterProtocol {
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func viewModelAt(_ indexPath: IndexPath) -> FundingPostDetail.ViewModelType
  
  func handleHideAction()
  func handleAction(_ action: FundingPostDetail.Actions)
  
  func presentPost(_ post: PostingProtocol, currentUser: UserProtocol)
  
}

//MARK: - FundingPostDetailInteractor API
protocol FundingPostDetailInteractorApi: InteractorProtocol {
  var post: PostingProtocol { get }
  
  func fetchInitialData()
//  func performDonateAt(_ withBalance: BalanceProtocol, donatePrice: Double?)
}

protocol FundingPostDetailCheckoutButtonViewModelProtocol {
  var title: String { get }
  var disabledStateTitle: String { get }
  var isEnabled: Bool { get }
}

protocol FundingPostDetailTitleViewModelProtocol {
  var title: String { get }
  var tags: String { get }
  var icon: UIImage? { get }
}
 
protocol FundingPostDetailProgressStatusViewModelProtocol {
  var raisedPerCent: String { get }
  var campaignProgress: Double { get }
  var raisedAmount: String { get }
  var goalAmount: String { get }
}

protocol FundingPostDetailTimeProgressStatusViewModelProtocol {
  var startedDate: String { get }
  var campaignProgress: Double { get }
  var endDate: String { get }
}

protocol FundingPostDetailContributorsInfoViewModelProtocol {
  var contributorsCount: String { get }
}

protocol FundingPostDetailTeamViewModelProtocol {
  var teamName: String { get }
  var teamInfo: String { get }
}

protocol FundingPostDetailRewardsInfoViewModelProtocol {
  var rewards: [FundingPostDetailRewardsInfoItemViewModelProtocol] { get }
}

protocol FundingPostDetailRewardsInfoItemViewModelProtocol {
  var rewardTitle: String { get }
  var rewardsPrice: String { get }
  var rewardAmount: String { get }
  var isSelected: Bool { get }
}

protocol FundingPostDetailFinishStatsViewModelProtocol {
  var goal: String { get }
  var raised: String { get }
  var finishDate: String { get }
}


protocol FundingPostDetailCampaignFinishViewModelProtocol {
  var iconImage: UIImage? { get }
  var message: String { get }
  var isExtended: Bool { get }
}

protocol FundingPostDetailActionButtonViewModelProtocol {
  var title: String { get }
  var action: FundingPostDetail.Actions { get }

}

protocol FundingDetailDelegateProtocol: class {
  func shouldDonateWithBalance(_ balance: BalanceProtocol, price: Double?)
  
  func shouldStopFindingCampaign()
  
  func shouldCreateFundingPostWithTeam(_ team: FundingCampaignTeamProtocol)
}
