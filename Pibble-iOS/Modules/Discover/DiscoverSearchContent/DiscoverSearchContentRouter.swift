//
//  DiscoverSearchContentRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - DiscoverSearchContentRouter class
final class DiscoverSearchContentRouter: Router {
}

// MARK: - DiscoverSearchContentRouter API
extension DiscoverSearchContentRouter: DiscoverSearchContentRouterApi {
  func routeToDetailFor(_ user: UserProtocol) {
    AppModules
      .UserProfile
      .userProfileContainer(.other(user))
      .build()?
      .router.present(withPushfrom: _presenter._viewController, animated: true)
  }
  
  func routeToDetailFor(_ place: LocationProtocol) {
    AppModules
      .Discover
      .searchResultDetailContainer(.placeRelatedPosts(place))
      .build()?
      .router.present(withPushfrom: _presenter._viewController, animated: true)
  }
  
  func routeToDetailFor(_ tag: TagProtocol) {
    AppModules
      .Discover
      .searchResultDetailContainer(.relatedPostsForTag(tag))
      .build()?
      .router.present(withPushfrom: _presenter._viewController, animated: true)
  }
  
//  func routeToDetailFor(_ searchResult: DiscoverSearchContent.SearchResult) {
//    switch searchResult {
//    case .user(let user):
//      AppModules
//        .UserProfile
//        .userProfileContainer(.other(user))
//        .build()?
//        .router.present(withPushfrom: _presenter._viewController, animated: true)
//    case .place(let place):
//      AppModules
//        .Discover
//        .searchResultDetailContainer(.placeRelatedPosts(place))
//        .build()?
//        .router.present(withPushfrom: _presenter._viewController, animated: true)
//    case .tag(let tag):
//      AppModules
//        .Discover
//        .searchResultDetailContainer(.tagRelatedPosts(tag))
//        .build()?
//        .router.present(withPushfrom: _presenter._viewController, animated: true)
//    }
//  }
  
}

// MARK: - DiscoverSearchContent Viper Components
fileprivate extension DiscoverSearchContentRouter {
    var presenter: DiscoverSearchContentPresenterApi {
        return _presenter as! DiscoverSearchContentPresenterApi
    }
}
