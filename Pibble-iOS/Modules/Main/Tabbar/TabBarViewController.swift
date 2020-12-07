//
//  TabBarModuleView.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 15.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit
import VisualEffectView

//MARK: TabBarModuleView Class
final class TabBarViewController: ViewController {
  //MARK:- IBOutlets
  
  @IBOutlet weak var tabbarView: UIView!
  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var tabbarContainerView: UIView!
  
  @IBOutlet weak var tabBarCenterButton: UIButton!
  @IBOutlet var tabBarItemButtons: [UIButton]!
  @IBOutlet weak var bottomSpaceView: UIView!
  
  @IBOutlet weak var blurView: CurveBlurView!
  @IBOutlet weak var menuCollectionView: UICollectionView!
  
  //MARK:- IBOutlets contraints
  
  @IBOutlet weak var tabbarBottomConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var tabbarbackgroundCompactConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var tabbarbackgroundExtendedConstraint: NSLayoutConstraint!
  //MARK:- IBActions
  
  @IBAction func presentTabBarItemAction(_ sender: UIButton) {
    if let index = tabBarItemButtons.index(of: sender),
      let submodule = TabBar.MainItems(rawValue: index) {
      presenter.handlePresentTabBarItemActionFor(submodule)
    }
  }
  
  @IBAction func menuButtonAction(_ sender: UIButton) {
    presenter.handleMenuButtonAction()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupAppearance()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    blurView.setPath(.initial, animated: false)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    subscribeScrollViewNotications()
    subscribeToViewControllerGlobalNotications()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeScrollViewNotications()
    unsubscribeFromViewControllerGlobalNotications()
  }
  
  //MARK:- Properties
  
  fileprivate var isMenuHidden: Bool = true
  fileprivate var isTabbarHidden: Bool = false
  fileprivate var isTabbarAnimating: Bool = false
}

//MARK: - TabBarModuleView API
extension TabBarViewController: TabBarViewControllerApi {
  func showNotImplementedAlert() {
    let alertController = UIAlertController(title: TabBar.Strings.Alerts.notImplementedAlertTitle.localize(), message: TabBar.Strings.Alerts.notImplementedAlertMessage.localize(), safelyPreferredStyle: .alert)
    
    alertController.view.tintColor = UIColor.bluePibble
    
    let ok = UIAlertAction(title: TabBar.Strings.Alerts.notImplementedAlertOkActionTitle.localize(), style: .default) {(action) in
      
    }
    
    alertController.addAction(ok)
    
    present(alertController, animated: true, completion: nil)
    alertController.view.tintColor = UIColor.bluePibble
  }
  
  func reloadMenuCollectionView() {
    guard let collection = menuCollectionView else {
      return
    }
    collection.reloadData()
  }
  
  func updateMenuCollectionView(update: CollectionViewUpdate) {
    guard let collection = menuCollectionView else {
      return
    }
    
    collection.performBatchUpdates({
      collection.deleteItems(at: update.removeAt)
      update.moveFromTo.forEach { collection.moveItem(at: $0.0, to: $0.1) }
      collection.insertItems(at: update.insertAt)
    }) { (_) in
      
    }
  }
  
  func setSideMenuHidden(_ hidden: Bool) {
    isMenuHidden = hidden
    setActionsCollectionViewHidden(hidden)
    setCentralButtonSelected(true)
    setCentralButtonActive(hidden)
    setTabbarButtonsActive(hidden, sideMenuButtonActive: true)
    setTabbarBackgroundHidden(hidden)
  }
  
  func setMenuHidden(_ hidden: Bool) {
    isMenuHidden = hidden
    setActionsCollectionViewHidden(hidden)
    setCentralButtonSelected(hidden)
    setCentralButtonActive(true)
    setTabbarButtonsActive(hidden, sideMenuButtonActive: hidden)
    setTabbarBackgroundHidden(hidden)
  }
  
  var submoduleContainerView: UIView {
    return containerView
  }
}

