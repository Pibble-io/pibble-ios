//
//  PostHelpRewardPickViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 05.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: PostHelpRewardPickView Class
final class PostHelpRewardPickViewController: ViewController {
  //MARK:- IBOutlets
  
  @IBOutlet weak var sliderInputView: PostHelpRewardPickTextFieldInputView!
  
  @IBOutlet weak var gradientView: GradientView!
  
  @IBOutlet weak var confirmButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  
  @IBOutlet weak var inputsViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var inputsViewCentralConstraint: NSLayoutConstraint!
  
  //MARK:- IBActions
  
  @IBAction func cancelAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  @IBAction func confirmAction(_ sender: Any) {
    presenter.handleConfirmAction()
  }
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAppearance()
    setupView()
  }
}

//MARK: - PostHelpRewardPickView API
extension PostHelpRewardPickViewController: PostHelpRewardPickViewControllerApi {
  func setInputViewHidden(_ hidden: Bool, animated: Bool) {
    if hidden {
      inputsViewTopConstraint.priority = .defaultHigh
      inputsViewCentralConstraint.priority = .defaultLow
    } else {
      inputsViewTopConstraint.priority = .defaultLow
      inputsViewCentralConstraint.priority = .defaultHigh
    }
  }
  
  func setViewModel(_ vm: PostHelpRewardPick.PostHelpRewardPickViewModel?, animated: Bool) {
    guard let viewModel = vm else {
      confirmButton.isEnabled = false
      return
    }
    
    confirmButton.isEnabled = viewModel.isConfirmButtonEnabled
    sliderInputView.setViewModel(viewModel, animated: animated)
  }
}

// MARK: - PostHelpRewardPickView Viper Components API
fileprivate extension PostHelpRewardPickViewController {
  var presenter: PostHelpRewardPickPresenterApi {
    return _presenter as! PostHelpRewardPickPresenterApi
  }
}

//MARK:- Helper

extension PostHelpRewardPickViewController {
  fileprivate func setupView() {
    sliderInputView.delegate = self
  }
  
  fileprivate func setupAppearance() {
    gradientView.addBackgroundGradientWith(UIConstants.Colors.background, direction: .vertical)
    
    sliderInputView.layer.cornerRadius = UIConstants.Corners.inputsContainerView
    sliderInputView.clipsToBounds = true
    
    [confirmButton, cancelButton].forEach {
      $0?.layer.cornerRadius = UIConstants.Corners.bottomButtons
      $0?.clipsToBounds = true
    }
  }
}

//MARK:- UIConstants

fileprivate enum UIConstants {
  enum Corners {
    static let inputsContainerView: CGFloat = 21.0
    static let bottomButtons: CGFloat = 18.0
  }
  
  enum Colors {
    static let background = UIColor.darkGrayGradient
    
    static let promotedButtons = UIColor.pinkPibble
    static let buttons = UIColor.bluePibble
  }
}

//MARK:- PostHelpRewardPickInputViewDelegateProtocol, PostHelpRewardPickSliderInputViewDelegateProtocol, PostHelpRewardPickTextFieldInputViewDelegateProtocol

extension PostHelpRewardPickViewController: PostHelpRewardPickTextFieldInputViewDelegateProtocol {
  func handleDidEndEditing() {
    guard let viewModel = presenter.viewModel else {
      return
    }
    
    sliderInputView.setViewModel(viewModel, animated: false)
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.sliderInputView.alpha = 1.0
    }
  }
  
  func handleChangeValue(_ value: String) {
     presenter.handleChangeValue(value)
  }
  
  func handleChangeValueToMin() {
    presenter.handleChangeValueToMin()
  }
  
  func handleChangeValueToMax() {
    presenter.handleChangeValueToMax()
  }
}
