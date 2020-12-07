//
//  CommercialPostDetailModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 06/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

enum CommercialPostDetail {
  enum CommercialPostType {
    case digitalGoods(PostingProtocol, CommerceInfoProtocol)
    case goods(PostingProtocol, GoodsProtocol)
  }
  
  typealias ActionHandler = (UITableViewCell, CommercialPostDetail.Actions) -> Void

  enum Errors: PibbleErrorProtocol {
    case invoiceRequestError
   
    var description: String {
      switch self {
      case .invoiceRequestError:
        return Strings.Errors.invoiceRequestError.localize()
      }
    }
  }
  
  enum Actions {
    case presentAgreement
    case messages
    case checkout
    case showGoodsURL
  }
  
  enum ViewModelType {
    case description(CommercialPostDetailDescriptionViewModelProtocol)
    case licensing(CommercialPostDetailLicensingViewModelProtocol)
    case agreement(CommercialPostDetailAgreementViewModelProtocol)
    case messages
    case checkout(CommercialPostCheckoutButtonViewModelProtocol)
    case goodsDescription(CommercialPostDetailGoodsDescriptionViewModelProtocol)
    case goodsInfo(CommercialPostDetailGoodsInfoViewModelProtocol)
    
    case digitalGoodsUsageInfo
    case goodsEscrowInfo
  }
  
  struct CommercialPostDetailLicensingViewModel: CommercialPostDetailLicensingViewModelProtocol {
    let commercialUseAllowed: Bool
    let editorialUseAllowed: Bool
    let royaltyFreeUseAllowed: Bool
    let exclusiveUseAllowed: Bool
    
    let isDownloadable: Bool
    let isDownloadableString: String
    
    init(commericalInfo: CommerceInfoProtocol) {
      commercialUseAllowed = commericalInfo.isCommercialUseAvailable
      editorialUseAllowed = commericalInfo.isEditorialUseAvailable
      royaltyFreeUseAllowed = commericalInfo.isRoyaltyFreeUseAvailable
      exclusiveUseAllowed = commericalInfo.isExclusiveUseAvailable
      
      isDownloadable = commericalInfo.isDownloadAvailable
      isDownloadableString = commericalInfo.isDownloadAvailable ?
        CommercialPostDetail.Strings.downloadAvailable.localize() :
        CommercialPostDetail.Strings.downloadNotAvailable.localize()
    }
  }
  
  struct CommercialPostDetailMediaItemDescriptionViewModel: CommercialPostDetailMediaItemDescriptionViewModelProtocol {
    let itemImageViewURLString: String
    let resolution: String
    let dpi: String
    let format: String
    let size: String
    
    let originalMediaWidth: CGFloat
    let originalMediaHeight: CGFloat
    
    init(media: MediaProtocol) {
      let width = String(format:"%.0f", media.contentOriginalWidth)
      let height = String(format:"%.0f", media.contentOriginalHeight)
      
      itemImageViewURLString = media.mediaUrl
      resolution = "\(width) x \(height) pixel"
      
      let printWidth = String(format:"%.1f", media.printWidth)
      let printHeight = String(format:"%.1f", media.printHeight)
      let printSizeDPI = String(format:"%.0f", media.printSizeDPI)
      dpi = "\(printSizeDPI) dpi (\(printWidth)cm x \(printHeight)cm)"
      
      format = media.contentFileExtension.uppercased()
      size = "-"
      
      originalMediaWidth = CGFloat(media.contentWidth)
      originalMediaHeight = CGFloat(media.contentHeight)
    }
  }
  
  struct CommercialPostDetailDescriptionViewModel: CommercialPostDetailDescriptionViewModelProtocol {
    let itemTitleLabel: String
    let price: String
    
    let reward: String
    let rewardCurrency: String
    let rewardCurrencyColor: UIColor
    
    var mediaItemsViewModel: [CommercialPostDetailMediaItemDescriptionViewModelProtocol]
    
    init(post: PostingProtocol, commerceInfo: CommerceInfoProtocol) {
      itemTitleLabel = commerceInfo.commerceItemTitle
      price = "\(commerceInfo.commerceItemPrice) \(commerceInfo.commerceItemCurrency.symbol)"
      
      let rewardAmount = commerceInfo.commerceReward * Double(commerceInfo.commerceItemPrice)
      reward = String(format:"%.2f", rewardAmount)
      rewardCurrency = "\(commerceInfo.commerceItemCurrency.symbol)"
      rewardCurrencyColor = commerceInfo.commerceItemCurrency.colorForCurrency
      
      mediaItemsViewModel = post.postingMedia.map { CommercialPostDetailMediaItemDescriptionViewModel(media: $0)}
    }
    
