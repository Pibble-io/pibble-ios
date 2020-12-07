//
//  CampaignEditViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: CampaignEditView Class
final class CampaignEditViewController: ViewController {
  
  //MARK:- IBOutlets
  
  @IBOutlet weak var navigationBarBackButton: UIButton!
  @IBOutlet weak var navigationBarTitleLabel: UILabel!
  
  @IBOutlet weak var navigationBarDoneButton: UIButton!
  
  @IBOutlet weak var tableView: UITableView!
  
  //MARK:- IBAction
  
  @IBAction func doneAction(_ sender: Any) {
    presenter.handleDoneAction()
  }
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    subscribeKeyboardNotications()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeKeyboardNotications()
  }
  
  //MARK:- Properties
  
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
  fileprivate var cachedCellsSizes: [IndexPath: CGSize] = [:]
}

//MARK: - CampaignEditView API
extension CampaignEditViewController: CampaignEditViewControllerApi {
  func setNavigationBarTitle(_ title: String) {
    navigationBarTitleLabel.text = title
  }
  
  func setNextStageButtonEnabled(_ enabled: Bool, title: String) {
    navigationBarDoneButton.isEnabled = enabled
    navigationBarDoneButton.setTitleForAllStates(title)
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
  
  func reloadData() {
    tableView.reloadData()
  }
}

// MARK: - CampaignEditView Viper Components API
fileprivate extension CampaignEditViewController {
    var presenter: CampaignEditPresenterApi {
        return _presenter as! CampaignEditPresenterApi
    }
}

// MARK: - Helpers

extension CampaignEditViewController {
  fileprivate func setupView() {
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.registerCell(CampaignEditAmountInputTableViewCell.self)
    tableView.registerCell(CampaignEditTitleInputTableViewCell.self)
    tableView.registerCell(CampaignEditSelectedItemTableViewCell.self)
    tableView.registerCell(CampaignEditExpandingSectionItemTableViewCell.self)
    tableView.registerCell(CampaignEditTeamItemTableViewCell.self)
    tableView.registerCell(CampaignEditTeamNameInputTableViewCell.self)
    tableView.registerCell(CampaignEditTeamSectionHeaderTableViewCell.self)
    tableView.registerCell(CampaignEditTeamLogoPickerTableViewCell.self)
    tableView.registerCell(CampaignEditTeamSectionFooterTableViewCell.self)
    tableView.registerCell(CampaignEditSelectionItemTableViewCell.self)
    tableView.registerCell(CampaignEditHeaderItemTableViewCell.self)
    tableView.registerCell(CampaignEditRewardAmountPickTableViewCell.self)
    
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 57.0
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CampaignEditViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    view.endEditing(true)
    tableView.deselectRow(at: indexPath, animated: false)
    presenter.handleSelectionAt(indexPath)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cachedCellsSizes[indexPath] = cell.frame.size
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cachedCellsSizes[indexPath] = cell.frame.size
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    if let cached = cachedCellsSizes[indexPath]?.height {
      return cached
    }
    
    let viewModelType = presenter.itemViewModelFor(indexPath)
    switch viewModelType {
    case .amount(_):
      return UIConstants.EstimatedHeights.amount
    case .title(_):
      return UIConstants.EstimatedHeights.commonItem
    case .selectedCampaignRecipient(_):
      return UIConstants.EstimatedHeights.commonItem
    case .campaignRecipientItem(_):
      return UIConstants.EstimatedHeights.commonItem
    case .selectedCategory(_):
      return UIConstants.EstimatedHeights.commonItem
    case .categoryItem(_):
      return UIConstants.EstimatedHeights.commonItem
    case .teamType(_):
      return UIConstants.EstimatedHeights.teamItem
    case .teamNameInput(_):
       return UIConstants.EstimatedHeights.commonItem
    case .teamHeaderItem:
      return UIConstants.EstimatedHeights.teamSectionHeaderFooter
    case .teamLogoPick(_):
      return UIConstants.EstimatedHeights.teamLogoPick
    case .sectionFooterItem:
      return UIConstants.EstimatedHeights.teamSectionHeaderFooter
    case .selectionItem(_):
      return UIConstants.EstimatedHeights.rewardTypeItem
    case .sectionHeader(_):
      return UIConstants.EstimatedHeights.rewardSectionHeaderItem
    case .rewardInputPrice(_):
       return UIConstants.EstimatedHeights.rewardsInputItem
    case .rewardInputDiscountPrice(_):
       return UIConstants.EstimatedHeights.rewardsInputItem
    case .rewardInputEarlyPrice(_):
       return UIConstants.EstimatedHeights.rewardsInputItem
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let viewModelType = presenter.itemViewModelFor(indexPath)
    switch viewModelType {
    case .amount(let vm):
      let cell = tableView.dequeueReusableCell(cell: CampaignEditAmountInputTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: amountChangeActionHandler)
      return cell
    case .title(let vm):
      let cell = tableView.dequeueReusableCell(cell: CampaignEditTitleInputTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: titleChangeActionHandler)
      return cell
    case .selectedCampaignRecipient(let vm):
      let cell = tableView.dequeueReusableCell(cell: CampaignEditSelectedItemTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .campaignRecipientItem(let vm):
      let cell = tableView.dequeueReusableCell(cell: CampaignEditExpandingSectionItemTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .selectedCategory(let vm):
      let cell = tableView.dequeueReusableCell(cell: CampaignEditSelectedItemTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .categoryItem(let vm):
      let cell = tableView.dequeueReusableCell(cell: CampaignEditExpandingSectionItemTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .teamType(let vm):
      let cell = tableView.dequeueReusableCell(cell: CampaignEditTeamItemTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .teamNameInput(let vm):
      let cell = tableView.dequeueReusableCell(cell: CampaignEditTeamNameInputTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: teamNameActionHandler)
      return cell
    case .teamHeaderItem:
      let cell = tableView.dequeueReusableCell(cell: CampaignEditTeamSectionHeaderTableViewCell.self, for: indexPath)
      return cell
    case .teamLogoPick(let vm):
      let cell = tableView.dequeueReusableCell(cell: CampaignEditTeamLogoPickerTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: teamLogoActionHandler)
      return cell
    case .sectionFooterItem:
      let cell = tableView.dequeueReusableCell(cell: CampaignEditTeamSectionFooterTableViewCell.self, for: indexPath)
      return cell
    case .selectionItem(let vm):
      let cell = tableView.dequeueReusableCell(cell: CampaignEditSelectionItemTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .sectionHeader(let vm):
      let cell = tableView.dequeueReusableCell(cell: CampaignEditHeaderItemTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .rewardInputPrice(let vm):
      let cell = tableView.dequeueReusableCell(cell: CampaignEditRewardAmountPickTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.rewardAmountPickHandler($0, action: $1) }
      return cell
    case .rewardInputDiscountPrice(let vm):
      let cell = tableView.dequeueReusableCell(cell: CampaignEditRewardAmountPickTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.rewardAmountPickHandler($0, action: $1) }
      return cell
    case .rewardInputEarlyPrice(let vm):
      let cell = tableView.dequeueReusableCell(cell: CampaignEditRewardAmountPickTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.rewardAmountPickHandler($0, action: $1) }
      return cell
    }
  }
}

//MARK:- Actions handlers

extension CampaignEditViewController {
  func rewardAmountPickHandler(_ cell: UITableViewCell, action: CampaignEdit.RewardAmountInputActions) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    presenter.handleRewardInputAt(indexPath, action: action)
  }
  
  func amountChangeActionHandler(_ cell: CampaignEditAmountInputTableViewCell, action: CampaignEdit.AmountInputActions) {
    switch action {
    case .sliderValueChanged(let value):
      presenter.handleAmountUpdate(value)
    case .amountTextValueChanged(let value):
      presenter.handleAmountUpdate(value)
    case .amountTextEndEditing:
      presenter.handleAmountEndEditing()
    }
  }
  
  func titleChangeActionHandler(_ cell: CampaignEditTitleInputTableViewCell, action: CampaignEdit.TitleInputActions) {
    switch action {
    case .titleTextChanged(let value):
      presenter.handleTitleUpdate(value)
    case .endEditing:
      presenter.handleTitleEndEditing()
    }
  }
  
  func teamNameActionHandler(_ cell: CampaignEditTeamNameInputTableViewCell, action: CampaignEdit.TeamNameInputActions) {
    
    switch action {
    case .titleTextChanged(let value):
      presenter.handleTeamNameUpdate(value)
    case .endEditing:
      presenter.handleTeamNameEndEditing()
    }
  }
  
  func teamLogoActionHandler(_ cell: CampaignEditTeamLogoPickerTableViewCell, action: CampaignEdit.LogoPickActions) {
    switch action {
    case .pickLogoAction:
      presenter.handleTeamLogoPickAction()
    }
  }
}

//MARK:- KeyboardNotificationsDelegateProtocol

extension CampaignEditViewController: KeyboardNotificationsDelegateProtocol {
  func keyBoardWillShowWithBottomInsets(_ bottomInsets: CGFloat, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.tableView.contentInset.bottom = bottomInsets
    }) { (_) in  }
  }
  
  func keyBoardWillHide(animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.tableView.contentInset.bottom = 0.0
    }) { (_) in  }
  }
}

fileprivate enum UIConstants {
  enum EstimatedHeights {
    static let amount: CGFloat = 200
    static let commonItem: CGFloat = 57
    static let teamItem: CGFloat = 71
    static let teamSectionHeaderFooter: CGFloat = 51
    static let teamLogoPick: CGFloat = 200
    static let rewardSectionHeaderItem: CGFloat = 80
    static let rewardTypeItem: CGFloat = 80
    
    static let rewardsInputItem: CGFloat = 93
  }
}

