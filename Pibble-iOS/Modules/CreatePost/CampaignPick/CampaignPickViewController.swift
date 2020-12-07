//
//  CampaignPickViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 29.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: CampaignPickView Class
final class CampaignPickViewController: ViewController {
  
  //MARK: IBOutlets
  
  @IBOutlet weak var hideButton: UIButton!
  
  @IBOutlet weak var doneButton: UIButton!
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var searchTextFieldBackgroundView: UIView!
  @IBOutlet weak var searchTextField: UITextField!
  
  @IBOutlet weak var cancelSearchButton: UIButton!
  
  
  //MARK: IBActions
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  @IBAction func doneAction(_ sender: Any) {
    presenter.handleDoneAction()
  }
  
  @IBAction func searchTextFieldEditingChangedAction(_ sender: UITextField) {
    presenter.handleSearchTextChange(sender.text ?? "")
  }
  
  @IBAction func cancelSearchAction(_ sender: Any) {
    presenter.handleSearchTextChange("")
//    presenter.handleSearchTextEndEditingWith("")
    searchTextField.text = ""
    view.endEditing(true)
  }
  
  //MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupAppearance()
  }
  
  //MARK:- Properties
  
  fileprivate var cachedCellsSizes: [IndexPath: CGSize] = [:]
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
}

//MARK: - CampaignPickView API
extension CampaignPickViewController: CampaignPickViewControllerApi {
  func setDoneButtonEnabled(_ enabled: Bool) {
    doneButton.isEnabled = enabled
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

// MARK: - CampaignPickView Viper Components API
fileprivate extension CampaignPickViewController {
  var presenter: CampaignPickPresenterApi {
    return _presenter as! CampaignPickPresenterApi
  }
}

//MARK:- Helpers

extension CampaignPickViewController {
  fileprivate func setupAppearance() {
    searchTextFieldBackgroundView.layer.cornerRadius = searchTextFieldBackgroundView.bounds.height * 0.5
    searchTextFieldBackgroundView.clipsToBounds = true
    searchTextFieldBackgroundView.layer.borderWidth = 1.0
    searchTextFieldBackgroundView.layer.borderColor = UIConstants.Colors.searchTextFieldBackgroundView.cgColor
  }
  
  func setupView() {
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UIConstants.itemCellsEstimatedHeight
    
    tableView.registerCell(CampaignPickItemTableViewCell.self)
  }
}

//MARK:- UITableViewDelegate, UITableViewDataSource

extension CampaignPickViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
    presenter.handleSelectActionAt(indexPath)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let vm = presenter.itemViewModelAt(indexPath)
    let cell = tableView.dequeueReusableCell(cell: CampaignPickItemTableViewCell.self, for: indexPath)
    cell.setViewModel(vm)
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
}

fileprivate enum UIConstants {
  enum Colors {
    static let searchTextFieldBackgroundView = UIColor.gray191
  }
  
  static let itemCellsEstimatedHeight: CGFloat = 125
}


