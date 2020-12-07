//
//  PostHelpAnswersViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 10.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import SwipeCellKit

//MARK: PostHelpAnswersView Class
final class PostHelpAnswersViewController: ViewController {
  //MARK:- IBOutlets
  @IBOutlet weak var headerView: PostHelpAnswersHeaderView!
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var sendButton: UIButton!
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var commentTextView: UITextView!
  @IBOutlet weak var commentsBackgroundView: UIView!
  
  @IBOutlet weak var commentsPlaceHolder: UILabel!
  
  //MARK:- IBActions
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  @IBAction func sendAction(_ sender: UIButton) {
    sender.isEnabled = false
    presenter.handleSendAnswerAction(commentTextView.text)
  }
  
  //MARK:- IBOutlet Constraints
  
  @IBOutlet weak var tableViewToNavBarTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var tableViewToHeaderTopConstraint: NSLayoutConstraint!
  
  
  @IBOutlet weak var commentViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
  
  //MARK:- private properties
  
  fileprivate var collectionUpdateOperations: [BlockOperation] = []
  fileprivate var shouldAnimateCollectionUpdate: Bool = true
  fileprivate var cachedCellsSizes: [IndexPath: CGSize] = [:]
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
  
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
    commentTextView.becomeFirstResponder()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateTableViewInsetsAnimated(false)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    tableView.shouldFireContentOffsetChangesNotifications = false
    unsubscribeKeyboardNotications()
  }
}

//MARK: - PostHelpAnswersView API
extension PostHelpAnswersViewController: PostHelpAnswersViewControllerApi {
  func setHeaderViewModel(vm: PostHelpAnswersHeaderViewModelProtocol?, animated: Bool) {
    guard let viewModel = vm else {
      setHeaderViewHidden(true, animated: animated)
      return
    }
    setHeaderViewHidden(false, animated: animated)
    headerView.setViewModel(viewModel, handler: headerActionsHandler, animated: animated)
  }
  
  func showDeleteAlert() {
    let alertController = UIAlertController(title: nil, message: PostHelpAnswers.Strings.deleteCommentMessage.localize(), safelyPreferredStyle: .alert)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    let delete = UIAlertAction(title: PostHelpAnswers.Strings.deleteCommentAction.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleDeleteCurrentItemAction()
    }
    
    let cancel = UIAlertAction(title: PostHelpAnswers.Strings.cancelDeleteComment.localize(), style: .cancel) {(action) in
      
    }
    
    alertController.addAction(delete)
    alertController.addAction(cancel)
    
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
  
  func setBeginEditingAndScrollTo(_ indexPath: IndexPath) {
    UIView.animate(withDuration: 0.3, animations: {[weak self] in
      self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }) { [weak self] (_) in
      self?.commentTextView.becomeFirstResponder()
    }
  }
  
  func setCommentInputText(_ text: String) {
    commentTextView.text = text
    updatePlaceholder()
    updateEditViewForTextContent()
  }
  
  func setUserPic(_ urlString: String, placeHolderImage: UIImage?) {
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.userImageView.image = placeHolderImage
      self?.userImageView.setCachedImageOrDownload(urlString)
      self?.userImageView.alpha = 1.0
    }
  }
  
  func cleanUpCommentInputField() {
    commentTextView.text = ""
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
    CATransaction.begin()
    CATransaction.setCompletionBlock { [weak self] in
      //we have to do it twice because tableview contentsize may be wrong for the first item inserted
      self?.updateTableViewInsetsAnimated(true)
      DispatchQueue.main.async { [weak self] in
        self?.updateTableViewInsetsAnimated(true)
      }
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
    CATransaction.commit()
    batchUpdates = []
  }
}

// MARK: - PostHelpAnswersView Viper Components API

fileprivate extension PostHelpAnswersViewController {
  var presenter: PostHelpAnswersPresenterApi {
    return _presenter as! PostHelpAnswersPresenterApi
  }
}

//MARK:- Helpers

extension PostHelpAnswersViewController {
  fileprivate func setHeaderViewHidden(_ hidden: Bool, animated: Bool) {
    tableViewToNavBarTopConstraint.priority = hidden ? .defaultHigh : .defaultLow
    tableViewToHeaderTopConstraint.priority = !hidden ? .defaultHigh : .defaultLow
    
    guard animated else {
      view.layoutIfNeeded()
      return
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.view.layoutIfNeeded()
    }
  }
  
  fileprivate func scrollToBottom(animated: Bool) {
    let indexPath = IndexPath.zero
    guard let _ = tableView.cellForRow(at: indexPath) else {
      return
    }
    
    //scroll to top because table view is flipped
    tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
  }
  
  fileprivate func updateTableViewInsetsAnimated(_ animated: Bool) {
    guard animated else {
      tableView.contentInset.top = max(0, tableView.bounds.height - tableView.contentSize.height)
      return
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      guard let strongSelf = self else {
        return
      }
      strongSelf.tableView.contentInset.top = max(0, strongSelf.tableView.bounds.height - strongSelf.tableView.contentSize.height)
    }
  }
  
