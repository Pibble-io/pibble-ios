//
//  ChatViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/02/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: ChatView Class
final class ChatViewController: ViewController {
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var sendButton: UIButton!
  
  @IBOutlet weak var additionalActionButton: UIButton!
  
  
  @IBOutlet weak var draftMessageTextView: UITextView!
  @IBOutlet weak var draftMessageBackgroundView: UIView!
  
  @IBOutlet weak var draftMessagePlaceHolder: UILabel!
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var subtitleLabel: UILabel!
 
  //MARK:- IBActions
  @IBAction func additionalAction(_ sender: Any) {
    presenter.handleAdditionalAction()
  }
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  @IBAction func sendAction(_ sender: UIButton) {
    sender.isEnabled = false
    presenter.handleSendMessageAction(draftMessageTextView.text)
  }
  
  //MARK:- IBOutlet Constraints
  
  @IBOutlet weak var draftMessageViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
  
  //MARK:- private properties
  
  fileprivate var collectionUpdateOperations: [BlockOperation] = []
  fileprivate var shouldAnimateCollectionUpdate: Bool = true
  fileprivate var cachedCellsSizes: [IndexPath: CGSize] = [:]
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
  
  fileprivate var tableViewContentSizeObserver: NSKeyValueObservation?
  
  deinit {
    tableViewContentSizeObserver = nil
  }
  
  fileprivate weak var downloadingStatusAlert: UIAlertController?
  fileprivate weak var progressView: UIProgressView?
  fileprivate weak var progressBarTimer: Timer? {
    didSet {
      oldValue?.invalidate()
    }
  }
  
  //MARK:- Overrides
  
  override var shouldHandleSwipeToPopGesture: Bool {
    return true
  }
  
  //MARK:- Lyfecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupLayout()
    setupAppearance()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tableView.shouldFireContentOffsetChangesNotifications = true
    subscribeKeyboardNotications()
    draftMessageTextView.becomeFirstResponder()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    tableView.shouldFireContentOffsetChangesNotifications = false
    unsubscribeKeyboardNotications()
  }
}

//MARK: - ChatView API
extension ChatViewController: ChatViewControllerApi {
  func showGoodsBuyerAdditionalActionSheet() {
    let confirmPurchase = UIAlertAction(title: Chat.Strings.Alerts.confirmGoodsItemAction.localize(), style: .default) { [weak self] (action) in
      
      let ok = UIAlertAction(title: Chat.Strings.Alerts.okAction.localize(), style: .default) { [weak self] (action) in
        self?.presenter.handleConfirmGoodsAction()
      }
      
      let cancel = UIAlertAction(title: Chat.Strings.Alerts.cancelAction.localize(), style: .cancel) { (_) in  }
      
      self?.showAlertWith(nil, message: Chat.Strings.Alerts.confirmGoodsItemMessage.localize(), actions: [ok, cancel], preferredStyle: .alert)
    }
    
    let returnPurchase = UIAlertAction(title: Chat.Strings.Alerts.returnGoodsItemAction.localize(), style: .destructive) { [weak self] (action) in
      
      let ok = UIAlertAction(title: Chat.Strings.Alerts.okAction.localize(), style: .default) { [weak self] (action) in
        self?.presenter.handleReturnGoodsRequestAction()
      }
      
      let cancel = UIAlertAction(title: Chat.Strings.Alerts.cancelAction.localize(), style: .cancel) { (_) in  }
      
      self?.showAlertWith(nil, message: Chat.Strings.Alerts.returnRequestGoodsItemMessage.localize(), actions: [ok, cancel], preferredStyle: .alert)
    }
    
    let cancel = UIAlertAction(title: Chat.Strings.Alerts.cancelAction.localize(), style: .cancel) { (action) in
      
    }
    
    showAlertWith(nil, message: nil, actions: [confirmPurchase, returnPurchase, cancel], preferredStyle: .actionSheet)
  }
  
  func showGoodsSellerAdditionalActionSheet() {
    let approveReturn = UIAlertAction(title: Chat.Strings.Alerts.approveReturnGoodsItemAction.localize(), style: .default) { [weak self] (action) in
      
      let ok = UIAlertAction(title: Chat.Strings.Alerts.okAction.localize(), style: .default) { [weak self] (action) in
        self?.presenter.handleReturnGoodsApprovalAction()
      }
      
      let cancel = UIAlertAction(title: Chat.Strings.Alerts.cancelAction.localize(), style: .cancel) { (_) in  }
      
      self?.showAlertWith(nil, message: Chat.Strings.Alerts.returnGoodsItemMessage.localize(), actions: [ok, cancel], preferredStyle: .alert)
    }
    
    let cancel = UIAlertAction(title: Chat.Strings.Alerts.cancelAction.localize(), style: .cancel) { [weak self] (action) in
      
    }
    
    showAlertWith(nil, message: nil, actions: [approveReturn, cancel], preferredStyle: .actionSheet)
  }
  
