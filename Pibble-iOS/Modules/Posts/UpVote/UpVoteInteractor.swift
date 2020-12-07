//
//  UpVoteInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - UpVoteInteractor Class
final class UpVoteInteractor: Interactor {
  fileprivate let accountProfileService: AccountProfileServiceProtocol
 
  fileprivate var minUpvote = 0
  fileprivate var maxUpvote = Int.max
  
  fileprivate var availableUpVotes: Int = 0
  fileprivate(set) var selectedAmount: Int = 0
  fileprivate let purpose: UpVote.UpvotePurpose
  
  init(accountProfileService: AccountProfileServiceProtocol, purpose: UpVote.UpvotePurpose) {
    self.accountProfileService = accountProfileService
    self.purpose = purpose
  }
}

// MARK: - UpVoteInteractor API
extension UpVoteInteractor: UpVoteInteractorApi {
  func setValueToMin() {
    setUpvoteValue(minUpvote)
  }
  
  func setValueToMax() {
     setUpvoteValue(maxUpvote)
  }
  
  func fetchInitialData() {
    accountProfileService.availableUpVotesForCurrentUser { [weak self] in
      switch $0 {
      case .success(let minValue, let maxValue, let available):
        guard let strongSelf = self else {
          return
        }
        strongSelf.minUpvote = minValue
        strongSelf.maxUpvote = min(maxValue, Int(available))
        strongSelf.availableUpVotes = min(maxValue, available)
        switch strongSelf.purpose {
        case .posting:
          strongSelf.setUpvoteValue(strongSelf.minUpvote)
        case .comment:
          strongSelf.setUpvoteValue(strongSelf.minUpvote)
        case .user(let amount):
          strongSelf.setUpvoteValue(amount)
        }
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  func setUpvoteValue(_ value: Int) {
    let availableUpVotesWithLimit = min(availableUpVotes, maxUpvote)
    let amount = (max(minUpvote, min(value, availableUpVotesWithLimit)))
    selectedAmount = amount
    let upvoting = UpVote.UpVoteModel(minUpvotes: minUpvote,
                       maxUpvotes: maxUpvote,
                       available: availableUpVotes,
                       currentPickUpvoteAmount: amount)
    
    presenter.presentUpvotingData(upvoting)
  }
  
}

// MARK: - Interactor Viper Components Api
private extension UpVoteInteractor {
    var presenter: UpVotePresenterApi {
        return _presenter as! UpVotePresenterApi
    }
}
