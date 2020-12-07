//
//  TagPickModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 20.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

//MARK: - TagPickRouter API

protocol TagPickRouterApi: RouterProtocol {
}

//MARK: - TagPickView API
protocol TagPickViewControllerApi: ViewControllerProtocol {
  func reloadTagsCollection()
  func setCurrentTagString(_ string: String)
}

//MARK: - TagPickPresenter API
protocol TagPickPresenterApi: PresenterProtocol {
  func handleInputTextChange(_ text: String)
  func handleHideAction()
  func handleDoneAction()
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelFor(_ indexPath: IndexPath) -> TagViewModelProtocol
  func handleSelectionAt(_ indexPath: IndexPath)
  
  func presentTagsCollection()
  func presentCurrentTagsString(_ string: String)
}

//MARK: - TagPickInteractor API
protocol TagPickInteractorApi: InteractorProtocol {
  var separatedTags: [String] { get }
  
  func setInitialTags(_ tags: [String])
  func searchTagsFor(_ text: String)
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelFor(_ indexPath: IndexPath) -> TagProtocol
  func selectItemAt(_ indexPath: IndexPath)
}

protocol TagPickDelegateProtocol: class {
  func didSelectTags(_ tags: TagPick.PickedTags)
  func selectedTags() -> TagPick.PickedTags
}

protocol TagViewModelProtocol {
  var title: String { get }
  var presentationStyle: TagPick.ItemPresentationStyle { get }
}
