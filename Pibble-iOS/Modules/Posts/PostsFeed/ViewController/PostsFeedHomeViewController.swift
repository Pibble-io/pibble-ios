//
//  PostsFeedViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 02.08.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: PostsFeedView Class

final class PostsFeedHomeViewController: PostsFeedBaseContentViewController {

  @IBOutlet weak var walletPreviewBackgroundView: UIView!
  
  @IBOutlet weak var walletPreviewContainerView: UIView!
  
  @IBOutlet weak var notificationsBadgeLabel: UILabel!
  
  @IBOutlet weak var walletBadgeLabel: UILabel!
  
  @IBOutlet weak var walletPreviewBackgroundViewTopConstraint: NSLayoutConstraint!

  @IBAction func walletAction(_ sender: Any) {
    presenter.handleWalletAction()
  }
  
  @IBAction func notificationsAction(_ sender: Any) {
    presenter.handleNotificationsAction()
  }
  
  @IBAction func playRoomAction(_ sender: Any) {
    presenter.handlePlayRoomAction()
  }
  
  @IBAction func giftAction(_ sender: Any) {
    presenter.handleGiftAction()
  }
  
  
  //MARK:- Private properties
  
  fileprivate var initialContentOffsetY: CGFloat = 0.0
  
  fileprivate let panInteractionController = PanGestureSlideInteractionController(isRightEdge: true)
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAppearance()
    panInteractionController.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    (tableView.tableHeaderView as? PostsFeedHomeTopGroupsHeaderView)?.animateBannerMessageIfNeeded()
  }
  
  //MARK:- Overrides
  
  override var shouldHandleSwipeToPopGesture: Bool {
    return false
  }
  
//  override func setTopHeaderViewModel(_ vm: PostsFeedHomeTopGroupsHeaderViewModelProtocol?, animated: Bool) {
//    guard let viewModel = vm else {
//      tableView.tableHeaderView = nil
//      return
//    }
//
//    let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 100)
//    let headerView = PostsFeedHomeTopGroupsHeaderView(frame: frame)
//    headerView.setViewModel(viewModel, handler: headerActionsHandler)
//    tableView.setAndLayoutTableHeaderView(header: headerView)
//
//    headerView.alpha = 0.0
//    UIView.animate(withDuration: 0.3) {
//      headerView.alpha = 1.0
//    }
//  }
  
  override func setTopHeaderViewModel(_ vm: PostsFeedHomeTopGroupsHeaderViewModelProtocol?, animated: Bool) {
    guard let viewModel = vm else {
     tableView.tableHeaderView = nil
      return
    }

    guard let header = tableView.tableHeaderView as? PostsFeedHomeTopGroupsHeaderView else {
      let frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 100)
      let headerView = PostsFeedHomeTopGroupsHeaderView(frame: frame)
     
      tableView.tableHeaderView = headerView
      headerView.translatesAutoresizingMaskIntoConstraints = false
      NSLayoutConstraint.activate([
        headerView.widthAnchor.constraint(equalTo: tableView.widthAnchor, multiplier: 1.0),
        headerView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
        headerView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
        headerView.topAnchor.constraint(equalTo: tableView.topAnchor)
        ])
      headerView.alpha = 0.0
      
      UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
        guard let strongSelf = self else{
          return
        }
        
        headerView.setViewModel(viewModel, handler: strongSelf.headerActionsHandler)
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
      }) { [weak self] (_) in
        headerView.animateBannerMessageIfNeeded()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
          self?.tableView.tableHeaderView = headerView
          headerView.alpha = 1.0
        })
      }
      return
    }
  
    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
      guard let strongSelf = self else{
        return
      }
      
      header.setViewModel(viewModel, handler: strongSelf.headerActionsHandler)
      header.setNeedsLayout()
      header.layoutIfNeeded()
      
      
    }) { [weak self] (_) in
      header.animateBannerMessageIfNeeded()
      UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
        self?.tableView.tableHeaderView = header
      })
  
    }
  }
}

//MARK:- Overrides

extension PostsFeedHomeViewController {
  //not supported
  
    
  override var walletContainerView: UIView {
    return walletPreviewContainerView
  }
  
