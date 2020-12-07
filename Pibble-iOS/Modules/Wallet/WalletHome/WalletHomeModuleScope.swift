//
//  WalletHomeModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 23.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum WalletHome {
  enum RouteActions {
    case payBill, send, recieve, exchange, activity, market
  }
  
  struct ActionViewModel: WalletHomeActionViewModelProtocol {
    let action: WalletHome.RouteActions
    let activeIvoicesCount: String?
    
    init(action: WalletHome.RouteActions, currentUser: AccountProfileProtocol?) {
      self.action = action
      
      guard let user = currentUser else{
        activeIvoicesCount = nil
        return
      }
      
      activeIvoicesCount = user.activeInvoicesCount == 0 ? nil : "\(user.activeInvoicesCount)"
    }
    
    var badgeTitle: String? {
      switch action {
      case .payBill:
        return activeIvoicesCount
      default:
        return nil
      }
    }
    
    var image: UIImage {
      switch action {
      case .payBill:
        return #imageLiteral(resourceName: "WalletHome-Paybill")
      case .send:
        return #imageLiteral(resourceName: "WalletHome-Send")
      case .recieve:
        return #imageLiteral(resourceName: "WalletHome-QRCode")
      case .exchange:
        return #imageLiteral(resourceName: "WalletHome-Exchange")
      case .activity:
        return #imageLiteral(resourceName: "WalletHome-Activity")
      case .market:
        return #imageLiteral(resourceName: "WalletHome-Market")
      }
    }
    
    var title: String {
      switch action {
      case .payBill:
        return WalletHome.Strings.payBill.localize().capitalized
      case .send:
        return WalletHome.Strings.send.localize().capitalized
      case .recieve:
        return WalletHome.Strings.recieve.localize().capitalized
      case .exchange:
        return WalletHome.Strings.exchange.localize().capitalized
      case .activity:
        return WalletHome.Strings.activity.localize().capitalized
      case .market:
        return WalletHome.Strings.market.localize().capitalized
      }
    }
  }
  
  struct UserProfileViewModel: WalletHomeDashboardViewModelProtocol {
    let balances: [(currency: String, balance: String)]
    
    let userpicUrlString: String
    let userpicPlaceholder: UIImage?
    let username: String
    let pibbleBalance: String

    let greenBrushBalance: String
    let redBrushBalance: String
    
    init(userProfile: UserProtocol) {
      username = userProfile.userName.capitalized
      userpicUrlString = userProfile.userpicUrlString
      userpicPlaceholder = UIImage.avatarImageForNameString(userProfile.userName)
     
      let pibbleValue = userProfile.walletBalances.first { $0.currency == BalanceCurrency.pibble }?.value ?? 0.0
      let greenBrushValue = userProfile.walletBalances.first { $0.currency == BalanceCurrency.greenBrush }?.value ?? 0.0
      let redBrushValue = userProfile.walletBalances.first { $0.currency == BalanceCurrency.redBrush }?.value ?? 0.0
      let ethValue = userProfile.walletBalances.first { $0.currency == BalanceCurrency.etherium }?.value ?? 0.0
      let btcValue = userProfile.walletBalances.first { $0.currency == BalanceCurrency.bitcoin }?.value ?? 0.0
      
       let klayValue = userProfile.walletBalances.first { $0.currency == BalanceCurrency.klaytn }?.value ?? 0.0
      
      pibbleBalance = String(format:"%.1f", pibbleValue)
      greenBrushBalance = String(format:"%.1f", greenBrushValue)
      redBrushBalance = String(format:"%.1f", redBrushValue)
      
      let ethBalance = String(format:"%.8f", ethValue)
      let btcBalance = String(format:"%.8f", btcValue)
      let klayBalance = String(format:"%.8f", klayValue)
      
      let pibBalanceCurrency = BalanceCurrency.pibble.symbol.uppercased()
      let etcBalanceCurrency = BalanceCurrency.etherium.symbol.uppercased()
      let btcBalanceCurrency = BalanceCurrency.bitcoin.symbol.uppercased()
      let klayBalanceCurrency = BalanceCurrency.klaytn.symbol.uppercased()
      
      balances = [(pibBalanceCurrency, pibbleBalance),
                  (etcBalanceCurrency, ethBalance),
                  (btcBalanceCurrency, btcBalance),
                  (klayBalanceCurrency, klayBalance)]
    }
  }
}

extension WalletHome {
  enum Strings: String, LocalizedStringKeyProtocol {
    case payBill = "pay bill"
    case send = "send"
    case recieve = "recieve"
    case exchange = "exchange"
    case activity = "activity"
    case market = "market"
  }
}
