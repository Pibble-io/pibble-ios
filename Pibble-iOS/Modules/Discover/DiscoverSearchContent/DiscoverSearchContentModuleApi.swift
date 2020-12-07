//
//  DiscoverSearchContentModuleApi.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//
import UIKit


//MARK: - DiscoverSearchContentRouter API
protocol DiscoverSearchContentRouterApi: RouterProtocol {
  func routeToDetailFor(_ user: UserProtocol)
  func routeToDetailFor(_ place: LocationProtocol)
  func routeToDetailFor(_ tag: TagProtocol)
}

//MARK: - DiscoverSearchContentView API
protocol DiscoverSearchContentViewControllerApi: ViewControllerProtocol {
  func updateCollection(_ updates: CollectionViewModelUpdate)
  func reloadData()
}

//MARK: - DiscoverSearchContentPresenter API
protocol DiscoverSearchContentPresenterApi: PresenterProtocol {
  func handleSelectionAt(_ indexPath: IndexPath)
  
  func handleCopySearchStringAt(_ indexPath: IndexPath)
  
  func presentCollectionUpdates(_ updates: CollectionViewModelUpdate)
  func presentReload()
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> DiscoverSearchContentResultViewModelProtocol
  
 
}

//MARK: - DiscoverSearchContentInteractor API
protocol DiscoverSearchContentInteractorApi: InteractorProtocol {
  var isCopySearchStringAvailable: Bool { get }
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemAt(_ indexPath: IndexPath) -> SearchResultEntity
  
  func saveToSearchHistoryItemAt(_ indexPath: IndexPath)
  
  func prepareItemFor(_ indexPath: Int)
  func cancelPrepareItemFor(_ indexPath: Int)
  func initialFetchData()
  func initialRefresh()
  
  func performSearch(_ text: String)
}

protocol DiscoverSearchContentResultViewModelProtocol {
  var resultImage: String { get }
  var resultImagePlaceholder: UIImage? { get }
  
  var resultTypeImage: UIImage? { get }
  
  var resultTitle: String { get }
  var resultSubtitle: String { get }
  
  var isCopySearchStringAvailable: Bool { get }
}

protocol DiscoverSearchContentDelegate: class {
  func searchWithCopyPastedSearchString(_ text: String)
}