  override func setWalletPreviewContainerPresentation(_ hidden: Bool, animated: Bool) {
    walletPreviewContainerView.roundCorners([.bottomLeft,.bottomRight], radius: UIConstants.CornerRadius.upvotesUsersView)
    let alpha: CGFloat = hidden ? 0.0 : 1.0
    let shadowAlpha: Float = hidden ? 0.0 : UIConstants.ShadowsOpacity.walletPreviewView
    let shadowAlphaInitValue: Float = !hidden ? 0.0 : UIConstants.ShadowsOpacity.walletPreviewView
    walletPreviewBackgroundViewTopConstraint.constant = hidden ? -walletPreviewBackgroundView.bounds.height : 0.0
    guard animated else {
      walletPreviewBackgroundView.alpha = alpha
      walletPreviewBackgroundView.layer.shadowOpacity = shadowAlpha
      view.layoutIfNeeded()
      return
    }
    
    let animation = CABasicAnimation(keyPath: "shadowOpacity")
    animation.fromValue = shadowAlphaInitValue
    animation.toValue = Float(shadowAlpha)
    animation.duration = 0.3
    walletPreviewBackgroundView.layer.add(animation, forKey: animation.keyPath)
    walletPreviewBackgroundView.layer.shadowOpacity = shadowAlpha
    
    if !hidden {
      walletPreviewBackgroundView.alpha = alpha
    }
    
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      guard let strongSelf = self else {
        return
      }
      
      strongSelf.view.layoutIfNeeded()
      }, completion: {  [weak self]  (_) in
        if hidden {
          self?.walletPreviewBackgroundView.alpha = alpha
        }
    })
  }
  
  override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    super.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    
    guard tableView == scrollView else {
      return
    }
    
    guard presenter.isWalletPreviewPresented else {
      return
    }
    
    let offset = max(scrollView.contentOffset.y - initialContentOffsetY, 0.0)
    if abs(offset) > walletPreviewBackgroundView.bounds.height * 0.6 {
      presenter.handleWalletAction()
    } else {
      walletPreviewBackgroundViewTopConstraint.constant = 0.0
      UIView.animate(withDuration: 0.3) { [weak self] in
        self?.view.layoutIfNeeded()
      }
    }
  }
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    super.scrollViewDidScroll(scrollView)
    
    let offset = -max(scrollView.contentOffset.y - initialContentOffsetY, 0.0)
    
    guard presenter.isWalletPreviewPresented, (!scrollView.isDecelerating || scrollView.isTracking) else {
      return
    }
    
    if abs(offset) > walletPreviewBackgroundView.bounds.height * 0.6 {
      presenter.handleWalletAction()
    } else {
      walletPreviewBackgroundViewTopConstraint.constant = offset
      UIView.animate(withDuration: 0.1) { [weak self] in
        self?.view.layoutIfNeeded()
      }
    }
  }
  
  override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    super.scrollViewWillBeginDragging(scrollView)
    initialContentOffsetY = scrollView.contentOffset.y
  }
  
  override func scrollTo(_ indexPath: IndexPath, animated: Bool) {
    //scroll to item is not supported because this view controller is supposed to be embedded in containers
    
    tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
  }
  
  override func pan(sender: UIPanGestureRecognizer) {
    panInteractionController.handleGesture(sender)
    super.pan(sender: sender)
  }
  
  override func setBadges(notificationBadge: String?, walletBadge: String?) {
    super.setBadges(notificationBadge: notificationBadge, walletBadge: walletBadge)
    
    [(notificationBadge, notificationsBadgeLabel), (walletBadge, walletBadgeLabel)].forEach {
      let newText = $0.0 ?? ""
      let hasChange = $0.1?.text != newText
      let shouldShow = $0.0 != nil
      
      $0.1?.text = newText
      $0.1?.alpha = shouldShow ? 1.0 : 0.0
      
      if shouldShow, hasChange, let badgeView = $0.1 {
        animateBadgesZoom(badgeView)
      }
    }
  }
 
 	 override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    
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
    
    if gestureRecognizer == pan || otherGestureRecognizer == pan {
      return false
    }

    return true
  }
}

//MARK:- PanInteractionControllerDelegate

extension PostsFeedHomeViewController: GestureInteractionControllerDelegateProtocol {
  func handlePresentActionWith(_ transition: GestureInteractionController) {
    presenter.handleNotificationsActionWith(transition)
  }
}

//MARK:- Helpers

extension PostsFeedHomeViewController {
  fileprivate func headerActionsHandler(_ view: PostsFeedHomeTopGroupsHeaderView, action: PostsFeed.TopGroupsHeaderActions) {
    switch action {
    case .selectionAt(let indexPath):
      presenter.handleTopGroupSelectionAt(indexPath)
    case .showLeaderboard:
      presenter.handleLeaderbordAction()
    case .showTopBannerInfo:
      presenter.handleTopBannerInfoAction()
    }
  }
  
  fileprivate func animateBadgesZoom(_ viewToAnimate: UIView, duration: TimeInterval = 0.15, scale: CGFloat = 1.25, delay: TimeInterval = 0.0) {
    
    UIView.animate(withDuration: duration,
                   delay: delay,
                   options: .curveLinear,
                   animations: {
                    viewToAnimate.transform = CGAffineTransform(scaleX: scale, y: scale)
    }) { (_) in
      UIView.animate(withDuration: duration, animations: {
        viewToAnimate.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
      }) { (_) in  }
    }
  }
  
  fileprivate func setupAppearance() {
    walletPreviewContainerView.roundCorners([.bottomLeft,.bottomRight], radius: UIConstants.CornerRadius.upvotesUsersView)
    
    walletPreviewBackgroundView.addShadow(shadowColor: UIColor.black,
                                          offSet: CGSize(width: 0, height: 30),
                                          opacity: UIConstants.ShadowsOpacity.walletPreviewView,
                                          radius: 30.0)
    
    [notificationsBadgeLabel, walletBadgeLabel].forEach {
      $0?.alpha = 0.0
      $0?.setCornersToCircle()
    }
  }
}

fileprivate enum UIConstants {
  enum CornerRadius {
    static let upvotesUsersView: CGFloat = 12.0
    static let walletPreviewView: CGFloat = 12.0
  }
  
  enum ShadowsOpacity {
    static let upvotesUsersView: Float = 0.5
    static let walletPreviewView: Float = 0.5
  }
}
