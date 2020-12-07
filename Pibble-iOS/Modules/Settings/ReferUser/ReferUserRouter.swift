//
//  ReferUserRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 17/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

// MARK: - ReferUserRouter class
final class ReferUserRouter: Router {
}

// MARK: - ReferUserRouter API
extension ReferUserRouter: ReferUserRouterApi {
  func routeToShareControl(_ text: String) {
    let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
    
    presenter._viewController.present(vc, animated: true, completion: nil)
  }
}

// MARK: - ReferUser Viper Components
fileprivate extension ReferUserRouter {
  var presenter: ReferUserPresenterApi {
    return _presenter as! ReferUserPresenterApi
  }
}
