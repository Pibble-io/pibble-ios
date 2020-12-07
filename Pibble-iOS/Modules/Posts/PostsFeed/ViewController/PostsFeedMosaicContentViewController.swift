//
//  PostsFeedMosaicContentViewController.swift
//  Pibble
//
//  Created by Kazakov Sergey on 20.12.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class PostsFeedMosaicGridContentViewController: ViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupLayout()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    collectionView.shouldFireContentOffsetChangesNotifications = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    collectionView.shouldFireContentOffsetChangesNotifications = false
  }
  
  
  //MARK:- Private properties
  
  fileprivate var batchUpdates: [CollectionViewModelUpdate] = []
  fileprivate let refreshControl = UIRefreshControl()
  
  //MARK:- Delegates
  
  weak var embedableDelegate: EmbedableViewControllerDelegate?
  
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
}

// MARK: - PostsFeedView Viper Components API
fileprivate extension PostsFeedMosaicGridContentViewController {
  var presenter: PostsFeedPresenterApi {
    return _presenter as! PostsFeedPresenterApi
  }
}

//MARK: - PostsFeedView API
extension PostsFeedMosaicGridContentViewController: PostsFeedViewControllerApi {
  //not supported
  func showConfirmPostHelpCreationOrderAlert(_ title: String) {
    
  }
  
  //not supported
  func presentStopFundingConfirmAlert() {
    
  }
  
  //not supported
  func presentStopFundingSuccessAlert() {
    
  }
  
   //not supported
  func presentDonationSuccessAlert() {
    
  }
  
  //not supported
  func showMyFundingControlsActionSheet() {
    
  }
  
  //showSpamReportedSuccessAlert  is not supported in this viewController
  func showConfirmGoodsOrderAlert(_ title: String) {  }
  
  //not supported
  func setTopHeaderViewModel(_ vm: PostsFeedHomeTopGroupsHeaderViewModelProtocol?, animated: Bool) {  }
  
  //not supported
  func showResumePromotionAlert() {  }
  
  //not supported
  func showPausePromotionAlert() {  }
  
  //not supported
  func showClosePromotionAlert() {  }
  
  //not supported
  func showMyPostingPromotionOptionsActionSheet(_ actions: [PostsFeed.PromotionEventsActions]) { }
  
  //placeholder is not supported
  func showPlaceholder(_ vm: PostsFeedItemsPlaceholderProtocol?, animated: Bool) {  }
  
  //showSpamReportedSuccessAlert  is not supported in this viewController
  func showSpamReportedSuccessAlert() {  }
  
  //showReportTypeSelectionAlert is not supported in this viviewControllerew
  func showReportTypeSelectionAlert() { }
  
  //showPostDeleteAlertWith is not supported in this viewController
  func showPostDeleteAlertWith(_ title: String, message: String, canBeDeleted: Bool) {   }
  
  //presentInvoicePaymentSuccessAlert  is not supported in this viewControlleris not
  func presentPurchaseSuccessAlert() {  }
  
  //showConfirmInvoiceAlert  is not supported in this viewControlleris not
  func showConfirmInvoiceAlert(_ title: String) {  }
  
  //badges is not supported in this viewController
  func setBadges(notificationBadge: String?, walletBadge: String?) {   }
  
  //editing is not supported in this viewController
  func showLocationOptionsActionSheet() {  }
  
  func scrollTo(_ indexPath: IndexPath, animated: Bool) {
    collectionView.scrollToItem(at: indexPath, at: .top, animated: animated)
  }
  
  func updateCollection(_ updates: CollectionViewModelUpdate) {
    if case CollectionViewModelUpdate.reloadData = updates {
      batchUpdates = []
      collectionView.reloadData()
      return
    }
    
    guard case CollectionViewModelUpdate.endUpdates = updates else {
      batchUpdates.append(updates)
      return
    }
    
    let updates = batchUpdates
    collectionView.performBatchUpdates({
      updates.forEach {
        switch $0 {
        case .reloadData:
          break
        case .beginUpdates:
          break
        case .endUpdates:
          break
        case .insert(let idx):
          collectionView.insertItems(at: idx)
        case .delete(let idx):
          collectionView.deleteItems(at: idx)
        case .insertSections(let idx):
          collectionView.insertSections(IndexSet(idx))
        case .deleteSections(let idx):
          collectionView.deleteSections(IndexSet(idx))
        case .updateSections(let idx):
          collectionView.reloadSections(IndexSet(idx))
        case .moveSections(let from, let to):
          collectionView.moveSection(from, toSection: to)
        case .update(let idx):
          collectionView.reloadItems(at: idx)
        case .move(let from, let to):
          collectionView.moveItem(at: from, to: to)
        }
      }
    }) { [weak self] (_) in
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.embedableDelegate?.handleContentSizeChange(strongSelf, contentSize: strongSelf.contentSize)
    }
    
    batchUpdates = []
  }
  
