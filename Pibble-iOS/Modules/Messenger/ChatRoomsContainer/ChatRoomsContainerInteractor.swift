//
//  ChatRoomsContainerInteractor.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/04/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation 

// MARK: - ChatRoomsContainerInteractor Class
final class ChatRoomsContainerInteractor: Interactor {
}

// MARK: - ChatRoomsContainerInteractor API
extension ChatRoomsContainerInteractor: ChatRoomsContainerInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension ChatRoomsContainerInteractor {
  var presenter: ChatRoomsContainerPresenterApi {
    return _presenter as! ChatRoomsContainerPresenterApi
  }
}
