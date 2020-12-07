//
//  SearchResultDetailContainerViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 27.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: SearchResultDetailContainerViewController Class
final class SearchResultDetailContainerViewController: ViewController {
  //MARK:- IBOutlets
  
  @IBOutlet weak var contentStackView: UIStackView!
  @IBOutlet weak var hideButton: UIButton!
  @IBOutlet weak var navBarTitleLabel: UILabel!
  
  @IBOutlet weak var upperSectionView: UIView!
  
  @IBOutlet weak var bottomSectionView: UIView!
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var segmentSelectorBackgroundView: UIView!
  
  @IBOutlet var segmentSwitchButton: [UIButton]!
  
  @IBOutlet weak var topSectionHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomSectionHeightConstraint: NSLayoutConstraint!
  
  //MARK:- IBActions
  @IBAction func segmentSwitchAction(_ sender: UIButton) {
    guard let idx = segmentSwitchButton.index(of: sender) else {
      return
    }
    let selectedSegment = segments[idx]
    setSelectedSegment(selectedSegment)
    presenter.handleSwitchTo(selectedSegment)
  }
  
  fileprivate func setSelectedSegment(_ segment: SearchResultDetailContainer.PostsSegments) {
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
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
  
  
  fileprivate let segments: [SearchResultDetailContainer.PostsSegments] = [.grid, .listing]
  
  weak var bottmoSectionEmbeddableViewController: EmbedableViewController? {
    didSet {
      bottmoSectionEmbeddableViewController?.embedableDelegate = self
      bottmoSectionEmbeddableViewController?.setScrollingEnabled(false)
      bottmoSectionEmbeddableViewController?.setBouncingEnabled(false)
      if let vc = bottmoSectionEmbeddableViewController {
        handlePreferredContentSizeDidChange(vc, contentSize: vc.contentSize)
      }
    }
  }
  
  weak var topSectionEmbeddableViewController: EmbedableViewController? {
    didSet {
      topSectionEmbeddableViewController?.embedableDelegate = self
      topSectionEmbeddableViewController?.setScrollingEnabled(false)
      if let vc = topSectionEmbeddableViewController {
        handlePreferredContentSizeDidChange(vc, contentSize: vc.contentSize)
      }
    }
  }
  
  
  override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
    super.preferredContentSizeDidChange(forChildContentContainer: container)
    if let topSectionEmbeddableViewController = topSectionEmbeddableViewController, container.isEqual(topSectionEmbeddableViewController) {
      handlePreferredContentSizeDidChange(topSectionEmbeddableViewController, contentSize: container.preferredContentSize)
    }
    
    if let bottmoSectionEmbeddableViewController = bottmoSectionEmbeddableViewController, container.isEqual(bottmoSectionEmbeddableViewController) {
      handlePreferredContentSizeDidChange(bottmoSectionEmbeddableViewController, contentSize: container.preferredContentSize)
    }
  }
}

//MARK: - SearchResultDetailContainerView API
extension SearchResultDetailContainerViewController: SearchResultDetailContainerViewControllerApi {
  func handlePreferredContentSizeDidChange(_ container: EmbedableViewController, contentSize: CGSize) {
    if container.isEqual(topSectionEmbeddableViewController) {
      topSectionHeightConstraint.constant = contentSize.height
      if isVisible {
        UIView.animate(withDuration: 0.3) { [weak self] in
          self?.contentStackView.layoutIfNeeded()
          self?.segmentSelectorBackgroundView.alpha = 1.0
        }
      } else {
        segmentSelectorBackgroundView.alpha = 1.0
        contentStackView.layoutIfNeeded()
      }
    }
    
    if container.isEqual(bottmoSectionEmbeddableViewController) {
      let currentheight = bottomSectionHeightConstraint.constant
      let contentHeight = bottmoSectionEmbeddableViewController?.contentSize.height ?? 0
      let pageSize = scrollView.bounds.height
      if contentHeight - currentheight > pageSize {
        bottomSectionHeightConstraint.constant += pageSize
        contentStackView.layoutIfNeeded()
      } else {
        bottomSectionHeightConstraint.constant = pageSize
        contentStackView.layoutIfNeeded()
      }
      
    }
  }
  
  func handleContentSizeChange(_ viewController: EmbedableViewController, contentSize: CGSize) {
     
  }
 
  func scrollToTop() {
    scrollView.setContentOffset(CGPoint.zero, animated: true)
  }
  
  func setSegmentSelected(_ segment: SearchResultDetailContainer.PostsSegments) {
    setSelectedSegment(segment)
  }
  
  func handleDidScroll(_ viewController: EmbedableViewController, childScrollView: UIScrollView) {
    
  }
  
  func setNavigationBarTitle(_ title: String) {
    navBarTitleLabel.text = title
  }
  /*
  func handleContentSizeChange(_ viewController: EmbedableViewController, contentSize: CGSize) {
    if viewController.isEqual(topSectionEmbeddableViewController) {
      topSectionHeightConstraint.constant = contentSize.height
      if isVisible {
        UIView.animate(withDuration: 0.2) { [weak self] in
          self?.view.layoutIfNeeded()
          self?.segmentSelectorBackgroundView.alpha = 1.0
        }
      } else {
        segmentSelectorBackgroundView.alpha = 1.0
        view.layoutIfNeeded()
      }
    }
    
    if viewController.isEqual(bottmoSectionEmbeddableViewController) {
      let currentheight = bottomSectionHeightConstraint.constant
      let contentHeight = bottmoSectionEmbeddableViewController?.contentSize.height ?? 0
      let pageSize = scrollView.bounds.height
      if contentHeight - currentheight > pageSize {
        bottomSectionHeightConstraint.constant += pageSize
        view.layoutIfNeeded()
      } else {
        bottomSectionHeightConstraint.constant = contentHeight
        view.layoutIfNeeded()
      }
    }
  }*/
  
  var topSectionContainerView: UIView {
    return upperSectionView
  }
  
  var bottomSectionContainerView: UIView {
    return bottomSectionView
  }
}

// MARK: - UserProfileContainerView Viper Components API
fileprivate extension SearchResultDetailContainerViewController {
  var presenter: SearchResultDetailContainerPresenterApi {
    return _presenter as! SearchResultDetailContainerPresenterApi
  }
}

extension SearchResultDetailContainerViewController {
  fileprivate func setupView() {
    scrollView.delegate = self
    scrollView.bounces = true
    bottomSectionView.clipsToBounds = false
  }
  
  fileprivate func setupAppearance() {
    let pushed = (navigationController?.viewControllers.count ?? 0 > 1)
    hideButton.isHidden = !pushed
    scrollView.contentInset.bottom = pushed ? 0.0 : 50.0
    
    contentStackView.layer.shouldRasterize = true
    contentStackView.layer.rasterizationScale = UIScreen.main.scale
    
//    segmentSelectorBackgroundView.alpha = 0.0
  }
  
  fileprivate func setupLayout() {
    topSectionHeightConstraint.constant = scrollView.bounds.height
    bottomSectionHeightConstraint.constant = scrollView.bounds.height
  }
}

extension SearchResultDetailContainerViewController: UIScrollViewDelegate {
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
