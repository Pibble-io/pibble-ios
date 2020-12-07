//
//  UserDescriptionPickerRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - UserDescriptionPickerRouter class
final class UserDescriptionPickerRouter: Router {
}

// MARK: - UserDescriptionPickerRouter API
extension UserDescriptionPickerRouter: UserDescriptionPickerRouterApi {
}

// MARK: - UserDescriptionPicker Viper Components
fileprivate extension UserDescriptionPickerRouter {
    var presenter: UserDescriptionPickerPresenterApi {
        return _presenter as! UserDescriptionPickerPresenterApi
    }
}
