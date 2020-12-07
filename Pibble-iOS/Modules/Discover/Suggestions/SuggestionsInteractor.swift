//
//  SuggestionsInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 22.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - SuggestionsInteractor Class
final class SuggestionsInteractor: Interactor {
}

// MARK: - SuggestionsInteractor API
extension SuggestionsInteractor: SuggestionsInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension SuggestionsInteractor {
    var presenter: SuggestionsPresenterApi {
        return _presenter as! SuggestionsPresenterApi
    }
}
