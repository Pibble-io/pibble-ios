//
//  AboutHomeViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: AboutHomeView Class
final class AboutHomeViewController: ViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var gradientView: GradientView!
  
  @IBOutlet weak var blurView: UIVisualEffectView!
  @IBAction func hideAction(_ sender: Any) {
     presenter.handleHideAction()
  }
  
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAppearance()
    setupView()
  }
}

//MARK: - AboutHomeView API
extension AboutHomeViewController: AboutHomeViewControllerApi {
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
        tableView.insertRows(at: idx, with: .automatic)
      case .delete(let idx):
        tableView.deleteRows(at: idx, with: .automatic)
      case .insertSections(let idx):
        tableView.insertSections(IndexSet(idx), with: .automatic)
      case .deleteSections(let idx):
        tableView.deleteSections(IndexSet(idx), with: .automatic)
      case .updateSections(let idx):
        tableView.reloadSections(IndexSet(idx), with: .automatic)
      case .moveSections(let from, let to):
        tableView.moveSection(from, toSection: to)
      case .update(let idx):
        tableView.reloadRows(at: idx, with: .automatic)
      case .move(let from, let to):
        tableView.moveRow(at: from, to: to)
      }
    }
    
    tableView.endUpdates()
    batchUpdates = []
  }
}

// MARK: - AboutHomeView Viper Components API
fileprivate extension AboutHomeViewController {
    var presenter: AboutHomePresenterApi {
        return _presenter as! AboutHomePresenterApi
    }
}

//MARK:- Helpers
extension AboutHomeViewController {
  fileprivate func setupView() {
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.rowHeight = UIConstants.tableViewHeight
  }
  
  fileprivate func setupAppearance() {
    gradientView.addBackgroundGradientWith(UIConstants.Colors.background, direction: .vertical)
    tableView.contentInset.top = floor(tableView.frame.height * 0.15)
  }
}

fileprivate enum UIConstants {
  static let tableViewHeight: CGFloat = 55.0
  
  enum Colors {
    static let background = UIColor.darkGrayGradient
  }
}

extension AboutHomeViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter.handleSelectionAt(indexPath)
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(cell: AboutHomeTableViewCell.self, for: indexPath)
    let vm = presenter.itemViewModelAt(indexPath)
    cell.setViewModel(vm, handler: selectionHandler)
    return cell
  }
}

extension AboutHomeViewController {
  func selectionHandler(cell: AboutHomeTableViewCell) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    presenter.handleSelectionAt(indexPath)
  }
}

