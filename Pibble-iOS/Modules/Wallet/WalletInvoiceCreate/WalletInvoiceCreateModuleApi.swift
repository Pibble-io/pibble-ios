//
//  WalletInvoiceCreateModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 31.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//
import UIKit

//MARK: - WalletInvoiceCreateRouter API
protocol WalletInvoiceCreateRouterApi: WalletPinCodeSecuredRouterProtocol {
  func routeToHome()
  func routeTo(_ segment: WalletInvoiceCreate.SelectedSegment, insideView: UIView, delegate: UserPickDelegateProtocol)
}

//MARK: - WalletInvoiceCreateView API
protocol WalletInvoiceCreateViewControllerApi: ViewControllerProtocol {
  var submoduleContainerView: UIView  { get }
  func setPostingButtonInteraction(_ enabled: Bool)
  func setPostingButtonPresentation(_ enabled: Bool)
  func setViewModel(_ vm: WalletRequestAmountInputViewModelProtocol)
}

//MARK: - WalletInvoiceCreatePresenter API
protocol WalletInvoiceCreatePresenterApi: PresenterProtocol {
  func handleDescriptionChanged(_ value: String)
  func handleHideAction()
  func handleSendAction()
  func handleSwitchTo(_ segment: WalletInvoiceCreate.SelectedSegment)
  
  func present(mainBalance: Balance, secondaryBalance: Balance)
  func presentCreateInvoiceEnabled(_ enabled: Bool)
  func presentInvoiceSentSuccefully(_ success: Bool)
}

//MARK: - WalletInvoiceCreateInteractor API
protocol WalletInvoiceCreateInteractorApi: InteractorProtocol {
  func initialFetchData()
  var invoiceRecipientUser: UserProtocol? { get set }
  func updateDescriptionWith(_ value: String)
  func createInvoice()
}
