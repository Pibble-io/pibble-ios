//
//  DonateModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

//MARK: - DonateRouter API
protocol DonateRouterApi: RouterProtocol {
}

//MARK: - DonateView API
protocol DonateViewControllerApi: ViewControllerProtocol {
  func setViewModel(_ vm: Donate.UpVoteViewModel?, animated: Bool)
  func setInputViewHidden(_ hidden: Bool, animated: Bool)
}

//MARK: - DonatePresenter API
protocol DonatePresenterApi: PresenterProtocol {
  var isDirectInputSupported: Bool { get }
  var viewModel: Donate.UpVoteViewModel? { get }
  
  
  func handleHideAction()
  func handleVoteAction()
  func handleSliderChangeValue(_ value: Float)
  func handleSwitchToNextCurrency()
  
  func handleChangeValue(_ value: String)
  func handleChangeValueToMin()
  func handleChangeValueToMax()
  
  
  func presentUpvotingData(_ upvoting: Donate.UpVoteModel)
}

//MARK: - DonateInteractor API
protocol DonateInteractorApi: InteractorProtocol {
  var amountPickType: Donate.AmountPickType { get }
  
  var selectedAmount: BalanceProtocol  { get }
  func fetchInitialData()
  func setUpvoteValue(_ value: Int)
  func switchToNextCurrency()
  
  func setValueToMin()
  func setValueToMax()
}

protocol DonateDelegateProtocol: class {
  func shouldDonateWithBalance(_ balance: BalanceProtocol, price: Double?)
}
