//
//  UpVotePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - UpVotePresenter Class
final class UpVotePresenter: Presenter {
  fileprivate weak var upVoteAmountPickDelegate: UpVoteDelegateProtocol?
  
  fileprivate lazy var numberFormatter: NumberFormatter = {
    return NumberFormatter()
  }()
  
  fileprivate let purpose: UpVote.UpvotePurpose
  fileprivate(set) var viewModel: UpVote.UpVoteViewModel? {
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
  
  init(upVoteAmountPickDelegate: UpVoteDelegateProtocol, purpose: UpVote.UpvotePurpose) {
    self.upVoteAmountPickDelegate = upVoteAmountPickDelegate
    self.purpose = purpose
  }
}

// MARK: - UpVotePresenter API
extension UpVotePresenter: UpVotePresenterApi {
  
  func handleChangeValue(_ value: String) {
    let amountValueString = value.count > 0 ? value : "0"
    guard let amount = numberFormatter.number(from: amountValueString)?.intValue else {
      interactor.setUpvoteValue(0)
      return
    }
    
    interactor.setUpvoteValue(amount)
  }
  
  func handleChangeValueToMin() {
    interactor.setValueToMin()
  }
  
  func handleChangeValueToMax() {
    interactor.setValueToMax()
  }
  
  var isPromoted: Bool {
    return upVoteAmountPickDelegate?.isPromoted() ?? false
  }
  
  func handleSliderChangeValue(_ value: Float) {
    interactor.setUpvoteValue(Int(value))
  }
  
  func presentUpvotingData(_ upvoting: UpVote.UpVoteModel) {
    let currentUpVoteAmount = String(upvoting.currentPickUpvoteAmount)
    let currentUpVoteCurrency = "BRUSH"
    let purposeTitle = upvotePurposeTitleFor(purpose)
    
    viewModel = UpVote.UpVoteViewModel(minSliderValue: Float(upvoting.minUpvotes),
                                           maxSliderValue: Float(upvoting.maxUpvotes),
                                           currentSliderValue: Float(upvoting.currentPickUpvoteAmount),
                                           currentUpVoteAmount: currentUpVoteAmount,
                                           currentUpVoteCurrency: currentUpVoteCurrency, upvotePurposeTitle: purposeTitle)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func handleLikeAction() {
    router.dismiss()
  }
  
  func handleVoteAction() {
    router.dismiss()
    upVoteAmountPickDelegate?
      .shouldUpVoteWithAmount(interactor.selectedAmount)
  }
}

//MARK:- Helpers
extension UpVotePresenter {
  fileprivate func upvotePurposeTitleFor(_ purpose: UpVote.UpvotePurpose) -> NSAttributedString {
    let titleBegin: String
    let titleMid = UpVote.Strings.action.localize()
    let titleEnd: String
    
    switch purpose {
    case .posting:
      titleBegin = UpVote.Strings.titleBegin.localize()
      titleEnd = UpVote.Strings.postingEnd.localize()
    case .comment:
      titleBegin = UpVote.Strings.titleBegin.localize()
      titleEnd = UpVote.Strings.commentEnd.localize()
    case .user(_):
      titleBegin = UpVote.Strings.userBegin.localize()
      titleEnd = UpVote.Strings.userEnd.localize()
    }
    
    let attributedTitle = NSMutableAttributedString()
    
    let attributedBegin =
      NSAttributedString(string: titleBegin,
                         attributes: [
                          NSAttributedString.Key.font: UIFont.AvenirNextRegular(size: 15.0),
                          NSAttributedString.Key.foregroundColor: UIConstants.Colors.upvotePurposeTitle
        ])
    
    let attributedMid =
      NSAttributedString(string: titleMid,
                         attributes: [
                          NSAttributedString.Key.font: UIFont.AvenirNextDemiBold(size: 15.0),
                          NSAttributedString.Key.foregroundColor: UIConstants.Colors.upvotePurposeActionTitle
        ])
    
    let attributedEnd =
      NSAttributedString(string: titleEnd,
                         attributes: [
                          NSAttributedString.Key.font: UIFont.AvenirNextRegular(size: 15.0),
                          NSAttributedString.Key.foregroundColor: UIConstants.Colors.upvotePurposeTitle
        ])
    
    attributedTitle.append(attributedBegin)
    attributedTitle.append(attributedMid)
    attributedTitle.append(attributedEnd)
    return attributedTitle
  }
}

// MARK: - UpVote Viper Components
fileprivate extension UpVotePresenter {
    var viewController: UpVoteViewControllerApi {
        return _viewController as! UpVoteViewControllerApi
    }
    var interactor: UpVoteInteractorApi {
        return _interactor as! UpVoteInteractorApi
    }
    var router: UpVoteRouterApi {
        return _router as! UpVoteRouterApi
    }
}


fileprivate enum UIConstants {
  enum Colors {
    static let upvotePurposeTitle = UIColor.gray70
    static let upvotePurposeActionTitle = UIColor.greenPibble
  }
}

extension UpVote {
  enum Strings: String, LocalizedStringKeyProtocol {
    case action = "upvote"
    
    case titleBegin = "I love it! I will "
    
    case postingEnd = " for your posting."
    case commentEnd = " for your comment."
    
    case userBegin = "Thanks for your help. I will "
    case userEnd = " for your upvoting."
  }
}