  func setAdditionalButtonEnabled(_ enabled: Bool) {
    additionalActionButton.isEnabled = enabled
  }
  
  func setNavigationBarViewModel(_ vm: ChatNavigationBarViewModelProtocol) {
    titleLabel.text = vm.title
    subtitleLabel.text = vm.subtitle
  }
  
  func presentPurchaseFinishSuccessAlert() {
    showInvoicePaymentSuccessAlert()
  }
  
  func showConfirmInvoiceAlert(_ title: String) {
    showConfirmInvoiceAlertWithMessage(title)
  }
  
  func showConfirmOrderAlert(_ title: String) {
    showConfirmOrderAlertWithMessage(title)
  }
  
  func setHeaderViewModel(_ vm: ChatDigitalGoodPostHeaderViewModelProtocol?) {
    guard let viewModel = vm else {
      tableView.tableFooterView = nil
      return
    }
    
    guard let header = tableView.tableFooterView as? ChatDigitalGoodPostHeaderView else {
      let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50)
      let headerView = ChatDigitalGoodPostHeaderView(frame: frame)
      headerView.setViewModel(viewModel, handler: headerActionHandler)
      headerView.flipUpsideDown()
      
      tableView.setAndLayoutTableFooterView(footer: headerView)
      return
    }
   
    header.setViewModel(viewModel, handler: headerActionHandler)
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.tableView.setAndLayoutTableFooterView(footer: header)
    }
  }
  
  func setTitle(_ title: String) {
    titleLabel.text = title
  }
  
  func presentDownloadingStatusAlert() {
    
    let alert = UIAlertController(title: Chat.Strings.Alerts.downloading.localize(), message: "", safelyPreferredStyle: .alert)
    alert.view.tintColor = UIColor.bluePibble
    
    let progressBar = UIProgressView(progressViewStyle: .default)
    progressBar.setProgress(0.0, animated: false)
    progressBar.frame = CGRect(x: 0, y: 62, width: 270, height: 0)
    
    progressBar.trackTintColor = UIColor.lightGray
    progressBar.progressTintColor = UIColor.bluePibble
    alert.view.addSubview(progressBar)
    
    let cancel = UIAlertAction(title: Chat.Strings.Alerts.cancelAction.localize(), style: .cancel) { [weak self] (action) in
      self?.presenter.handleCancelDownloadAction()
    }
    
    alert.addAction(cancel)
    
    progressView = progressBar
    
    progressBarTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { (_) in
      var progress = progressBar.progress
      progress += 0.005
      let maxProgressRandomDelta = Float.random(in: 0 ..< 0.25)
      progress = max(progressBar.progress, min(0.5 + maxProgressRandomDelta, progress))
      progressBar.setProgress(progress, animated: true)
    })
 
    downloadingStatusAlert = alert
    present(alert, animated: true, completion: nil)
    alert.view.tintColor = UIColor.bluePibble
  }
  
  func hideDownloadingStatusAlert(_ complete: @escaping (() -> Void)) {
    progressBarTimer = nil
    progressView?.setProgress(1.0, animated: true)
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
      self?.downloadingStatusAlert?.dismiss(animated: true, completion: complete)
    }
  }
  
  func showBuyItemActionSheet() {
     showBuyCurrentItemActionSheet()
  }
  
  func reloadData() {
    guard tableView.visibleCells.count == 0 else {
      tableView.reloadData()
      return
    }
    
    tableView.alpha = 0.0
    tableView.reloadData()
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.tableView.alpha = 1.0
    }
  }
  
  func scrollToBottom(animated: Bool) {
    let indexPath = IndexPath(item: 0, section: 0)
    guard let _ = tableView.cellForRow(at: indexPath) else {
      return
    }
    tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
  }
  
  
  
