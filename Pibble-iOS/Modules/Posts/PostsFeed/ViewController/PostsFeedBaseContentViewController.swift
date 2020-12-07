//
//  PostsFeedUserPostsContentViewController.swift
//  Pibble
//
//  Created by Kazakov Sergey on 21.11.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: PostsFeedView Class
class PostsFeedBaseContentViewController: ViewController {
  //MARK:- IBOutlets
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var mainFeedBottomConstraint: NSLayoutConstraint!

  //MARK:- IBActions
  
  func hideAction() {
    presenter.handleHideAction()
  }
  
  
  fileprivate var zoomingView: ZoomingView = ZoomingView()
  fileprivate var isZooming: Bool = false
  fileprivate var zoomingViewOriginalCenter: CGPoint?
  
  fileprivate var scrollToBottomDelayObject = DelayBlockObject()
  
  fileprivate let contentOverlayView = UIView()
  
  fileprivate(set) lazy var tap: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(tap(sender:)))
    gesture.delegate = self
    return gesture
  }()
  
  fileprivate(set) lazy var pinch: UIPinchGestureRecognizer = {
    let gesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch(sender:)))
    gesture.delegate = self
    return gesture
  }()
  
  fileprivate(set) lazy var pan: UIPanGestureRecognizer = {
    let gesture = UIPanGestureRecognizer(target: self, action: #selector(pan(sender:)))
    gesture.delegate = self
    return gesture
  }()
  
  fileprivate(set) lazy var longPress: UILongPressGestureRecognizer = {
    let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender:)))
//    gesture.delegate = self
    return gesture
  }()
 
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
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    view.endEditing(true)
    tableView.shouldFireContentOffsetChangesNotifications = false
    unsubscribeKeyboardNotications()
  }
  
  //MARK:- private properies
  
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
  fileprivate var cachedCellsSizes: [IndexPath: CGSize] = [:]
  fileprivate let refreshControl = UIRefreshControl()
  
  //MARK:- Properies
  
  weak var embedableDelegate: EmbedableViewControllerDelegate?
  
  //MARK:- Overrrides
  
  override var shouldHandleSwipeToPopGesture: Bool {
    return true
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    preferredContentSize = contentSize
  }
  
  
  //MARK:- Error handling
  
  override func shouldPresentAlertFor(_ error: Error) -> Bool {
    guard let pibbleError = error as? PibbleError else {
      return true
    }
    
    switch pibbleError {
    case .underlying(_):
      return true
    case .methodNotImplemented:
      return false
    case .requestError(_):
      return false
    case .fileProcessingError(_):
      return true
    case .notAuthorizedError:
      return false
    case .internalServerError:
      return false
    case .notAllowedError:
      return false
    case .unprocessableEntityError(_):
      return true
    case .serverErrorWithMessage(_):
      return true
    case .parsingError:
      return true
    case .socketEventParsingError(_):
      return true
    case .decodableMapping(_):
      return false
    case .objectDeallocated:
      return false
    case .wrondVericationCode:
      return true
    case .resendCodeTimeInterval:
      return true
    case .mapKitSearchError(_):
      return true
    case .googlePlaceSearchError(_):
      return true
    case .missingAttribute(_):
      return true
    case .chatRoomsGroupForPostNotFound:
      return true
    }
  }
  
  
  //implemented here to have a chance to be overiden
  
  func showPlaceholder(_ vm: PostsFeedItemsPlaceholderProtocol?, animated: Bool) {
    
  }
  
  
  func setTopHeaderViewModel(_ vm: PostsFeedHomeTopGroupsHeaderViewModelProtocol?, animated: Bool) {
    
  }
}

//MARK: - PostsFeedView API
extension PostsFeedBaseContentViewController: PostsFeedViewControllerApi {
  func showConfirmPostHelpCreationOrderAlert(_ title: String) {
    let confirm = UIAlertAction(title: PostsFeed.Strings.Alerts.okAction.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleConfirmPostHelpCreationAction()
    }
    
    let cancel = UIAlertAction(title: PostsFeed.Strings.Alerts.cancelAction.localize(), style: .cancel) { [weak self] (action) in
      self?.presenter.handleCancelPostHelpCreationAction()
    }
    
    showAlertWith(nil, message: title, actions: [confirm, cancel], preferredStyle: .alert)
  }
  
  func showConfirmGoodsOrderAlert(_ title: String) {
    let buy = UIAlertAction(title: PostsFeed.Strings.Alerts.okAction.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleConfirmOrderCreationAction()
    }
    
    let cancel = UIAlertAction(title: PostsFeed.Strings.Alerts.cancelAction.localize(), style: .cancel) { [weak self] (action) in
      self?.presenter.handleCancelOrderCreationAction()
    }
    
    showAlertWith(nil, message: title, actions: [buy, cancel], preferredStyle: .alert)
  }
  
  func showResumePromotionAlert() {
    let ok = UIAlertAction(title: PostsFeed.Strings.Alerts.okAction.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleCurrentItemResumePromotionConfirmAction()
    }
    
    let cancel = UIAlertAction(title: PostsFeed.Strings.Alerts.cancelAction.localize(), style: .cancel) { (action) in
      
    }
    
    let alertActions = [cancel, ok]
    showAlertWith(nil, message: PostsFeed.Strings.Alerts.PromotionMessages.resume.localize(), actions: alertActions, preferredStyle: .alert)
  }
  
  func showPausePromotionAlert() {
    let ok = UIAlertAction(title: PostsFeed.Strings.Alerts.okAction.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleCurrentItemPausePromotionConfirmAction()
    }
    
    let cancel = UIAlertAction(title: PostsFeed.Strings.Alerts.cancelAction.localize(), style: .cancel) { (action) in
      
    }
    
    let alertActions = [cancel, ok]
    showAlertWith(nil, message: PostsFeed.Strings.Alerts.PromotionMessages.pause.localize(), actions: alertActions, preferredStyle: .alert)
  }
  
