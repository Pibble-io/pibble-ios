//
//  PostStatisticsInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 18/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - PostStatisticsInteractor Class
final class PostStatisticsInteractor: Interactor {
  fileprivate let postService: PostingServiceProtocol
  fileprivate let post: PostingProtocol
  
  init(postService: PostingServiceProtocol, post: PostingProtocol) {
    self.postService = postService
    self.post = post
    super.init()
  }
}

// MARK: - PostStatisticsInteractor API
extension PostStatisticsInteractor: PostStatisticsInteractorApi {
  func initialFetchData() {
    postService.getStatisticsFor(post) { [weak self] in
      switch $0 {
      case .success(let postStats):
        self?.presenter.presentStatistics(postStats)
      case .failure(let error):
        self?.presenter.handleError(error)
      }
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension PostStatisticsInteractor {
  var presenter: PostStatisticsPresenterApi {
    return _presenter as! PostStatisticsPresenterApi
  }
}
