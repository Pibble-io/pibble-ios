//
//  CreatePostHelpViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 26/09/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: CreatePostHelpView Class
final class CreatePostHelpViewController: ViewController {
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  
  @IBOutlet weak var stackView: UIStackView!
  
  @IBOutlet weak var bottomInsetsView: UIView!
  @IBOutlet weak var dimView: UIView!
  
  @IBOutlet weak var helpTypesCollectionView: UICollectionView!
  @IBOutlet weak var rewardsCollectionView: UICollectionView!
  
  @IBOutlet weak var tapToHideView: UIView!
  @IBOutlet weak var helpTextContainerView: UIView!
  
  @IBOutlet weak var helpTextView: UITextView!
  @IBOutlet weak var helpTextPlaceholderLabel: UILabel!
  
  @IBOutlet weak var createPostHelpButton: UIButton!
  
  @IBOutlet weak var topRoundedCornerView: UIView!
  @IBOutlet weak var helpTextViewHeightConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
 
  fileprivate lazy var tapGestureRecognizer: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(tap(sender:)))
    return gesture
  }()
  
  fileprivate lazy var endEditTapGestureRecognizer: UITapGestureRecognizer = {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(endEditTap(sender:)))
    gesture.cancelsTouchesInView = false
    return gesture
  }()
  
  @IBAction func hideAction(_ sender: Any) {
    
  }
  
  @IBAction func createPostHelpAction(_ sender: Any) {
    presenter.handleCreatePostHelpAction()
  }
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupAppearance()
    setBackgroundImageView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setTableViewContentHidden(true, animated: false)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setTableViewContentHidden(false, animated: true)
  }
}

//MARK: - CreatePostHelpView API
extension CreatePostHelpViewController: CreatePostHelpViewControllerApi {
  func setCreatePostHelpButtonEnabled(_ enabled: Bool) {
    createPostHelpButton.isEnabled = enabled
    createPostHelpButton.backgroundColor = enabled ?
      UIConstants.Colors.CreatePostHelpButton.enabledBackground:
      UIConstants.Colors.CreatePostHelpButton.disabledBackground
  }
  
  func setHelpText(_ text: String) {
    helpTextView.text = text
    updatePlaceholder()
  }
  
  func performHideAnimation(_ complete: @escaping () -> Void) {
    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
      self?.setTableViewContentHidden(true, animated: false)
      self?.view.layoutIfNeeded()
    }) {(_) in
      complete()
    }
  }
  
  func reloadData() {
    helpTypesCollectionView.reloadData()
    rewardsCollectionView.reloadData()
    
    //needed for dynamic sized cells were layouted correctly
    DispatchQueue.main.async { [weak self] in
      self?.helpTypesCollectionView.collectionViewLayout.invalidateLayout()
      self?.rewardsCollectionView.collectionViewLayout.invalidateLayout()
    }
  }
}

// MARK: - CreatePostHelpView Viper Components API
fileprivate extension CreatePostHelpViewController {
  var presenter: CreatePostHelpPresenterApi {
    return _presenter as! CreatePostHelpPresenterApi
  }
}

//MARK:- UICollectionViewDataSource, UICollectionViewDelegate

extension CreatePostHelpViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    if collectionView == helpTypesCollectionView {
      return presenter.helpTypesNumberOfSections()
    }
    
    if collectionView == rewardsCollectionView {
      return presenter.rewardsNumberOfSections()
    }
    
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == helpTypesCollectionView {
      return presenter.helpTypesNumberOfItemsInSection(section)
    }
    
    if collectionView == rewardsCollectionView {
      return presenter.rewardsNumberOfItemsInSection(section)
    }
    
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == helpTypesCollectionView {
      let viewModel = presenter.helpTypesViewModelAt(indexPath)
      let cell = collectionView.dequeueReusableCell(cell: CreatePostHelpTypeCollectionViewCell.self, for: indexPath)
      cell.setViewModel(viewModel)
      return cell
    }
    
    if collectionView == rewardsCollectionView {
      let viewModel = presenter.rewardsViewModelAt(indexPath)
      let cell = collectionView.dequeueReusableCell(cell: CreatePostHelpRewardCollectionViewCell.self, for: indexPath)
      cell.setViewModel(viewModel)
      return cell
    }
    
    return UICollectionViewCell()
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == helpTypesCollectionView {
      presenter.handleHelpTypeSelectionAt(indexPath)
    }
    
    if collectionView == rewardsCollectionView {
      presenter.handleRewardSelectionAt(indexPath)
    }
  }
}


extension CreatePostHelpViewController {
  fileprivate func setBackgroundImageView() {
    backgroundImageView.image = presentingViewController?.view.takeSnapshot()
  }
  
