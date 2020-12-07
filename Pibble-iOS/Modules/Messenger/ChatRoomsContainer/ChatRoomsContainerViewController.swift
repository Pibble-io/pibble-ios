//
//  ChatRoomsContainerViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 11/04/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: ChatRoomsContainerView Class
final class ChatRoomsContainerViewController: ViewController {
  //MARK:- IBOutlets
  
  @IBOutlet weak var bottomContainerView: UIView!
  
  @IBOutlet weak var personalChatRoomsSwitchButton: UIButton!
  @IBOutlet weak var goodsGroupsSwitchButton: UIButton!
  
  @IBOutlet weak var sergmentControlContainerView: UIView!
  @IBOutlet weak var segmentSelectionView: UIView!
  
  @IBOutlet weak var contentContainerView: UIView!
  
  //MARK:- IBOutlet Constraints
  
  @IBOutlet weak var segmentViewLeftConstraint: NSLayoutConstraint!
  @IBOutlet weak var segmentViewRightConstraint: NSLayoutConstraint!
  
  
  //MARK:- IBActions
  
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  @IBAction func personalChatRoomsSwitchAction(_ sender: Any) {
    setButtonStateFor(.personalChatRooms)
    presenter.handleSwitchTo(.personalChatRooms)
  }
  
  @IBAction func goodsGroupsSwitchAction(_ sender: Any) {
    setButtonStateFor(.goodsRooms)
    presenter.handleSwitchTo(.goodsRooms)
  }
  
  //MARK:- Properties
  
  fileprivate let panInteractionController = PanGestureSlideInteractionController(isRightEdge: false)
  
  fileprivate lazy var pan: UIPanGestureRecognizer = {
    let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    //    gesture.delegate = self
    return gesture
  }()
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setButtonStateFor(.personalChatRooms)
    presenter.handleSwitchTo(.personalChatRooms)
  }
}

//MARK: - ChatRoomsContainerView API
extension ChatRoomsContainerViewController: ChatRoomsContainerViewControllerApi {
  var submoduleContainerView: UIView  {
    return contentContainerView
  }
}

// MARK: - ChatRoomsContainerView Viper Components API
fileprivate extension ChatRoomsContainerViewController {
  var presenter: ChatRoomsContainerPresenterApi {
    return _presenter as! ChatRoomsContainerPresenterApi
  }
}


extension ChatRoomsContainerViewController {
  @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
    panInteractionController.handleGesture(gestureRecognizer)
    gestureRecognizer.setTranslation(CGPoint.zero, in: view)
  }
}

//MARK:- Helper

//MARK:- Helpers

extension ChatRoomsContainerViewController: GestureInteractionControllerDelegateProtocol {
  func handlePresentActionWith(_ transition: GestureInteractionController) {
    presenter.handleHideAction()
  }
}


extension ChatRoomsContainerViewController {
  fileprivate func setupView() {
    panInteractionController.delegate = self
    view.addGestureRecognizer(pan)
    transitionsController.dismissalAnimator?.interactiveTransitioning = panInteractionController
    
  }
  
  fileprivate func setupAppearance() {
    
  }
  
  fileprivate func setButtonStateFor(_ segment: ChatRoomsContainer.SelectedSegment) {
    switch segment {
    case .personalChatRooms:
      goodsGroupsSwitchButton.isSelected = false
      personalChatRoomsSwitchButton.isSelected = true
      
      segmentViewLeftConstraint.priority = .defaultHigh
      segmentViewRightConstraint.priority = .defaultLow
    case .goodsRooms:
      goodsGroupsSwitchButton.isSelected = true
      personalChatRoomsSwitchButton.isSelected = false
      
      segmentViewLeftConstraint.priority = .defaultLow
      segmentViewRightConstraint.priority = .defaultHigh
    }
    
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
