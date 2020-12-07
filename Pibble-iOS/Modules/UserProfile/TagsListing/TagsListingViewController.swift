//
//  TagsListingViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 14/03/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: TagsListingView Class
final class TagsListingViewController: ViewController {
  //MARK:- IBOutlets
  
  @IBOutlet weak var hideButton: UIButton!
  
  @IBOutlet weak var navBarTitleLabel: UILabel!
  
  @IBOutlet weak var tableView: UITableView!
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  //MARK:- Overrrides
  
  override var shouldHandleSwipeToPopGesture: Bool {
    return true
  }
  
  //MARK:- IBActions
  
  @IBAction func hideButtonAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  //MARK:- Properties
  
  fileprivate var cachedCellsSizes: [IndexPath: CGSize] = [:]
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
}

//MARK: - TagsListingView API
extension TagsListingViewController: TagsListingViewControllerApi {
  func setNavigationBarTitle(_ title: String) {
    navBarTitleLabel.text = title
  }
  
  func updateCollection(_ updates: CollectionViewModelUpdate) {
    if case CollectionViewModelUpdate.reloadData = updates {
      batchUpdates = []
      tableView.reloadData()
      return
    }
    
    guard case CollectionViewModelUpdate.endUpdates = updates else {
      batchUpdates.append(updates)
      return
    }
    
    tableView.beginUpdates()
    batchUpdates.forEach {
      switch $0 {
      case .reloadData:
        break
      case .beginUpdates:
        break
      case .endUpdates:
        break
      case .insert(let idx):
        tableView.insertRows(at: idx, with: .fade)
      case .delete(let idx):
        tableView.deleteRows(at: idx, with: .fade)
      case .insertSections(let idx):
        tableView.insertSections(IndexSet(idx), with: .fade)
      case .deleteSections(let idx):
        tableView.deleteSections(IndexSet(idx), with: .fade)
      case .updateSections(let idx):
        tableView.reloadSections(IndexSet(idx), with: .fade)
      case .moveSections(let from, let to):
        tableView.moveSection(from, toSection: to)
      case .update(let idx):
        tableView.reloadRows(at: idx, with: .fade)
      case .move(let from, let to):
        tableView.moveRow(at: from, to: to)
      }
    }
    
    tableView.endUpdates()
    batchUpdates = []
  }
}

// MARK: - TagsListingView Viper Components API
fileprivate extension TagsListingViewController {
  var presenter: TagsListingPresenterApi {
    return _presenter as! TagsListingPresenterApi
  }
}


//MARK:- Helpers

extension TagsListingViewController {
  fileprivate func setupView() {
    tableView.registerCell(TagsListingItemTableViewCell.self)
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.shouldFireContentOffsetChangesNotifications = true
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UIConstants.itemCellsEstimatedHeight
    
    tableView.contentInset.bottom = UIConstants.bottomContentOffset
  }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension TagsListingViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let viewModel = presenter.itemViewModelAt(indexPath)
    let cell = tableView.dequeueReusableCell(cell: TagsListingItemTableViewCell.self, for: indexPath)
    cell.setViewModel(viewModel, handler: itemsActionsHandler)
    return cell
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cachedCellsSizes[indexPath] = cell.frame.size
    presenter.handleWillDisplayItem(indexPath)
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cachedCellsSizes[indexPath] = cell.frame.size
    presenter.handleDidEndDisplayItem(indexPath)
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return cachedCellsSizes[indexPath]?.height ?? UIConstants.itemCellsEstimatedHeight
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    presenter.handleSelectActionAt(indexPath)
  }
}

extension TagsListingViewController {
  func itemsActionsHandler(_ cell: TagsListingItemTableViewCell, action: TagsListing.ItemActions) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    switch action {
    case .following:
      presenter.handleFollowingActionAt(indexPath)
    }
  }
}

fileprivate enum UIConstants {
  static let bottomContentOffset: CGFloat = 60
  static let itemCellsEstimatedHeight: CGFloat = 60
}

