//
//  SearchResultTagDetailContentModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: - SearchResultTagDetailContentRouter API
protocol SearchResultTagDetailContentRouterApi: RouterProtocol {
}

//MARK: - SearchResultTagDetailContentView API
protocol SearchResultTagDetailContentViewControllerApi: ViewControllerProtocol {  
  func updateCollection(_ updates: CollectionViewModelUpdate)
  func setTagViewModel(_ vm: SearchResultTagDetailViewModelProtocol?, animated: Bool)
}

//MARK: - SearchResultTagDetailContentPresenter API
protocol SearchResultTagDetailContentPresenterApi: PresenterProtocol {
  func handleFollowAction()
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate)
  func presentTag(_ tag: TagProtocol)
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> PostsFeedTagViewModelProtocol
}

//MARK: - SearchResultTagDetailContentInteractor API
protocol SearchResultTagDetailContentInteractorApi: InteractorProtocol {
  func performFollowAction()
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemAt(_ indexPath: IndexPath) -> TagProtocol
 
  func initialFetchData()
  func initialRefresh()
}

protocol SearchResultTagDetailViewModelProtocol {
  var imageURLString: String { get }
  var imagePlaceholder: UIImage? { get }
  var title: String { get }
  var countString: String { get }
  var countTitleString: String { get }
  var isFollowed: Bool { get }
  var followStatus: String { get }
}