//  func showDeleteAlert() {
//    let alertController = UIAlertController(title: nil, message: Chat.Strings.deleteCommentMessage, safelyPreferredStyle: .alert)
//
//    alertController.view.tintColor = UIColor.bluePibble
//
//    let delete = UIAlertAction(title: Chat.Strings.deleteCommentAction, style: .default) { [weak self] (action) in
//      self?.presenter.handleDeleteCurrentItemAction()
//    }
//
//    let cancel = UIAlertAction(title: Chat.Strings.cancelDeleteComment, style: .cancel) {(action) in
//
//    }
//
//    alertController.addAction(delete)
//    alertController.addAction(cancel)
//
//    present(alertController, animated: true, completion: nil)
//    alertController.view.tintColor = UIColor.bluePibble
//  }
  
  
  func setCommentInputText(_ text: String) {
    draftMessageTextView.text = text
    updatePlaceholder()
    updateEditViewForTextContent()
  }
  
  func cleanUpMessageInputField() {
    draftMessageTextView.text = ""
    updatePlaceholder()
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

// MARK: - ChatView Viper Components API
fileprivate extension ChatViewController {
  var presenter: ChatPresenterApi {
    return _presenter as! ChatPresenterApi
  }
}

extension ChatViewController {
  fileprivate func showInvoicePaymentSuccessAlert() {
    let ok = UIAlertAction(title: Chat.Strings.Alerts.okAction.localize(), style: .default) {(action) in
      
    }
    
    showAlertWith(Chat.Strings.Alerts.invoicePaymentSuccessAlertTitle.localize(),
                  message: Chat.Strings.Alerts.invoicePaymentSuccessAlertMessage.localize(),
                  actions: [ok], preferredStyle: .alert)
  }
  
  fileprivate func showConfirmInvoiceAlertWithMessage(_ message: String) {
    let buy = UIAlertAction(title: Chat.Strings.Alerts.okAction.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleConfirmCurrentInvoiceAction()
    }
    
    let cancel = UIAlertAction(title: Chat.Strings.Alerts.cancelAction.localize(), style: .cancel) { [weak self] (action) in
      self?.presenter.handleCancelCurrentInvoiceAction()
    }
    
    showAlertWith(nil, message: message, actions: [buy, cancel], preferredStyle: .alert)
  }
  
  fileprivate func showConfirmOrderAlertWithMessage(_ message: String) {
    let buy = UIAlertAction(title: Chat.Strings.Alerts.okAction.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleConfirmCurrentOrderAction()
    }
    
    let cancel = UIAlertAction(title: Chat.Strings.Alerts.cancelAction.localize(), style: .cancel) { [weak self] (action) in
      self?.presenter.handleCancelCurrentOrderAction()
    }
    
    showAlertWith(nil, message: message, actions: [buy, cancel], preferredStyle: .alert)
  }
  
  fileprivate func showBuyCurrentItemActionSheet() {
    let alertController = UIAlertController(title: nil, message: nil, safelyPreferredStyle: .actionSheet)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    let buy = UIAlertAction(title: Chat.Strings.Alerts.buyAction.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleBuyCurrentItemAction()
    }
    
    let cancel = UIAlertAction(title: Chat.Strings.Alerts.cancelAction.localize(), style: .cancel) { (action) in
      
    }
    
    alertController.addAction(buy)
    alertController.addAction(cancel)
    
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
  
  fileprivate func setupView() {
    tableView.delegate = self
    tableView.dataSource = self
    draftMessageTextView.delegate = self
    view.addEndEditingTapGesture()
    
    tableViewContentSizeObserver = tableView.observe(\UITableView.contentSize, options: .old) { (object, observedChange) in
      object.contentInset.top = max(0, object.bounds.height - object.contentSize.height)
    }
  }
  
  fileprivate func setupAppearance() {
    draftMessageBackgroundView.layer.cornerRadius =  draftMessageBackgroundView.bounds.height * 0.5
    draftMessageBackgroundView.layer.borderColor =  UIConstants.Colors.commentsInputBorder.cgColor
    draftMessageBackgroundView.layer.borderWidth = 0.5
    
    updatePlaceholder()
    
    tableView.flipUpsideDown()
    tableView.backgroundView = nil
    tableView.backgroundColor = UIColor.clear
  }
  
  fileprivate func setupLayout() {
    tableView.registerCell(ChatOutcomingMessageTableViewCell.self)
    tableView.registerCell(ChatIncomingMessageTableViewCell.self)
    tableView.registerCell(ChatStatusMessageTableViewCell.self)
    tableView.registerCell(ChatDigitalGoodPostMessageContainerTableViewCell.self)
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UIConstants.itemCellsEstimatedHeights.comment
    
    
    tableView.registerViewAsFooter(ChatMessagesHeaderView.self)
//
    tableView.sectionFooterHeight = UITableView.automaticDimension
    tableView.estimatedSectionFooterHeight = 35.0
    
  }
  
  fileprivate func updatePlaceholder() {
    draftMessagePlaceHolder.alpha = draftMessageTextView.text.count > 0 ? 0.0 : 1.0
    let trimmed = draftMessageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
    sendButton.isEnabled = trimmed.count > 0
    updateEditViewForTextContent()
  }
}

//MARK:- UITableViewDataSource, UITableViewDelegate

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
//  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//    let vm = presenter.itemViewModelAt(indexPath)
//    return vm.canBeEdited
//  }
  
//  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//    guard editingStyle == .delete else {
//      return
//    }
//
//    presenter.handleDeleteItemActionAt(indexPath)
//  }
//
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    guard section == 0 else {
      return UIView()
    }

    guard let title = presenter.titleForSection(section) else {
      return UIView()
    }

    let view = tableView.dequeueReusableFooter(ChatMessagesHeaderView.self)
    view.headerTitleLabel.text = title
    view.flipUpsideDown()
    return view
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let viewModel = presenter.itemViewModelAt(indexPath)
    switch viewModel {
    case .incomingTextMessage(let vm):
      let cell = tableView.dequeueReusableCell(cell: ChatIncomingMessageTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      cell.flipUpsideDown()
      return cell
    case .outcomingTextMessage(let vm):
      let cell = tableView.dequeueReusableCell(cell: ChatOutcomingMessageTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      cell.flipUpsideDown()
      return cell
    case .loadingPlaceholder:
      return UITableViewCell()
    case .paymentMessage(let vm):
      let cell = tableView.dequeueReusableCell(cell: ChatStatusMessageTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: systemMessageActionHandler)
      cell.flipUpsideDown()
      return cell
    case .digitalGoodPostMessage(let vm):
      let cell = tableView.dequeueReusableCell(cell: ChatDigitalGoodPostMessageContainerTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: messagesActionHandler)
      cell.flipUpsideDown()
      return cell
    case .unsupportedMessageType(let vm):
      let cell = tableView.dequeueReusableCell(cell: ChatStatusMessageTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, handler: systemMessageActionHandler)
      cell.flipUpsideDown()
      return cell
    }
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
    return cachedCellsSizes[indexPath]?.height ?? UIConstants.itemCellsEstimatedHeights.comment
  }
}

//MARK:- Actions

extension ChatViewController {
  fileprivate func systemMessageActionHandler(_ cell: UITableViewCell, action: Chat.SystemMessageAction) -> Void {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    switch action {
    case .approveReturn:
      let ok = UIAlertAction(title: Chat.Strings.Alerts.okAction.localize(), style: .default) { [weak self] (_) in
        self?.presenter.handleReturnGoodsApprovalActionAt(indexPath)
      }
      
      let cancel = UIAlertAction(title: Chat.Strings.Alerts.cancelAction.localize(), style: .cancel) { (_) in  }
      
      showAlertWith(nil, message: Chat.Strings.Alerts.returnGoodsItemMessage.localize(), actions: [ok, cancel], preferredStyle: .alert)
    }
  }
  
  fileprivate func messagesActionHandler(_ cell: UITableViewCell, action: Chat.MessageActions) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    presenter.handleMessageActionAt(indexPath, action: action)
  }
  
  fileprivate func headerActionHandler(_ view: UIView, action: Chat.ChatHeaderActions) {
    presenter.handleHeaderAction(action)
  }
}

//MARK:- UITextViewDelegate

extension ChatViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    updatePlaceholder()
    updateEditViewForTextContent()
    presenter.handleMessageDraftTextChanged(textView.text)
  }
  
  fileprivate func updateEditViewForTextContent() {
    let fittingSize = draftMessageTextView.sizeThatFits(CGSize(width: draftMessageTextView.frame.size.width, height: 9999))
    
    let textViewMinHeight = UIConstants.Constraints.inputTextViewMinHeight
    let viewMaxHeight = UIConstants.Constraints.inputTextViewMaxHeight
    let trueViewHeight = max(textViewMinHeight, CGFloat(fittingSize.height)) //+ viewContentHeightWithoutTextView
    let viewContentHeight = min(viewMaxHeight, trueViewHeight)
    
    textViewHeightConstraint.constant = viewContentHeight
    
    UIView.animate(withDuration: 0.1, delay: 0.0, options: .beginFromCurrentState, animations: { [weak self] in
      self?.view.layoutIfNeeded()
      
    }) { (_) in  }
  }
}

//MARK:- KeyboardNotificationsDelegateProtocol

extension ChatViewController: KeyboardNotificationsDelegateProtocol {
  func keyBoardWillShowWithBottomInsets(_ bottomInsets: CGFloat, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    draftMessageViewBottomConstraint.constant = bottomInsets + UIConstants.Constraints.draftMessageBackgroundBottomConstraintMin
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { [weak self] (_) in
      self?.scrollToBottom(animated: true)
    }
  }
  
  func keyBoardWillHide(animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    draftMessageViewBottomConstraint.constant = UIConstants.Constraints.draftMessageBackgroundBottomConstraintMin
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in }
  }
}


//MARK:- UIConstants

fileprivate enum UIConstants {
  enum itemCellsEstimatedHeights {
    static let comment: CGFloat = 100.0
  }
  
  enum Constraints {
    static let inputTextViewMaxHeight: CGFloat = 150.0
    static let inputTextViewMinHeight: CGFloat = 36.0
    static let draftMessageBackgroundBottomConstraintMin: CGFloat = 0.0
  }
  
  enum Colors {
    static let commentsInputBorder =  UIColor.gray191
  }
}
