//
//  AboutHomeModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: - AboutHomeRouter API
protocol AboutHomeRouterApi: RouterProtocol {
  func routeToLogin()
}

//MARK: - AboutHomeView API
protocol AboutHomeViewControllerApi: ViewControllerProtocol {
  func updateCollection(_ updates: CollectionViewModelUpdate)
  
}

//MARK: - AboutHomePresenter API
protocol AboutHomePresenterApi: PresenterProtocol {
  func handleHideAction()
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> AboutHomeItemViewModelProtocol
  func handleSelectionAt(_ indexPath: IndexPath) 
}

//MARK: - AboutHomeInteractor API
protocol AboutHomeInteractorApi: InteractorProtocol {
  func performLogout()
}

protocol AboutHomeItemViewModelProtocol {
  var image: UIImage { get }
  var title: String { get }
  var isActive: Bool { get }
}
