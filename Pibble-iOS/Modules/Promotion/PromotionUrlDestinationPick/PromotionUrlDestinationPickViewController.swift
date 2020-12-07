//
//  PromotionUrlDestinationPickViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 24/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: PromotionUrlDestinationPickView Class
final class PromotionUrlDestinationPickViewController: ViewController {
  
  @IBOutlet weak var doneButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var urlTextField: UITextField!
  @IBOutlet weak var validationImageView: UIImageView!
  
  @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
  
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  @IBAction func doneAction(_ sender: Any) {
    presenter.handleDoneAction()
  }
  
  @IBAction func urlTextFieldEditionChangedAction(_ sender: UITextField) {
    presenter.handleUrlChanged(sender.text ?? "")
  }
  
  
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    subscribeKeyboardNotications()
  }
  
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeKeyboardNotications()
  }
}

//MARK: - PromotionUrlDestinationPickView API
extension PromotionUrlDestinationPickViewController: PromotionUrlDestinationPickViewControllerApi {
  func setUrlString(_ text: String) {
    urlTextField.text = text
  }
  
  func setUrlValidationImage(_ image: UIImage) {
    validationImageView.image = image
  }
  
  func setUrlValidationHidden(_ isHidden: Bool) {
    validationImageView.isHidden = isHidden
  }
  
  func reloadData() {
    tableView.reloadData()
  }
  
  func setDoneButtomEnabled(_ enabled: Bool) {
    doneButton.isEnabled = enabled
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
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

//MARK:- UITableViewDataSource, UITableViewDelegate

extension PromotionUrlDestinationPickViewController: UITableViewDataSource, UITableViewDelegate {
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
    let cell = tableView.dequeueReusableCell(cell: PromotionUrlDestinationPickButtonActionTableViewCell.self, for: indexPath)
    cell.setViewModel(viewModel)
    return cell
  }
}

//MARK:- Helpers

extension PromotionUrlDestinationPickViewController {
  fileprivate func setupView() {
    tableView.registerCell(PromotionUrlDestinationPickButtonActionTableViewCell.self)
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UIConstants.itemCellsEstimatedHeight
  }
}


// MARK: - PromotionUrlDestinationPickView Viper Components API
fileprivate extension PromotionUrlDestinationPickViewController {
  var presenter: PromotionUrlDestinationPickPresenterApi {
    return _presenter as! PromotionUrlDestinationPickPresenterApi
  }
}

fileprivate enum UIConstants {
  static let itemCellsEstimatedHeight: CGFloat = 60.0
}

//MARK:- KeyboardNotificationsDelegateProtocol

extension PromotionUrlDestinationPickViewController: KeyboardNotificationsDelegateProtocol {
  
  func keyBoardWillShowWithBottomInsets(_ bottomInsets: CGFloat, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    tableViewBottomConstraint.constant = bottomInsets
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
       self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
  
  func keyBoardWillHide(animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    tableViewBottomConstraint.constant = 0.0
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
}
