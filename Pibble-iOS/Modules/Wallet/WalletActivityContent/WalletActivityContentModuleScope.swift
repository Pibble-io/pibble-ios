//
//  WalletActivityContentModuleScope.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 25.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

enum WalletActivityContent {
  enum ContentType {
    case walletActivities(ActivityCurrencyType)
    case donationsForPost(PostingProtocol)
  }
  
  enum PresentationType {
    case walletActivities
    case donationTransactions
  }
  
  enum WalletActivityAction {
    case copyTransactionId
    case showUserProfile
  }
  
  typealias WalletActivityActionHandler = (UITableViewCell, WalletActivityContent.WalletActivityAction) -> Void

  
  enum ActivityViewModelType {
    case outcomingRequest(WalletActivityInvoiceViewModelProtocol)
    case incomingRequest(WalletActivityInvoiceViewModelProtocol)
    case internalTransaction(WalletActivityInternalTransactionViewModelProtocol)
    case externalTransaction(WalletActivityExtenalTransactionViewModelProtocol)
    case exchangeTransaction(WalletActivityExchangeTransactionViewModelProtocol)
    case externalExchangeTransaction(WalletActivityExchangeTransactionViewModelProtocol)
    
    case donatorFundingTransaction(WalletActivityDonatorTransactionViewModelProtocol)
    
    case loadingPlaceholder
    
    
    static func donationsPresentationViewModelFor(baseWalletActivity: WalletActivityEntity, currentUser: UserProtocol) -> WalletActivityContent.ActivityViewModelType {
      
      switch baseWalletActivity {
      //only donation transactions supported
      case .charityFundingDonateTransaction(let walletActivity):
        let vm = DonatorTransactionViewModel(walletActivity: walletActivity)
        return .donatorFundingTransaction(vm)
      case .crowdFundingDonateTransaction(let walletActivity):
        let vm = DonatorTransactionViewModel(walletActivity: walletActivity)
        return .donatorFundingTransaction(vm)
      case .crowdFundingWithRewardsDonateTransaction(let walletActivity):
        let vm = DonatorTransactionViewModel(walletActivity: walletActivity)
        return .donatorFundingTransaction(vm)
      default:
        return .loadingPlaceholder
      }
    }
    
    static func viewModelFor(baseWalletActivity: WalletActivityEntity, currentUser: UserProtocol) -> WalletActivityContent.ActivityViewModelType {
      switch baseWalletActivity {
      case .internalTransaction(let walletActivity):
        let vm = WalletActivityInternalTransactionViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return internalTransaction(vm)
      case .externalTransaction(let walletActivity):
        let vm = WalletActivityExtenalTransactionViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return externalTransaction(vm)
      case .invoice(let walletActivity):
        let isIncoming = walletActivity.isIncomingTo(account: currentUser)
        let vm = Wallet.WalletActivityInvoiceViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return isIncoming ? .incomingRequest(vm) : .outcomingRequest(vm)
      case .rewardTransaction(let walletActivity):
        let vm = WalletActivityRewardTransactionViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return internalTransaction(vm)
      case .exchangeTransaction(let walletActivity):
        let vm = WalletActivityExchangeTransactionViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return exchangeTransaction(vm)
      case .fundingTransaction(let walletActivity):
        let vm = WalletActivityOldFundingTransactionViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return internalTransaction(vm)
      case .promotionTransaction(let walletActivity):
        let vm = WalletActivityPromotionTransactionViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return internalTransaction(vm)
      case .externalExchangeTransaction(let walletActivity):
        let vm = WalletActivityExchangeTransactionViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return externalExchangeTransaction(vm)
      case .commerceTransaction(let walletActivity):
        let vm = WalletActivityCommerceTransactionViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return internalTransaction(vm)
      case .digitalGoodTransaction(let walletActivity):
        let vm = WalletActivityDigitalGoodTransactionViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return internalTransaction(vm)
      case .airdropTransaction(let walletActivity):
        let vm = WalletActivityAirdropTransactionViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return internalTransaction(vm)
      case .goodTransaction(let walletActivity):
        let vm = WalletActivityDigitalGoodTransactionViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return internalTransaction(vm)
      case .charityFundingDonateTransaction(let walletActivity):
        let vm = WalletActivityFundingTransactionViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return internalTransaction(vm)
      case .crowdFundingDonateTransaction(let walletActivity):
        let vm = WalletActivityFundingTransactionViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return internalTransaction(vm)
      case .crowdFundingWithRewardsDonateTransaction(let walletActivity):
        let vm = WalletActivityFundingTransactionViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return internalTransaction(vm)
      case .charityFundingRefundTransaction(let walletActivity):
        let vm = WalletActivityFundingTransactionViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return internalTransaction(vm)
      case .crowdFundingRefundTransaction(let walletActivity):
        let vm = WalletActivityFundingTransactionViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return internalTransaction(vm)
      case .crowdFundingWithRewardsRefundTransaction(let walletActivity):
        let vm = WalletActivityFundingTransactionViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return internalTransaction(vm)
      case .charityFundingResultTransaction(let walletActivity):
        let vm = WalletActivityFundingTransactionViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return internalTransaction(vm)
      case .crowdFundingResultTransaction(let walletActivity):
        let vm = WalletActivityFundingTransactionViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return internalTransaction(vm)
      case .crowdFundingWithRewardsResultTransaction(let walletActivity):
        let vm = WalletActivityFundingTransactionViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return internalTransaction(vm)
      case .postHelpPaymentTransaction(let walletActivity):
        let vm = WalletActivityPostHelpTransactionViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return internalTransaction(vm)
      case .postHelpRewardTransaction(let walletActivity):
        let vm = WalletActivityPostHelpTransactionViewModel(walletActivity: walletActivity, currentUser: currentUser)
        return internalTransaction(vm)
      }
    }
  }
  
  struct WalletActivityExtenalTransactionViewModel: WalletActivityExtenalTransactionViewModelProtocol {
    let transactionId: String
    
    let currencyColor: UIColor
    
    let transactionTitle: String
    let isIncoming: Bool
    let transactionDate: String
    let transactionValue: String
    let transactionAddress: String
    
    init(walletActivity: ExternalTransactionProtocol, currentUser: UserProtocol) {
      isIncoming = walletActivity.isIncomingTo(account: currentUser)
      let outcomingIndicator = isIncoming ? "" : "-"
      transactionId = walletActivity.transactionId
      transactionValue =  "\(outcomingIndicator)\(String(format: walletActivity.activityCurrency.stringFormat, walletActivity.activityValue)) \(walletActivity.activityCurrency.symbol.uppercased())"
      
      transactionDate = walletActivity.activityCreatedAt.toDateWithCommonFormat()?.walletActivityDateString() ?? ""
      transactionAddress = isIncoming ?
        walletActivity.transactionFromAddress : walletActivity.transactionToAddress
      currencyColor = walletActivity.activityCurrency.colorForCurrency
      guard isIncoming else {
        transactionTitle = WalletActivityContent.Strings.outcomingExternal(walletActivity.activityCurrency.symbol)
        return
      }
      
      transactionTitle = WalletActivityContent.Strings.incomingExternal(walletActivity.activityCurrency.symbol)
    }
  }
  
  struct WalletActivityExchangeTransactionViewModel: WalletActivityExchangeTransactionViewModelProtocol {
    let currencyColor: UIColor
    
    let transactionTitle: NSAttributedString
    let userpicPlaceholder: UIImage?
    
    let userpicUrlString: String
    let isIncoming: Bool
    let transactionDate: String
    let transactionValue: String
    let transactionNote: String
    
