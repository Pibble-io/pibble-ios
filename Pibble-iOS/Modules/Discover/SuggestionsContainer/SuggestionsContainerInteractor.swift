//
//   SuggestionsContainerInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 22.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: -  SuggestionsContainerInteractor Class
final class  SuggestionsContainerInteractor: Interactor {
}

// MARK: -  SuggestionsContainerInteractor API
extension  SuggestionsContainerInteractor:  SuggestionsContainerInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension  SuggestionsContainerInteractor {
    var presenter:  SuggestionsContainerPresenterApi {
        return _presenter as!  SuggestionsContainerPresenterApi
    }
}
