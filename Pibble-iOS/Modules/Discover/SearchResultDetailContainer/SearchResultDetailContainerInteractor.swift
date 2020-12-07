//
//  SearchResultDetailContainerInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 27.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - SearchResultDetailContainerInteractor Class
final class SearchResultDetailContainerInteractor: Interactor {
  fileprivate let userInteractionService: UserInteractionServiceProtocol
  fileprivate let tagService: TagServiceProtocol
  fileprivate(set) var fetchedTag: TagProtocol?
  
  let contentType: SearchResultDetailContainer.ContentType
  
  init(userInteractionService: UserInteractionServiceProtocol,
       tagService: TagServiceProtocol,
       targetUser: SearchResultDetailContainer.ContentType) {
    self.userInteractionService = userInteractionService
    self.tagService = tagService
    self.contentType = targetUser
  }
}

// MARK: - SearchResultDetailContainerInteractor API
extension SearchResultDetailContainerInteractor: SearchResultDetailContainerInteractorApi {
  
  func initialFetchData() {
    switch contentType {
    case .relatedPostsForTag(let tag):
      fetchedTag = tag
      presenter.presentTag(tag)
    case .relatedPostsForTagString(let tag):
      tagService.getRelatedPostsFor(tag, page: 1, perPage: 1) { [weak self] in
        switch $0 {
        case .success(let tag, _, _, _):
          self?.fetchedTag = tag
          self?.presenter.presentTag(tag)
        case .failure(let error):
          self?.presenter.handleError(error)
        }
      }
    case .placeRelatedPosts(let place):
      presenter.presentPlace(place)
    }
  }
}

// MARK: - Interactor Viper Components Api
private extension SearchResultDetailContainerInteractor {
  var presenter: SearchResultDetailContainerPresenterApi {
    return _presenter as! SearchResultDetailContainerPresenterApi
  }
}
