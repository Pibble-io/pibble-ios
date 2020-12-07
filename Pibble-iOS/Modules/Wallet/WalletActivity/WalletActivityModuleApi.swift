//
//  WalletActivityModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: - WalletActivityRouter API
protocol WalletActivityRouterApi: WalletPinCodeSecuredRouterProtocol {
  func routeTo(_ segment: WalletActivity.SelectedSegment, insideView: UIView)
}

//MARK: - WalletActivityView API
protocol WalletActivityViewControllerApi: ViewControllerProtocol {
  var submoduleContainerView: UIView  { get }
 
}

//MARK: - WalletActivityPresenter API
protocol WalletActivityPresenterApi: PresenterProtocol {
  func handleHideAction()
  func handleSwitchTo(_ segment: WalletActivity.SelectedSegment)

}

//MARK: - WalletActivityInteractor API
protocol WalletActivityInteractorApi: InteractorProtocol {
  
}

