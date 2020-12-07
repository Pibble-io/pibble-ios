//
//  DiscoverFeedRootContainerViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 18.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: DiscoverFeedRootContainerView Class
final class DiscoverFeedRootContainerViewController: ViewController {
  
  //MARK:- IBOutlets
  
  @IBOutlet weak var searchTextFieldBackgroundView: UIView!
  @IBOutlet weak var searchTextField: UITextField!
  
  @IBOutlet weak var cancelSearchButton: UIButton!
  
  @IBOutlet weak var searchHistoryButton: UIButton!
  
  @IBOutlet weak var discoverContentContainerView: UIView!
  
  @IBOutlet weak var searchContentContainerView: UIView!
  
  @IBOutlet var segmentSwitchButtons: [UIButton]!
  
  //MARK:- IBActions
  
  @IBAction func segmentSwitchAction(_ sender: UIButton) {
    guard let idx = segmentSwitchButtons.index(of: sender) else {
      return
    }
    
    let segment = segments[idx]
    presenter.handleSwitchTo(segment)
  }
  
  @IBAction func searchTextFieldEditingChangedAction(_ sender: UITextField) {
    presenter.handleSearchTextChange(sender.text ?? "")
  }
  
  @IBAction func cancelSearchAction(_ sender: Any) {
    presenter.handleSearchTextChange("")
    presenter.handleSearchTextEndEditingWith("")
    searchTextField.text = ""
    view.endEditing(true)
  }
  
  @IBAction func searchHistoryAction(_ sender: UIButton) {
    presenter.handleSearchHistoryAction()
  }
  
  //MARK:- Properties
  
  fileprivate let segments: [DiscoverFeedRootContainer.Segments] = [.top, .users, .tags, .places]
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupAppearance()
    setButtonStateFor(.top)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
}

//MARK: - DiscoverFeedRootContainerView API
extension DiscoverFeedRootContainerViewController: DiscoverFeedRootContainerViewControllerApi {
  func setSearchString(_ text: String) {
    searchTextField.text = text
  }
  
  func setButtonSelectedStateFor(_ segment: DiscoverFeedRootContainer.Segments) {
    setButtonStateFor(segment)
  }
  
  func setSegmentsDeselected() {
    setButtonStateDeselected()
  }
  
  func setHistoryButtonSelected(_ selected: Bool) {
    searchHistoryButton.isSelected = selected
  }
  
  func setDiscoverContainerHidden(_ hidden: Bool, animated: Bool) {
    let alpha: CGFloat = hidden ? 0.0 : 1.0
    guard animated else {
      discoverContentContainerView.alpha = alpha
      discoverContentContainerView.isHidden = hidden
      return
    }
    
    if !hidden {
      discoverContentContainerView.isHidden = hidden
    }
    
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
      self?.discoverContentContainerView.alpha = alpha
    }) {[weak self] (_) in
      self?.discoverContentContainerView.isHidden = hidden
    }
  }
  
  
  var containerView: UIView {
    return discoverContentContainerView
  }
  
  var searchResultsContainerView: UIView {
    return searchContentContainerView
  }
}

// MARK: - DiscoverFeedRootContainerView Viper Components API
fileprivate extension DiscoverFeedRootContainerViewController {
    var presenter: DiscoverFeedRootContainerPresenterApi {
        return _presenter as! DiscoverFeedRootContainerPresenterApi
    }
}

//MARK: - Helpers

extension DiscoverFeedRootContainerViewController {
  fileprivate func setupAppearance() {
    searchTextFieldBackgroundView.layer.cornerRadius = searchTextFieldBackgroundView.bounds.height * 0.5
    searchTextFieldBackgroundView.clipsToBounds = true
    searchTextFieldBackgroundView.layer.borderWidth = 1.0
    searchTextFieldBackgroundView.layer.borderColor = UIConstants.Colors.searchTextFieldBackgroundView.cgColor
  }
  
  fileprivate func setupView() {
    searchTextField.delegate = self
  }
  
  fileprivate func setButtonStateFor(_ segment: DiscoverFeedRootContainer.Segments) {
    segments.enumerated().forEach {
      let isSelected = $0.element == segment
      segmentSwitchButtons[$0.offset].isSelected = isSelected
    }
  }
  
  fileprivate func setButtonStateDeselected() {
    segmentSwitchButtons.forEach { $0.isSelected = false }
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let searchTextFieldBackgroundView = UIColor.gray191
  }
}


//MARK:- UITextFieldDelegate
extension DiscoverFeedRootContainerViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    presenter.handleSearchTextBeginEditingWith(textField.text ?? "")
  }
  
  func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
    presenter.handleSearchTextEndEditingWith(textField.text ?? "")
  }
}
