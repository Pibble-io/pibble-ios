//
//  WalletPinCodeModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

//MARK: - WalletPinCodeRouter API
protocol WalletPinCodeRouterApi: RouterProtocol {
  func routeToCodeVerificationWith(_ email: ResetPasswordEmailProtocol)
}

//MARK: - WalletPinCodeView API
protocol WalletPinCodeViewControllerApi: ViewControllerProtocol {
  func setPickedDigits(_ digits: [Bool])
  func setPurposeTitle(_ title: String)
  func showFailAnimaion()
  func showLoaderViewHidden(_ hidden: Bool)
  func setRestorePincodeButtonHidden(_ hidden: Bool)
}

//MARK: - WalletPinCodePresenter API
protocol WalletPinCodePresenterApi: PresenterProtocol {
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelFor(_ indexPath: IndexPath) -> WalletPinCode.DigitItemType
  
  func handlePickItemAt(_ indexPath: IndexPath)
  func handleLeftControlAction()
  func handleRightControlAction()
  func handleResetPinCodeAction()
  
  func presentPinCodeCheckSuccess(_ pinCode: String)
  func presentPinCodeCheckFailure()
  func presentPickedDigits(_ digits: [Int])
  func presentPurpose(_ purpose: WalletPinCode.PinCodePurpose)
  func presentPinCodeCheckingInProgress()
  
  func presentSendingRequestFinished()
  func presentEmailResetCodeSentSuccessTo(_ email: ResetPasswordEmailProtocol)
}

//MARK: - WalletPinCodeInteractor API
protocol WalletPinCodeInteractorApi: InteractorProtocol {
  func fetchInitialData()
  func appendPinCodeDigitValue(_ value: Int)
  func removeLastPinCodeDigitValue()
  func performEmailResetCodeRequest()
  
  var pinCodePurpose: WalletPinCode.PinCodePurpose { get set }
}

protocol DigitViewModelProtocol {
  var title: String { get }
}

protocol DigitWithControlsViewModelProtocol: DigitViewModelProtocol{
  var leftTitle: String { get }
  var rightTitle: String { get }
}

protocol WalletPinCodeUnlockDelegateProtocol: class {
  func walletDidUnlockWith(_ pinCode: String)
  func walletDidFailToUnlock()
}
