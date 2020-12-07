//
//  GoodsPostDetailInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 30/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - GoodsPostDetailInteractor Class
final class GoodsPostDetailInteractor: Interactor {
}

// MARK: - GoodsPostDetailInteractor API
extension GoodsPostDetailInteractor: GoodsPostDetailInteractorApi {
  func initialFetchData() {
     
  }
  
}

// MARK: - Interactor Viper Components Api
private extension GoodsPostDetailInteractor {
  var presenter: GoodsPostDetailPresenterApi {
    return _presenter as! GoodsPostDetailPresenterApi
  }
}
