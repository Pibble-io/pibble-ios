//
//  MediaPostingViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 13.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: MediaPostingView Class
final class MediaPostingViewController: ViewController {
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var postButton: UIButton!
  @IBOutlet weak var backButton: UIButton!
  
  @IBOutlet weak var navBarTitleLabel: UILabel!
  @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
  
  fileprivate var scrollToBottomDelayObject = DelayBlockObject()
  fileprivate var cachedCellsSizes: [IndexPath: CGSize] = [:]
  
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
  
  @IBAction func postAction(_ sender: Any) {
    presenter.handlePostAction()
  }
  
  @IBAction func previousStepAction(_ sender: Any) {
    presenter.handlePreviosStepAction()
  }
  
  //MARK:- Private properties
  
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
}

//MARK:- KeyboardNotificationsDelegateProtocol

extension MediaPostingViewController: KeyboardNotificationsDelegateProtocol {
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


//MARK: - MediaPostingView API
extension MediaPostingViewController: MediaPostingViewControllerApi {
  func setTitle(_ title: String) {
    navBarTitleLabel.text = title
  }
  
  func setNextStageButtonEnabled(_ enabled: Bool, title: String) {
    postButton.isEnabled = enabled
    postButton.setTitleForAllStates(title)
  }
  
  func reloadTable() {
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

// MARK: - MediaPostingView Viper Components API
fileprivate extension MediaPostingViewController {
    var presenter: MediaPostingPresenterApi {
        return _presenter as! MediaPostingPresenterApi
    }
}

//MARK:- Helpers

fileprivate extension MediaPostingViewController {
  func setupView() {
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 100.0
  }
}

//MARK:- UITableViewDataSource, UITableViewDelegate

extension MediaPostingViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    if let size = cachedCellsSizes[indexPath] {
      return size.height
    }
    
    return 100
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cachedCellsSizes[indexPath] = cell.frame.size
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cachedCellsSizes[indexPath] = cell.frame.size
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfAttachmentsInSection(section)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfAttachmentSections()
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    presenter.handleSelectionAt(indexPath)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let viewModel = presenter.attachmentViewModelAt(indexPath)
    switch viewModel {
    case .mediaItems(let mediaItemsViewModel):
      let id = PostingMediaItemsCollectionTableViewCell.identifier
      let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! PostingMediaItemsCollectionTableViewCell
      cell.setViewModel(mediaItemsViewModel, actionHandler: addItemHandler)
      return cell
    case .description(let vm):
      let id = PostingMediaDescriptionTableViewCell.identifier
      let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! PostingMediaDescriptionTableViewCell
      cell.setViewModel(vm)
      return cell
    case .location(let vm):
      let id = PostingMediaLocationTableViewCell.identifier
      let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! PostingMediaLocationTableViewCell
      cell.setViewModel(vm)
      return cell
    case .tags(let vm):
      let id = PostingMediaTagsTableViewCell.identifier
      let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! PostingMediaTagsTableViewCell
      cell.setViewModel(vm)
      return cell
    case .promotion(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostingMediaPromotionTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .createCampaign(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostingMediaCampaignTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.fundingEditActionsHandler($0, action: $1) }
      return cell
    case .pickCampaign(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostingMediaCampaignTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.fundingEditActionsHandler($0, action: $1) }
      return cell
    case .joinCampaignSectionHeader:
      let cell = tableView.dequeueReusableCell(cell: PostingMediaCampaignSectionHeaderTableViewCell.self, for: indexPath)
      return cell
    case .joinCampaignSectionFooter:
      let cell = tableView.dequeueReusableCell(cell: PostingMediaFooterItemTableViewCell.self, for: indexPath)
      return cell
    case .commerceHeaderItem:
      let cell = tableView.dequeueReusableCell(cell: PostingCommerceSectionHeaderTableViewCell.self, for: indexPath)
      return cell
    case .digitanGoodToggle(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostingCommerceDigitalGoodToggleTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: commercialEditActionsHandler)
      return cell
    case .digitalGoodLicensing(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostingCommerceDigitalGoodLicensingTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: commercialEditActionsHandler)
      return cell
    case .digitalGoodAgreement(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostingCommerceDigitalGoodTermsTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: commercialEditActionsHandler)
      return cell
    case .commerceTitle(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostingCommerceTitleInputTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: commercialEditActionsHandler)
      return cell
    case .commercePrice(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostingCommercePriceInputTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: commercialEditActionsHandler)
      return cell
    case .commerceReward(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostingCommerceRewardTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .downloadableToogle(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostingCommerceDigitalGoodDownloadableToggleTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: commercialEditActionsHandler)
      return cell
    case .goodsEscrowAgreement(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostingCommerceGoodsEscrowTermsTableVIewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: commercialEditActionsHandler)
      return cell
    case .isNewGoodToggle(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostingCommerceGoodIsNewToggleTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: commercialEditActionsHandler)
      return cell
    case .goodsUrl(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostingCommerceGoodUrlInputTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: commercialEditActionsHandler)
      return cell
    case .goodDescription(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostingMediaDescriptionPickTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: commercialEditActionsHandler)
      return cell
    case .preselectedFundingTeam(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostingMediaPreselectedFundingTeamTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    }
  }
}

extension MediaPostingViewController {
  fileprivate func fundingEditActionsHandler(_ cell: UITableViewCell, action: MediaPosting.FundingEditActions) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    presenter.handleFundingEditActionAt(indexPath, action: action)
  }
  
  fileprivate func commercialEditActionsHandler(_ cell: UITableViewCell, action: MediaPosting.CommerceEditActions) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    scrollToBottomDelayObject.cancel()
    scrollToBottomDelayObject.scheduleAfter(delay: 0.3) { [weak self] in
      self?.tableView.scrollToRowIfExists(at: indexPath, at: .bottom, animated: true)
    }
      
    presenter.handleCommercialEditAction(action)
  }
  
  fileprivate func addItemHandler(_ cell: PostingMediaItemsCollectionTableViewCell) {
    presenter.handleAddItemAction()
  }
}
