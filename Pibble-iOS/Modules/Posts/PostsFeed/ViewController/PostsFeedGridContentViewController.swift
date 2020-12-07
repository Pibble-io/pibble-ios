//
//  PostsFeedGridContentViewController.swift
//  Pibble
//
//  Created by Kazakov Sergey on 23.11.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

class PostsFeedGridContentViewController: ViewController {
  @IBOutlet weak var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupLayout()
    reloadData()
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
fileprivate extension PostsFeedGridContentViewController {
  var presenter: PostsFeedPresenterApi {
    return _presenter as! PostsFeedPresenterApi
  }
}

//MARK: - PostsFeedView API
extension PostsFeedGridContentViewController: PostsFeedViewControllerApi {
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
  
  //not supported
  func showConfirmGoodsOrderAlert(_ title: String) {
    
  }
  
  //not supported
  func setTopHeaderViewModel(_ vm: PostsFeedHomeTopGroupsHeaderViewModelProtocol?, animated: Bool) {
    
  }
    
  //not supported
  func showResumePromotionAlert() {  }
  
  //not supported
  func showPausePromotionAlert() {  }
  
  //not supported
  func showClosePromotionAlert() {  }
  
  //not supported
  func showMyPostingPromotionOptionsActionSheet(_ actions: [PostsFeed.PromotionEventsActions]) { }
  
  //no placeholder
  func showPlaceholder(_ vm: PostsFeedItemsPlaceholderProtocol?, animated: Bool) {  }
  
  //showReportTypeSelectionAlert is not supported in this viviewControllerew
  func showSpamReportedSuccessAlert() {   }
  
  //showReportTypeSelectionAlert is not supported in this viviewControllerew
  func showReportTypeSelectionAlert() {  }
  
  //showPostDeleteAlertWith is not supported in this viewController
  func showPostDeleteAlertWith(_ title: String, message: String, canBeDeleted: Bool) {  }
  
  //presentInvoicePaymentSuccessAlert  is not supported in this viewControlleris not
  func presentPurchaseSuccessAlert() {  }
  
  //showConfirmInvoiceAlert  is not supported in this viewControlleris not
  func showConfirmInvoiceAlert(_ title: String) {  }
  
  //badges is not supported in this viewController
  func setBadges(notificationBadge: String?, walletBadge: String?) { }
  
  //editing is not supported in this viewController
  func showLocationOptionsActionSheet() {   }
   
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
  
  func setFetchingFinished() {  }
  
  func setFetchingStarted() {  }
  
  func scrollToTop(animated: Bool) { }
  
  
  func setUpvoteUsersContainerPresentation(_ hidden: Bool, forIndexPath: IndexPath?, animated: Bool) {  }
  
  func setWalletPreviewContainerPresentation(_ hidden: Bool, animated: Bool) { }
  
  var upvoteUsersContainerView: UIView {
    return UIView()
  }
  
  var walletContainerView: UIView {
    return UIView()
  }
}


extension PostsFeedGridContentViewController {
  fileprivate func setupView() {
    collectionView.registerCell(PostsFeedGridItemContentCollectionViewCell.self)
    
    collectionView.delegate = self
    collectionView.dataSource = self
   
    collectionView.prefetchDataSource = self
    collectionView.isPrefetchingEnabled = true
  }
  
  func setupLayout() {
    view.clipsToBounds = true
  }
}

extension PostsFeedGridContentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return UIConstants.Grid.mediaColumnsInnerSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return UIConstants.Grid.mediaColumnsInnerSpacing
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return mediaItemSize
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return presenter.numberOfSections()
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return presenter.numberOfItemsInSection(section)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(cell: PostsFeedGridItemContentCollectionViewCell.self, for: indexPath)
    guard let viewModel = presenter.itemViewModelAt(indexPath) else {
      return UICollectionViewCell()
    }
    
    switch viewModel {
    case .user(_):
      fatalError("Unsuppored ViewModel")
    case .content(let vm):
      cell.setViewModel(vm)
      return cell
    case .actions(_):
      fatalError("Unsuppored ViewModel")
    case .location(_):
      fatalError("Unsuppored ViewModel")
    case .description(_):
      fatalError("Unsuppored ViewModel")
    case .postingDate(_):
      fatalError("Unsuppored ViewModel")
    case .tags(_):
      fatalError("Unsuppored ViewModel")
    case .comment(_):
      fatalError("Unsuppored ViewModel")
    case .showAllComments(_):
      fatalError("Unsuppored ViewModel")
    case .addComment(_):
      fatalError("Unsuppored ViewModel")
    case .fundingCampaignTitle(_):
      fatalError("Unsuppored ViewModel")
    case .fundingCampaignStatus(_):
      fatalError("Unsuppored ViewModel")
    case .fundingCampaignTeam(_):
      fatalError("Unsuppored ViewModel")
    case .promotionStatus(_):
      fatalError("Unsuppored ViewModel")
    case .addPromotion:
      fatalError("Unsuppored ViewModel")
    case .editDescription(_):
      fatalError("Unsuppored ViewModel")
    case .uploading(_):
      fatalError("Unsuppored ViewModel")
    case .commercialInfo(_):
      fatalError("Unsuppored ViewModel")
    case .commercialPostError:
      fatalError("Unsuppored ViewModel")
    case .goodsInfo:
      fatalError("Unsuppored ViewModel")
    }
  }
}

extension PostsFeedGridContentViewController {
  fileprivate var mediaItemSize: CGSize {
    let space = UIConstants.Grid.mediaColumnsInnerSpacing * CGFloat(UIConstants.Grid.numberOfColumns - 1)
    
    let width = (collectionView.bounds.width - space) / CGFloat(UIConstants.Grid.numberOfColumns)
    return CGSize(width: width, height: width)
  }
}

fileprivate enum UIConstants {
  enum Grid {
    static let mediaColumnsInnerSpacing: CGFloat = 2.0
    static let numberOfColumns = 3
  }
}

extension PostsFeedGridContentViewController: EmbedableViewController {
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

extension PostsFeedGridContentViewController: UICollectionViewDataSourcePrefetching {
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    guard isVisible else {
      return
    }
    
    presenter.handlePrefetchItemAt(indexPath)
  }
  
  
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

