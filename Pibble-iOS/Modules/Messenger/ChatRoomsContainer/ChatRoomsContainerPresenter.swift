//
//  ChatRoomsContainerPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/04/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - ChatRoomsContainerPresenter Class
final class ChatRoomsContainerPresenter: Presenter {
}

// MARK: - ChatRoomsContainerPresenter API
extension ChatRoomsContainerPresenter: ChatRoomsContainerPresenterApi {
  func handleSwitchTo(_ segment: ChatRoomsContainer.SelectedSegment) {
    router.routeTo(segment, insideView: viewController.submoduleContainerView)
  }
  
  func handleHideAction() {
    router.dismiss()
  }
}

// MARK: - ChatRoomsContainer Viper Components
fileprivate extension ChatRoomsContainerPresenter {
  var viewController: ChatRoomsContainerViewControllerApi {
    return _viewController as! ChatRoomsContainerViewControllerApi
  }
  var interactor: ChatRoomsContainerInteractorApi {
    return _interactor as! ChatRoomsContainerInteractorApi
  }
  var router: ChatRoomsContainerRouterApi {
    return _router as! ChatRoomsContainerRouterApi
  }
}
