//
//  TestTwoInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - TestTwoInteractor Class
final class TestTwoInteractor: Interactor {
}

// MARK: - TestTwoInteractor API
extension TestTwoInteractor: TestTwoInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension TestTwoInteractor {
    var presenter: TestTwoPresenterApi {
        return _presenter as! TestTwoPresenterApi
    }
}
