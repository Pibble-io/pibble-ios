//
//  WalletRequestAmountPickModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

//MARK: - WalletRequestAmountPickRouter API
protocol WalletTransactionAmountPickRouterApi: WalletPinCodeSecuredRouterProtocol {
  func routeToPinCodeUnlock(delegate: WalletPinCodeUnlockDelegateProtocol)
  func routeToInvoiceCreate(_ mainBalance: Balance, secondaryBalance: Balance)
  func routeToTransactionCreate(_ mainBalance: Balance, secondaryBalance: Balance)
}

//MARK: - WalletRequestAmountPickView API
protocol WalletTransactionAmountPickViewControllerApi: ViewControllerProtocol {
  func setViewModel(_ vm: WalletRequestAmountInputViewModelProtocol?)
  func setNextStageButtonEnabled(_ enabled: Bool)
  func setNavBarTitle(_ title: String)
  func setProfile(_ vm: WalletProfileHeaderViewModelProtocol?, animated: Bool)
  
  func showExchangeDirectionWarningAlert(_ title: String, message: String)
}


//MARK: - WalletRequestAmountPickPresenter API
protocol WalletTransactionAmountPickPresenterApi: PresenterProtocol {
  func handleHideAction()
  func handleNextStageAction()
  func handleSwapCurrencyAction()
  func handleAmountChangedAction(_ value: String)
  func handleSwitchToNextCurrency()
  func handleNextStageActionConfirmation()
  
  func present(mainBalance: Balance, secondaryBalance: Balance, availableBalance: Balance)
  func presentNextStageAvailable(_ available: Bool)
  
  func presentExchangeSuccess()
  func presentUserProfile(_ profile: UserProtocol?)
}

//MARK: - WalletTransactionAmountPickInteractor API
protocol WalletTransactionAmountPickInteractorApi: InteractorProtocol {
  var userProfile: UserProtocol? { get }
  var currentInput: WalletTransactionAmountPick.AmountInput { get }
  
  func initialFetchData()
  func performExchange(mainBalanceToSecondary: Bool)
  
  
  func switchInput()
  func changeAmountTo(_ value: Double)
  
  func performSwitchToNextMainCurrency()
  
  var mainBalance: Balance { get }
  var secondaryBalance: Balance { get }
  var mainCurrencies: [BalanceCurrency] { get }
  var hasPinCode: Bool { get }
  var transactionType: WalletTransactionAmountPick.TransactionType { get }
  var isCurrencySwapAvailable: Bool { get }
}
