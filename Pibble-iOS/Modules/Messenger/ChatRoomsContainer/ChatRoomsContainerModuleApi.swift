//
//  ChatRoomsContainerModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/04/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: - ChatRoomsContainerRouter API
protocol ChatRoomsContainerRouterApi: RouterProtocol {
  func routeTo(_ segment: ChatRoomsContainer.SelectedSegment, insideView: UIView)
}

//MARK: - ChatRoomsContainerView API
protocol ChatRoomsContainerViewControllerApi: ViewControllerProtocol {
   var submoduleContainerView: UIView  { get }
}

//MARK: - ChatRoomsContainerPresenter API
protocol ChatRoomsContainerPresenterApi: PresenterProtocol {
  func handleSwitchTo(_ segment: ChatRoomsContainer.SelectedSegment)
  func handleHideAction()
}

//MARK: - ChatRoomsContainerInteractor API
protocol ChatRoomsContainerInteractorApi: InteractorProtocol {
}
