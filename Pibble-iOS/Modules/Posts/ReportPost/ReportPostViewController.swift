//
//  ReportPostViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 01/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: ReportPostView Class
final class ReportPostViewController: ViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  //MARK:- properties
  
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
}

//MARK: - ReportPostView API
extension ReportPostViewController: ReportPostViewControllerApi {
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

// MARK: - ReportPostView Viper Components API
fileprivate extension ReportPostViewController {
  var presenter: ReportPostPresenterApi {
    return _presenter as! ReportPostPresenterApi
  }
}

// MARK: - Helpers

extension ReportPostViewController {
  fileprivate func setupView() {
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 70.0
  }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ReportPostViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    presenter.handleSelectItemAt(indexPath)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let viewModel = presenter.itemViewModelAt(indexPath)
    let cell = tableView.dequeueReusableCell(cell: ReportPostTableViewCell.self, for: indexPath)
    cell.setViewModel(viewModel)
    return cell
  }
}




