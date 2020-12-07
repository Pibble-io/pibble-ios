//
//  TestOneInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - TestOneInteractor Class
final class TestOneInteractor: Interactor {
}

// MARK: - TestOneInteractor API
extension TestOneInteractor: TestOneInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension TestOneInteractor {
    var presenter: TestOnePresenterApi {
        return _presenter as! TestOnePresenterApi
    }
}
