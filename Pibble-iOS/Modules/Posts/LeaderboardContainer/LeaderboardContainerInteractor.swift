//
//  LeaderboardContainerInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 19/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - LeaderboardContainerInteractor Class
final class LeaderboardContainerInteractor: Interactor {
}

// MARK: - LeaderboardContainerInteractor API
extension LeaderboardContainerInteractor: LeaderboardContainerInteractorApi {
  var helpUrl: URL {
    return PibbleAppEndpoints.leaderboardHelpUrl
  }
  
}

// MARK: - Interactor Viper Components Api
private extension LeaderboardContainerInteractor {
  var presenter: LeaderboardContainerPresenterApi {
    return _presenter as! LeaderboardContainerPresenterApi
  }
}