  fileprivate func setupView() {
    tableView.delegate = self
    tableView.dataSource = self
    commentTextView.delegate = self
    view.addEndEditingTapGesture()
  }
  
  fileprivate func setupAppearance() {
    userImageView.alpha = 0.0
    userImageView.setCornersToCircle()
    commentsBackgroundView.layer.cornerRadius =  commentsBackgroundView.bounds.height * 0.5
    commentsBackgroundView.layer.borderColor =  UIConstants.Colors.commentsInputBorder.cgColor
    commentsBackgroundView.layer.borderWidth = 0.5
    
    updatePlaceholder()
    
    tableView.flipUpsideDown()
  }
  
  fileprivate func setupLayout() {
    tableView.registerCell(PostHelpAnswerTableViewCell.self)
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = UIConstants.itemCellsEstimatedHeights.comment
  }
  
  fileprivate func updatePlaceholder() {
    commentsPlaceHolder.alpha = commentTextView.text.count > 0 ? 0.0 : 1.0
    sendButton.isEnabled = commentTextView.text.count > 0
    updateEditViewForTextContent()
  }
  
  fileprivate func replyActionHandler(_ cell: PostHelpAnswerTableViewCell, action: PostHelpAnswers.Actions) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    switch action {
    case .reply:
      presenter.handleSelectReplyActionAt(indexPath)
    case .upvote:
      presenter.handleUpvoteActionAt(indexPath)
    case .showUser:
      presenter.handleShowUserActionAt(indexPath)
    }
  }
  
  fileprivate func headerActionsHandler(_ view: PostHelpAnswersHeaderView, action: PostHelpAnswers.Actions) {
    switch action {
    case .reply:
      break
    case .upvote:
      break
    case .showUser:
      presenter.handleShowPostHelpAuthorUser()
    }
  }
}

//MARK:- SwipeTableViewCellDelegate
extension PostHelpAnswersViewController: SwipeTableViewCellDelegate {
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else {
      return nil
    }
    
    let vm = presenter.itemViewModelAt(indexPath)
    
    if vm.canBePicked && presenter.canPickAnswers {
      let pickAction = SwipeAction(style: .default, title: PostHelpAnswers.Strings.pickAnswerAction.localize()) { [weak self] action, indexPath in
        self?.presenter.handlePickItemActionAt(indexPath)
      }
      
      pickAction.backgroundColor = UIConstants.Colors.pickItemBackground
      pickAction.textColor = UIConstants.Colors.pickItemTitle
      return [pickAction]
    }
    
    if vm.canBeEdited {
      let deleteAction = SwipeAction(style: .destructive, title: PostHelpAnswers.Strings.deleteCommentAction.localize()) { [weak self] action, indexPath in
        self?.presenter.handleDeleteItemActionAt(indexPath)
      }
      
      return [deleteAction]
    }
    
    return nil
  }
}

//MARK:- UITableViewDataSource, UITableViewDelegate

extension PostHelpAnswersViewController: UITableViewDataSource, UITableViewDelegate {
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
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(cell: PostHelpAnswerTableViewCell.self, for: indexPath)
    let vm = presenter.itemViewModelAt(indexPath)
    cell.setViewModel(vm, handler: replyActionHandler)
    cell.flipUpsideDown()
    cell.delegate = self
    return cell
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
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

//MARK:- UITextViewDelegate

extension PostHelpAnswersViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    updatePlaceholder()
    updateEditViewForTextContent()
    presenter.handleAnswerTextChanged(textView.text)
  }
  
  fileprivate func updateEditViewForTextContent() {
    let fittingSize = commentTextView.sizeThatFits(CGSize(width: commentTextView.frame.size.width, height: 9999))
    
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

extension PostHelpAnswersViewController: KeyboardNotificationsDelegateProtocol {
  func keyBoardWillShowWithBottomInsets(_ bottomInsets: CGFloat, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    commentViewBottomConstraint.constant = bottomInsets + UIConstants.Constraints.commentBackgroundBottomConstraintMin
  
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
      self?.updateTableViewInsetsAnimated(false)
    }) { [weak self] (_) in
      self?.scrollToBottom(animated: true)
    }
  }
  
  func keyBoardWillHide(animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    commentViewBottomConstraint.constant = UIConstants.Constraints.commentBackgroundBottomConstraintMin
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
      self?.updateTableViewInsetsAnimated(false)
    }) { (_) in  }
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
    static let commentBackgroundBottomConstraintMin: CGFloat = 0.0
  }
  
  enum Colors {
    static let commentsInputBorder =  UIColor.gray191
    static let pickItemBackground = UIColor.yellowPostHelp
    static let pickItemTitle = UIColor.black
  }
}
