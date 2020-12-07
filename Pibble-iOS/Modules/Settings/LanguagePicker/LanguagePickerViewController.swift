//
//  LanguagePickerViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 15/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: LanguagePickerView Class
final class LanguagePickerViewController: ViewController {
  
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

//MARK: - LanguagePickerView API
extension LanguagePickerViewController: LanguagePickerViewControllerApi {
  func showLanguagePickConfirmationAlert() {
    let alertController = UIAlertController(title: LanguagePicker.Strings.Alert.confirmationTitle.localize(),
                                            message: LanguagePicker.Strings.Alert.confirmationMessage.localize(),
                                            safelyPreferredStyle: .alert)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    let okAction = UIAlertAction(title: LanguagePicker.Strings.Alert.confirmationAction.localize(),
                                 style: .default) { [weak self] (action) in
      self?.presenter.confirmLanguagePick()
    }
    
    let cancelAction = UIAlertAction(title: LanguagePicker.Strings.Alert.cancelAction.localize(),
                                     style: .cancel) {(action) in
      
    }
    
    alertController.addAction(okAction)
    alertController.addAction(cancelAction)
    
    
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
  
  func reloadData() {
    tableView.reloadData()
  }
  
}

// MARK: - LanguagePickerView Viper Components API
fileprivate extension LanguagePickerViewController {
  var presenter: LanguagePickerPresenterApi {
    return _presenter as! LanguagePickerPresenterApi
  }
}


//MARK:- UITableViewDataSource, UITableViewDelegate

extension LanguagePickerViewController: UITableViewDataSource, UITableViewDelegate {
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
    let cell = tableView.dequeueReusableCell(cell: LanguagePickerTableViewCell.self, for: indexPath)
    cell.setViewModel(viewModel)
    return cell
  }
}

//MARK:- Helpers

extension LanguagePickerViewController {
  fileprivate func setupView() {
    tableView.registerCell(LanguagePickerTableViewCell.self)
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UIConstants.itemCellsEstimatedHeight
  }
}

fileprivate enum UIConstants {
  static let itemCellsEstimatedHeight: CGFloat = 60.0
}