    init(walletActivity: ExchangeTransactionProtocol, currentUser: UserProtocol) {
      
      isIncoming = walletActivity.toBalance.currency == .pibble
      let outcomingIndicator = isIncoming ? "" : "-"
      let transactionValueAmount = isIncoming ?
        String(format: walletActivity.toBalance.currency.stringFormat, walletActivity.toBalance.value):
        String(format: walletActivity.fromBalance.currency.stringFormat, walletActivity.fromBalance.value)
      
      let currency = isIncoming ?
        walletActivity.toBalance.currency.symbol.uppercased():
        walletActivity.fromBalance.currency.symbol.uppercased()
      
      transactionValue = "\(outcomingIndicator)\(transactionValueAmount) \(currency)"
      
      let transactionExchangedValueFrom =  "\(String(format: walletActivity.fromBalance.currency.stringFormat, walletActivity.fromBalance.value)) \(walletActivity.fromBalance.currency.symbol.uppercased())"
      
      let transactionExchangedValueTo =  "\(String(format:walletActivity.toBalance.currency.stringFormat, walletActivity.toBalance.value)) \(walletActivity.toBalance.currency.symbol.uppercased())"
      
      transactionNote = ""
      currencyColor = isIncoming ?
        walletActivity.toBalance.currency.colorForCurrency:
        walletActivity.fromBalance.currency.colorForCurrency
      
      transactionDate = walletActivity.activityCreatedAt.toDateWithCommonFormat()?.walletActivityDateString() ?? ""
      
      userpicPlaceholder = #imageLiteral(resourceName: "Wallet-PibbleUserAvatar")
      userpicUrlString = ""
      
      let attributedBegin =
        NSAttributedString(string: WalletActivityContent.Strings.exchanged.localize(),
          attributes: [
            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
            NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
          ])
      
      let attributedMid =
        NSAttributedString(string: WalletActivityContent.Strings.exchangedTo.localize(),
          attributes: [
            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
            NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
          ])
      
      let attributedFrom =
        NSAttributedString(string: transactionExchangedValueFrom,
          attributes: [
            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
            NSAttributedString.Key.foregroundColor: walletActivity.fromBalance.currency.colorForCurrency
          ])
      
      let attributedTo =
        NSAttributedString(string: transactionExchangedValueTo,
          attributes: [
            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
            NSAttributedString.Key.foregroundColor: walletActivity.toBalance.currency.colorForCurrency
          ])
      
      let title = NSMutableAttributedString()
      title.append(attributedBegin)
      title.append(attributedFrom)
      title.append(attributedMid)
      title.append(attributedTo)
     
      transactionTitle = title
    }
    
    init(walletActivity: ExternalExchangeTransactionProtocol, currentUser: UserProtocol) {
      isIncoming = true
      transactionValue = ""
      
      let transactionExchangedValueFrom =  "\(String(format: walletActivity.fromBalance.currency.stringFormat, walletActivity.fromBalance.value)) \(walletActivity.fromBalance.currency.symbol.uppercased())"
      
      let transactionExchangedValueTo =  "\(String(format: walletActivity.fromBalance.currency.stringFormat, walletActivity.toBalance.value)) \(walletActivity.toBalance.currency.symbol.uppercased())"
      
      transactionNote = ""
      currencyColor = walletActivity.toBalance.currency.colorForCurrency
      
      transactionDate = walletActivity.activityCreatedAt.toDateWithCommonFormat()?.walletActivityDateString() ?? ""
      
      userpicPlaceholder = #imageLiteral(resourceName: "Wallet-PibbleUserAvatar")
      userpicUrlString = walletActivity.fromBalance.currency.iconUrlString
      
      let attributedBegin =
        NSAttributedString(string: WalletActivityContent.Strings.exchanged.localize(),
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
          ])
      
      let attributedMid =
        NSAttributedString(string: WalletActivityContent.Strings.exchangedTo.localize(),
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
          ])
      
