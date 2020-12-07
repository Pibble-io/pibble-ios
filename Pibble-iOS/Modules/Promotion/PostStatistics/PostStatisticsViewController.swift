//
//  PostStatisticsViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 18/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: PostStatisticsView Class
final class PostStatisticsViewController: ViewController {
  
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var stackView: UIStackView!
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  
  @IBOutlet weak var dimView: UIView!
  
   @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var impressionsAmountLabel: UILabel!
  @IBOutlet weak var profileAmountLabel: UILabel!
  
  @IBOutlet weak var amountsView: UIView!
  
  
  @IBOutlet weak var promotionPostCharContainer: UICorneredView!
  
  
  @IBOutlet weak var promotionPostEngagementChartView: PromotionPostStatsChartContainerView!
  
  fileprivate lazy var tapGestureRecognizer: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(tap(sender:)))
    return gesture
  }()
  
  fileprivate lazy var backgroundImageTapGestureRecognizer: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(tap(sender:)))
    return gesture
  }()
  
  fileprivate var scrollViewContentSizeObserver: NSKeyValueObservation?
  
  deinit {
    scrollViewContentSizeObserver = nil
  }
  
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupAppearance()
    setBackgroundImageView()
  }
}

//MARK: - PostStatisticsView API

extension PostStatisticsViewController: PostStatisticsViewControllerApi {
  func setImpressionAmountsViewModel(_ vm: PostStatisticsAmountsViewModelProtocol) {
    impressionsAmountLabel.text = vm.totalImpressionsAmount
    profileAmountLabel.text = vm.profileViewsAmount
  }
  
  func setImpressionAmountsViewModel(_ vm: PostStatisticsAmountsViewModelProtocol?, animated: Bool) {
    let hidden = vm == nil
    let alpha: CGFloat = hidden ? 0.0 : 1.0
    
    if let vm = vm {
      impressionsAmountLabel.text = vm.totalImpressionsAmount
      profileAmountLabel.text = vm.profileViewsAmount
    }
    
    guard animated else {
      amountsView.alpha = alpha
      amountsView.isHidden = hidden
      return
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.amountsView.alpha = alpha
      self?.amountsView.isHidden = hidden
      self?.stackView.layoutIfNeeded()
    }
  }
  
  func setViewModels(_ vms: (amounts: PostStatisticsAmountsViewModelProtocol,
    enagements: PostStatisticsChartContainerViewModelProtocol)?,
                     animated: Bool) {
    
    let isHidden = vms?.amounts == nil || vms?.enagements == nil
    
    setImpressionAmountsViewModel(vms?.amounts, animated: false)
    setEngagementViewModel(vms?.enagements, animated: false)
    stackView.layoutIfNeeded()
    setScrollViewContentHidden(isHidden, animated: animated)
  }
  
  func setEngagementViewModel(_ vm: PostStatisticsChartContainerViewModelProtocol?, animated: Bool) {
    let hidden = vm == nil
    let alpha: CGFloat = hidden ? 0.0 : 1.0
    
    if let vm = vm {
      promotionPostEngagementChartView.setViewModel(vm)
    }
    
    guard animated else {
      promotionPostEngagementChartView.alpha = alpha
      promotionPostEngagementChartView.isHidden = hidden
      return
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.promotionPostEngagementChartView.alpha = alpha
      self?.promotionPostEngagementChartView.isHidden = hidden
      self?.stackView.layoutIfNeeded()
    }
  }
}

// MARK: - PostStatisticsView Viper Components API
fileprivate extension PostStatisticsViewController {
  var presenter: PostStatisticsPresenterApi {
    return _presenter as! PostStatisticsPresenterApi
  }
}

extension PostStatisticsViewController {
  fileprivate func setupAppearance() {
    promotionPostCharContainer.cornersToRound = [.topLeft, .topRight]
    promotionPostCharContainer.radius = 12.0
  }
  
  fileprivate func setupView() {
    scrollView.delegate = self
    scrollView.addGestureRecognizer(tapGestureRecognizer)
    backgroundImageView.isUserInteractionEnabled = true
    backgroundImageView.addGestureRecognizer(backgroundImageTapGestureRecognizer)
    
    scrollViewContentSizeObserver = scrollView.observe(\UIScrollView.contentSize, options: .old) { (object, observedChange) in
      object.contentInset.top = max(0, object.bounds.height - object.contentSize.height)
    }
  }
 
  @objc func tap(sender: UITapGestureRecognizer) {
    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
      self?.setScrollViewContentHidden(true, animated: false)
      self?.view.layoutIfNeeded()
    }) { [weak self] (_) in
      self?.presenter.handleHideAction()
    }
  }
  
  fileprivate func setBackgroundImageView() {
    backgroundImageView.image = presentingViewController?.view.takeSnapshot()
  }
  
  fileprivate func setDimViewHidden(_ hidden: Bool, animated: Bool) {
    let dimViewAlpha: CGFloat = hidden ? 0.0 : 0.1
    
    guard animated else {
      dimView.alpha = dimViewAlpha
      return
    }
    
    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
      self?.dimView.alpha = dimViewAlpha
    }) { (_) in }
  }
  
  fileprivate func setScrollViewContentHidden(_ hidden: Bool, animated: Bool) {
    let offset = hidden ? view.bounds.height : 0.0
    scrollViewTopConstraint.constant = offset
    let dimViewAlpha: CGFloat = hidden ? 0.0 : 0.4
    
    guard animated else {
      dimView.alpha = dimViewAlpha
      return
    }
    
    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
      self?.dimView.alpha = dimViewAlpha
      self?.view.layoutIfNeeded()
    }) { (_) in }
  }
}

extension PostStatisticsViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView.contentOffset.y >= -scrollView.contentInset.top {
      scrollView.contentOffset.y = -scrollView.contentInset.top
    }
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if scrollView.contentOffset.y < -scrollView.bounds.height * 0.3 {
      
      //we won't observe content size anymore, and force set inset as current offset to keep tableview in current state
      scrollViewContentSizeObserver = nil
      scrollView.contentInset.top = abs(scrollView.contentOffset.y)
      scrollView.bounces = false
      scrollView.alwaysBounceVertical = false
      
      UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
        self?.setScrollViewContentHidden(true, animated: false)
        self?.view.layoutIfNeeded()
      }) { [weak self] (_) in
        self?.presenter.handleHideAction()
      }
    }
  }
}
