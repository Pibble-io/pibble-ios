//
//  CommercialPostDetailModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 06/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - CommercialPostDetailRouter API
protocol CommercialPostDetailRouterApi: RouterProtocol {
  func routeToEULAForPost(_ post: PostingProtocol)
  func routeToChatRoomForPost(_ post: PostingProtocol)
  func routeToExternalLinkAt(_ url: URL)
}

//MARK: - CommercialPostDetailView API
protocol CommercialPostDetailViewControllerApi: ViewControllerProtocol {
  func reloadData()
  func performHideAnimation(_ complete: @escaping () -> Void)
}

//MARK: - CommercialPostDetailPresenter API
protocol CommercialPostDetailPresenterApi: PresenterProtocol {
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func viewModelAt(_ indexPath: IndexPath) -> CommercialPostDetail.ViewModelType
  
  func handleHideAction()
  func handleAction(_ action: CommercialPostDetail.Actions)
  
  func present(post: PostingProtocol, commerceInfo: CommerceInfoProtocol)
  func present(post: PostingProtocol, goodsInfo: GoodsProtocol)
  
  func presentInvoiceRequestFailure()
  func presentInvoiceRequestSuccess(_ invoice: InvoiceProtocol)
  
  func presentPostForGoodsOrderCreation(_ post: PostingProtocol)
}

//MARK: - CommercialPostDetailInteractor API
protocol CommercialPostDetailInteractorApi: InteractorProtocol {
  var post: PostingProtocol { get }
  var commercialPostType: CommercialPostDetail.CommercialPostType { get }

  func fetchInitialData()
  func performCheckout()
  
//  func sendPostToChatRoomWithPostAuthor()
//  func createChatRoomForPost()
}

protocol CommercialPostDetailLicensingViewModelProtocol {
  var commercialUseAllowed: Bool { get }
  var editorialUseAllowed: Bool { get }
  var royaltyFreeUseAllowed: Bool { get }
  var exclusiveUseAllowed: Bool { get }
  var isDownloadable: Bool { get }
  var isDownloadableString: String { get }
}

protocol CommercialPostDetailMediaItemDescriptionViewModelProtocol {
  var itemImageViewURLString: String { get }
  var resolution: String { get }
  var dpi: String { get }
  var format: String { get }
  var size: String { get }
  
  var originalMediaWidth: CGFloat { get }
  var originalMediaHeight: CGFloat { get }
}

protocol CommercialPostDetailDescriptionViewModelProtocol {
  var itemTitleLabel: String { get }
  var price: String { get }
  var reward: String { get }
  var rewardCurrency: String { get }
  var rewardCurrencyColor: UIColor { get }
  
  var mediaItemsViewModel: [CommercialPostDetailMediaItemDescriptionViewModelProtocol] { get }
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> CommercialPostDetailMediaItemDescriptionViewModelProtocol
}

protocol CommercialPostDetailAgreementViewModelProtocol {
  var agreementTitle: NSAttributedString { get }
}

protocol CommercialPostCheckoutButtonViewModelProtocol {
  var title: String { get }
  var disabledStateTitle: String { get }
  var isEnabled: Bool { get }
}

protocol CommercialPostDetailDelegateProtocol: class {
  func didRequestedInvoice(_ invoice: InvoiceProtocol)
  func shouldCreateGoodsOrderFor()
}

protocol CommercialPostDetailGoodsDescriptionViewModelProtocol {
  var descriptionText: String { get }
}

protocol CommercialPostDetailGoodsInfoViewModelProtocol {
  var title: String { get }
  var price: String { get }
  var urlString: String { get }
  var isNew: Bool { get }
}
