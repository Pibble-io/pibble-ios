//
//  WalletPreviewPresenter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 15.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

fileprivate enum WalletPreviewItems {
  case upvotes
  case redBrush
  case greenBrush
  case pibble
  case etherium
  case bitcoin
}

// MARK: - WalletPreviewPresenter Class
final class WalletPreviewPresenter: Presenter {
  fileprivate let items: [[WalletPreviewItems]] = [
    [.upvotes, .redBrush, .greenBrush],
    [.pibble, .etherium, .bitcoin]
  ]
  
  override func viewWillAppear() {
    super.viewWillAppear()
    interactor.initialFetchData()
  }
}

// MARK: - WalletPreviewPresenter API
extension WalletPreviewPresenter: WalletPreviewPresenterApi {
  func handleWalletAction() {
    router.routeToWallet()
  }
  
  func presentReload() {
    viewController.reloadData()
  }
  
  func numberOfSections() -> Int {
    return items.count
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return items[section].count
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> WalletPreviewItemViewModelProtocol {
    let item = items[indexPath.section][indexPath.item]
    let userProfile = interactor.currentUserAccount.account
    let accountLimits = interactor.currentUserAccount.limits
    
    let amount: String
    switch item {
    case .upvotes:
      let dayCount = accountLimits?.postUpvoteLimits.dayCount ?? 0
      let dayLimit = accountLimits?.postUpvoteLimits.dayLimit ?? 0

      amount = "\(dayCount)/\(dayLimit)"
    case .redBrush:
      let amounValue = userProfile?.walletBalances.first { $0.currency == BalanceCurrency.redBrush }?.value ?? 0.0
      amount = String(format:"%.0f", amounValue)
    case .greenBrush:
      let amounValue = userProfile?.walletBalances.first { $0.currency == BalanceCurrency.greenBrush }?.value ?? 0.0
      amount = String(format:"%.0f", amounValue)
    case .pibble:
      let amounValue = userProfile?.walletBalances.first { $0.currency == BalanceCurrency.pibble }?.value ?? 0.0
      amount = String(format:"%.0f", amounValue)
    case .etherium:
      let amounValue = userProfile?.walletBalances.first { $0.currency == BalanceCurrency.etherium }?.value ?? 0.0
      amount = String(format:"%.3f", amounValue)
    case .bitcoin:
      let amounValue = userProfile?.walletBalances.first { $0.currency == BalanceCurrency.bitcoin }?.value ?? 0.0
      amount = String(format:"%.8f", amounValue)
    }
    
    return WalletPreview.ItemViewModel(itemImage: item.image,
                                       itemAmount: amount,
                                       itemTitle: item.title)
  }
  
}

// MARK: - WalletPreview Viper Components
fileprivate extension WalletPreviewPresenter {
  var viewController: WalletPreviewViewControllerApi {
    return _viewController as! WalletPreviewViewControllerApi
  }
  var interactor: WalletPreviewInteractorApi {
    return _interactor as! WalletPreviewInteractorApi
  }
  var router: WalletPreviewRouterApi {
    return _router as! WalletPreviewRouterApi
  }
}

extension WalletPreviewItems {
  var image: UIImage {
    switch self {
    case .upvotes:
      return #imageLiteral(resourceName: "WalletPreview-Upvote")
    case .redBrush:
      return #imageLiteral(resourceName: "WalletPreview-RedBrush")
    case .greenBrush:
      return #imageLiteral(resourceName: "WalletPreview-GreenBrush")
    case .pibble:
      return #imageLiteral(resourceName: "WalletPreview-Pibble")
    case .etherium:
      return #imageLiteral(resourceName: "WalletPreview-Etherium")
    case .bitcoin:
      return #imageLiteral(resourceName: "WalletPreview-Bitcoin")
    }
  }
  
  var title: String {
    switch self {
    case .upvotes:
      return WalletPreview.Strings.upvotes.localize()
    case .redBrush:
      return BalanceCurrency.redBrush.symbolPresentation
    case .greenBrush:
      return BalanceCurrency.greenBrush.symbolPresentation
    case .pibble:
      return BalanceCurrency.pibble.symbolPresentation
    case .etherium:
      return BalanceCurrency.etherium.symbolPresentation
    case .bitcoin:
      return BalanceCurrency.bitcoin.symbolPresentation
    }
  }
}

extension WalletPreview {
  enum Strings: String, LocalizedStringKeyProtocol {
    case upvotes = "Upvote"
  }
}