  @objc func tap(sender: UITapGestureRecognizer) {
    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
      self?.setTableViewContentHidden(true, animated: false)
      self?.view.layoutIfNeeded()
    }) { [weak self] (_) in
      self?.presenter.handleHideAction()
    }
  }
  
  @objc func endEditTap(sender: UITapGestureRecognizer) {
    view.endEditing(true)
  }
  
  fileprivate func setupView() {
    helpTextView.delegate = self
    scrollView.delegate = self
    
    rewardsCollectionView.delegate = self
    rewardsCollectionView.dataSource = self
    
    helpTypesCollectionView.delegate = self
    helpTypesCollectionView.dataSource = self
    
    rewardsCollectionView.registerCell(CreatePostHelpRewardCollectionViewCell.self)
    helpTypesCollectionView.registerCell(CreatePostHelpTypeCollectionViewCell.self)
    
    tapToHideView.addGestureRecognizer(tapGestureRecognizer)
    scrollView.addGestureRecognizer(endEditTapGestureRecognizer)
  }
  
  fileprivate func setupAppearance() {
    helpTextContainerView.layer.cornerRadius = UIConstants.CornerRadius.textView
    helpTextContainerView.layer.borderColor = UIConstants.Colors.textViewBounds.cgColor
    helpTextContainerView.layer.borderWidth = 1.0
    
    createPostHelpButton.layer.cornerRadius = UIConstants.CornerRadius.createPostHelpButton
    createPostHelpButton.clipsToBounds = true
    
    topRoundedCornerView.layer.cornerRadius = UIConstants.CornerRadius.topRoundedCornerView
    topRoundedCornerView.clipsToBounds = true
    
    updatePlaceholder()
    
    if let layout = rewardsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.itemSize = UICollectionViewFlowLayout.automaticSize
      layout.estimatedItemSize = CGSize(width: 100, height: 28.0)
      layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
      layout.minimumLineSpacing = 10.0
      layout.minimumInteritemSpacing = 5.0
    }
    
    if let layout = helpTypesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.itemSize = UICollectionViewFlowLayout.automaticSize
      layout.estimatedItemSize = CGSize(width: 100, height: 30.0)
      layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
      layout.minimumLineSpacing = 10.0
      layout.minimumInteritemSpacing = 5.0
    }
  }
  
  fileprivate func setTableViewContentHidden(_ hidden: Bool, animated: Bool) {
    let offset = hidden ? scrollView.bounds.height : 0.0
    scrollViewTopConstraint.constant = offset
    let dimViewAlpha: CGFloat = hidden ? 0.0 : 0.3
    
    guard animated else {
      dimView.alpha = dimViewAlpha
      return
    }
    
    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
      self?.dimView.alpha = dimViewAlpha
      self?.view.layoutIfNeeded()
    }) { (_) in }
  }
  
  fileprivate func updatePlaceholder() {
    helpTextPlaceholderLabel.alpha = helpTextView.text.count > 0 ? 0.0 : 1.0
    updateEditViewForTextContent()
  }
  
  fileprivate func updateEditViewForTextContent() {
    let fittingSize = helpTextView.sizeThatFits(CGSize(width: helpTextView.frame.size.width, height: 9999))
    
    let textViewMinHeight = UIConstants.Constraints.inputTextViewMinHeight
    let viewMaxHeight = UIConstants.Constraints.inputTextViewMaxHeight
    let trueViewHeight = max(textViewMinHeight, CGFloat(fittingSize.height)) //+ viewContentHeightWithoutTextView
    let viewContentHeight = min(viewMaxHeight, trueViewHeight)
    
    helpTextViewHeightConstraint.constant = viewContentHeight
    
    UIView.animate(withDuration: 0.1, delay: 0.0, options: .beginFromCurrentState, animations: { [weak self] in
      self?.view.layoutIfNeeded()
      
    }) { (_) in  }
  }
}

//MARK:- UITextViewDelegate

extension CreatePostHelpViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    presenter.handleHelpTextChange(textView.text)
    updatePlaceholder()
  }
}


//MARK:- UITableViewDataSource, UITableViewDelegate

extension CreatePostHelpViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    guard scrollView == self.scrollView else {
      return
    }
    
    if scrollView.contentOffset.y >= -scrollView.contentInset.top {
      scrollView.contentOffset.y = -scrollView.contentInset.top
    }
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    guard scrollView == self.scrollView else {
      return
    }
    
    if scrollView.contentOffset.y < -scrollView.bounds.height * 0.1 {
      scrollView.contentInset.top = abs(scrollView.contentOffset.y)
      scrollView.bounces = false
      scrollView.alwaysBounceVertical = false

      UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: { [weak self] in
        self?.setTableViewContentHidden(true, animated: false)
        self?.view.layoutIfNeeded()
      }) { [weak self] (_) in
        self?.presenter.handleHideAction()
      }
    }
  }
}

fileprivate enum UIConstants {
  enum CornerRadius {
    static let textView: CGFloat = 24
    static let createPostHelpButton: CGFloat = 4.0
    static let topRoundedCornerView: CGFloat = 12.0
  }
  
  enum Colors {
    static let textViewBounds = UIColor.gray84
    
    enum CreatePostHelpButton {
      static let enabledBackground = UIColor.bluePibble
      static let disabledBackground = UIColor.gray191
    
    }
  }
  
  enum Constraints {
    static let inputTextViewMaxHeight: CGFloat = 150.0
    static let inputTextViewMinHeight: CGFloat = 60.0
    static let commentBackgroundBottomConstraintMin: CGFloat = 0.0
  }
}
