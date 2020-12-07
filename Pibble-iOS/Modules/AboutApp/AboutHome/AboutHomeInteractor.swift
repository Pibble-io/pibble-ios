//
//  AboutHomeInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - AboutHomeInteractor Class
final class AboutHomeInteractor: Interactor {
  fileprivate let authService: AuthServiceProtocol
  
  init(authService: AuthServiceProtocol) {
    self.authService = authService
  }
}

// MARK: - AboutHomeInteractor API
extension AboutHomeInteractor: AboutHomeInteractorApi {
  func performLogout() {
    authService.logout()
  }
}

// MARK: - Interactor Viper Components Api
private extension AboutHomeInteractor {
    var presenter: AboutHomePresenterApi {
        return _presenter as! AboutHomePresenterApi
    }
}
