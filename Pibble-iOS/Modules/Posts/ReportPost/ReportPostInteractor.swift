//
//  ReportPostInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 01/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - ReportPostInteractor Class
final class ReportPostInteractor: Interactor {
  fileprivate let postService: PostingServiceProtocol
  
  init(postService: PostingServiceProtocol) {
    self.postService = postService
  }
}

// MARK: - ReportPostInteractor API
extension ReportPostInteractor: ReportPostInteractorApi {
  func initialFetchData() {
    postService.getPostReportReasons { [weak self] in
      switch $0 {
      case .success(let reasons):
        self?.presenter.presentReasons(reasons)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
  
}

// MARK: - Interactor Viper Components Api
private extension ReportPostInteractor {
  var presenter: ReportPostPresenterApi {
    return _presenter as! ReportPostPresenterApi
  }
}