      let attributedFrom =
        NSAttributedString(string: transactionExchangedValueFrom,
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: walletActivity.fromBalance.currency.colorForCurrency
          ])
      
      let attributedTo =
        NSAttributedString(string: transactionExchangedValueTo,
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: walletActivity.toBalance.currency.colorForCurrency
          ])
      
      let attributedWith =
        NSAttributedString(string: WalletActivityContent.Strings.exchangedExternalWithApp.localize(),
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
          ])
      
      let appName = walletActivity.fromExternalAppName.usernamed
      let attrubutedAppName =
        NSAttributedString(string: appName,
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
          ])
      
      
      let title = NSMutableAttributedString()
      title.append(attributedBegin)
      title.append(attributedFrom)
      title.append(attributedMid)
      title.append(attributedTo)
      
      if appName.count > 0 {
        title.append(attributedWith)
        title.append(attrubutedAppName)
      }
      
      transactionTitle = title
    }
     
  }
  
  struct WalletActivityPromotionTransactionViewModel: WalletActivityInternalTransactionViewModelProtocol {
    let currencyColor: UIColor
    
    let transactionTitle: NSAttributedString
    let userpicPlaceholder: UIImage?
    
    let userpicUrlString: String
    let isIncoming: Bool
    let transactionDate: String
    let transactionValue: String
    let transactionNote: String
    
    init(walletActivity: PromotionTransactionProtocol, currentUser: UserProtocol) {
      self.isIncoming = walletActivity.isIncomingTo(account: currentUser)
      let outcomingIndicator = isIncoming ? "" : "-"
      transactionValue =  "\(outcomingIndicator)\(String(format: walletActivity.activityCurrency.stringFormat, walletActivity.activityValue)) \(walletActivity.activityCurrency.symbol.uppercased())"
      
      transactionNote = "" // walletActivity.walletActivityDescription
      currencyColor = walletActivity.activityCurrency.colorForCurrency
      
      transactionDate = walletActivity.activityCreatedAt.toDateWithCommonFormat()?.walletActivityDateString() ?? ""
      
      
      if case PromotionType.debit = walletActivity.promotionTransactionType {
        userpicPlaceholder = #imageLiteral(resourceName: "Wallet-PibbleUserAvatar")
        userpicUrlString = ""
        let attributedTitleString = WalletActivityContent.Strings.promotionDebit(walletActivity.activityCurrency.symbol)
        let attrubutedTitle =
          NSAttributedString(string: attributedTitleString,
                             attributes: [
                              NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                              NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
            ])
        transactionTitle = attrubutedTitle
        return
      }
      
      let attributedTitleString: String
      
      switch walletActivity.promotionTransactionType {
      case .debit: //old promotion type presentation
        userpicPlaceholder = #imageLiteral(resourceName: "Wallet-PibbleUserAvatar")
        userpicUrlString = ""
        attributedTitleString = WalletActivityContent.Strings.promotionDebit(walletActivity.activityCurrency.symbol)
        let attrubutedTitle =
          NSAttributedString(string: attributedTitleString,
                             attributes: [
                              NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                              NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
            ])
        transactionTitle = attrubutedTitle
        return
      case .like, .share, .collect, .tag, .defaultType: //old promotion types presentation
        let user = isIncoming ?
          walletActivity.activityFromUser :
          walletActivity.activityToUser
        
        userpicPlaceholder = UIImage.avatarImageForNameString(user?.userName ?? WalletActivityContent.Strings.pibbleUsername.localize())
        
        userpicUrlString = user?.userpicUrlString ?? ""
        
        attributedTitleString = isIncoming ?
          WalletActivityContent.Strings.PromotionTransactions.promotedPostRewardOutcoming.localize():
          WalletActivityContent.Strings.PromotionTransactions.promotedPostRewardIncoming.localize()
       
        let attrubutedTitle =
          NSAttributedString(string: attributedTitleString,
                             attributes: [
                              NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                              NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
            ])
        transactionTitle = attrubutedTitle
        return
      case .promotionDebit:
        attributedTitleString = WalletActivityContent.Strings.PromotionTransactions.promotionDebit.localize()
        
        userpicPlaceholder = #imageLiteral(resourceName: "Wallet-PibbleUserAvatar")
        userpicUrlString = ""
        
        let attrubutedTitle =
          NSAttributedString(string: attributedTitleString,
                             attributes: [
                              NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                              NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
            ])
        transactionTitle = attrubutedTitle
        return
      case .impression:
        attributedTitleString = WalletActivityContent.Strings.PromotionTransactions.impression.localize()
      case .upvote:
        attributedTitleString = WalletActivityContent.Strings.PromotionTransactions.upvote.localize()
      case .comment:
        attributedTitleString = WalletActivityContent.Strings.PromotionTransactions.comment.localize()
      case .promotionCollect:
        attributedTitleString = WalletActivityContent.Strings.PromotionTransactions.collect.localize()
      case .follow:
        attributedTitleString = WalletActivityContent.Strings.PromotionTransactions.follow.localize()
      case .action:
        attributedTitleString = WalletActivityContent.Strings.PromotionTransactions.action.localize()
      case .followTag:
        attributedTitleString = WalletActivityContent.Strings.PromotionTransactions.followTag.localize()
      case .profileView:
        attributedTitleString = WalletActivityContent.Strings.PromotionTransactions.profileView.localize()
      }
      
      let user = isIncoming ?
        walletActivity.activityFromUser :
        walletActivity.activityToUser
      
      userpicPlaceholder = UIImage.avatarImageForNameString(user?.userName ?? WalletActivityContent.Strings.pibbleUsername.localize())
      
      userpicUrlString = user?.userpicUrlString ?? ""
      let username = user?.userName ?? ""
      
      let attrubutedUsername =
        NSAttributedString(string: username.usernamed,
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
          ])
      
      let attrubutedTitle =
        NSAttributedString(string: attributedTitleString,
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
          ])
      
      let title = NSMutableAttributedString()
      title.append(attrubutedTitle)
      title.append(attrubutedUsername)
      transactionTitle = title
    }
  }
  
  struct WalletActivityOldFundingTransactionViewModel: WalletActivityInternalTransactionViewModelProtocol {
    let currencyColor: UIColor
    
    let transactionTitle: NSAttributedString
    let userpicPlaceholder: UIImage?
    
    let userpicUrlString: String
    let isIncoming: Bool
    let transactionDate: String
    let transactionValue: String
    let transactionNote: String
    
    init(walletActivity: FundingTransactionProtocol, currentUser: UserProtocol) {
      self.isIncoming = walletActivity.isIncomingTo(account: currentUser)
      let outcomingIndicator = isIncoming ? "" : "-"
      transactionValue =  "\(outcomingIndicator)\(String(format: walletActivity.activityCurrency.stringFormat, walletActivity.activityValue)) \(walletActivity.activityCurrency.symbol.uppercased())"
      
      transactionNote = "" // walletActivity.walletActivityDescription
      currencyColor = walletActivity.activityCurrency.colorForCurrency
      
      transactionDate = walletActivity.activityCreatedAt.toDateWithCommonFormat()?.walletActivityDateString() ?? ""
      
      userpicPlaceholder = #imageLiteral(resourceName: "WalletActivity-CharityAvatar")
      userpicUrlString = "" //walletActivity.activityToUser?.userpicUrlString ?? ""
//      let username = walletActivity.activityToUser?.username ?? ""
      let campaignName = walletActivity.fundingPosting?.fundingCampaign?.campaignTitle ?? ""
      
      let attrubutedCampaignName =
        NSAttributedString(string: campaignName.usernamed,
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
          ])
      
      let attributedTitleBodyString = WalletActivityContent.Strings.outcomingFunding(walletActivity.activityCurrency.symbol)
      let attributedTitleBody =
        NSAttributedString(string: attributedTitleBodyString,
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.outcomingBody
          ])
      
      let title = NSMutableAttributedString()
      title.append(attributedTitleBody)
      title.append(attrubutedCampaignName)
      transactionTitle = title
    }
  }
  
  struct WalletActivityCommerceTransactionViewModel: WalletActivityInternalTransactionViewModelProtocol {
    let currencyColor: UIColor
    
    let transactionTitle: NSAttributedString
    let userpicPlaceholder: UIImage?
    
    let userpicUrlString: String
    let isIncoming: Bool
    let transactionDate: String
    let transactionValue: String
    let transactionNote: String
    
    init(walletActivity: CommerceTransactionProtocol, currentUser: UserProtocol) {
      self.isIncoming = walletActivity.isIncomingTo(account: currentUser)
      let outcomingIndicator = isIncoming ? "" : "-"
      transactionValue =  "\(outcomingIndicator)\(String(format: walletActivity.activityCurrency.stringFormat, walletActivity.activityValue)) \(walletActivity.activityCurrency.symbol.uppercased())"
      
      transactionNote = "" // walletActivity.walletActivityDescription
      currencyColor = walletActivity.activityCurrency.colorForCurrency
      
      transactionDate = walletActivity.activityCreatedAt.toDateWithCommonFormat()?.walletActivityDateString() ?? ""
      
      userpicPlaceholder = #imageLiteral(resourceName: "Wallet-PibbleUserAvatar")
      userpicUrlString = "" //walletActivity.activityToUser?.userpicUrlString ?? ""
      //      let username = walletActivity.activityToUser?.username ?? ""
      let campaignName = walletActivity.relatedPost?.commerceInfo?.commerceItemTitle ?? ""
      
      let attrubutedCampaignName =
        NSAttributedString(string: campaignName.usernamed,
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
          ])
      
      let attributedTitleBodyString = WalletActivityContent.Strings.outcomingFunding(walletActivity.activityCurrency.symbol)
      let attributedTitleBody =
        NSAttributedString(string: attributedTitleBodyString,
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.outcomingBody
          ])
      
      let title = NSMutableAttributedString()
      title.append(attributedTitleBody)
      title.append(attrubutedCampaignName)
      transactionTitle = title
    }
  }
  
  struct WalletActivityInternalTransactionViewModel: WalletActivityInternalTransactionViewModelProtocol {
    let currencyColor: UIColor
    
    let transactionTitle: NSAttributedString
    let userpicPlaceholder: UIImage?
    
    let userpicUrlString: String
    let isIncoming: Bool
    let transactionDate: String
    let transactionValue: String
    let transactionNote: String
    
    init(walletActivity: InternalTransactionProtocol, currentUser: UserProtocol) {
      self.isIncoming = walletActivity.isIncomingTo(account: currentUser)
      let outcomingIndicator = isIncoming ? "" : "-"
      transactionValue =  "\(outcomingIndicator)\(String(format: walletActivity.activityCurrency.stringFormat, walletActivity.activityValue)) \(walletActivity.activityCurrency.symbol.uppercased())"
      
      transactionNote = "" // walletActivity.walletActivityDescription
      currencyColor = walletActivity.activityCurrency.colorForCurrency
      
      transactionDate = walletActivity.activityCreatedAt.toDateWithCommonFormat()?.walletActivityDateString() ?? ""
      
      guard isIncoming else {
        userpicPlaceholder = UIImage.avatarImageForNameString(walletActivity.activityToUser?.userName ?? WalletActivityContent.Strings.pibbleUsername.localize())
        userpicUrlString = walletActivity.activityToUser?.userpicUrlString ?? ""
        let username = walletActivity.activityToUser?.userName ?? ""
        let attrubutedUsername =
          NSAttributedString(string: username.usernamed,
                             attributes: [
                              NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                              NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
            ])
        
        let attributedTitleBodyString = WalletActivityContent.Strings.outcoming(walletActivity.activityCurrency.symbol)
        let attributedTitleBody =
          NSAttributedString(string: attributedTitleBodyString,
                             attributes: [
                              NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                              NSAttributedString.Key.foregroundColor: UIConstants.Colors.outcomingBody
            ])
        
        let title = NSMutableAttributedString()
        title.append(attributedTitleBody)
        title.append(attrubutedUsername)
        transactionTitle = title
        return
      }
      
      userpicPlaceholder = UIImage.avatarImageForNameString(walletActivity.activityFromUser?.userName ?? WalletActivityContent.Strings.pibbleUsername.localize())
      userpicUrlString = walletActivity.activityFromUser?.userpicUrlString ?? ""
      let username = walletActivity.activityFromUser?.userName ?? ""
      let attrubutedUsername =
        NSAttributedString(string: username.usernamed,
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
          ])
      
      let attributedTitleBody =
        NSAttributedString(string: WalletActivityContent.Strings.incoming(walletActivity.activityCurrency.symbol),
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
          ])
      
      let title = NSMutableAttributedString()
      title.append(attributedTitleBody)
      title.append(attrubutedUsername)
      
      transactionTitle = title
    }
  }
  
  struct WalletActivityPostHelpTransactionViewModel: WalletActivityInternalTransactionViewModelProtocol {
    let currencyColor: UIColor
    
    let transactionTitle: NSAttributedString
    let userpicPlaceholder: UIImage?
    
    let userpicUrlString: String
    let isIncoming: Bool
    let transactionDate: String
    let transactionValue: String
    let transactionNote: String
    
    init(walletActivity: PostHelpRewardTransactionProtocol, currentUser: UserProtocol) {
      self.isIncoming = true
      
      let outcomingIndicator = isIncoming ? "" : "-"
      let activityValue = walletActivity.activityValue
      transactionValue =  "\(outcomingIndicator)\(String(format: walletActivity.activityCurrency.stringFormat, activityValue)) \(walletActivity.activityCurrency.symbol.uppercased())"
      
      transactionNote = "" // walletActivity.walletActivityDescription
      currencyColor = walletActivity.activityCurrency.colorForCurrency
      
      transactionDate = walletActivity.activityCreatedAt.toDateWithCommonFormat()?.walletActivityDateString() ?? ""
      
//      userpicUrlString = walletActivity.activityFromUser?.userpicUrlString ?? ""
//      if let username = walletActivity.activityFromUser?.userName,
//        let image = UIImage.avatarImageForNameString(username) {
//        userpicPlaceholder = image
//      } else {
//        userpicPlaceholder = UIImage(imageLiteralResourceName: "WalletActivity-PostHelpAnswerUserpic")
//      }
      
      userpicPlaceholder = UIImage(imageLiteralResourceName: "WalletActivity-PostHelpAnswerUserpic")
      userpicUrlString = ""

      let username = walletActivity.activityFromUser?.userName ?? ""
      let attrubutedUsername =
        NSAttributedString(string: username.usernamed,
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
          ])
      
      let attributedTitleBody =
        NSAttributedString(string: WalletActivityContent.Strings.PostHelpAnswers.postHelpReward.localize(),
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
          ])
      
      let title = NSMutableAttributedString()
      title.append(attributedTitleBody)
      title.append(attrubutedUsername)
      
      transactionTitle = title
    }
    
    init(walletActivity: PostHelpPaymentTransactionProtocol, currentUser: UserProtocol) {
      self.isIncoming = false
      
      let outcomingIndicator = isIncoming ? "" : "-"
      let activityValue = walletActivity.activityValue
      transactionValue =  "\(outcomingIndicator)\(String(format: walletActivity.activityCurrency.stringFormat, activityValue)) \(walletActivity.activityCurrency.symbol.uppercased())"
      
      transactionNote = "" // walletActivity.walletActivityDescription
      currencyColor = walletActivity.activityCurrency.colorForCurrency
      
      transactionDate = walletActivity.activityCreatedAt.toDateWithCommonFormat()?.walletActivityDateString() ?? ""
      
      userpicUrlString = ""
      let attributedTitleBodyString: String
      userpicPlaceholder = UIImage(imageLiteralResourceName: "WalletActivity-PostHelpAnswerUserpic")
      attributedTitleBodyString = WalletActivityContent.Strings.PostHelpAnswers.postHelpPayment.localize()
      
      let attributedTitleBody =
        NSAttributedString(string: attributedTitleBodyString,
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.outcomingBody
          ])
      
      transactionTitle = attributedTitleBody
      return
    }
  }
  
  struct WalletActivityFundingTransactionViewModel: WalletActivityInternalTransactionViewModelProtocol {
    let currencyColor: UIColor
    
    let transactionTitle: NSAttributedString
    let userpicPlaceholder: UIImage?
    
    let userpicUrlString: String
    let isIncoming: Bool
    let transactionDate: String
    let transactionValue: String
    let transactionNote: String
    
    init(walletActivity: FundingDonateTransactionProtocol, currentUser: UserProtocol) {
      self.isIncoming = false
      
      let outcomingIndicator = isIncoming ? "" : "-"
      let activityValue = walletActivity.activityValue
      transactionValue =  "\(outcomingIndicator)\(String(format: walletActivity.activityCurrency.stringFormat, activityValue)) \(walletActivity.activityCurrency.symbol.uppercased())"
      
      transactionNote = "" // walletActivity.walletActivityDescription
      currencyColor = walletActivity.activityCurrency.colorForCurrency
      
      transactionDate = walletActivity.activityCreatedAt.toDateWithCommonFormat()?.walletActivityDateString() ?? ""
      
      userpicUrlString = ""
      let attributedTitleBodyString: String
      switch walletActivity.walletActivityType {
      case .charityFundingDonateTransaction:
        userpicPlaceholder = UIImage(imageLiteralResourceName: "WalletActivity-CharityFundingUserpic")
        attributedTitleBodyString = WalletActivityContent.Strings.Funding.charityFundingDonate.localize()
      case .crowdFundingDonateTransaction:
        userpicPlaceholder = UIImage(imageLiteralResourceName: "WalletActivity-CrowdFundingUserpic")
        attributedTitleBodyString = WalletActivityContent.Strings.Funding.crowdFundingDonate.localize()
      case .crowdFundingWithRewardsDonateTransaction:
        userpicPlaceholder = UIImage(imageLiteralResourceName: "WalletActivity-CrowdFundingWithRewardUserpic")
        attributedTitleBodyString = WalletActivityContent.Strings.Funding.crowdFundingWithRewardDonate.localize()
      default:
        userpicPlaceholder = nil
        attributedTitleBodyString = ""
      }
      
      let username = walletActivity.fundingPosting?.postingUser?.userName ?? ""
      let attrubutedUsername =
        NSAttributedString(string: username.usernamed,
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
          ])
      
      
      let attributedTitleBody =
        NSAttributedString(string: attributedTitleBodyString,
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.outcomingBody
          ])
      
      let title = NSMutableAttributedString()
      title.append(attributedTitleBody)
      title.append(attrubutedUsername)
      transactionTitle = title
      return
    }
    
    init(walletActivity: FundingRefundTransactionProtocol, currentUser: UserProtocol) {
      self.isIncoming = true
      
      let outcomingIndicator = isIncoming ? "" : "-"
      let activityValue = walletActivity.activityValue
      transactionValue =  "\(outcomingIndicator)\(String(format: walletActivity.activityCurrency.stringFormat, activityValue)) \(walletActivity.activityCurrency.symbol.uppercased())"
      
      transactionNote = "" // walletActivity.walletActivityDescription
      currencyColor = walletActivity.activityCurrency.colorForCurrency
      
      transactionDate = walletActivity.activityCreatedAt.toDateWithCommonFormat()?.walletActivityDateString() ?? ""
      
      userpicUrlString = ""
      let attributedTitleBodyString: String
      switch walletActivity.walletActivityType {
      case .charityFundingRefundTransaction:
        userpicPlaceholder = UIImage(imageLiteralResourceName: "WalletActivity-CharityFundingUserpic")
        attributedTitleBodyString = WalletActivityContent.Strings.Funding.charityFundingRefund.localize()
      case .crowdFundingRefundTransaction:
        userpicPlaceholder = UIImage(imageLiteralResourceName: "WalletActivity-CrowdFundingUserpic")
        attributedTitleBodyString = WalletActivityContent.Strings.Funding.crowdFundingRefund.localize()
      case .crowdFundingWithRewardsRefundTransaction:
        userpicPlaceholder = UIImage(imageLiteralResourceName: "WalletActivity-CrowdFundingWithRewardUserpic")
        attributedTitleBodyString = WalletActivityContent.Strings.Funding.crowdFundingWithRewardRefund.localize()
      default:
        userpicPlaceholder = nil
        attributedTitleBodyString = ""
      }
     
      let attributedTitleBody =
        NSAttributedString(string: attributedTitleBodyString,
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.outcomingBody
          ])
      
      transactionTitle = attributedTitleBody
      return
    }
    
    init(walletActivity: BaseFundingResultTransactionProtocol, currentUser: UserProtocol) {
      self.isIncoming = walletActivity.isFundingSuccessful
      
      let outcomingIndicator = isIncoming ? "" : "-"
      let activityValue = walletActivity.activityValue
      transactionValue =  "\(outcomingIndicator)\(String(format: walletActivity.activityCurrency.stringFormat, activityValue)) \(walletActivity.activityCurrency.symbol.uppercased())"
      
      transactionNote = "" // walletActivity.walletActivityDescription
      currencyColor = walletActivity.activityCurrency.colorForCurrency
      
      transactionDate = walletActivity.activityCreatedAt.toDateWithCommonFormat()?.walletActivityDateString() ?? ""
      
      userpicUrlString = ""
      let attributedTitleBodyString: String
      switch walletActivity.walletActivityType {
      case .charityFundingResultTransaction:
        userpicPlaceholder = UIImage(imageLiteralResourceName: "WalletActivity-CharityFundingUserpic")
        attributedTitleBodyString = isIncoming ?
          WalletActivityContent.Strings.Funding.charityFundingCollected.localize():
          WalletActivityContent.Strings.Funding.charityFundingRefund.localize()
      case .crowdFundingResultTransaction:
        userpicPlaceholder = UIImage(imageLiteralResourceName: "WalletActivity-CrowdFundingUserpic")
        attributedTitleBodyString = isIncoming ?
          WalletActivityContent.Strings.Funding.crowdFundingCollected.localize():
          WalletActivityContent.Strings.Funding.crowdFundingRefund.localize()
      case .crowdFundingWithRewardsResultTransaction:
        userpicPlaceholder = UIImage(imageLiteralResourceName: "WalletActivity-CrowdFundingWithRewardUserpic")
        attributedTitleBodyString = isIncoming ?
          WalletActivityContent.Strings.Funding.crowdFundingWithRewardCollected.localize():
          WalletActivityContent.Strings.Funding.crowdFundingWithRewardRefund.localize()
      default:
        userpicPlaceholder = nil
        attributedTitleBodyString = ""
      }
      
      let attributedTitleBody =
        NSAttributedString(string: attributedTitleBodyString,
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.outcomingBody
          ])
      
      transactionTitle = attributedTitleBody
      return
    }
    
  }
  
  struct WalletActivityDigitalGoodTransactionViewModel: WalletActivityInternalTransactionViewModelProtocol {
    let currencyColor: UIColor
    
    let transactionTitle: NSAttributedString
    let userpicPlaceholder: UIImage?
    
    let userpicUrlString: String
    let isIncoming: Bool
    let transactionDate: String
    let transactionValue: String
    let transactionNote: String
    
    init(walletActivity: DigitalGoodTransactionProtocol, currentUser: UserProtocol) {
      self.isIncoming = walletActivity.isIncomingTo(account: currentUser)
      let outcomingIndicator = isIncoming ? "" : "-"
      let activityValue = walletActivity.activityValueForUser(currentUser)
      transactionValue =  "\(outcomingIndicator)\(String(format: walletActivity.activityCurrency.stringFormat, activityValue)) \(walletActivity.activityCurrency.symbol.uppercased())"
      
      transactionNote = "" // walletActivity.walletActivityDescription
      currencyColor = walletActivity.activityCurrency.colorForCurrency
      
      transactionDate = walletActivity.activityCreatedAt.toDateWithCommonFormat()?.walletActivityDateString() ?? ""
      var commerceGoodTitle = WalletActivityContent.Strings.digitalGoodTitlePlaceholder.localize()
      if let commerceTitle = walletActivity.relatedPost?.commerceInfo?.commerceItemTitle {
        commerceGoodTitle = "\"\(commerceTitle)\""
      }
      
      guard isIncoming else {
        userpicPlaceholder = UIImage.avatarImageForNameString(walletActivity.activityToUser?.userName ?? WalletActivityContent.Strings.pibbleUsername.localize())
        userpicUrlString = walletActivity.activityToUser?.userpicUrlString ?? ""
        let username = walletActivity.activityToUser?.userName ?? ""
        let attrubutedUsername =
          NSAttributedString(string: username.usernamed,
                             attributes: [
                              NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                              NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
            ])
        
        let attributedTitleBodyString = WalletActivityContent.Strings.outcomingBuy(commerceGoodTitle)
        let attributedTitleBody =
          NSAttributedString(string: attributedTitleBodyString,
                             attributes: [
                              NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                              NSAttributedString.Key.foregroundColor: UIConstants.Colors.outcomingBody
            ])
        
        let title = NSMutableAttributedString()
        title.append(attributedTitleBody)
        title.append(attrubutedUsername)
        transactionTitle = title
        return
      }
      
      userpicPlaceholder = UIImage.avatarImageForNameString(walletActivity.activityFromUser?.userName ?? WalletActivityContent.Strings.pibbleUsername.localize())
      userpicUrlString = walletActivity.activityFromUser?.userpicUrlString ?? ""
      let username = walletActivity.activityFromUser?.userName ?? ""
      let attrubutedUsername =
        NSAttributedString(string: username.usernamed,
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
          ])
      
      let attributedTitleBody =
        NSAttributedString(string: WalletActivityContent.Strings.incomingSell(commerceGoodTitle),
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
          ])
      
      let title = NSMutableAttributedString()
      title.append(attributedTitleBody)
      title.append(attrubutedUsername)
      
      transactionTitle = title
    }
    
    init(walletActivity: GoodTransactionProtocol, currentUser: UserProtocol) {
      self.isIncoming = walletActivity.isIncomingTo(account: currentUser)
      let outcomingIndicator = isIncoming ? "" : "-"
      let activityValue = walletActivity.activityValueForUser(currentUser)
      transactionValue =  "\(outcomingIndicator)\(String(format: walletActivity.activityCurrency.stringFormat, activityValue)) \(walletActivity.activityCurrency.symbol.uppercased())"
      
      transactionNote = "" // walletActivity.walletActivityDescription
      currencyColor = walletActivity.activityCurrency.colorForCurrency
      
      transactionDate = walletActivity.activityCreatedAt.toDateWithCommonFormat()?.walletActivityDateString() ?? ""
      var commerceGoodTitle = WalletActivityContent.Strings.goodsTitlePlaceholder.localize()
      if let commerceTitle = walletActivity.relatedPost?.goodsInfo?.goodsTitle {
        commerceGoodTitle = "\"\(commerceTitle)\""
      }
      
      
      guard isIncoming else {
        userpicPlaceholder = UIImage.avatarImageForNameString(walletActivity.activityToUser?.userName ?? WalletActivityContent.Strings.pibbleUsername.localize())
        userpicUrlString = walletActivity.activityToUser?.userpicUrlString ?? ""
        let username = walletActivity.activityToUser?.userName ?? ""
        let attrubutedUsername =
          NSAttributedString(string: username.usernamed,
                             attributes: [
                              NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                              NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
            ])
        
        let attributedTitleBodyString: String
        
        switch walletActivity.acitivityGoodTransactionType {
        case .escrowTransaction:
          attributedTitleBodyString = WalletActivityContent.Strings.outcomingBuyEscrow(commerceGoodTitle)
        case .payTransaction:
          attributedTitleBodyString = WalletActivityContent.Strings.outcomingBuy(commerceGoodTitle)
        case .returnTransaction:
          attributedTitleBodyString = WalletActivityContent.Strings.returnGoodsToSeller(commerceGoodTitle)
        case .unsupported:
          attributedTitleBodyString = WalletActivityContent.Strings.outcomingBuy(commerceGoodTitle)
        }
        
        let attributedTitleBody =
          NSAttributedString(string: attributedTitleBodyString,
                             attributes: [
                              NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                              NSAttributedString.Key.foregroundColor: UIConstants.Colors.outcomingBody
            ])
        
        let title = NSMutableAttributedString()
        title.append(attributedTitleBody)
        title.append(attrubutedUsername)
        transactionTitle = title
        return
      }
      
      userpicPlaceholder = UIImage.avatarImageForNameString(walletActivity.activityFromUser?.userName ?? WalletActivityContent.Strings.pibbleUsername.localize())
      userpicUrlString = walletActivity.activityFromUser?.userpicUrlString ?? ""
      let username = walletActivity.activityFromUser?.userName ?? ""
      let attrubutedUsername =
        NSAttributedString(string: username.usernamed,
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
          ])
      
      let attributedTitleBodyString: String
      
      switch walletActivity.acitivityGoodTransactionType {
      case .escrowTransaction:
        attributedTitleBodyString = WalletActivityContent.Strings.incomingSellEscrow(commerceGoodTitle)
      case .payTransaction:
        attributedTitleBodyString = WalletActivityContent.Strings.incomingSell(commerceGoodTitle)
      case .returnTransaction:
        attributedTitleBodyString = WalletActivityContent.Strings.returnGoodsToSeller(commerceGoodTitle)
      case .unsupported:
        attributedTitleBodyString = WalletActivityContent.Strings.incomingSell(commerceGoodTitle)
      }
      
      let attributedTitleBody =
        NSAttributedString(string: attributedTitleBodyString,
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
          ])
      
      let title = NSMutableAttributedString()
      title.append(attributedTitleBody)
      title.append(attrubutedUsername)
      
      transactionTitle = title
    }
  
  }
  
  
  struct WalletActivityAirdropTransactionViewModel: WalletActivityInternalTransactionViewModelProtocol {
    let currencyColor: UIColor
    
    let transactionTitle: NSAttributedString
    let userpicPlaceholder: UIImage?
    
    let userpicUrlString: String
    let isIncoming: Bool
    let transactionDate: String
    let transactionValue: String
    let transactionNote: String
    
    init(walletActivity: AirdropTransactionProtocol, currentUser: UserProtocol) {
      isIncoming = walletActivity.isIncomingTo(account: currentUser)
      let outcomingIndicator = isIncoming ? "" : "-"
      transactionValue =  "\(outcomingIndicator)\(String(format: walletActivity.activityCurrency.stringFormat, walletActivity.activityValue)) \(walletActivity.activityCurrency.symbol.uppercased())"
      
      transactionNote = "" //walletActivity.walletActivityDescription
      currencyColor = walletActivity.activityCurrency.colorForCurrency
      
      transactionDate = walletActivity.activityCreatedAt.toDateWithCommonFormat()?.walletActivityDateString() ?? ""
      
      userpicPlaceholder = #imageLiteral(resourceName: "Wallet-PibbleUserAvatar")
      userpicUrlString = ""
      let attributedTitleBody =
        NSAttributedString(string: WalletActivityContent.Strings.airdrop.localize(),
                           attributes: [
                            NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                            NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
          ])
      transactionTitle = attributedTitleBody
    }
  }
    
  struct WalletActivityRewardTransactionViewModel: WalletActivityInternalTransactionViewModelProtocol {
    let currencyColor: UIColor
    
    let transactionTitle: NSAttributedString
    let userpicPlaceholder: UIImage?
    
    let userpicUrlString: String
    let isIncoming: Bool
    let transactionDate: String
    let transactionValue: String
    let transactionNote: String
    
    init(walletActivity: RewardTransactionProtocol, currentUser: UserProtocol) {
      isIncoming = walletActivity.isIncomingTo(account: currentUser)
      let outcomingIndicator = isIncoming ? "" : "-"
      transactionValue =  "\(outcomingIndicator)\(String(format: walletActivity.activityCurrency.stringFormat, walletActivity.activityValue)) \(walletActivity.activityCurrency.symbol.uppercased())"
      
      transactionNote = "" //walletActivity.walletActivityDescription
      currencyColor = walletActivity.activityCurrency.colorForCurrency
      
      transactionDate = walletActivity.activityCreatedAt.toDateWithCommonFormat()?.walletActivityDateString() ?? ""
      
      switch walletActivity.rewardActivityType {
      case .reward:
        userpicPlaceholder = #imageLiteral(resourceName: "Wallet-PibbleUserAvatar")
        userpicUrlString = ""
        let attributedTitleBody =
          NSAttributedString(string: WalletActivityContent.Strings.rewardForPosting.localize(),
                             attributes: [
                              NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                              NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
            ])
        transactionTitle = attributedTitleBody
      case .rewardFree:
        userpicPlaceholder = #imageLiteral(resourceName: "Wallet-PibbleUserAvatar")
        userpicUrlString = ""
        let attributedTitleBody =
          NSAttributedString(string: WalletActivityContent.Strings.freeReward.localize(),
                             attributes: [
                              NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                              NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
            ])
        transactionTitle = attributedTitleBody
      case .upvotePost:
        if isIncoming {
          userpicPlaceholder = UIImage.avatarImageForNameString(walletActivity.activityFromUser?.userName ?? WalletActivityContent.Strings.pibbleUsername.localize())
          userpicUrlString = walletActivity.activityFromUser?.userpicUrlString ?? ""
          let username = walletActivity.activityFromUser?.userName ?? ""
          let attrubutedUsername =
            NSAttributedString(string: username.usernamed,
                               attributes: [
                                NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                                NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
              ])
          
          let attributedTitleBody =
            NSAttributedString(string: WalletActivityContent.Strings.incomingForVoting.localize(),
                               attributes: [
                                NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                                NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
              ])
          
          let title = NSMutableAttributedString()
          
          title.append(attributedTitleBody)
          title.append(attrubutedUsername)
          transactionTitle = title
        } else {
          userpicPlaceholder = UIImage.avatarImageForNameString(walletActivity.activityToUser?.userName ?? WalletActivityContent.Strings.pibbleUsername.localize())
          userpicUrlString = walletActivity.activityToUser?.userpicUrlString ?? ""
          let username = walletActivity.activityToUser?.userName ?? ""
          let attrubutedUsername =
            NSAttributedString(string: username.usernamed,
                               attributes: [
                                NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                                NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
              ])
          
          let attributedTitleBodyBegin =
            NSAttributedString(string: WalletActivityContent.Strings.outcomingForVotingBegin.localize(),
                               attributes: [
                                NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                                NSAttributedString.Key.foregroundColor: UIConstants.Colors.outcomingBody
              ])
          
          
          let title = NSMutableAttributedString()
          title.append(attributedTitleBodyBegin)
          title.append(attrubutedUsername)
          transactionTitle = title
        }
     
      case .upvoteComment:
        if isIncoming {
          userpicPlaceholder = UIImage.avatarImageForNameString(walletActivity.activityFromUser?.userName ?? WalletActivityContent.Strings.pibbleUsername.localize())
          userpicUrlString = walletActivity.activityFromUser?.userpicUrlString ?? ""
          let username = walletActivity.activityFromUser?.userName ?? ""
          let attrubutedUsername =
            NSAttributedString(string: username.usernamed,
                               attributes: [
                                NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                                NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
              ])
          
          let attributedTitleBody =
            NSAttributedString(string: WalletActivityContent.Strings.incomingForComment.localize(),
                               attributes: [
                                NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                                NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
              ])
          
          let title = NSMutableAttributedString()
          
          title.append(attributedTitleBody)
          title.append(attrubutedUsername)
          transactionTitle = title
        } else {
          userpicPlaceholder = UIImage.avatarImageForNameString(walletActivity.activityToUser?.userName ?? WalletActivityContent.Strings.pibbleUsername.localize())
          userpicUrlString = walletActivity.activityToUser?.userpicUrlString ?? ""
          let username = walletActivity.activityToUser?.userName ?? ""
          let attrubutedUsername =
            NSAttributedString(string: username.usernamed,
                               attributes: [
                                NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                                NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
              ])
          
          let attributedTitleBodyBegin =
            NSAttributedString(string: WalletActivityContent.Strings.outcomingForComment.localize(),
                               attributes: [
                                NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                                NSAttributedString.Key.foregroundColor: UIConstants.Colors.outcomingBody
              ])
          
          
          let title = NSMutableAttributedString()
          title.append(attributedTitleBodyBegin)
          title.append(attrubutedUsername)
          
          transactionTitle = title
        }
      case .upvotePostHelpAnswer:
        if isIncoming {
          userpicPlaceholder = UIImage.avatarImageForNameString(walletActivity.activityFromUser?.userName ?? WalletActivityContent.Strings.pibbleUsername.localize())
          userpicUrlString = walletActivity.activityFromUser?.userpicUrlString ?? ""
          let username = walletActivity.activityFromUser?.userName ?? ""
          let attrubutedUsername =
            NSAttributedString(string: username.usernamed,
                               attributes: [
                                NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                                NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
              ])
          
          let attributedTitleBody =
            NSAttributedString(string: WalletActivityContent.Strings.incomingForPostHelpAnswer.localize(),
                               attributes: [
                                NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                                NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
              ])
          
          let title = NSMutableAttributedString()
          
          title.append(attributedTitleBody)
          title.append(attrubutedUsername)
          transactionTitle = title
        } else {
          userpicPlaceholder = UIImage.avatarImageForNameString(walletActivity.activityToUser?.userName ?? WalletActivityContent.Strings.pibbleUsername.localize())
          userpicUrlString = walletActivity.activityToUser?.userpicUrlString ?? ""
          let username = walletActivity.activityToUser?.userName ?? ""
          let attrubutedUsername =
            NSAttributedString(string: username.usernamed,
                               attributes: [
                                NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                                NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
              ])
          
          let attributedTitleBodyBegin =
            NSAttributedString(string: WalletActivityContent.Strings.outcomingForPostHelpAnswer.localize(),
                               attributes: [
                                NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                                NSAttributedString.Key.foregroundColor: UIConstants.Colors.outcomingBody
              ])
          
          
          let title = NSMutableAttributedString()
          title.append(attributedTitleBodyBegin)
          title.append(attrubutedUsername)
          
          transactionTitle = title
        }
      case .upvoteProfile:
        if isIncoming {
          userpicPlaceholder = UIImage.avatarImageForNameString(walletActivity.activityFromUser?.userName ?? WalletActivityContent.Strings.pibbleUsername.localize())
          userpicUrlString = walletActivity.activityFromUser?.userpicUrlString ?? ""
          let username = walletActivity.activityFromUser?.userName ?? ""
          let attrubutedUsername =
            NSAttributedString(string: username.usernamed,
                               attributes: [
                                NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                                NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
              ])
          
          let attributedTitleBody =
            NSAttributedString(string: WalletActivityContent.Strings.incomingForProfile.localize(),
                               attributes: [
                                NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                                NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
              ])
          
          let title = NSMutableAttributedString()
          
          title.append(attributedTitleBody)
          title.append(attrubutedUsername)
          transactionTitle = title
        } else {
          userpicPlaceholder = UIImage.avatarImageForNameString(walletActivity.activityToUser?.userName ?? WalletActivityContent.Strings.pibbleUsername.localize())
          userpicUrlString = walletActivity.activityToUser?.userpicUrlString ?? ""
          let username = walletActivity.activityToUser?.userName ?? ""
          let attrubutedUsername =
            NSAttributedString(string: username.usernamed,
                               attributes: [
                                NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                                NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
              ])
          
          let attributedTitleBodyBegin =
            NSAttributedString(string: WalletActivityContent.Strings.outcomingForProfile.localize(),
                               attributes: [
                                NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                                NSAttributedString.Key.foregroundColor: UIConstants.Colors.outcomingBody
              ])
          
          
          let title = NSMutableAttributedString()
          title.append(attributedTitleBodyBegin)
          title.append(attrubutedUsername)
          
          transactionTitle = title
        }
      case .defaultType:
        userpicPlaceholder = nil
        userpicUrlString = ""
        transactionTitle = NSAttributedString(string: "")
      case .deletePost:
        userpicPlaceholder = #imageLiteral(resourceName: "Wallet-PibbleUserAvatar")
        userpicUrlString = ""
        let attributedTitleBody =
          NSAttributedString(string: WalletActivityContent.Strings.feeForDeletePosting.localize(),
                             attributes: [
                              NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                              NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
            ])
        transactionTitle = attributedTitleBody
      case .referral:
        if isIncoming {
          userpicPlaceholder = UIImage.avatarImageForNameString(walletActivity.activityFromUser?.userName ?? WalletActivityContent.Strings.pibbleUsername.localize())
          userpicUrlString = walletActivity.activityFromUser?.userpicUrlString ?? ""
          let username = walletActivity.activityFromUser?.userName ?? ""
          let attrubutedUsername =
            NSAttributedString(string: username.usernamed,
                               attributes: [
                                NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                                NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
              ])
          
          let attributedTitleBody =
            NSAttributedString(string: WalletActivityContent.Strings.referralReward.localize(),
                               attributes: [
                                NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                                NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
              ])
          
          let title = NSMutableAttributedString()
          
          title.append(attributedTitleBody)
          title.append(attrubutedUsername)
          transactionTitle = title
        } else {
          userpicPlaceholder = UIImage.avatarImageForNameString(walletActivity.activityToUser?.userName ?? WalletActivityContent.Strings.pibbleUsername.localize())
          userpicUrlString = walletActivity.activityToUser?.userpicUrlString ?? ""
          let username = walletActivity.activityToUser?.userName ?? ""
          let attrubutedUsername =
            NSAttributedString(string: username.usernamed,
                               attributes: [
                                NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                                NSAttributedString.Key.foregroundColor: UIConstants.Colors.username
              ])
          
          let attributedTitleBodyBegin =
            NSAttributedString(string: WalletActivityContent.Strings.referralReward.localize(),
                               attributes: [
                                NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                                NSAttributedString.Key.foregroundColor: UIConstants.Colors.outcomingBody
              ])
          
          
          let title = NSMutableAttributedString()
          title.append(attributedTitleBodyBegin)
          title.append(attrubutedUsername)
          
          transactionTitle = title
        }
      
      case .challenge10Min, .challengeHourly, .challengeDaily:
        userpicPlaceholder = #imageLiteral(resourceName: "Wallet-PibbleUserAvatar")
        userpicUrlString = ""
        let attributedTitleBody =
          NSAttributedString(string: WalletActivityContent.Strings.challengeReward.localize(),
                             attributes: [
                              NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                              NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
            ])
        transactionTitle = attributedTitleBody
      case .unsupportedRewardType:
        userpicPlaceholder = #imageLiteral(resourceName: "Wallet-PibbleUserAvatar")
        userpicUrlString = ""
        let attributedTitleBody =
          NSAttributedString(string: WalletActivityContent.Strings.unsupportedReward.localize(),
                             attributes: [
                              NSAttributedString.Key.font: UIFont.AvenirNextMedium(size: 14.0),
                              NSAttributedString.Key.foregroundColor: UIConstants.Colors.incomingBody
            ])
        transactionTitle = attributedTitleBody
      }
    }
  }
  
  struct DataPlaceholderViewModel: DataPlaceholderViewModelProtocol {
    let title: String
    let subtitle: String
    
    init(currencyType: ActivityCurrencyType?) {
      guard let currencyType = currencyType else {
        title = ""
        subtitle = ""
        return
      }
      switch currencyType {
      case .coin(let currency):
        title = Strings.DataPlaceholderMessages.noActivity.localize(value: currency.symbol)
        subtitle = Strings.DataPlaceholderMessages.noActivityMessage.localize(value: currency.symbol)
      case .brush:
        let currencyName = Strings.brushSegmentTitle.localize()
        title = Strings.DataPlaceholderMessages.noActivity.localize(value: currencyName)
        subtitle = Strings.DataPlaceholderMessages.noBrushActivityMessage.localize()
        return
      }
    }
  }
  
  struct DonatorTransactionViewModel: WalletActivityDonatorTransactionViewModelProtocol {
    let avatarPlaceholder: UIImage?
    let avatarURLString: String
    let username: String
    let userLevel: String
    
    var priceTitle: String
    
    var amount: String
    
    init(walletActivity: FundingDonateTransactionProtocol) {
      avatarPlaceholder = UIImage.avatarImageForNameString(walletActivity.activityFromUser?.userName ?? WalletActivityContent.Strings.pibbleUsername.localize())
      avatarURLString = walletActivity.activityFromUser?.userpicUrlString ?? ""
      username = walletActivity.activityFromUser?.userName ?? ""
      if let date = walletActivity.activityCreatedAt.toDateWithCommonFormat() {
        userLevel = date.timeAgoSinceNow(useNumericDates: true, useCompactDates: false)
      } else {
        userLevel = ""
      }
      
      amount = String(format: "%.0f", walletActivity.activityValue)
      priceTitle = ""
      
    }
    
    init(walletActivity: CrowdFundingWithRewardsDonateTransactionProtocol) {
      avatarPlaceholder = UIImage.avatarImageForNameString(walletActivity.activityFromUser?.userName ?? WalletActivityContent.Strings.pibbleUsername.localize())
      avatarURLString = walletActivity.activityFromUser?.userpicUrlString ?? ""
      username = walletActivity.activityFromUser?.userName ?? ""
      if let date = walletActivity.activityCreatedAt.toDateWithCommonFormat() {
        userLevel = date.timeAgoSinceNow(useNumericDates: true, useCompactDates: false)
      } else {
        userLevel = ""
      }
      
      amount = String(format: "%.0f", walletActivity.activityValue)
      priceTitle = walletActivity.rewardPriceTitle
    }
  }
}