// MARK: - TabBarModuleView Viper Components API
private extension TabBarViewController {
    var presenter: TabBarPresenterApi {
        return _presenter as! TabBarPresenterApi
    }
}

//MARK:- Helpers

fileprivate extension TabBarViewController {
  func setTabbarButtonsActive(_ active: Bool, sideMenuButtonActive: Bool) {
    let alpha: CGFloat = active ? 1.0 : 0.5
    let sideMenuButtonAlpha: CGFloat = sideMenuButtonActive ? 1.0 : 0.5
 
    tabBarItemButtons.forEach {
      $0.isUserInteractionEnabled = false
    }
    
    tabBarItemButtons.last?.isUserInteractionEnabled = false
    
    UIView.animate(withDuration: 0.25, animations: { [weak self] in
      self?.tabBarItemButtons.forEach {
        $0.alpha = alpha
      }
      
      self?.tabBarItemButtons.last?.alpha = sideMenuButtonAlpha
    }) { [weak self] (_) in
      self?.tabBarItemButtons.forEach {
        $0.isUserInteractionEnabled = active
      }
      
      self?.tabBarItemButtons.last?.isUserInteractionEnabled = sideMenuButtonActive
    }
  }
  
  func setTabbarBackgroundHidden(_ hidden: Bool) {
    tabbarbackgroundCompactConstraint.priority = hidden ? .defaultHigh : .defaultLow
    tabbarbackgroundExtendedConstraint.priority = !hidden ? .defaultHigh : .defaultLow
    
    if !hidden {
      blurView.setPath(.middle, animated: true, duration: 0.1) { [weak self](_) in
        self?.blurView.setPath(.initial, animated: true, duration: 0.2)
      }
    }
    
    UIView.animate(withDuration: 0.2, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
  
  func setActionsCollectionViewHidden(_ hidden: Bool) {
    guard hidden else {
      menuCollectionView.isHidden = hidden
      menuCollectionView.alpha = 1.0
      return
    }
    
    let alpha: CGFloat = hidden ? 0.0 : 1.0
    
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      self?.menuCollectionView.alpha = alpha
    }) { [weak self] (_) in
      if hidden {
        self?.menuCollectionView.isHidden = hidden
      }
    }
  }
  
//  func setCetralButtonShadowHidden(_ hidden: Bool) {
//    return
//    let targetValue: Float = hidden ? 0.0 : 1.0
//    let startValue: Float = hidden ? 1.0 : 0.0
//
//    let animation = CABasicAnimation(keyPath: "shadowOpacity")
//    animation.fromValue = startValue
//    animation.toValue = targetValue
//    animation.duration = 0.25
//    tabBarCenterButton.layer.add(animation, forKey: animation.keyPath)
//    tabBarCenterButton.layer.shadowOpacity = targetValue
//  }
  
  func setCentralButtonActive(_ active: Bool) {
    let alpha: CGFloat = active ? 1.0 : 0.5
    UIView.animate(withDuration: 0.25) { [weak self] in
      self?.tabBarCenterButton.alpha = alpha
      self?.tabBarCenterButton.isUserInteractionEnabled = active
    }
  }
  
  func setCentralButtonSelected(_ selected: Bool) {
    UIView.animate(withDuration: 0.25) { [weak self] in
      if selected {
        let transform = CGAffineTransform(rotationAngle: 0.0)
        self?.tabBarCenterButton.transform = transform
      } else {
        let transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4.0)
        self?.tabBarCenterButton.transform = transform
      }
    }
  }
  
  func setup() {
    menuCollectionView.delegate = self
    menuCollectionView.dataSource = self
    
    guard let layout = menuCollectionView.collectionViewLayout as? TabBarActionCollectionViewLayout else {
      return
    }
    
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing  = 15
    
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
  }
  
  func setupAppearance() {
    blurView.colorTint = UIColor.bluePibble
    blurView.colorTintAlpha = 0.75
    blurView.blurRadius = 5
    blurView.scale = 1
  }
}

