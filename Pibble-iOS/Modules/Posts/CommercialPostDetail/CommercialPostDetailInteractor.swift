//
//  CommercialPostDetailInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 06/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - CommercialPostDetailInteractor Class
final class CommercialPostDetailInteractor: Interactor {
  fileprivate let chatService: ChatServiceProtocol
  fileprivate let walletService: WalletServiceProtocol
  fileprivate let coreDataStorage: CoreDataStorageServiceProtocol
  
  let commercialPostType: CommercialPostDetail.CommercialPostType
  
  var post: PostingProtocol {
    switch commercialPostType {
    case .digitalGoods(let post, _):
      return post
    case .goods(let post, _):
      return post
    }
  }
  
  fileprivate var observableInvoice: ObservableManagedObject<InvoiceManagedObject>?
  
  func createObservableInvoice(_ invoice: PartialInvoiceProtocol) {
    guard observableInvoice == nil else {
      return
    }
    
    observableInvoice = InvoiceManagedObject.createObservable(with: invoice, in: coreDataStorage.viewContext)
    
    observableInvoice?.observationHandler = { [weak self] in
      self?.presenter.presentInvoiceRequestSuccess($0)
    }
    
    observableInvoice?.performFetch { [weak self] in
      switch $0 {
      case .success(let invoice):
        guard let invoice = invoice else {
          return
        }
        self?.presenter.presentInvoiceRequestSuccess(invoice)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
  init(chatService: ChatServiceProtocol,
       walletService: WalletServiceProtocol,
       coreDataStorage: CoreDataStorageServiceProtocol,
       commercialPostType: CommercialPostDetail.CommercialPostType) {
    self.chatService = chatService
    self.walletService = walletService
    self.coreDataStorage = coreDataStorage
    self.commercialPostType = commercialPostType
  }
}

// MARK: - CommercialPostDetailInteractor API
extension CommercialPostDetailInteractor: CommercialPostDetailInteractorApi {
  func performCheckout() {
    requestInvoiceFor(post)
  }
  
  fileprivate func requestInvoiceFor(_ post: PostingProtocol) {
    switch post.postingType {
    case .media, .funding, .charity, .crowdfundingWithReward:
      presenter.presentInvoiceRequestFailure()
      presenter.handleError(CommercialPostDetail.Errors.invoiceRequestError)
      return
    case .commercial:
      guard let digitalGoodInfo = post.commerceInfo,
        let postAuthor = post.postingUser
        else {
          presenter.presentInvoiceRequestFailure()
          presenter.handleError(CommercialPostDetail.Errors.invoiceRequestError)
          return
      }
      
      walletService.requestInvoiceFor(post: post,
                                      commerce: digitalGoodInfo,
                                      user: postAuthor) { [weak self] in
                                        guard let strongSelf = self else {
                                          return
                                        }
                                        
                                        switch $0 {
                                        case .success(let invoice):
                                          strongSelf.createObservableInvoice(invoice)
                                          strongSelf.coreDataStorage.updateStorage(with: [invoice])
                                        case .failure(let error):
                                          strongSelf.presenter.presentInvoiceRequestFailure()
                                          strongSelf.presenter.handleError(error)
                                        }
      }
    case .goods:
      guard let _ = post.goodsInfo else {
        presenter.presentInvoiceRequestFailure()
        presenter.handleError(CommercialPostDetail.Errors.invoiceRequestError)
        return
      }
      
      presenter.presentPostForGoodsOrderCreation(post)
    }
  }
  
   
  
  func fetchInitialData() {
    switch commercialPostType {
    case .digitalGoods(let post, let digitalGoodCommerceInfo):
      presenter.present(post: post, commerceInfo: digitalGoodCommerceInfo)
    case .goods(let post, let goodsCommerceInfo):
      presenter.present(post: post, goodsInfo: goodsCommerceInfo)
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension CommercialPostDetailInteractor {
  var presenter: CommercialPostDetailPresenterApi {
    return _presenter as! CommercialPostDetailPresenterApi
  }
}
