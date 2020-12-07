//
//  WalletActivityInvoiceViewModel.swift
//  Pibble
//
//  Created by Kazakov Sergey on 29.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

extension Wallet {
  enum WalletActivityInvoiceAction {
    case cancel
    case confirm
  }
 
  struct WalletActivityInvoiceViewModel: WalletActivityInvoiceViewModelProtocol {
    let currencyColor: UIColor
    
    var invoiceTitle: NSAttributedString
    let userpicPlacholder: UIImage?
    var userpicUrlString: String
    var isIncoming: Bool
    var invoiceDate: String
    var invoiceValue: String
    var invoiceNote: String
    let shouldPresentActions: Bool
    
    init(walletActivity: InvoiceProtocol, currentUser: UserProtocol) {
      self.isIncoming = walletActivity.isIncomingTo(account: currentUser)
      
      invoiceValue =  "\(String(format:"%.2f", walletActivity.activityValue)) \(walletActivity.activityCurrency.symbol.uppercased())"
      
      invoiceNote = walletActivity.walletActivityDescription
      currencyColor = walletActivity.activityCurrency.colorForCurrency
      
      invoiceDate = walletActivity.activityCreatedAt.toDateWithCommonFormat()?.walletActivityDateString() ?? ""
      
      var titleBodyString = ""
      if isIncoming {
        switch walletActivity.walletActivityStatus {
        case .requested:
          shouldPresentActions = true
          titleBodyString = Wallet.Strings.incomingInvoice.localize()
        case .accepted:
          shouldPresentActions = false
          titleBodyString = Wallet.Strings.acceptedInvoice.localize()
        case .rejected:
          shouldPresentActions = false
          titleBodyString = Wallet.Strings.rejectedInvoice.localize()
        case .empty:
          shouldPresentActions = false
        }
      } else {
        shouldPresentActions = false
        titleBodyString = Wallet.Strings.outcomingInvoice.localize()
      }
 
      
      
      
      userpicUrlString = isIncoming ?
        (walletActivity.activityFromUser?.userpicUrlString ?? "") :
        (walletActivity.activityToUser?.userpicUrlString ?? "")
      
      let username = isIncoming ?
        (walletActivity.activityFromUser?.userName ?? "").capitalized : (walletActivity.activityToUser?.userName ?? "").capitalized
      userpicPlacholder = UIImage.avatarImageForNameString(username)
      
      let attrubutedUsername =
        NSAttributedString(string: username.usernamed,
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
          ])
      
      let attributedTitleBody =
        NSAttributedString(string: titleBodyString,
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.invoiceBody
          ])
      
      let title = NSMutableAttributedString()
      if isIncoming {
        switch walletActivity.walletActivityStatus {
        case .requested:
          title.append(attrubutedUsername)
          title.append(attributedTitleBody)
        case .accepted:
          title.append(attributedTitleBody)
          title.append(attrubutedUsername)
        case .rejected:
          title.append(attributedTitleBody)
          title.append(attrubutedUsername)
        case .empty:
          break
        }
      } else {
        title.append(attributedTitleBody)
        title.append(attrubutedUsername)
      }
      
      invoiceTitle = title
    }
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let username = UIColor.gray70
//    static let incomingBody = UIColor.gray124
//    static let outcomingBody = UIColor.gray191
    static let invoiceBody = UIColor.gray70
  }
}

fileprivate extension String {
  var usernamed: String {
    guard count > 0 else {
      return self
    }
    return "@\(self)"
  }
}

extension Date {
  fileprivate static let lessThanYearDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d, MMM H:mm"
    return dateFormatter
  }()
  
  fileprivate static let moreThanYearDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d, MMM yyyy H:mm" //2, Oct 20:18
    return dateFormatter
  }()
  
  func walletActivityDateString() -> String {
    if abs(timeIntervalSinceNow) < TimeInterval.daysInterval(1) {
      return timeAgoSinceNow(useNumericDates: true)
      //return NSDate(timeIntervalSince1970: timeIntervalSince1970).dateTimeUntilNow()
    }
    
    if abs(timeIntervalSinceNow) < TimeInterval.daysInterval(365) {
      return Date.lessThanYearDateFormatter.string(from: self)
    }
    
    return Date.moreThanYearDateFormatter.string(from: self)
  }
}

extension Wallet {
  enum Strings: String, LocalizedStringKeyProtocol {
    case incomingInvoice = " sent you request"
    case rejectedInvoice = "You rejected request from "
    case acceptedInvoice = "You confirmed request from "
    case outcomingInvoice = "You sent request to "
  }
}
