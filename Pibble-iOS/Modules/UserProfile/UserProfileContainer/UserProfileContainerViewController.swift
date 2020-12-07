//
//  UserProfileContainerViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.11.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: UserProfileContainerView Class
final class UserProfileContainerViewController: ViewController {
  //MARK:- IBOutlets
  
  @IBOutlet weak var hideButton: UIButton!
  @IBOutlet weak var navBarTitleLabel: UILabel!
  
  @IBOutlet weak var upperSectionView: UIView!
  @IBOutlet weak var bottomSectionView: UIView!
  
  @IBOutlet weak var overlayingView: UIView!
  
  @IBOutlet weak var settingsButton: UIButton!
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var segmentSelectorBackgroundView: UIView!
  
  @IBOutlet var segmentSwitchButton: [UIButton]!
  
  
  @IBOutlet weak var topSectionHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var bottomSectionHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet var segmentSelectorViewZeroWidthConstraints: [NSLayoutConstraint]!
  @IBOutlet var segmentSelectorViewWidthConstraints: [NSLayoutConstraint]!
  
  
  //MARK:- IBActions
  @IBAction func additionalAction(_ sender: Any) {
    presenter.handleAdditionalAction()
  }
  
  @IBAction func segmentSwitchAction(_ sender: UIButton) {
    guard let idx = segmentSwitchButton.index(of: sender) else {
      return
    }
    let selectedSegment = segments[idx]
    setSelectedSegment(selectedSegment)
    presenter.handleSwitchTo(selectedSegment)
  }
  
  fileprivate func setSelectedSegment(_ segment: UserProfileContainer.UserPostsSegments) {
    segments.enumerated().forEach {
      let isSelected = $0.element == segment
      segmentSwitchButton[$0.offset].isSelected = isSelected
    }
  }
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupLayout()
    setupAppearance()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    scrollView.shouldFireContentOffsetChangesNotifications = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    scrollView.shouldFireContentOffsetChangesNotifications = false
  }
  
  
  //MARK:- Overrides
  
  override var shouldHandleSwipeToPopGesture: Bool {
    return true
  }
  
  //MARK:- Properties
  
  
  fileprivate let segments: [UserProfileContainer.UserPostsSegments] = [.grid, .listing, .favorites, .brushed]
  
  weak var bottmoSectionEmbeddableViewController: EmbedableViewController? {
    didSet {
      bottmoSectionEmbeddableViewController?.embedableDelegate = self
      bottmoSectionEmbeddableViewController?.setScrollingEnabled(false)
      bottmoSectionEmbeddableViewController?.setBouncingEnabled(false)
      if let vc = bottmoSectionEmbeddableViewController {
        handleContentSizeChange(vc, contentSize: vc.contentSize)
      }
    }
  }
  
  weak var topSectionEmbeddableViewController: EmbedableViewController? {
    didSet {
      topSectionEmbeddableViewController?.embedableDelegate = self
      topSectionEmbeddableViewController?.setScrollingEnabled(false)
      if let vc = topSectionEmbeddableViewController {
        handleContentSizeChange(vc, contentSize: vc.contentSize)
      }
    }
  }
}

//MARK: - UserProfileContainerView API
extension UserProfileContainerViewController: UserProfileContainerViewControllerApi {
  func setSettingsHidden(_ hidden: Bool) {
    settingsButton.isHidden = hidden
  }
  
