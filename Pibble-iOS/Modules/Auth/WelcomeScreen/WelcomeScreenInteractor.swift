//
//  WelcomeModuleInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - WelcomeModuleInteractor Class
final class WelcomeScreenInteractor: Interactor {
}

// MARK: - WelcomeModuleInteractor API
extension WelcomeScreenInteractor: WelcomeScreenInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension WelcomeScreenInteractor {
    var presenter: WelcomeScreenPresenterApi {
        return _presenter as! WelcomeScreenPresenterApi
    }
}
