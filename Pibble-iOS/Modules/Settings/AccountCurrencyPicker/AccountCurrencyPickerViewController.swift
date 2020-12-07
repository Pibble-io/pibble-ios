//
//  AccountCurrencyPickerViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: AccountCurrencyPickerView Class
final class AccountCurrencyPickerViewController: ViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
}

//MARK: - AccountCurrencyPickerView API
extension AccountCurrencyPickerViewController: AccountCurrencyPickerViewControllerApi {
  func reloadData() {
    tableView.reloadData()
  }
  
}

// MARK: - AccountCurrencyPickerView Viper Components API
fileprivate extension AccountCurrencyPickerViewController {
  var presenter: AccountCurrencyPickerPresenterApi {
    return _presenter as! AccountCurrencyPickerPresenterApi
  }
}


//MARK:- UITableViewDataSource, UITableViewDelegate

extension AccountCurrencyPickerViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    presenter.handleSelectionAt(indexPath)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let viewModel = presenter.itemViewModelAt(indexPath)
    let cell = tableView.dequeueReusableCell(cell: AccountCurrencyPickerTableViewCell.self, for: indexPath)
    cell.setViewModel(viewModel)
    return cell
  }
}

//MARK:- Helpers

extension AccountCurrencyPickerViewController {
  fileprivate func setupView() {
    tableView.registerCell(AccountCurrencyPickerTableViewCell.self)
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UIConstants.itemCellsEstimatedHeight
  }
}

fileprivate enum UIConstants {
  static let itemCellsEstimatedHeight: CGFloat = 60.0
}
