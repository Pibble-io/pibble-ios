//
//  DonatePresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

// MARK: - DonatePresenter Class
final class DonatePresenter: Presenter {
  fileprivate weak var upVoteAmountPickDelegate: DonateDelegateProtocol?
  
  fileprivate lazy var numberFormatter: NumberFormatter = {
    return NumberFormatter()
  }()
  
  fileprivate(set) var viewModel: Donate.UpVoteViewModel? {
    didSet {
      let hadValueBefore = oldValue == nil && viewModel != nil
      let currencyDidChange = oldValue?.currentUpVoteCurrency != viewModel?.currentUpVoteCurrency
      let changeModelWithoutAnimation = hadValueBefore || currencyDidChange
      viewController.setViewModel(viewModel, animated: !changeModelWithoutAnimation)
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
  
  init(delegate: DonateDelegateProtocol) {
    self.upVoteAmountPickDelegate = delegate
  }
}

// MARK: - DonatePresenter API
extension DonatePresenter: DonatePresenterApi {
  var isDirectInputSupported: Bool {
    switch interactor.amountPickType {
    case .anyAmount:
      return true
    case .fixedStepAmount(_):
      return false
    }
  }
  
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
  
  func handleSwitchToNextCurrency() {
    interactor.switchToNextCurrency()
  }
  
  func handleSliderChangeValue(_ value: Float) {
    interactor.setUpvoteValue(Int(value))
  }
  
  func presentUpvotingData(_ upvoting: Donate.UpVoteModel) {
    let currentUpVoteAmount = String(upvoting.currentPickUpvoteAmount)
    let currentUpVoteCurrency = upvoting.currency.symbolPresentation
    let purposeTitle = upvotePurposeTitleFor()
    viewModel = Donate.UpVoteViewModel(minSliderValue: Float(upvoting.minUpvotes),
                                           maxSliderValue: Float(upvoting.maxUpvotes),
                                           currentSliderValue: Float(upvoting.currentPickUpvoteAmount),
                                           currentUpVoteAmount: currentUpVoteAmount,
                                           currentUpVoteCurrency: currentUpVoteCurrency,
                                           currentUpVoteCurrencyColor: upvoting.currency.colorForCurrency,
                                           upvotePurposeTitle: purposeTitle,
                                           isUpvoteEnabled: upvoting.currentPickUpvoteAmount > 0)
    
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func handleVoteAction() {
    router.dismiss()
    let price: Double?
    switch interactor.amountPickType {
    case .anyAmount:
      price = nil
    case .fixedStepAmount(let fixedStepAmount):
      price = Double(fixedStepAmount)
    }
    
    upVoteAmountPickDelegate?
      .shouldDonateWithBalance(interactor.selectedAmount, price: price)
  }
}

// MARK: - Donate Viper Components
fileprivate extension DonatePresenter {
    var viewController: DonateViewControllerApi {
        return _viewController as! DonateViewControllerApi
    }
    var interactor: DonateInteractorApi {
        return _interactor as! DonateInteractorApi
    }
    var router: DonateRouterApi {
        return _router as! DonateRouterApi
    }
}

//MARK:- Helpers
extension DonatePresenter {
  fileprivate func upvotePurposeTitleFor() -> NSAttributedString {
    let titleBegin: String
    let titleMid = Donate.Strings.action.localize()
    let titleEnd: String
    titleBegin = Donate.Strings.postingBegin.localize()
    titleEnd = Donate.Strings.postingEnd.localize()
    
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


fileprivate enum UIConstants {
  enum Colors {
    static let upvotePurposeTitle = UIColor.gray70
    static let upvotePurposeActionTitle = UIColor.pinkPibble
  }
}

extension Donate {
  enum Strings: String, LocalizedStringKeyProtocol {
    case action = "Donate"
    
    case postingBegin = "I love it! I will "
    case postingEnd = " for your campaign."
    
    case zeroValue = "0"
  }
}
