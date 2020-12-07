//
//  LocationPickRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 23.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - LocationPickRouter class
final class LocationPickRouter: Router {
}

// MARK: - LocationPickRouter API
extension LocationPickRouter: LocationPickRouterApi {
}

// MARK: - LocationPick Viper Components
fileprivate extension LocationPickRouter {
    var presenter: LocationPickPresenterApi {
        return _presenter as! LocationPickPresenterApi
    }
}
