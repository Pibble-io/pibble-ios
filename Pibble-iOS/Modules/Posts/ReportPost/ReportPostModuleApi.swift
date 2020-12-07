//
//  ReportPostModuleApi.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 01/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

//MARK: - ReportPostRouter API
protocol ReportPostRouterApi: RouterProtocol {
}

//MARK: - ReportPostView API
protocol ReportPostViewControllerApi: ViewControllerProtocol {
  func updateCollection(_ updates: CollectionViewModelUpdate)
  func reloadData()
}

//MARK: - ReportPostPresenter API
protocol ReportPostPresenterApi: PresenterProtocol {
  func handleHideAction() 
  func handleSelectItemAt(_ indexPath: IndexPath)
  
  func numberOfSections() -> Int
  func numberOfItemsInSection(_ section: Int) -> Int
  func itemViewModelAt(_ indexPath: IndexPath) -> ReportPostItemViewModelProtocol
  
  func presentReasons(_ reasons: [PostReportReasonProtocol])
}

//MARK: - ReportPostInteractor API
protocol ReportPostInteractorApi: InteractorProtocol {
  func initialFetchData()
}

protocol ReportPostItemViewModelProtocol {
  var title: String { get }
}

protocol ReportPostDelegateProtocol: class {
  func didSelectReason(_ reason: PostReportReasonProtocol)
}
