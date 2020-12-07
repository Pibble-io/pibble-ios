//
//  TabBarModuleInteractor.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 15.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - TabBarModuleInteractor Class
final class TabBarInteractor: Interactor {
  fileprivate let pushNotificationsService: PushNotificationServiceProtocol
  
  init(pushNotificationsService: PushNotificationServiceProtocol) {
    self.pushNotificationsService = pushNotificationsService
  }
}

// MARK: - TabBarModuleInteractor API
extension TabBarInteractor: TabBarInteractorApi {
  func registerForPushNotifications() {
    pushNotificationsService.registerForPushNotifications()
  }
}

// MARK: - Interactor Viper Components Api
private extension TabBarInteractor {
    var presenter: TabBarPresenterApi {
        return _presenter as! TabBarPresenterApi
    }
}
