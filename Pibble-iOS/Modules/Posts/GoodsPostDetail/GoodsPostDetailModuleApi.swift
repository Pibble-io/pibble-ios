//
//  GoodsPostDetailModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 30/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

//MARK: - GoodsPostDetailRouter API
protocol GoodsPostDetailRouterApi: RouterProtocol {
}

//MARK: - GoodsPostDetailView API
protocol GoodsPostDetailViewControllerApi: ViewControllerProtocol {
}

//MARK: - GoodsPostDetailPresenter API
protocol GoodsPostDetailPresenterApi: PresenterProtocol {
  
  func handleHideAction()
  
  func present(post: PostingProtocol, goodsInfo: GoodsProtocol)
  
}

//MARK: - GoodsPostDetailInteractor API
protocol GoodsPostDetailInteractorApi: InteractorProtocol {
  func initialFetchData()
}

protocol GoodsPostDetailDescriptionViewModelProtocol {
  var descriptionText: String { get }
}

protocol GoodsPostDetailInfoViewModelProtocol {
  var title: String { get }
  var price: String { get }
  var urlString: String { get }
  var isNew: Bool { get }
}
