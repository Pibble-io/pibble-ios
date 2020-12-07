//
//  TestThreeInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - TestThreeInteractor Class
final class TestThreeInteractor: Interactor {
}

// MARK: - TestThreeInteractor API
extension TestThreeInteractor: TestThreeInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension TestThreeInteractor {
    var presenter: TestThreePresenterApi {
        return _presenter as! TestThreePresenterApi
    }
}
