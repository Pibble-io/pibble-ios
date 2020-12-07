//
//  CommercialPostDetailPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 06/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - CommercialPostDetailPresenter Class

final class CommercialPostDetailPresenter: Presenter {
  fileprivate enum Sections: Int {
    case info
    case actions
  }
  
  fileprivate enum Items {
    case description
    case licensing
    case agreement
    case messages
    case checkout
  }
  
  fileprivate var sections: [(section: Sections, items: [CommercialPostDetail.ViewModelType])] = []
  
  fileprivate weak var delegate: CommercialPostDetailDelegateProtocol?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.fetchInitialData()
  }
  
  init(delegate: CommercialPostDetailDelegateProtocol) {
    self.delegate = delegate
  }
}

// MARK: - CommercialPostDetailPresenter API

extension CommercialPostDetailPresenter: CommercialPostDetailPresenterApi {
  func presentPostForGoodsOrderCreation(_ post: PostingProtocol) {
    viewController.performHideAnimation() { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.router.dismiss()
      strongSelf.delegate?.shouldCreateGoodsOrderFor()
    }
  }
  
  func presentInvoiceRequestFailure() {
    viewController.reloadData()
  }
  
  func presentInvoiceRequestSuccess(_ invoice: InvoiceProtocol) {
    viewController.performHideAnimation() { [weak self] in
      guard let strongSelf = self else {
        return
      }
     
      strongSelf.router.dismiss()
      strongSelf.delegate?.didRequestedInvoice(invoice)
    }
  }
 
  func handleAction(_ action: CommercialPostDetail.Actions) {
    switch action {
    case .presentAgreement:
      router.routeToEULAForPost(interactor.post)
    case .messages:
      router.routeToChatRoomForPost(interactor.post)
    case .checkout:
      interactor.performCheckout()
    case .showGoodsURL:
      switch interactor.commercialPostType {
      case .digitalGoods(_, _):
        break
      case .goods(_, let goodsInfo):
        guard let url = goodsInfo.goodsURL else {
          return
        }
        
        router.routeToExternalLinkAt(url)
      }
      
    }
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  
  func present(post: PostingProtocol, goodsInfo: GoodsProtocol) {
    var infoSection: [CommercialPostDetail.ViewModelType] = []
    
    let goodsInfoVM = CommercialPostDetail.GoodsInfoViewModel(goodsInfo: goodsInfo)
    let goodsDescriptionVM = CommercialPostDetail.GoodsDescriptionViewModel(goodsInfo: goodsInfo)
    
    infoSection.append(.goodsInfo(goodsInfoVM))
    if let goodsDescriptionVM = goodsDescriptionVM {
      infoSection.append(.goodsDescription(goodsDescriptionVM))
    }
    
    var actionsSection: [CommercialPostDetail.ViewModelType] = []
    
    actionsSection.append(.messages)
    actionsSection.append(.checkout(CommercialPostDetail.CheckoutButtonViewModel(goodsInfo: goodsInfo)))
    actionsSection.append(.goodsEscrowInfo)
   
    sections = [(.info, infoSection), (.actions, actionsSection)]
    viewController.reloadData()
  }
  
  func present(post: PostingProtocol, commerceInfo: CommerceInfoProtocol) {
    var infoSection: [CommercialPostDetail.ViewModelType] = []
    
    let mediaItemsVM = CommercialPostDetail.CommercialPostDetailDescriptionViewModel(post: post, commerceInfo: commerceInfo)
    let licensingVM = CommercialPostDetail.CommercialPostDetailLicensingViewModel(commericalInfo: commerceInfo)
    let agreementVM = CommercialPostDetail.CommercialPostDetailAgreementViewModel()
    
    infoSection.append(.description(mediaItemsVM))
    infoSection.append(.licensing(licensingVM))
    infoSection.append(.agreement(agreementVM))
    
    var actionsSection: [CommercialPostDetail.ViewModelType] = []
    
    actionsSection.append(.messages)
    actionsSection.append(.checkout(CommercialPostDetail.CheckoutButtonViewModel(digitalGoodInfo: commerceInfo)))
    actionsSection.append(.digitalGoodsUsageInfo)
    
    sections = [(.info, infoSection), (.actions, actionsSection)]
    viewController.reloadData()
  }
  
  func numberOfSections() -> Int {
    return sections.count
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return sections[section].items.count
  }
  
  func viewModelAt(_ indexPath: IndexPath) -> CommercialPostDetail.ViewModelType {
    return sections[indexPath.section].items[indexPath.item]
  }
}

// MARK: - CommercialPostDetail Viper Components

fileprivate extension CommercialPostDetailPresenter {
  var viewController: CommercialPostDetailViewControllerApi {
    return _viewController as! CommercialPostDetailViewControllerApi
  }
  var interactor: CommercialPostDetailInteractorApi {
    return _interactor as! CommercialPostDetailInteractorApi
  }
  var router: CommercialPostDetailRouterApi {
    return _router as! CommercialPostDetailRouterApi
  }
}
