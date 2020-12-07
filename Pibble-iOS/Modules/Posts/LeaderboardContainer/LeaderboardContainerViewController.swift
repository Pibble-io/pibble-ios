//
//  LeaderboardContainerViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 19/07/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: LeaderboardContainerView Class
final class LeaderboardContainerViewController: ViewController {
  //MARK:- IBOutlets
  
  @IBOutlet weak var bottomContainerView: UIView!
  
  @IBOutlet weak var activeSectionSwitchButton: UIButton!
  @IBOutlet weak var closedSectionSwitchButton: UIButton!
  @IBOutlet weak var pausedSectionSwitchButton: UIButton!
  
  @IBOutlet weak var sergmentControlContainerView: UIView!
  @IBOutlet weak var segmentSelectionView: UIView!
  
  @IBOutlet weak var contentContainerView: UIView!
  
  //MARK:- IBOutlet Constraints
  
  @IBOutlet weak var segmentViewLeftConstraint: NSLayoutConstraint!
  @IBOutlet weak var segmentViewRightConstraint: NSLayoutConstraint!
  @IBOutlet weak var segmentViewCenterConstraint: NSLayoutConstraint!
  
  //MARK:- IBActions
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  @IBAction func helpAction(_ sender: Any) {
    presenter.handleHelpAction()
  }
  
  
  @IBAction func pausedSectionSwitchAction(_ sender: Any) {
    setButtonStateFor(.week)
    presenter.handleSwitchTo(.week)
  }
  
  @IBAction func activeSectionSwitchAction(_ sender: Any) {
    setButtonStateFor(.day)
    presenter.handleSwitchTo(.day)
  }
  
  @IBAction func closedSectionSwitchAction(_ sender: Any) {
    setButtonStateFor(.allHistory)
    presenter.handleSwitchTo(.allHistory)
  }
  
  //MARK:- Properties
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setButtonStateFor(.day)
    presenter.handleSwitchTo(.day)
  }
  
}

//MARK: - LeaderboardContainerView API
extension LeaderboardContainerViewController: LeaderboardContainerViewControllerApi {
  var submoduleContainerView: UIView  {
    return contentContainerView
  }
}

// MARK: - LeaderboardContainerView Viper Components API
fileprivate extension LeaderboardContainerViewController {
  var presenter: LeaderboardContainerPresenterApi {
    return _presenter as! LeaderboardContainerPresenterApi
  }
}


//MARK:- Helpers

extension LeaderboardContainerViewController {
  fileprivate func setupView() {
  }
  
  fileprivate func setupAppearance() {
    
  }
  
  fileprivate func setButtonStateFor(_ segment: LeaderboardContainer.SelectedSegment) {
    activeSectionSwitchButton.isSelected = segment == .day
    closedSectionSwitchButton.isSelected = segment == .allHistory
    pausedSectionSwitchButton.isSelected = segment == .week
    
    segmentViewLeftConstraint.priority = segment == .day ? .defaultHigh: .defaultLow
    segmentViewRightConstraint.priority = segment == .allHistory ? .defaultHigh: .defaultLow
    segmentViewCenterConstraint.priority = segment == .week ? .defaultHigh: .defaultLow
    
    UIView.animate(withDuration: 0.3,
                   delay: 0.0,
                   usingSpringWithDamping: 0.65,
                   initialSpringVelocity: 0.5,
                   options: .curveEaseInOut,
                   animations: { [weak self] in
                    self?.sergmentControlContainerView.layoutIfNeeded()
    }) { (_) in  }
  }
}


//MARK:- UIConstants

fileprivate enum UIConstants {
  enum Constraints {
    static let descriptionTextViewMaxHeight: CGFloat = 120.0
    static let descriptionTextViewMinHeight: CGFloat = 36.0
  }
  
  enum Colors {
    static let inputContainerView = UIColor.blueGradient
    static let descriptionTextContainerViewBorder = UIColor.gray112
  }
  
  enum CornerRadius {
    static let inputContainerView: CGFloat = 5.0
    static let bottomContainerView: CGFloat = 5.0
    
    static let descriptionTextContainerView: CGFloat = 8.0
  }
}
