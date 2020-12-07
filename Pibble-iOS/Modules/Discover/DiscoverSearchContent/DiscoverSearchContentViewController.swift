//
//  DiscoverSearchContentViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: DiscoverSearchContentView Class
final class DiscoverSearchContentViewController: ViewController {
   //MARK:- IBOutlet
  
  @IBOutlet weak var tableView: UITableView!
  
  //MARK:- Properties
  
  fileprivate var cachedCellsSizes: [IndexPath: CGSize] = [:]
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tableView.shouldFireContentOffsetChangesNotifications = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    tableView.shouldFireContentOffsetChangesNotifications = false
  }
}

//MARK: - DiscoverSearchContentView API
extension DiscoverSearchContentViewController: DiscoverSearchContentViewControllerApi {
  func reloadData() {
    tableView.reloadData()
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

// MARK: - DiscoverSearchContentView Viper Components API
fileprivate extension DiscoverSearchContentViewController {
    var presenter: DiscoverSearchContentPresenterApi {
        return _presenter as! DiscoverSearchContentPresenterApi
    }
}


//MARK:- Helpers

extension DiscoverSearchContentViewController {
  func setupView() {
    tableView.registerCell(DiscoverSearchContentResultTableViewCell.self)
    
    tableView.delegate = self
    tableView.dataSource = self
  
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UIConstants.itemCellsEstimatedHeight
    
    tableView.contentInset.bottom = UIConstants.bottomContentOffset
  }
}


//MARK:- UITableViewDelegate, UITableViewDataSource

extension DiscoverSearchContentViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    presenter.handleSelectionAt(indexPath)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let vm = presenter.itemViewModelAt(indexPath)
    let cell = tableView.dequeueReusableCell(cell: DiscoverSearchContentResultTableViewCell.self, for: indexPath)
    cell.setViewModel(vm, handler: copySearchStringActionHandler)
    return cell
  }
}

//MARK:- Handlers

extension DiscoverSearchContentViewController {
  func copySearchStringActionHandler(_ cell: DiscoverSearchContentResultTableViewCell) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    presenter.handleCopySearchStringAt(indexPath)
  }
}

fileprivate enum UIConstants {
  static let bottomContentOffset: CGFloat = 60
  static let itemCellsEstimatedHeight: CGFloat = 60
}

