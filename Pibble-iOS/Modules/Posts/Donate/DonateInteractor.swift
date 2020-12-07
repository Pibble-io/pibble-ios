//
//  DonateInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - DonateInteractor Class
final class DonateInteractor: Interactor {
  fileprivate let accountProfileService: AccountProfileServiceProtocol
  
  fileprivate var minUpvote = 0
  fileprivate var maxUpvote = Int.max
  
  fileprivate var availableUpVotes: Int = 0
  fileprivate(set) var selectedAmount: BalanceProtocol = Balance(currency: .pibble, value: 0.0)
  fileprivate let currencies: [BalanceCurrency]
  fileprivate var currentCurrency: BalanceCurrency?
  
  let amountPickType: Donate.AmountPickType
  
  init(accountProfileService: AccountProfileServiceProtocol, currencies: [BalanceCurrency], amountPickType: Donate.AmountPickType) {
    self.accountProfileService = accountProfileService
    self.currencies = currencies
    currentCurrency = currencies.first
    self.amountPickType = amountPickType
  }
}

// MARK: - DonateInteractor API
extension DonateInteractor: DonateInteractorApi {
  func setValueToMin() {
    setUpvoteValue(minUpvote)
  }
  
  func setValueToMax() {
    setUpvoteValue(maxUpvote)
  }
  
  func switchToNextCurrency() {
    guard let selectedCurrency = currentCurrency else {
      return
    }
    
    guard var selectedCurrencyIndex = currencies.index(of: selectedCurrency) else {
      return
    }
    
    selectedCurrencyIndex += 1
    if selectedCurrencyIndex >= currencies.count {
      currentCurrency = currencies.first
    } else {
      currentCurrency = currencies[selectedCurrencyIndex]
    }
    
    guard let profile = accountProfileService.currentUserAccount else {
      fetchProfileDataAndUpdateLimits()
      return
    }
    
    setAmountLimitForProfile(profile)
  }
  
  func fetchInitialData() {
    fetchProfileDataAndUpdateLimits()
  }
  
  func setUpvoteValue(_ value: Int) {
    guard let selectedCurrency = currentCurrency else {
      return
    }
    
    var availableUpVotesWithLimit = min(availableUpVotes, maxUpvote)
    switch amountPickType {
    case .anyAmount:
      break
    case .fixedStepAmount(let minStep):
      availableUpVotesWithLimit = (availableUpVotesWithLimit / minStep) * minStep
    }
    
    var amount = (max(minUpvote, min(value, availableUpVotesWithLimit)))
    
    switch amountPickType {
    case .anyAmount:
      break
    case .fixedStepAmount(let minStep):
      amount = (amount / minStep) * minStep
    }
    
    selectedAmount = Balance(currency: selectedCurrency, value: Double(amount))
    let upvoting = Donate.UpVoteModel(minUpvotes: minUpvote,
                                      maxUpvotes: maxUpvote,
                                      available: availableUpVotes,
                                      currentPickUpvoteAmount: amount,
                                      currency: selectedCurrency)
    
    presenter.presentUpvotingData(upvoting)
  }
}

// MARK: - Interactor Viper Components Api
private extension DonateInteractor {
  var presenter: DonatePresenterApi {
    return _presenter as! DonatePresenterApi
  }
}

extension DonateInteractor {
  fileprivate func fetchProfileDataAndUpdateLimits() {
    if let profile = accountProfileService.currentUserAccount {
      setAmountLimitForProfile(profile)
    }
    
    accountProfileService.getProfile { [weak self] in
      guard let strongSelf = self else {
        return
      }
      switch $0 {
      case .success(let userProfile):
        strongSelf.setAmountLimitForProfile(userProfile)
      case .failure(let error):
        strongSelf.presenter.handleError(error)
      }
    }
  }
  
  fileprivate func setAmountLimitForProfile(_ accountProfile: AccountProfileProtocol) {
    guard let selectedCurrency = currentCurrency else {
      return
    }
    
    minUpvote = 0
    let balance = accountProfile.walletBalances.first {
      $0.currency == selectedCurrency
    }
    
    guard let selectedCurrencyBalance = balance else {
      maxUpvote = 0
      availableUpVotes = 0
      setUpvoteValue(minUpvote)
      return
    }
    
    maxUpvote = Int(selectedCurrencyBalance.value)
    availableUpVotes = maxUpvote
    setUpvoteValue(minUpvote)
  }
}