  func reloadData() {
    batchUpdates = []
    collectionView.reloadData()
    collectionView.collectionViewLayout.invalidateLayout()
    
    guard let _ = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
      return
    }
    collectionView.setNeedsLayout()
    collectionView.layoutIfNeeded()
    embedableDelegate?.handleContentSizeChange(self, contentSize: contentSize)
  }
  
  func showMyPostingOptionsActionSheet() { }
  
  func showPostingOptionsActionSheet(_ vm: PostsFeedUserViewModelProtocol) {  }
  
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
    collectionView.setContentOffset(offsetPoint, animated: true)
  }
  
  func scrollToTop(animated: Bool) {
    collectionView.setContentOffset(CGPoint.zero, animated: animated)
  }
  
  func setUpvoteUsersContainerPresentation(_ hidden: Bool, forIndexPath: IndexPath?, animated: Bool) {  }
  
  func setWalletPreviewContainerPresentation(_ hidden: Bool, animated: Bool) { }
  
  var upvoteUsersContainerView: UIView {
    return UIView()
  }
  
  var walletContainerView: UIView {
    return UIView()
  }
}

extension PostsFeedMosaicGridContentViewController {
  @objc fileprivate func pullToRefresh() {
    presenter.handlePullToRefresh()
  }
  
  fileprivate func setupView() {
    collectionView.registerCell(PostsFeedGridItemContentCollectionViewCell.self)
    collectionView.registerCell(PostsFeedGridVideoItemCollectionViewCell.self)
    collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.prefetchDataSource = self
    collectionView.isPrefetchingEnabled = true
    
    collectionView.refreshControl = refreshControl
    
    
    // Configure Refresh Control
    refreshControl.addTarget(self, action: #selector(self.pullToRefresh), for: .valueChanged)
  }
  
  func setupLayout() {
    collectionView?.collectionViewLayout = MosaicGridLayout()
    view.clipsToBounds = true
  }
}

extension PostsFeedMosaicGridContentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    if let videoCell = cell as? PostsFeedGridVideoItemCollectionViewCell {
      videoCell.pause()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard isVisible else {
      return
    }
    
    presenter.handlePrefetchItemAt(indexPath)
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return presenter.numberOfSections()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let viewModel = presenter.itemViewModelAt(indexPath) else {
      return UICollectionViewCell()
    }
    
    switch viewModel {
    case .content(let vm):
      guard let attributes = collectionView.layoutAttributesForItem(at: indexPath),
        mediaItemSize.maxDimension.isLess(than: attributes.bounds.size.minDimension),
        let firstItem = vm.content.first,
        case let .video(videoVM) = firstItem
      else {
        let cell = collectionView.dequeueReusableCell(cell: PostsFeedGridItemContentCollectionViewCell.self, for: indexPath)
        cell.setViewModel(vm)
        return cell
      }
      
      let itemLayout = PostsFeed.ItemLayout(size: attributes.bounds.size)
      let cell = collectionView.dequeueReusableCell(cell: PostsFeedGridVideoItemCollectionViewCell.self, for: indexPath)
      cell.setViewModel(videoVM, layout: itemLayout)
      cell.play()
      return cell
    default:
      fatalError("Unsuppored ViewModel")
    }
  }
}

extension PostsFeedMosaicGridContentViewController {
  fileprivate var mediaItemSize: CGSize {
    let space = UIConstants.Grid.mediaColumnsInnerSpacing * CGFloat(UIConstants.Grid.numberOfColumns - 1)
    
    let width = (collectionView.bounds.width - space) / CGFloat(UIConstants.Grid.numberOfColumns)
    return CGSize(width: width, height: width)
  }
}

fileprivate enum UIConstants {
  enum Grid {
    static let mediaColumnsInnerSpacing: CGFloat = 0.0
    static let numberOfColumns = 3
  }
}

extension PostsFeedMosaicGridContentViewController: EmbedableViewController {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    embedableDelegate?.handleDidScroll(self, childScrollView: scrollView)
  }
  
  func setBouncingEnabled(_ enabled: Bool) {
    collectionView.bounces = enabled
    collectionView.alwaysBounceVertical = enabled
  }
  
  var contentSize: CGSize {
    guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
      return CGSize.zero
    }
    
    return layout.collectionViewContentSize
  }
  
  func setScrollingEnabled(_ enabled: Bool) {
    collectionView.isScrollEnabled = enabled
  }
}

//MARK:- UICollectionViewDataSourcePrefetching

extension PostsFeedMosaicGridContentViewController: UICollectionViewDataSourcePrefetching {
  func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
    indexPaths.forEach {
      presenter.handlePrefetchItemAt($0)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    indexPaths.forEach {
      presenter.handleCancelPrefetchingItem($0)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: false)
    presenter.handleSelectionActionAt(indexPath)
  }
}

extension CGSize {
  fileprivate var maxDimension: CGFloat {
    return max(width, height)
  }
  
  fileprivate var minDimension: CGFloat {
    return min(width, height)
  }
}
