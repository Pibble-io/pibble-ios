//
//  ResetPasswordSuccessModuleInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 27.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - ResetPasswordSuccessModuleInteractor Class
final class ResetPasswordSuccessInteractor: Interactor {
}

// MARK: - ResetPasswordSuccessModuleInteractor API
extension ResetPasswordSuccessInteractor: ResetPasswordSuccessInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension ResetPasswordSuccessInteractor {
    var presenter: ResetPasswordSuccessPresenterApi {
        return _presenter as! ResetPasswordSuccessPresenterApi
    }
}
