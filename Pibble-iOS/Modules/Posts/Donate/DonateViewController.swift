//
//  DonateViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 30.10.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: UpVoteView Class
final class DonateViewController: ViewController {
  //MARK:- IBOutlets
  
  @IBOutlet weak var gradientView: GradientView!
  
  
  @IBOutlet weak var sliderInputView: DonateSliderInputView!
  @IBOutlet weak var textFieldInputView: DonateTextFieldInputView!
  
  @IBOutlet weak var upVoteButton: UIButton!
  @IBOutlet weak var cancelButton: UIButton!
  
  @IBOutlet weak var inputsViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var inputsViewCentralConstraint: NSLayoutConstraint!
  
  //MARK:- IBActions
  
  @IBAction func cancelAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  @IBAction func upVoteAction(_ sender: Any) {
    presenter.handleVoteAction()
  }
  
  //MARK:- Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAppearance()
    setupView()
  }
}

//MARK: - UpVoteView API
extension DonateViewController: DonateViewControllerApi {
  func setInputViewHidden(_ hidden: Bool, animated: Bool) {
    if hidden {
      inputsViewTopConstraint.priority = .defaultHigh
      inputsViewCentralConstraint.priority = .defaultLow
    } else {
      inputsViewTopConstraint.priority = .defaultLow
      inputsViewCentralConstraint.priority = .defaultHigh
    }
  }
  
  func setViewModel(_ vm: Donate.UpVoteViewModel?, animated: Bool) {
    guard let viewModel = vm else {
      return
    }
    
    upVoteButton.isEnabled = vm?.isUpvoteEnabled ?? false
    
    sliderInputView.setViewModel(viewModel, animated: animated)
    textFieldInputView.setCurrencyForViewModel(viewModel, animated: animated)
  }
}

// MARK: - UpVoteView Viper Components API
fileprivate extension DonateViewController {
  var presenter: DonatePresenterApi {
    return _presenter as! DonatePresenterApi
  }
}

//MARK:- Helper

extension DonateViewController {
  fileprivate func setupView() {
    sliderInputView.delegate = self
    textFieldInputView.delegate = self
  }
  
  fileprivate func setupAppearance() {
    gradientView.addBackgroundGradientWith(UIConstants.Colors.background, direction: .vertical)
    [sliderInputView, textFieldInputView].forEach {
      $0?.layer.cornerRadius = UIConstants.Corners.inputsContainerView
      $0?.clipsToBounds = true
    }
    
    [upVoteButton, cancelButton].forEach {
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
    static let buttons = UIColor.greenPibble
  }
}

//MARK:- UpVoteInputViewDelegateProtocol, UpVoteSliderInputViewDelegateProtocol, UpVoteTextFieldInputViewDelegateProtocol

extension DonateViewController: DonateTextFieldInputViewDelegateProtocol, DonateSliderInputViewDelegateProtocol {
  func handleCurrencySwitch() {
    presenter.handleSwitchToNextCurrency()
  }
  
  func handleDidEndEditing() {
    guard let viewModel = presenter.viewModel else {
      return
    }
    
    sliderInputView.setViewModel(viewModel, animated: false)
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.sliderInputView.alpha = 1.0
    }
  }
  
  func handleDirectInputAction() {
    guard presenter.isDirectInputSupported else {
      return
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      self?.sliderInputView.alpha = 0.0
    }
    
    guard let viewModel = presenter.viewModel else {
      return
    }
    
    textFieldInputView.setViewModel(viewModel, animated: true)
    textFieldInputView.beginEditing()
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
  
  func handleChangeValue(_ value: Float) {
    presenter.handleSliderChangeValue(value)
  }
}