fileprivate enum UIConstants {
  enum Colors {
    static let username = UIColor.gray70
    static let incomingBody = UIColor.gray70
    static let outcomingBody = UIColor.gray70
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


extension WalletActivityContent {
  enum Strings: String, LocalizedStringKeyProtocol {
    case brushSegmentTitle = "Brush"
    
    case pibbleUsername = "Pibble"
    
    case incomingInvoice = " sent you request"
    case outcomingInvoice = "you sent request to "
    
    case rewardForPosting = "Got Media Post Reward"
    case feeForDeletePosting = "Fee for Post Delete"
    case freeReward = "You got free Upvote reward"
    case airdrop = "Airdrop"
    
    case challengeReward = "Challenge Reward"
    case unsupportedReward = "Reward"
    
    
    case incomingForVoting = "Got Upvote from "
    case outcomingForVotingBegin = "Upvote to Feed "
    
    case incomingForComment = "Got Comment Upvote from "
    case outcomingForComment = "Upvote to comment "
    
    case incomingForPostHelpAnswer = "Got Answer Upvote from "
    case outcomingForPostHelpAnswer = "Upvote to answer "
    
    case referralReward = "Referral reward"
    
    case incomingForProfile = "Got Profile Upvote from "
    case outcomingForProfile = "Upvote to Profile "
    
    case exchanged = "Exchanged "
    case exchangedTo = " to "
    case exchangedExternalWithApp = " with "
    
    case digitalGoodTitlePlaceholder = "digital good"
    case goodsTitlePlaceholder = "goods"
    
    
    enum PromotionTransactions: String, LocalizedStringKeyProtocol {
      case promotedPostRewardIncoming = "Got Promoted Post Reward"
      case promotedPostRewardOutcoming = "Sent Promoted Post Reward"
      
      
      case promotionDebit =  "Promotion Budget"
      case impression =  "Promotion Reward - impression "
      case upvote =  "Promotion Reward - upvote "
      case comment =  "Promotion Reward - comment "
      case collect = "Promotion Reward - collect "
      case follow = "Promotion Reward - follow "
      case action = "Promotion Reward - engage action button "
      case followTag = "Promotion Reward - tag follow "
      case profileView = "Promotion Reward - visit profile "
    }
    
    case promotionDebitWith = "Promote %"
    case receivedFrom = "Received % from "
    case sentTo = "Sent % to "
    case sellTo = "Sell % to "
    case buyFrom = "Buy % from "
    case sellEscrowTo = "Sell escrow % "
    case buyEscrowFrom = "Buy escrow % "
    case rewardedWith = "You were rewarded with %"
    case withdrawalOf = "Withdrawal of %"
    
    case returnGoods = "Return % "
    
    case charityFundingTo = "Charity funding % to "
    
    enum DataPlaceholderMessages: String, LocalizedStringKeyProtocol {
      case noActivity = "No % Activity"
      
      case noBrushActivityMessage = "You don't have any reward or upvote activitis using red or green brushes."
      case noActivityMessage = "You do not have any activities related to % transfer."
    }
    
    enum Funding: String, LocalizedStringKeyProtocol {
      case charityFundingDonate = "Charity funding to "
      case crowdFundingDonate = "Crowd funding to "
      case crowdFundingWithRewardDonate = "Reward crowd funding to "
      
      case charityFundingRefund = "Get a donation back"
      case crowdFundingRefund = "Get a crowd funding back"
      case crowdFundingWithRewardRefund = "Get a reward crowdfunding back"
      
      case charityFundingCollected = "Collected from Charity funding"
      case crowdFundingCollected = "Collected from Crowd funding"
      case crowdFundingWithRewardCollected = "Collected from Reward crowd funding"
    }
    
    enum PostHelpAnswers: String, LocalizedStringKeyProtocol {
      case postHelpPayment = "Prepayment for answer"
      case postHelpReward = "Reward for answer "
    }
    
    static func promotionDebit(_ currency: String) -> String {
      return Strings.promotionDebitWith.localize(value: currency)
    }
    
    static func incoming(_ currency: String) -> String {
      return Strings.receivedFrom.localize(value: currency)
    }
    
    static func outcoming(_ currency: String) -> String {
      return Strings.sentTo.localize(value: currency)
    }
    
    static func incomingSell(_ title: String) -> String {
      return Strings.sellTo.localize(value: title)
    }
    
    static func outcomingBuy(_ title: String) -> String {
      return Strings.buyFrom.localize(value: title)
    }
    
    static func incomingSellEscrow(_ title: String) -> String {
      return Strings.sellEscrowTo.localize(value: title)
    }
    
    static func outcomingBuyEscrow(_ title: String) -> String {
      return Strings.buyEscrowFrom.localize(value: title)
    }
    
    static func returnGoodsToSeller(_ title: String) -> String {
      return Strings.returnGoods.localize(value: title)
    }
    
    static func reward(_ currency: String) -> String {
      return Strings.rewardedWith.localize(value: currency)
    }
    
    static func withdrawal(_ currency: String) -> String {
      return Strings.withdrawalOf.localize(value: currency)
    }
    
    static func incomingExternal(_ currency: String) -> String {
      return Strings.receivedFrom.localize(value: currency)
    }
    
    static func outcomingExternal(_ currency: String) -> String {
      return Strings.sentTo.localize(value: currency)
    }
    
    static func outcomingFunding(_ currency: String) -> String {
      return Strings.charityFundingTo.localize(value: currency)
    }
    
  }
}









