//
//  ExternalLinkInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 20/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - ExternalLinkInteractor Class
final class ExternalLinkInteractor: Interactor {
}

// MARK: - ExternalLinkInteractor API
extension ExternalLinkInteractor: ExternalLinkInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension ExternalLinkInteractor {
  var presenter: ExternalLinkPresenterApi {
    return _presenter as! ExternalLinkPresenterApi
  }
}
