//
//  FundingPostsContainerViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 10/06/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: FundingPostsContainerView Class
final class FundingPostsContainerViewController: ViewController {
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
  
  @IBAction func pausedSectionSwitchAction(_ sender: Any) {
    setButtonStateFor(.ended)
    presenter.handleSwitchTo(.ended)
  }
  
  @IBAction func activeSectionSwitchAction(_ sender: Any) {
    setButtonStateFor(.active)
    presenter.handleSwitchTo(.active)
  }
  
  @IBAction func closedSectionSwitchAction(_ sender: Any) {
    setButtonStateFor(.backer)
    presenter.handleSwitchTo(.backer)
  }
  
  //MARK:- Properties
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setButtonStateFor(.active)
    presenter.handleSwitchTo(.active)
  }
  
}

//MARK: - FundingPostsContainerView API
extension FundingPostsContainerViewController: FundingPostsContainerViewControllerApi {
  var submoduleContainerView: UIView  {
    return contentContainerView
  }
}

// MARK: - FundingPostsContainerView Viper Components API
fileprivate extension FundingPostsContainerViewController {
  var presenter: FundingPostsContainerPresenterApi {
    return _presenter as! FundingPostsContainerPresenterApi
  }
}


//MARK:- Helpers

extension FundingPostsContainerViewController {
  fileprivate func setupView() { 
  }
  
  fileprivate func setupAppearance() {
    
  }
  
  fileprivate func setButtonStateFor(_ segment: FundingPostsContainer.SelectedSegment) {
    activeSectionSwitchButton.isSelected = segment == .active
    closedSectionSwitchButton.isSelected = segment == .backer
    pausedSectionSwitchButton.isSelected = segment == .ended
    
    segmentViewLeftConstraint.priority = segment == .active ? .defaultHigh: .defaultLow
    segmentViewRightConstraint.priority = segment == .backer ? .defaultHigh: .defaultLow
    segmentViewCenterConstraint.priority = segment == .ended ? .defaultHigh: .defaultLow
    
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
