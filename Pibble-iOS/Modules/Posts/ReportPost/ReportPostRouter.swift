//
//  ReportPostRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 01/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - ReportPostRouter class
final class ReportPostRouter: Router {
}

// MARK: - ReportPostRouter API
extension ReportPostRouter: ReportPostRouterApi {
}

// MARK: - ReportPost Viper Components
fileprivate extension ReportPostRouter {
  var presenter: ReportPostPresenterApi {
    return _presenter as! ReportPostPresenterApi
  }
}
