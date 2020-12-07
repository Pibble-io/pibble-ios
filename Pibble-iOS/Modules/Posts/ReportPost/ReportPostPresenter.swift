//
//  ReportPostPresenter.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 01/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

// MARK: - ReportPostPresenter Class
final class ReportPostPresenter: Presenter {
  fileprivate weak var delegate: ReportPostDelegateProtocol?
  
//  fileprivate let sections: [[ReportPostReason]] = [
//    ReportPostReason.inappropriateReasons
//  ]
  
  fileprivate var sections: [[PostReportReasonProtocol]] = [[]] {
    didSet {
      viewController.updateCollection(.beginUpdates)
      let sectionsNumbers = sections
        .enumerated()
        .map { $0.offset }
      
      viewController.updateCollection(.updateSections(idx: sectionsNumbers))
      viewController.updateCollection(.endUpdates)
    }
  }
  
  init(delegate: ReportPostDelegateProtocol) {
    super.init()
    self.delegate = delegate
  }
  
  override func viewWillAppear() {
    super.viewWillAppear()
    interactor.initialFetchData()
  }
}

// MARK: - ReportPostPresenter API
extension ReportPostPresenter: ReportPostPresenterApi {
  func presentReasons(_ reasons: [PostReportReasonProtocol]) {
    sections = [reasons]
  }
  
  func handleHideAction() {
    router.dismiss()
  }
  func numberOfSections() -> Int {
    return sections.count
  }
  
  func numberOfItemsInSection(_ section: Int) -> Int {
    return sections[section].count
  }
  
  func itemViewModelAt(_ indexPath: IndexPath) -> ReportPostItemViewModelProtocol {
    let viewModel = ReportPost.ItemViewModel(reason: itemAt(indexPath))
    return viewModel
  }
  
  fileprivate func itemAt(_ indexPath: IndexPath) -> PostReportReasonProtocol {
    return sections[indexPath.section][indexPath.item]
  }
  
  func handleSelectItemAt(_ indexPath: IndexPath) {
    let item = itemAt(indexPath)
    delegate?.didSelectReason(item)
    router.dismiss()
  }
}

// MARK: - ReportPost Viper Components
fileprivate extension ReportPostPresenter {
  var viewController: ReportPostViewControllerApi {
    return _viewController as! ReportPostViewControllerApi
  }
  var interactor: ReportPostInteractorApi {
    return _interactor as! ReportPostInteractorApi
  }
  var router: ReportPostRouterApi {
    return _router as! ReportPostRouterApi
  }
}


