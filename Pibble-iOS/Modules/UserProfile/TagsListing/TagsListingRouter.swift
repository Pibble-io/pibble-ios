//
//  TagsListingRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 14/03/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - TagsListingRouter class
final class TagsListingRouter: Router {
  
}

// MARK: - TagsListingRouter API
extension TagsListingRouter: TagsListingRouterApi {
  func routeToUserProfileFor(_ tag: TagProtocol) {
    let module = AppModules
      .Discover
      .searchResultDetailContainer(.relatedPostsForTag(tag))
      .build()
    
    module?.router.present(withPushfrom: presenter._viewController)
  }
}

// MARK: - TagsListing Viper Components
fileprivate extension TagsListingRouter {
  var presenter: TagsListingPresenterApi {
    return _presenter as! TagsListingPresenterApi
  }
}
