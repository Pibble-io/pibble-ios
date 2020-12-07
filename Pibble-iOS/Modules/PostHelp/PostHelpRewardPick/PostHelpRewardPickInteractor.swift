//
//  PostHelpRewardPickInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - PostHelpRewardPickInteractor Class
final class PostHelpRewardPickInteractor: Interactor {
  fileprivate let accountProfileService: AccountProfileServiceProtocol
 
  fileprivate let defaultMinReward: Double = 100
  fileprivate let defaultMaxReward: Double = 100000
  fileprivate let defaultReward: Int = 2000
  
  fileprivate var selectedAmount: Double = 2000
  
  fileprivate var availableAmountInWallet: Double = 0
  
  init(accountProfileService: AccountProfileServiceProtocol) {
    self.accountProfileService = accountProfileService
  }
}

// MARK: - PostHelpRewardPickInteractor API
extension PostHelpRewardPickInteractor: PostHelpRewardPickInteractorApi {
  var pickedAmount: Int {
    return selectedAmount.toInt() ?? defaultReward
  }
  
  func setValueToMin() {
    setPickedValue(defaultMinReward)
  }
  
  func setValueToMax() {
     setPickedValue(defaultMaxReward)
  }
  
  func fetchInitialData() {
    if let profile = accountProfileService.currentUserAccount {
      setLimitsForUserProfile(profile)
    }

    accountProfileService.getProfile { [weak self] in
      switch $0 {
      case .success(let profile):
        self?.setLimitsForUserProfile(profile)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  fileprivate func setLimitsForUserProfile(_ userProfile: AccountProfileProtocol) {
    let available = userProfile.walletBalances
      .first {  $0.currency == BalanceCurrency.pibble }?
      .value ?? 0.0
    
    
    availableAmountInWallet = available
    setPickedValue(selectedAmount)
  }
  
  func setPickedValue(_ value: Double) {
    selectedAmount = value
    let rewardModel = PostHelpRewardPick.PostHelpRewardPickModel(minReward: defaultMinReward,
                                                              maxReward: defaultMaxReward,
                                                              availableInWallet: availableAmountInWallet,
                                                              currentPickedAmount: selectedAmount)
    
    presenter.presentUpvotingData(rewardModel)
  }
}

// MARK: - Interactor Viper Components Api
private extension PostHelpRewardPickInteractor {
    var presenter: PostHelpRewardPickPresenterApi {
        return _presenter as! PostHelpRewardPickPresenterApi
    }
}
