//
//  MediaSourceInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 09.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - MediaSourceInteractor Class
final class MediaSourceInteractor: Interactor {

}

// MARK: - MediaSourceInteractor API
extension MediaSourceInteractor: MediaSourceInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension MediaSourceInteractor {
    var presenter: MediaSourcePresenterApi {
        return _presenter as! MediaSourcePresenterApi
    }
}