    func numberOfSections() -> Int {
      return 1
    }
    
    func numberOfItemsInSection(_ section: Int) -> Int {
      return mediaItemsViewModel.count
    }
    
    func itemViewModelAt(_ indexPath: IndexPath) -> CommercialPostDetailMediaItemDescriptionViewModelProtocol {
      return mediaItemsViewModel[indexPath.item]
    }
  }
  
  struct CommercialPostDetailAgreementViewModel: CommercialPostDetailAgreementViewModelProtocol {
    let agreementTitle: NSAttributedString
    
    init() {
      let title = CommercialPostDetail.Strings.eulaTitle.localize()
      agreementTitle = NSAttributedString(string: title,
                         attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
  }
  
  struct GoodsDescriptionViewModel: CommercialPostDetailGoodsDescriptionViewModelProtocol {
    var descriptionText: String
    
    init?(goodsInfo: GoodsProtocol) {
      guard goodsInfo.goodsDescription.count > 0 else {
        return nil
      }
      
      descriptionText = goodsInfo.goodsDescription
    }
  }
  
  struct GoodsInfoViewModel: CommercialPostDetailGoodsInfoViewModelProtocol {
    fileprivate static let numberToStringsFormatter: NumberFormatter = {
      let formatter = NumberFormatter()
      formatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
      formatter.numberStyle = NumberFormatter.Style.decimal
      return formatter
    }()
    
    let title: String
    let price: String
    let urlString: String
    let isNew: Bool
    
    init(goodsInfo: GoodsProtocol) {
      title = goodsInfo.goodsTitle
      
      let goodsPrice = NSNumber(value: goodsInfo.goodsPrice)
      let goodsPriceString = GoodsInfoViewModel.numberToStringsFormatter.string(from: goodsPrice) ?? ""
      price = "\(goodsPriceString) \(BalanceCurrency.pibble.symbol)"
      
      urlString = goodsInfo.goodsUrlString
      isNew = goodsInfo.isNewGoodsStatus
    }
  }
  
  struct CheckoutButtonViewModel: CommercialPostCheckoutButtonViewModelProtocol {
    var title: String
    var disabledStateTitle: String
    var isEnabled: Bool
    
    init(digitalGoodInfo: CommerceInfoProtocol) {
      isEnabled = true
      title = CommercialPostDetail.Strings.CheckoutButtonTitle.buyItem.localize()
      disabledStateTitle = CommercialPostDetail.Strings.CheckoutButtonTitle.requestingInvoice.localize()
    }
    
    init(goodsInfo: GoodsProtocol) {
      switch goodsInfo.availabilityStatus {
      case .available:
        isEnabled = true
        title = CommercialPostDetail.Strings.CheckoutButtonTitle.buyItem.localize()
        disabledStateTitle = CommercialPostDetail.Strings.CheckoutButtonTitle.requestingInvoice.localize()
      case .booked:
        isEnabled = false
        title = CommercialPostDetail.Strings.CheckoutButtonTitle.booked.localize()
        disabledStateTitle = CommercialPostDetail.Strings.CheckoutButtonTitle.booked.localize()
      case .soldOut:
        isEnabled = false
        title = CommercialPostDetail.Strings.CheckoutButtonTitle.soldOut.localize()
        disabledStateTitle = CommercialPostDetail.Strings.CheckoutButtonTitle.soldOut.localize()
      case .unsupportedStatus:
        isEnabled = true
        title = CommercialPostDetail.Strings.CheckoutButtonTitle.buyItem.localize()
        disabledStateTitle = CommercialPostDetail.Strings.CheckoutButtonTitle.requestingInvoice.localize()
      }
    }
  }
}


extension CommercialPostDetail {
  enum Strings: String, LocalizedStringKeyProtocol {
    case eulaTitle = "End-User License Agreement (EULA)"
    
    case downloadAvailable = "YES"
    case downloadNotAvailable = "NO"
    
    enum CheckoutButtonTitle: String, LocalizedStringKeyProtocol {
      case buyItem = "BUY ITEM"
      case requestingInvoice = "REQUESTING INVOICE"
      case booked = "BOOKED"
      case soldOut = "SOLD OUT"
    }
    
    enum Errors: String, LocalizedStringKeyProtocol {
      case invoiceRequestError = "Invoice Request Error"
    }
  }
}