  func setOverlayingContainerPresentationHidden(_ hidden: Bool, animated: Bool) {
    let alpha: CGFloat = hidden ? 0.0 : 1.0
    guard animated else {
      overlayingView.isHidden = hidden
      overlayingView.alpha = alpha
      return
    }
    
    if !hidden {
      overlayingView.isHidden = hidden
    }
    
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      self?.overlayingView.alpha = alpha
    }) { [weak self] (_) in
      self?.overlayingView.isHidden = hidden
    }
  }
  
  
  func showCurrentBannedUserActionSheet() {
    let alertController = UIAlertController(title: nil, message: nil, safelyPreferredStyle: .actionSheet)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    let logout = UIAlertAction(title: UserProfileContainer.Strings.logout.localize(), style: .destructive) { [weak self] (action) in
      self?.presenter.handleLogout()
    }
    
    let cancel = UIAlertAction(title: UserProfileContainer.Strings.cancelAction.localize(), style: .cancel) { (action) in
      
    }
    
    alertController.addAction(logout)
    alertController.addAction(cancel)
    
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
  
  
  func showMyActionSheet() {
    let alertController = UIAlertController(title: nil, message: nil, safelyPreferredStyle: .actionSheet)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    let messageRooms = UIAlertAction(title: UserProfileContainer.Strings.messageRooms.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleChatRoomsAction()
    }
    
    let settings = UIAlertAction(title: UserProfileContainer.Strings.settings.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleSettingsAction()
    }
    
    let cancel = UIAlertAction(title: UserProfileContainer.Strings.cancelAction.localize(), style: .cancel) { (action) in
      
    }
    
    alertController.addAction(messageRooms)
    alertController.addAction(settings)
    alertController.addAction(cancel)
   
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
  
  func showOtherUserActionSheet() {
    let alertController = UIAlertController(title: nil, message: nil, safelyPreferredStyle: .actionSheet)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    let message = UIAlertAction(title: UserProfileContainer.Strings.chat.localize(), style: .default) { [weak self] (action) in
      self?.presenter.handleChatRoomWithUserAction()
    }
    
    let mute = UIAlertAction(title: UserProfileContainer.Strings.mute.localize(), style: .default) { [weak self] (action) in
     self?.presenter.handleMuteUserAction()
    }
    
    let report = UIAlertAction(title: UserProfileContainer.Strings.report.localize(), style: .destructive) { [weak self] (action) in
      self?.presenter.handleReportUserAction()
    }
    
    let cancel = UIAlertAction(title: UserProfileContainer.Strings.cancelAction.localize(), style: .cancel) { (action) in
      
    }
    
    alertController.addAction(message)
    alertController.addAction(mute)
    alertController.addAction(report)
    alertController.addAction(cancel)
    
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
  
  fileprivate func showBuyCurrentItemActionSheet() {
    
  }
  
  func scrollToTop() {
    scrollView.setContentOffset(CGPoint.zero, animated: true)
  }
  
  func setSegmentSelected(_ segment: UserProfileContainer.UserPostsSegments) {
    setSelectedSegment(segment)
  }
  
  func setSegmentEnabled(_ segment: UserProfileContainer.UserPostsSegments, enabled: Bool) {
    guard let idx = segments.index(of: segment) else {
      return
    }
    
    segmentSelectorViewZeroWidthConstraints[idx].priority = enabled ? .defaultLow : .defaultHigh
    segmentSelectorViewWidthConstraints[idx].priority = !enabled ? .defaultLow : .defaultHigh
  }
  
  func handleDidScroll(_ viewController: EmbedableViewController, childScrollView: UIScrollView) {
    
  }
  
  func setNavigationBarTitle(_ title: String) {
    navBarTitleLabel.text = title
  }
  
  func handleContentSizeChange(_ viewController: EmbedableViewController, contentSize: CGSize) {
    if viewController.isEqual(topSectionEmbeddableViewController) {
      topSectionHeightConstraint.constant = max(contentSize.height, 1.0)
      if isVisible {
        UIView.animate(withDuration: 0.2) { [weak self] in
          self?.view.layoutIfNeeded()
        }
      } else{
        view.layoutIfNeeded()
      }
    }
    
    if viewController.isEqual(bottmoSectionEmbeddableViewController) {
      let currentHeight = bottomSectionHeightConstraint.constant
      let contentHeight = max(contentSize.height, 1.0)
      let updatedHeight = min(max(currentHeight, 0), contentHeight)
      if !currentHeight.isEqual(to: updatedHeight) {
        bottomSectionHeightConstraint.constant = updatedHeight
        view.layoutIfNeeded()
      }
    }
  }
  
  var topSectionContainerView: UIView? {
    return upperSectionView
  }
  
  var bottomSectionContainerView: UIView? {
    return bottomSectionView
  }
  
  var overlayingSectionContainerView: UIView {
    return overlayingView
  }
}

// MARK: - UserProfileContainerView Viper Components API
fileprivate extension UserProfileContainerViewController {
  var presenter: UserProfileContainerPresenterApi {
    return _presenter as! UserProfileContainerPresenterApi
  }
}

extension UserProfileContainerViewController {
  fileprivate func setupView() {
    scrollView.delegate = self
    scrollView.bounces = true
    
    bottomSectionView.clipsToBounds = false
  }
  
  fileprivate func setupAppearance() {
    let pushed = (navigationController?.viewControllers.count ?? 0 > 1)
    hideButton.isHidden = !pushed
    scrollView.contentInset.bottom = pushed ? 0.0 : 50.0
  }
  
  fileprivate func setupLayout() {
    topSectionHeightConstraint.constant = scrollView.bounds.height
    bottomSectionHeightConstraint.constant = scrollView.bounds.height / 2
  }
}

extension UserProfileContainerViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let scrolledToBottom = scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom)

    if scrolledToBottom {
      segmentSelectorBackgroundView.isHidden = false
      let currentheight = bottomSectionHeightConstraint.constant
      let contentHeight = bottmoSectionEmbeddableViewController?.contentSize.height ?? 0
      let pageSize = scrollView.bounds.height
      if contentHeight - currentheight > pageSize {
        bottomSectionHeightConstraint.constant += pageSize
      } else {
        bottomSectionHeightConstraint.constant = contentHeight
      }
    }
  }
}