//MARK:- Menu UICollectionViewDataSource, UICollectionViewDelegate

extension TabBarViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  
  public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
  
    let items = CGFloat(presenter.numberOfMenuItemsInSection(indexPath.section))
    return CGSize(width: collectionView.bounds.width / items, height: 80)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return presenter.numberOfMenuItemsInSection(section)
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return presenter.numberOfMenuSections()
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarActionsItemCollectionViewCell.identifier, for: indexPath) as! TabBarActionsItemCollectionViewCell
    let itemVM = presenter.menuItemFor(indexPath)
    cell.setViewModel(itemVM)
    cell.setLayoutDurationFor(indexPath)
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    presenter.handleMenuItemSelectionAt(indexPath)
  }
}

extension TabBarViewController: ScrollViewContentOffsetNotificationsDelegateProtocol {
  func scrollViewDidChangeContentOffset(_ contentOffset: CGPoint, oldContentOffset: CGPoint, initialContentOffset: CGPoint) {
    guard isMenuHidden else {
      return
    }
    
    guard !isTabbarAnimating else {
      return
    }
    
    var currentContraintValue = tabbarBottomConstraint.constant
    
    currentContraintValue += initialContentOffset.y - contentOffset.y
    
    let tabbarHiddenConstraineValue = -tabbarView.bounds.height - (bottomSpaceView.bounds.height) - UIConstants.Constraints.tabbarBlurViewTopSpace
    currentContraintValue = min(0, max(tabbarHiddenConstraineValue, currentContraintValue))
    guard !contentOffset.y.isLessThanOrEqualTo(0.0) else {
      return
    }
    
    tabbarBottomConstraint.constant = currentContraintValue
    if currentContraintValue.isEqual(to: tabbarHiddenConstraineValue) {
      isTabbarHidden = true
    }
    
    if currentContraintValue.isZero {
      isTabbarHidden = false
    }
    
    if currentContraintValue > tabbarHiddenConstraineValue * 0.5 && currentContraintValue.isLess(than: 0) {
      isTabbarHidden = false
      tabbarBottomConstraint.constant = 0.0
      
      isTabbarAnimating = true
      UIView.animate(withDuration: 0.2, animations: { [weak self] in
        self?.tabbarContainerView.layoutIfNeeded()
      }) { [weak self] (_) in
        self?.isTabbarAnimating = false
      }
    }
    
    if currentContraintValue < tabbarHiddenConstraineValue * 0.5 &&
      !currentContraintValue.isLessThanOrEqualTo(tabbarHiddenConstraineValue) {
      isTabbarHidden = true
      tabbarBottomConstraint.constant = tabbarHiddenConstraineValue
      isTabbarAnimating = true
      UIView.animate(withDuration: 0.2, animations: { [weak self] in
        self?.tabbarContainerView.layoutIfNeeded()
      }) { [weak self] (_) in
        self?.isTabbarAnimating = false
      }
    }
  }
}


//MARK:- UIViewControllerGlobalNotificationDelegateProtocol

extension TabBarViewController: UIViewControllerGlobalNotificationDelegateProtocol {
  func viewDidAppearGlobalNotificationHandler() {
    guard isTabbarHidden else {
      return
    }
    
    isTabbarHidden = false
    tabbarBottomConstraint.constant = 0.0
    
    isTabbarAnimating = true
    UIView.animate(withDuration: 0.2, animations: { [weak self] in
      self?.tabbarContainerView.layoutIfNeeded()
    }) { [weak self] (_) in
      self?.isTabbarAnimating = false
    }

  }
}

fileprivate enum UIConstants {
  enum Constraints {
    static let tabbarHeightMin: CGFloat = 75.0
    static let tabbarHeightMax: CGFloat = 230
    
    static let tabbarBlurViewTopSpace: CGFloat = 26.0
  }
}