  func showClosePromotionAlert() {
    let ok = UIAlertAction(title: PostsFeed.Strings.Alerts.okAction.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleCurrentItemClosePromotionConfirmAction()
    }
    
    let cancel = UIAlertAction(title: PostsFeed.Strings.Alerts.cancelAction.localize(), style: .cancel) { (action) in
      
    }
    
    let alertActions = [cancel, ok]
    showAlertWith(nil, message: PostsFeed.Strings.Alerts.PromotionMessages.close.localize(), actions: alertActions, preferredStyle: .alert)
  }
  
  func showSpamReportedSuccessAlert() {
    let alertController = UIAlertController(title: PostsFeed.Strings.Alerts.spamReportSuccessAlertTitle.localize(), message: PostsFeed.Strings.Alerts.spamReportSuccessAlertMessage.localize(), safelyPreferredStyle: .alert)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    let block = UIAlertAction(title: PostsFeed.Strings.Alerts.spamReportSuccessAlertBlockAction.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleCurrentItemBlockReportAction()
    }
    
    let cancel = UIAlertAction(title: PostsFeed.Strings.Alerts.cancelAction.localize(), style: .cancel) {(action) in
      
    }
    
    alertController.addAction(block)
    
    alertController.addAction(cancel)
    
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
  
  func showReportTypeSelectionAlert() {
    let alertController = UIAlertController(title: nil, message: nil, safelyPreferredStyle: .actionSheet)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    let inappropriateReport = UIAlertAction(title: PostsFeed.Strings.Alerts.inappropriateReportAlertTitle.localize(), style: .destructive) { [weak self] (action) in
      self?.presenter.handleCurrentItemInappropriateReportAction()
    }
    
    let spamReport = UIAlertAction(title: PostsFeed.Strings.Alerts.spamReportAlertTitle.localize(), style: .destructive) { [weak self] (action) in
      self?.presenter.handleCurrentItemSpamReportAction()
    }
    
    let cancel = UIAlertAction(title: PostsFeed.Strings.Alerts.cancelAction.localize(), style: .cancel) {(action) in
      
    }
    
    alertController.addAction(inappropriateReport)
    alertController.addAction(spamReport)
    
    alertController.addAction(cancel)
    
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
  
  func showPostDeleteAlertWith(_ title: String, message: String, canBeDeleted: Bool) {
    let alertController = UIAlertController(title: title, message: message, safelyPreferredStyle: .alert)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    let delete = UIAlertAction(title: PostsFeed.Strings.Alerts.deleteAction.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleCurrentItemDeletePostAction()
    }
    
    let cancel = UIAlertAction(title: PostsFeed.Strings.Alerts.cancelAction.localize(), style: .cancel) {(action) in
      
    }
    
    if canBeDeleted {
      alertController.addAction(delete)
    }
    
    alertController.addAction(cancel)
    
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
  
  func presentPurchaseSuccessAlert() {
    showInvoicePaymentSuccessAlert()
  }
  
  func presentDonationSuccessAlert() {
    showDonationPaymentSuccessAlert()
  }
  
  func presentStopFundingConfirmAlert() {
    let cancel = UIAlertAction(title: PostsFeed.Strings.Alerts.cancelAction.localize(), style: .cancel) { [weak self](action) in
      
    }
    
    let ok = UIAlertAction(title: PostsFeed.Strings.Alerts.okAction.localize(), style: .default) { [weak self](action) in
      self?.presenter.handleCurrentItemStopFundingConfirmAction()
    }
    
    let actions: [UIAlertAction] = [cancel, ok]
    
    showAlertWith(nil,
                  message: PostsFeed.Strings.Alerts.FundingMessages.stopFundingConfirmMessage.localize(), actions: actions, preferredStyle: .alert)
  }
  
  func presentStopFundingSuccessAlert() {
    let ok = UIAlertAction(title: PostsFeed.Strings.Alerts.okAction.localize(), style: .default) { [weak self](action) in
      
    }
    
    let actions: [UIAlertAction] = [ok]
    
    showAlertWith(nil,
                  message: PostsFeed.Strings.Alerts.FundingMessages.stopFundingSuccessMessage.localize(), actions: actions, preferredStyle: .alert)
  }
  
  
  func showConfirmInvoiceAlert(_ title: String) {
    showConfirmInvoiceAlertWithMessage(title)
  }
  
  @objc func setBadges(notificationBadge: String?, walletBadge: String?) {   }
  
  @objc func showLocationOptionsActionSheet() {  }
  
  //marked as accessable in objc to be able to override methods/properties from extension
  @objc func setWalletPreviewContainerPresentation(_ hidden: Bool, animated: Bool) {  }
  
  @objc var walletContainerView: UIView {
    //we don't present wallet preview in content postings view controller
    return UIView()
  }
  
  @objc func scrollTo(_ indexPath: IndexPath, animated: Bool) {
    //scroll to item is not supported directly because this view controller is supposed to be embedded inside other scrollable containers
  }
  
  
  func reloadData() {
    batchUpdates = []
    tableView.reloadData()
    preferredContentSize = contentSize
    embedableDelegate?.handleContentSizeChange(self, contentSize: contentSize)
  }
  
//  func setUpvoteUsersContainerPresentation(_ hidden: Bool, forIndexPath: IndexPath?, animated: Bool) {
//    guard !hidden || !upvotedUsersBackgroundView.alpha.isZero else {
//      return
//    }
//
//    if let idx = forIndexPath {
//      let itemRect = tableView.rectForRow(at: idx)
//      let rectInViewCoordinates = tableView.convert(itemRect, to: view)
//      upvoteUserBackgroundViewTopConstraint.constant = rectInViewCoordinates.origin.y + UIConstants.upvotesUsersViewOffset
//    }
//
//    let alpha: CGFloat = hidden ? 0.0 : 1.0
//    let shadowAlpha: Float = hidden ? 0.0 : UIConstants.ShadowsOpacity.upvotesUsersView
//    let shadowAlphaInitValue: Float = !hidden ? 0.0 : UIConstants.ShadowsOpacity.upvotesUsersView
//    guard animated else {
//      upvotedUsersBackgroundView.alpha = alpha
//      upvotedUsersBackgroundView.layer.shadowOpacity = shadowAlpha
//      return
//    }
//
//    let animation = CABasicAnimation(keyPath: "shadowOpacity")
//    animation.fromValue = shadowAlphaInitValue
//    animation.toValue = Float(shadowAlpha)
//    animation.duration = 0.3
//    upvotedUsersBackgroundView.layer.add(animation, forKey: animation.keyPath)
//    upvotedUsersBackgroundView.layer.shadowOpacity = shadowAlpha
//
//    UIView.animate(withDuration: 0.3) { [weak self] in
//      guard let strongSelf = self else {
//        return
//      }
//
//      strongSelf.upvotedUsersBackgroundView.alpha = alpha
//      strongSelf.view.layoutIfNeeded()
//    }
//  }
  
//  var upvoteUsersContainerView: UIView {
//    return upvoteUserContainerView
//  }
  
  func scrollToTop(animated: Bool) {
    tableView.setContentOffset(CGPoint.zero, animated: animated)
  }
  
  func setFetchingFinished() {
    guard refreshControl.isRefreshing else {
      return
    }
    
    refreshControl.endRefreshing()
  }
  
  func setFetchingStarted() {
    guard !refreshControl.isRefreshing else {
      return
    }
    
    refreshControl.beginRefreshing()
    let offsetPoint = CGPoint(x: 0, y: -refreshControl.frame.size.height)
    tableView.setContentOffset(offsetPoint, animated: true)
  }
  
  func showMyPostingOptionsActionSheet() {
    presentMyPostingOptionsActionSheet()
  }
  
  func showMyPostingPromotionOptionsActionSheet(_ actions: [PostsFeed.PromotionEventsActions]) {
    presentMyPromotedPostingOptionsActionSheet(actions)
  }
  
  func showPostingOptionsActionSheet(_ vm: PostsFeedUserViewModelProtocol) {
    presentPostingOptionsActionSheet(vm)
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
    preferredContentSize = contentSize
    embedableDelegate?.handleContentSizeChange(self, contentSize: contentSize)
    batchUpdates = []
  }
  
}

// MARK: - PostsFeedView Viper Components API
extension PostsFeedBaseContentViewController {
  var presenter: PostsFeedPresenterApi {
    return _presenter as! PostsFeedPresenterApi
  }
}

//MARK:- Helpers

extension PostsFeedBaseContentViewController {
  @objc fileprivate func pullToRefresh() {
    presenter.handlePullToRefresh()
  }
  
  fileprivate func setupView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.prefetchDataSource = self
    tableView.refreshControl = refreshControl
    
    
    // Configure Refresh Control
    refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
    
    tableView.registerCell(PostsFeedUserTableViewCell.self)
    tableView.registerCell(PostsFeedContentContainerTableViewCell.self)
    tableView.registerCell(PostsFeedActionsTableViewCell.self)
    
    tableView.registerCell(PostsFeedDescriptionTableViewCell.self)
    tableView.registerCell(PostsFeedDateTableViewCell.self)
    tableView.registerCell(PostsFeedCommentTableViewCell.self)
    tableView.registerCell(PostsFeedAllCommentsActionTableViewCell.self)
    tableView.registerCell(PostsFeedTagsContainerTableViewCell.self)
    
    tableView.registerCell(PostsFeedAddCommentTableViewCell.self)
    tableView.registerCell(PostsFeedLocationTableViewCell.self)
    
    tableView.registerCell(PostsFeedFundingCampaignTitleTableViewCell.self)
    tableView.registerCell(PostsFeedFundingCampaignStatusTableViewCell.self)
    tableView.registerCell(PostsFeedFundingCampaignTeamTableViewCell.self)
    
    tableView.registerCell(PostsFeedPromotedPostTableViewCell.self)
    tableView.registerCell(PostsFeedAddPromotionTableViewCell.self)
    
    tableView.registerCell(PostsFeedEditDescriptionTableViewCell.self)
    
    tableView.registerCell(PostsFeedUploadingStateTableViewCell.self)
    
    tableView.registerCell(PostsFeedCommercialPostTitleTableViewCell.self)
    tableView.registerCell(PostsFeedCommerceProcessingErrorTableViewCell.self)
    
    tableView.registerCell(PostsFeedGoodPriceTableViewCell.self)
    
    view.addGestureRecognizer(pan)
    view.addGestureRecognizer(pinch)
    view.addGestureRecognizer(longPress)
    tableView.addGestureRecognizer(tap)
  }
  
  fileprivate func setupLayout() {
    tableView.contentInset.bottom = UIConstants.bottomContentOffset
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = tableView.bounds.width
  }
  
  fileprivate func setupAppearance() {
//    upvotedUsersBackgroundView.addShadow(shadowColor: UIColor.black,
//                                         offSet: CGSize(width: 0, height: 30),
//                                         opacity: UIConstants.ShadowsOpacity.upvotesUsersView,
//                                         radius: 30.0)
//    
//    upvoteUserContainerView.layer.cornerRadius = UIConstants.CornerRadius.upvotesUsersView
//    upvoteUserContainerView.clipsToBounds = true
  }
  
  fileprivate func contentItemLayoutFor(_ vm: PostsFeedContentViewModelProtocol) -> PostsFeed.ItemLayout {
    guard vm.contentSize.height > 1.0 else {
      return PostsFeed.ItemLayout(size: CGSize.zero)
    }
    
    let ratio = vm.contentSize.height / vm.contentSize.width
    let size = CGSize(width: tableView.bounds.width, height: ceil(tableView.bounds.width * ratio))
    
    return PostsFeed.ItemLayout(size: size)
  }
}


//MARK:- UITableViewDelegate, UITableViewDataSource

extension PostsFeedBaseContentViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    embedableDelegate?.handleDidScroll(self, childScrollView: scrollView)
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    guard tableView == scrollView else {
      return
    }
    
    let visibleRows = tableView.indexPathsForVisibleRows ?? []
    guard !decelerate else {
      return
    }
    
    presenter.handleStopScrollingWithVisible(visibleRows)
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    guard tableView == scrollView else {
      return
    }
    
    let visibleRows = tableView.indexPathsForVisibleRows ?? []
    presenter.handleStopScrollingWithVisible(visibleRows)
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    guard tableView == scrollView else {
      return
    }
//    initialContentOffsetY = scrollView.contentOffset.y
    presenter.handleStartScrolling()
  }
  
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter.numberOfSections()
  }
  
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    indexPaths.forEach {
      presenter.handlePrefetchItemAt($0)
    }
  }
  
  func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
    indexPaths.forEach {
      presenter.handleCancelPrefetchingItem($0)
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let vm = presenter.itemViewModelAt(indexPath) else {
      return UITableView.automaticDimension
    }
    
    var height: CGFloat = 0.0
    
    switch vm {
    case .user(_):
      height = UIConstants.itemCellsEstimatedHeights.user
    case .content(let vm):
      height = contentItemLayoutFor(vm).size.height
    case .actions(_):
      height = UIConstants.itemCellsEstimatedHeights.actions
    case .description(_):
      height = UITableView.automaticDimension
    case .postingDate(_):
      height = UIConstants.itemCellsEstimatedHeights.postingDate
    case .tags(_):
      height = UITableView.automaticDimension
    case .comment(_):
      height = UITableView.automaticDimension
    case .showAllComments(_):
      height =  UIConstants.itemCellsEstimatedHeights.showAllComments
    case .addComment(_):
      height = UITableView.automaticDimension
    case .location(_):
      height = UITableView.automaticDimension
    case .fundingCampaignTitle(_):
      height = UITableView.automaticDimension
    case .fundingCampaignStatus(_):
      height = UITableView.automaticDimension
    case .fundingCampaignTeam(_):
      height = UITableView.automaticDimension
    case .promotionStatus(_):
      height = UITableView.automaticDimension
    case .editDescription(_):
      height = UITableView.automaticDimension
    case .uploading(_):
      height = UITableView.automaticDimension
    case .commercialInfo(_):
      height = UITableView.automaticDimension
    case .commercialPostError:
      height = UITableView.automaticDimension
    case .goodsInfo(_):
      height = UITableView.automaticDimension
    case .addPromotion(_):
      height = UITableView.automaticDimension
    }
    
    return height
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    if let size = cachedCellsSizes[indexPath] {
      return size.height
    }
    guard let vm = presenter.itemViewModelAt(indexPath) else {
      return 1.0
    }
    var height: CGFloat = 0.0
    
    switch vm {
    case .user(_):
      height = UIConstants.itemCellsEstimatedHeights.user
    case .content(let vm):
      height = contentItemLayoutFor(vm).size.height
    case .actions(_):
      height = UIConstants.itemCellsEstimatedHeights.actions
    case .description(_):
      height = UIConstants.itemCellsEstimatedHeights.description
    case .postingDate(_):
      height = UIConstants.itemCellsEstimatedHeights.postingDate
    case .tags(_):
      height = UIConstants.itemCellsEstimatedHeights.tags
    case .comment(_):
      height = UIConstants.itemCellsEstimatedHeights.comment
    case .showAllComments(_):
      height = UIConstants.itemCellsEstimatedHeights.showAllComments
    case .addComment:
      height = UIConstants.itemCellsEstimatedHeights.addComment
    case .location(_):
      height = UIConstants.itemCellsEstimatedHeights.location
    case .fundingCampaignTitle(_):
      height = UIConstants.itemCellsEstimatedHeights.fundingCampaignTitle
    case .fundingCampaignStatus(_):
      height = UIConstants.itemCellsEstimatedHeights.fundingCampaignStatus
    case .fundingCampaignTeam(_):
      height = UIConstants.itemCellsEstimatedHeights.fundingCampaignTeam
    case .promotionStatus(_):
      height = UIConstants.itemCellsEstimatedHeights.promotionStatus
    case .addPromotion:
      height = UIConstants.itemCellsEstimatedHeights.addPromotion
    case .editDescription(_):
      height = UIConstants.itemCellsEstimatedHeights.editDescription
    case .uploading(_):
      height = UIConstants.itemCellsEstimatedHeights.uploadPlaceholder
    case .commercialInfo(_):
      height = UIConstants.itemCellsEstimatedHeights.commecialInfo
    case .commercialPostError(_):
      height = UIConstants.itemCellsEstimatedHeights.commecialPostError
    case .goodsInfo(_):
      height = UIConstants.itemCellsEstimatedHeights.goodsInfo
    }
    
    return height
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let viewModelType = presenter.itemViewModelAt(indexPath) else {
      return UITableViewCell()
    }
    switch viewModelType {
    case .user(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostsFeedUserTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.handleUserSectionItemAction($0, action: $1) }
      return cell
    case .content(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostsFeedContentContainerTableViewCell.self, for: indexPath)
      cell.setViewModel(vm, layout: contentItemLayoutFor(vm)) { [weak self] in self?.handlePostingItemAction($0, action: $1) }
      return cell
    case .actions(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostsFeedActionsTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.handlePostingItemAction($0, action: $1) }
      return cell
    case .description(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostsFeedDescriptionTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .postingDate(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostsFeedDateTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .tags(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostsFeedTagsContainerTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.selectTagAction($0, tagIndexPath: $1) }
      return cell
    case .comment(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostsFeedCommentTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.selectCommentAction($0) }
      return cell
    case .showAllComments(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostsFeedAllCommentsActionTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.showAllCommentsAction($0) }
      return cell
    case .addComment(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostsFeedAddCommentTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.addCommentActionHandler($0, action: $1) }
      return cell
    case .location(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostsFeedLocationTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.selectLocation($0) }
      return cell
    case .fundingCampaignTitle(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostsFeedFundingCampaignTitleTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.fundingCampaignStatusActionHandler($0, action: $1) }
      return cell
    case .fundingCampaignStatus(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostsFeedFundingCampaignStatusTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.fundingCampaignStatusActionHandler($0, action: $1) }
      return cell
    case .fundingCampaignTeam(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostsFeedFundingCampaignTeamTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.fundingCampaignTeamActionHandler($0, action: $1) }
      return cell
    case .promotionStatus(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostsFeedPromotedPostTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.promotionItemActionsHandler($0, action: $1) }
      return cell
    case .addPromotion(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostsFeedAddPromotionTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.promotionItemActionsHandler($0, action: $1) }
      return cell
    case .editDescription(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostsFeedEditDescriptionTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.editDescriptionHandler($0, action: $1) }
      return cell
    case .uploading(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostsFeedUploadingStateTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.uploadStatusActionHandler($0, action: $1) }
      return cell
    case .commercialInfo(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostsFeedCommercialPostTitleTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.commercialItemActionsHandler($0, action: $1) }
      return cell
    case .commercialPostError(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostsFeedCommerceProcessingErrorTableViewCell.self, for: indexPath)
      cell.setViewModel(vm)
      return cell
    case .goodsInfo(let vm):
      let cell = tableView.dequeueReusableCell(cell: PostsFeedGoodPriceTableViewCell.self, for: indexPath)
      cell.setViewModel(vm) { [weak self] in self?.commercialItemActionsHandler($0, action: $1) }
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    presenter.handlePrefetchItemAt(indexPath)
  }
  
  func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //presenter.handleDidEndDisplayItem(indexPath)
    cachedCellsSizes[indexPath] = cell.frame.size
  }
}


//MARK:- Items Actions

extension PostsFeedBaseContentViewController {
  fileprivate func promotionItemActionsHandler(_ cell: UITableViewCell, action: PostsFeed.PromotionActions) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    switch action {
    case .add:
      presenter.handleAddPromotionActionAt(indexPath)
    case .showEngagement:
      presenter.handleShowEngagementActionAt(indexPath)
    case .showDestination:
      presenter.handleShowDestinationActionAt(indexPath)
    }
  }
  
  fileprivate func commercialItemActionsHandler(_ cell: UITableViewCell, action: PostsFeed.CommercialPostActions) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    switch action {
    case .chat:
      presenter.handleChatActionAt(indexPath)
    case .detail:
      presenter.handleCommercePostDetailsActionAt(indexPath)
    }
  }
  
  fileprivate func uploadStatusActionHandler(_ cell: PostsFeedUploadingStateTableViewCell, action: PostsFeed.UploadingActions) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    switch action {
    case .cancel:
      presenter.handleCancelUploadActionAt(indexPath)
    case .restart:
      presenter.handleRestartUploadActionAt(indexPath)
    }
  }
  
  fileprivate func editDescriptionHandler(_ cell: PostsFeedEditDescriptionTableViewCell, action: PostsFeed.EditDescriptionActions) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    switch action {
    case .changeText(let text):
      scrollToBottomDelayObject.cancel()
      scrollToBottomDelayObject.scheduleAfter(delay: 0.3) { [weak self] in
        self?.tableView.scrollToRowIfExists(at: indexPath, at: .bottom, animated: true)
      }
      
      presenter.handleEditDescriptionTextChangedAt(indexPath, text: text)
    case .beginEditing:
      tableView.scrollToRowIfExists(at: indexPath, at: .bottom, animated: true)
    }
    
  }
  
  fileprivate func selectLocation(_ cell: PostsFeedLocationTableViewCell) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    presenter.handleLocationSelectionActionAt(indexPath)
  }
  
  
  fileprivate func selectCommentAction(_ cell: PostsFeedCommentTableViewCell) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    presenter.handleCommentSelectionActionAt(indexPath)
  }
  
  fileprivate func selectTagAction(_ cell: PostsFeedTagsContainerTableViewCell, tagIndexPath: IndexPath) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    presenter.handleTagSelectionActionAt(indexPath, tagIndexPath: tagIndexPath)
  }
  
  fileprivate func addCommentActionHandler(_ cell: PostsFeedAddCommentTableViewCell, action: PostsFeed.AddCommentActions) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    switch action {
    case .changeText(let text):
      scrollToBottomDelayObject.cancel()
      scrollToBottomDelayObject.scheduleAfter(delay: 0.3) { [weak self] in
        self?.tableView.scrollToRowIfExists(at: indexPath, at: .bottom, animated: true)
      }
      presenter.handleAddCommentTextChangedAt(indexPath, text: text)
    case .postComment(let text):
      presenter.handleCommentPostingActionAt(indexPath, text: text)
    case .beginEditing:
      tableView.scrollToRowIfExists(at: indexPath, at: .bottom, animated: true)
    }
  }
  
  fileprivate func showAllCommentsAction(_ cell: PostsFeedAllCommentsActionTableViewCell) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    presenter.handleShowAllCommentsActionAt(indexPath)
    
  }
  
  fileprivate func handlePostingItemAction(_ cell: UITableViewCell, action: PostsFeed.PostsFeedActionsType)  {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    switch action {
    case .upvote:
      presenter.handleLikeActionAt(indexPath)
    case .upvoteInPlace:
      presenter.handleLikeInPlaceActionAt(indexPath)
    case .comment:
      presenter.handleShowAllCommentsActionAt(indexPath)
    case .shop:
      break
    case .favorites:
      presenter.handleFavoritesActionAt(indexPath)
    case .upvotedUsers:
      presenter.handleUpvotedUsersActionAt(indexPath)
    case .help:
      presenter.handleHelpActionAt(indexPath)
    }
  }
  
  fileprivate func handleUserSectionItemAction(_ cell: PostsFeedUserTableViewCell, action: PostsFeed.UserSectionActions) -> Void {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    switch action {
    case .following:
      presenter.handleFollowActionAt(indexPath)
    case .additional:
      presenter.handleAdditionalActionAt(indexPath)
    case .userProfile:
      presenter.handleUserProfileActionAt(indexPath)
    }
  }
  
  fileprivate func fundingCampaignStatusActionHandler(_ cell: UITableViewCell, action: PostsFeed.FundingCampaignActions) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    switch action {
    case .donate:
      presenter.handleDonateActionAt(indexPath)
    case .showCampaign:
      presenter.handleShowCampaignActionAt(indexPath)
    }
  }
  
  fileprivate func fundingCampaignTeamActionHandler(_ cell: PostsFeedFundingCampaignTeamTableViewCell, action: PostsFeed.FundingCampaignTeamActions) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    switch action {
    case .join:
      presenter.handleJoinTeamActionAt(indexPath)
    }
  }
  
  fileprivate func showInvoicePaymentSuccessAlert() {
    let alertController = UIAlertController(title: PostsFeed.Strings.Alerts.invoicePaymentSuccessAlertTitle.localize(), message: PostsFeed.Strings.Alerts.invoicePaymentSuccessAlertMessage.localize(), safelyPreferredStyle: .alert)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    let ok = UIAlertAction(title: PostsFeed.Strings.Alerts.okAction.localize(), style: .default) {(action) in
      
    }
    
    alertController.addAction(ok)
    
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
  
  fileprivate func showDonationPaymentSuccessAlert() {
    let ok = UIAlertAction(title: PostsFeed.Strings.Alerts.okAction.localize(), style: .default) {(action) in
      
    }
    
    let actions: [UIAlertAction] = [ok]
    
    showAlertWith(PostsFeed.Strings.Alerts.donationPaymentSuccessAlertTitle.localize(),
                  message: PostsFeed.Strings.Alerts.donationPaymentSuccessAlertMessage.localize(), actions: actions, preferredStyle: .alert)
  }
  
  fileprivate func showConfirmInvoiceAlertWithMessage(_ message: String) {
    let alertController = UIAlertController(title: nil, message: message, safelyPreferredStyle: .alert)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    let buy = UIAlertAction(title: PostsFeed.Strings.Alerts.okAction.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleConfirmCurrentInvoiceAction()
    }
    
    let cancel = UIAlertAction(title: PostsFeed.Strings.Alerts.cancelAction.localize(), style: .cancel) { [weak self] (action) in
      self?.presenter.handleCancelCurrentInvoiceAction()
    }
    
    alertController.addAction(buy)
    alertController.addAction(cancel)
    
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
  
  fileprivate func presentPostDeleteAlert() {
    let alertController = UIAlertController(title: nil, message: PostsFeed.Strings.Alerts.deletePostAlertMessage.localize(), safelyPreferredStyle: .alert)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    let delete = UIAlertAction(title: PostsFeed.Strings.Alerts.deleteAction.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleCurrentItemDeletePostAction()
    }
    
    let cancel = UIAlertAction(title: PostsFeed.Strings.Alerts.cancelAction.localize(), style: .cancel) {(action) in
      
    }
    
    alertController.addAction(delete)
    alertController.addAction(cancel)
    
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
  
  fileprivate func presentMyPromotedPostingOptionsActionSheet(_ actions: [PostsFeed.PromotionEventsActions]) {
    
    var alertActions: [UIAlertAction] = actions.map {
      switch $0 {
      case .pause:
        let pause = UIAlertAction(title: PostsFeed.Strings.Alerts.PromotionActions.pause.localize(), style: .default) { [weak self] (action) in
          self?.presenter.handleCurrentItemPausePromotionAction()
        }
        
        return pause
      case .resume:
        let resume = UIAlertAction(title: PostsFeed.Strings.Alerts.PromotionActions.resume.localize(), style: .default) { [weak self] (action) in
          self?.presenter.handleCurrentItemResumePromotionAction()
        }
        return resume
      case .close:
        let close = UIAlertAction(title: PostsFeed.Strings.Alerts.PromotionActions.close.localize(), style: .default) { [weak self] (action) in
          self?.presenter.handleCurrentItemStopPromotionAction()
        }
        
        return close
      case .insight:
        let insights = UIAlertAction(title: PostsFeed.Strings.Alerts.PromotionActions.insight.localize(), style: .default) { [weak self] (action) in
          self?.presenter.handleCurrentItemShowInsightAction()
        }
        
        return insights
      }
    }
    
    let cancel = UIAlertAction(title: PostsFeed.Strings.Alerts.cancelAction.localize(), style: .cancel) { (action) in
      
    }
    
    alertActions.append(cancel)
    
    
    showAlertWith(nil, message: nil, actions: alertActions, preferredStyle: .actionSheet)
  }
  
  func showMyFundingControlsActionSheet() {
    let details = UIAlertAction(title: PostsFeed.Strings.Alerts.FundingActions.details.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleCurrentItemShowFundingDetailsAction()
    }
    
    let donators = UIAlertAction(title: PostsFeed.Strings.Alerts.FundingActions.donators.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleCurrentItemShowFundingDonatorsAction()
    }
    
    let cancel = UIAlertAction(title: PostsFeed.Strings.Alerts.cancelAction.localize(), style: .cancel) { (action) in
    }
    
    let alertActions: [UIAlertAction] = [donators, details, cancel]
    
    showAlertWith(nil, message: nil, actions: alertActions, preferredStyle: .actionSheet)
  }
  
  
  fileprivate func presentMyPostingOptionsActionSheet() {
    let alertController = UIAlertController(title: nil, message: nil, safelyPreferredStyle: .actionSheet)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    let editCaption = UIAlertAction(title: PostsFeed.Strings.Alerts.editCaptionAction.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleCurrentItemEditPostCaptionAction()
    }
    
    let editTags = UIAlertAction(title: PostsFeed.Strings.Alerts.editTagsAction.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleCurrentItemEditPostTagsAction()
    }
    
    let share = UIAlertAction(title: PostsFeed.Strings.Alerts.shareAction.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleCurrentItemShareAction()
    }
    
    
    let viewEngagement = UIAlertAction(title: PostsFeed.Strings.Alerts.viewEngagement.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleCurrentItemShowEngagementAction()
    }
    
    let delete = UIAlertAction(title: PostsFeed.Strings.Alerts.deleteAction.localize(), style: .destructive) { [weak self] (action) in
      //      self?.presentPostDeleteAlert()
      self?.presenter.handleCurrentItemDeletePostCheckFundsAction()
    }
    
    let cancel = UIAlertAction(title: PostsFeed.Strings.Alerts.cancelAction.localize(), style: .cancel) { (action) in
      
    }
    
    alertController.addAction(editCaption)
    alertController.addAction(editTags)
    alertController.addAction(share)
    alertController.addAction(viewEngagement)
    alertController.addAction(delete)
    alertController.addAction(cancel)
    
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
  
  fileprivate func presentPostingOptionsActionSheet(_ vm: PostsFeedUserViewModelProtocol) {
    let alertController = UIAlertController(title: nil, message: nil, safelyPreferredStyle: .actionSheet)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    let share = UIAlertAction(title: PostsFeed.Strings.Alerts.shareAction.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleCurrentItemShareAction()
    }
    
    let copyLink = UIAlertAction(title: PostsFeed.Strings.Alerts.copyLink.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleCurrentItemCopyLinkAction()
    }
    
    let turnOnNotification = UIAlertAction(title: PostsFeed.Strings.Alerts.turnOnNotificationAction.localize(), style: .default) { (action) in
      
    }
    
    let report = UIAlertAction(title: PostsFeed.Strings.Alerts.reportAction.localize(), style: .destructive) { [weak self] (action) in
      self?.presenter.handleCurrentItemReportAction()
    }
    
    let mute = UIAlertAction(title: vm.muteActionTitle, style: .destructive) { [weak self] (action) in
      self?.presenter.handleCurrentItemMuteAction()
    }
    
    let cancel = UIAlertAction(title: PostsFeed.Strings.Alerts.cancelAction.localize(), style: .cancel) { (action) in
      
    }
    
    alertController.addAction(share)
    alertController.addAction(copyLink)
    alertController.addAction(turnOnNotification)
    alertController.addAction(report)
    alertController.addAction(mute)
    alertController.addAction(cancel)
    
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
}

//MARK:- KeyboardNotificationsDelegateProtocol

extension PostsFeedBaseContentViewController: KeyboardNotificationsDelegateProtocol {
  @objc func keyBoardWillShowWithBottomInsets(_ bottomInsets: CGFloat, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    tableView.contentInset.bottom = 0.0
    mainFeedBottomConstraint.constant = bottomInsets
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
  
  @objc  func keyBoardWillHide(animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    tableView.contentInset.bottom = UIConstants.bottomContentOffset
    mainFeedBottomConstraint.constant = 0.0
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
}

extension PostsFeedBaseContentViewController: UIGestureRecognizerDelegate {
  
  
  @objc func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    
    if gestureRecognizer == pinch && otherGestureRecognizer == pan {
      return true
    }
    
    if gestureRecognizer == pan && otherGestureRecognizer == pinch {
      return true
    }
    
    if gestureRecognizer == pinch || otherGestureRecognizer == pinch {
      return false
    }
    
    if gestureRecognizer == tap || otherGestureRecognizer == tap {
      return false
    }
    
//    if gestureRecognizer == pan || otherGestureRecognizer == pan {
//      return false
//    }
    
    return true
  }
  
//  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//    return true
//  }
  
  
  @objc func pinch(sender: UIPinchGestureRecognizer) {
    switch sender.state {
    case .possible:
      break
    case .began:
      let location = sender.location(in: tableView)
      guard let indexPath = tableView.indexPathForRow(at: location) else {
        return
      }
      
      guard let cell = tableView.cellForRow(at: indexPath) as? PostsFeedContentContainerTableViewCell,
        let vm = cell.currentVisibleContentItemViewModel() else {
          return
      }
      
      
      let rect = tableView.rectForRow(at: indexPath)
      let convertedRect = tableView.convert(rect, to: view)
      contentOverlayView.backgroundColor = UIColor.white
      contentOverlayView.frame = rect
      tableView.addSubview(contentOverlayView)
      
      zoomingView.setViewModel(vm, initialFrame: convertedRect)
      view.addSubview(zoomingView)
      
      let currentScale = zoomingView.frame.size.width / zoomingView.bounds.size.width
      let newScale = currentScale * sender.scale
      isZooming = newScale > 1
      
    case .changed:
      let viewToTransform = zoomingView
      
      let pinchCenter = CGPoint(x: sender.location(in: viewToTransform).x - viewToTransform.bounds.midX,
                                y: sender.location(in: viewToTransform).y - viewToTransform.bounds.midY)
      
      
      let currentScale = viewToTransform.frame.size.width / viewToTransform.bounds.size.width
      var newScale = currentScale * sender.scale
      
      guard newScale > 1 else {
        newScale = 1
        let transform = CGAffineTransform(scaleX: newScale, y: newScale)
        viewToTransform.transform = transform
        sender.scale = 1
        return
      }
      
      guard newScale < 2.5 else {
        newScale = 2
        let transform = viewToTransform.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
          .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
        viewToTransform.transform = transform
        sender.scale = 1
        return
      }
      
      let transform = viewToTransform.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
        .scaledBy(x: sender.scale, y: sender.scale)
        .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
      viewToTransform.transform = transform
      sender.scale = 1
    case .ended, .cancelled, .failed:
      let center = zoomingViewOriginalCenter ?? zoomingView.center
      
      let location = view.convert(center, to: tableView)
      guard let indexPath = tableView.indexPathForRow(at: location) else {
        return
      }
      
      guard let _ = tableView.cellForRow(at: indexPath) as? PostsFeedContentContainerTableViewCell else {
        return
      }
      
      isZooming = false
      UIView.animate(withDuration: 0.3, animations: { [weak self] in
        self?.zoomingView.transform = CGAffineTransform.identity
        self?.zoomingView.center = center
        self?.zoomingView.alpha = 0.0
        self?.contentOverlayView.alpha = 0.0
        }, completion: { [weak self] _ in
          self?.zoomingView.alpha = 1.0
          self?.contentOverlayView.alpha = 1.0
          self?.zoomingView.removeFromSuperview()
          self?.contentOverlayView.removeFromSuperview()
      })
    }
  }
  
  @objc func tap(sender: UITapGestureRecognizer) {
    presenter.handleTap()
    
    guard presenter.isWalletPreviewPresented else {
      return
    }
    
    presenter.handleWalletAction()
  }
  
  @objc func longPress(sender: UILongPressGestureRecognizer) {
    switch sender.state {
    case .possible:
      break
    case .began:
      let location = sender.location(in: tableView)
      guard let indexPath = tableView.indexPathForRow(at: location) else {
        return
      }
      
      guard let cell = tableView.cellForRow(at: indexPath) as? PostsFeedContentContainerTableViewCell,
        let mediaItemIndex = cell.currentVisibleContentItemIndex() else {
          return
      }
      
      
      presenter.handleZoomActionAt(indexPath, mediaItemIndex: mediaItemIndex)
    case .changed, .ended, .cancelled, .failed:
      break
      
    }
  }
  
  @objc func pan(sender: UIPanGestureRecognizer) {
    switch sender.state {
    case .possible:
      break
    case .began:
      guard isZooming else {
        break
      }
      if isZooming {
        zoomingViewOriginalCenter = zoomingView.center
      }
    case .changed:
      guard isZooming else {
        break
      }
      
      let translation = sender.translation(in: view)
      zoomingView.center = CGPoint(x: zoomingView.center.x + translation.x,
                                   y: zoomingView.center.y + translation.y)
    case .ended:
      break
    case .cancelled:
      break
    case .failed:
      break
    }
    
    sender.setTranslation(CGPoint.zero, in: sender.view)
  }
}

extension PostsFeedBaseContentViewController: EmbedableViewController {
  func setBouncingEnabled(_ enabled: Bool) {
    tableView.bounces = enabled
    tableView.alwaysBounceVertical = enabled
  }
  
  var contentSize: CGSize {
    return tableView.contentSize
  }
  
  func setScrollingEnabled(_ enabled: Bool) {
    tableView.isScrollEnabled = enabled
  }
}

fileprivate enum UIConstants {
  static let bottomContentOffset: CGFloat = 60
  
  enum Colors {
    static let upvotesUsersViewBorder = UIColor.gray227
  }
  
  enum CornerRadius {
    static let upvotesUsersView: CGFloat = 8.0
    static let walletPreviewView: CGFloat = 8.0
  }
  
  enum ShadowsOpacity {
    static let upvotesUsersView: Float = 0.5
    static let walletPreviewView: Float = 0.5
  }
  
  static let upvotesUsersViewOffset: CGFloat = 15.0
  
  enum itemCellsEstimatedHeights {
    static let user: CGFloat = 70.0
    static let actions: CGFloat = 50.0
    static let description: CGFloat = 100.0
    static let postingDate: CGFloat = 35.0
    static let tags: CGFloat = 40.0
    static let comment: CGFloat = 25.0
    static let showAllComments: CGFloat = 31.0
    static let addComment: CGFloat = 59.0
    static let location: CGFloat = 25.0
    
    static let fundingCampaignTitle: CGFloat = 40.0
    static let fundingCampaignStatus: CGFloat = 50.0
    static let fundingCampaignTeam: CGFloat = 40.0
    
    static let promotionStatus: CGFloat = 30.0
    static let addPromotion: CGFloat = 40.0
    
    
    static let editDescription: CGFloat = 50
    static let uploadPlaceholder: CGFloat = 50
    static let commecialInfo: CGFloat = 40
    static let commecialPostError: CGFloat = 50
    static let goodsInfo: CGFloat = 40
  }
}
