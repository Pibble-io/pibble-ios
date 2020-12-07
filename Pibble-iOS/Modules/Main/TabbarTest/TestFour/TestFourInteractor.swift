//
//  TestFourInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - TestFourInteractor Class
final class TestFourInteractor: Interactor {
}

// MARK: - TestFourInteractor API
extension TestFourInteractor: TestFourInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension TestFourInteractor {
    var presenter: TestFourPresenterApi {
        return _presenter as! TestFourPresenterApi
    }
}
