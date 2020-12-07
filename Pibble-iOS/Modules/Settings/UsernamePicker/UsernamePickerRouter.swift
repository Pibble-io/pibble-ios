//
//  UsernamePickerRouter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 21/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - UsernamePickerRouter class
final class UsernamePickerRouter: Router {
}

// MARK: - UsernamePickerRouter API
extension UsernamePickerRouter: UsernamePickerRouterApi {
}

// MARK: - UsernamePicker Viper Components
fileprivate extension UsernamePickerRouter {
  var presenter: UsernamePickerPresenterApi {
    return _presenter as! UsernamePickerPresenterApi
  }
}
