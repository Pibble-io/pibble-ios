//
//  MediaAlbumPickRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 12.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - MediaAlbumPickRouter class
final class MediaAlbumPickRouter: Router {
}

// MARK: - MediaAlbumPickRouter API
extension MediaAlbumPickRouter: MediaAlbumPickRouterApi {
}

// MARK: - MediaAlbumPick Viper Components
fileprivate extension MediaAlbumPickRouter {
    var presenter: MediaAlbumPickPresenterApi {
        return _presenter as! MediaAlbumPickPresenterApi
    }
}
