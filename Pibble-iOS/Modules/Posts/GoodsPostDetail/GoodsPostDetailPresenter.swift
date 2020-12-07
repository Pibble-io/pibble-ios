//
//  GoodsPostDetailPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 30/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - GoodsPostDetailPresenter Class
final class GoodsPostDetailPresenter: Presenter {
}

// MARK: - GoodsPostDetailPresenter API
extension GoodsPostDetailPresenter: GoodsPostDetailPresenterApi {
  func present(post: PostingProtocol, goodsInfo: GoodsProtocol) {
     
  }
  
  func handleHideAction() {
    router.dismiss()
  }
}

// MARK: - GoodsPostDetail Viper Components
fileprivate extension GoodsPostDetailPresenter {
  var viewController: GoodsPostDetailViewControllerApi {
    return _viewController as! GoodsPostDetailViewControllerApi
  }
  var interactor: GoodsPostDetailInteractorApi {
    return _interactor as! GoodsPostDetailInteractorApi
  }
  var router: GoodsPostDetailRouterApi {
    return _router as! GoodsPostDetailRouterApi
  }
}
