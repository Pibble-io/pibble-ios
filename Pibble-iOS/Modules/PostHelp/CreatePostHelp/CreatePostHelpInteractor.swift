//
//  CreatePostHelpInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 26/09/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - CreatePostHelpInteractor Class
final class CreatePostHelpInteractor: Interactor {
  fileprivate let predefinedRewardsAmounts: [Int] = [100, 300, 500, 1000]
  
  let draft: MutablePostHelpDraftProtocol = CreatePostHelp.PostHelpDraft()
  
  fileprivate lazy var predefinedRewards: [CreatePostHelp.Reward] = {
    return predefinedRewardsAmounts.map { .predefinedAmount($0)}
  }()
  
  lazy var helpTypes: [CreatePostHelp.HelpType] = {
    let items = [CreatePostHelp.Strings.HelpTypes.translateToEnglish.localize(),
                 CreatePostHelp.Strings.HelpTypes.translateToKorean.localize()]
    
    return items.map { .predefinedText($0) }
  }()
}

// MARK: - CreatePostHelpInteractor API
extension CreatePostHelpInteractor: CreatePostHelpInteractorApi {
  func initialFetchData() {
    presenter.presentReload()
  }
  
  var rewards: [CreatePostHelp.Reward] {
    guard let pickedReward = draft.reward else {
      return [predefinedRewards, [CreatePostHelp.Reward.amount(nil)]].flatMap { return $0 }
    }
    
    switch pickedReward {
    case .predefinedAmount(_):
      return [predefinedRewards, [CreatePostHelp.Reward.amount(nil)]].flatMap { return $0 }
    case .amount(let pickedAmount):
      return [predefinedRewards, [CreatePostHelp.Reward.amount(pickedAmount)]].flatMap { return $0 }
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension CreatePostHelpInteractor {
  var presenter: CreatePostHelpPresenterApi {
    return _presenter as! CreatePostHelpPresenterApi
  }
}
