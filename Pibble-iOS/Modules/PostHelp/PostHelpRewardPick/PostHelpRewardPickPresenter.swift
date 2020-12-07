//
//  PostHelpRewardPickPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - PostHelpRewardPickPresenter Class
final class PostHelpRewardPickPresenter: Presenter {
  fileprivate weak var upVoteAmountPickDelegate: PostHelpRewardPickDelegateProtocol?
  
  fileprivate lazy var numberFormatter: NumberFormatter = {
    return NumberFormatter()
  }()
  
  fileprivate(set) var viewModel: PostHelpRewardPick.PostHelpRewardPickViewModel? {
    didSet {
      let hadValueBefore = oldValue == nil && viewModel != nil
      viewController.setViewModel(viewModel, animated: !hadValueBefore)
      viewController.setInputViewHidden(viewModel == nil, animated: hadValueBefore)
    }
  }

  override func viewWillAppear() {
    super.viewWillAppear()
    viewModel = nil
    interactor.fetchInitialData()
  }
  
  override func viewDidAppear() {
    super.viewDidAppear()
  }
  
  init(upVoteAmountPickDelegate: PostHelpRewardPickDelegateProtocol) {
    self.upVoteAmountPickDelegate = upVoteAmountPickDelegate
  }
}

// MARK: - PostHelpRewardPickPresenter API
extension PostHelpRewardPickPresenter: PostHelpRewardPickPresenterApi {
  
  func handleChangeValue(_ value: String) {
    let amountValueString = value.count > 0 ? value : "0"
    guard let amount = numberFormatter.number(from: amountValueString)?.doubleValue else {
      interactor.setPickedValue(0)
      return
    }
    
    interactor.setPickedValue(amount)
  }
  
  func handleChangeValueToMin() {
    interactor.setValueToMin()
  }
  
  func handleChangeValueToMax() {
    interactor.setValueToMax()
  }
  
  func handleSliderChangeValue(_ value: Float) {
    interactor.setPickedValue(Double(value))
  }
  
  func presentUpvotingData(_ rewardModel: PostHelpRewardPick.PostHelpRewardPickModel) {
    viewModel = PostHelpRewardPick.PostHelpRewardPickViewModel(rewardModel: rewardModel)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func handleLikeAction() {
    router.dismiss()
  }
  
  func handleConfirmAction() {
    router.dismiss()
    upVoteAmountPickDelegate?
      .shouldPostHelpRewardPickWithAmount(interactor.pickedAmount)
  }
}

//MARK:- Helpers
extension PostHelpRewardPickPresenter {
  
}

// MARK: - PostHelpRewardPick Viper Components
fileprivate extension PostHelpRewardPickPresenter {
    var viewController: PostHelpRewardPickViewControllerApi {
        return _viewController as! PostHelpRewardPickViewControllerApi
    }
    var interactor: PostHelpRewardPickInteractorApi {
        return _interactor as! PostHelpRewardPickInteractorApi
    }
    var router: PostHelpRewardPickRouterApi {
        return _router as! PostHelpRewardPickRouterApi
    }
}


fileprivate enum UIConstants {
  enum Colors {
    static let upvotePurposeTitle = UIColor.gray70
    static let upvotePurposeActionTitle = UIColor.greenPibble
  }
}
