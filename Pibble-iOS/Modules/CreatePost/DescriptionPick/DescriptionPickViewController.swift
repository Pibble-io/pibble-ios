//
//  DescriptionPickViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 24.07.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: DescriptionPickView Class
final class DescriptionPickViewController: ViewController {
  @IBOutlet weak var inputTextView: UITextView!
  @IBOutlet weak var inputTextBackgroundView: UIView!
  
  @IBOutlet weak var hideButton: UIButton!
  @IBOutlet weak var doneButton: UIButton!
  
  //MARK:- IBOutlets LayoutConstraints
  
  @IBOutlet weak var textBackgroundViewBottomConstraint: NSLayoutConstraint!
  
  //MARK:- IBActions
  @IBAction func doneAction(_ sender: Any) {
    presenter.handleDoneAction()
  }
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupAppearance()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    subscribeKeyboardNotications()
    inputTextView.becomeFirstResponder()
    
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeKeyboardNotications()
  }
}

//MARK: - DescriptionPickView API
extension DescriptionPickViewController: DescriptionPickViewControllerApi {
  func setInputText(_ text: String) {
    inputTextView.text = text
  }
}

// MARK: - DescriptionPickView Viper Components API
fileprivate extension DescriptionPickViewController {
    var presenter: DescriptionPickPresenterApi {
        return _presenter as! DescriptionPickPresenterApi
    }
}

//MARK:- Helpers

extension DescriptionPickViewController {
  func setupView() {
    inputTextView.delegate = self
  }
  
  func setupAppearance() {
   
  }
}

//MARK:- UITextViewDelegate

extension DescriptionPickViewController: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    presenter.handleInputTextChange(textView.text)
  }
}

//MARK:- KeyboardNotificationsDelegateProtocol

extension DescriptionPickViewController: KeyboardNotificationsDelegateProtocol {
  func keyBoardWillShowWithBottomInsets(_ bottomInsets: CGFloat, animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    textBackgroundViewBottomConstraint.constant = bottomInsets
    
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
  
  func keyBoardWillHide(animationOptions: UIView.AnimationOptions, animationDuration: TimeInterval) {
    textBackgroundViewBottomConstraint.constant = 0.0
    UIView.animate(withDuration: animationDuration, delay: 0.0, options: animationOptions, animations: { [weak self] in
      self?.view.layoutIfNeeded()
    }) { (_) in  }
  }
   
}

fileprivate enum UIConstants {
  enum Constraints {
    static let inputTextViewMaxHeight: CGFloat = 150.0
    static let inputTextViewMinHeight: CGFloat = 70.0
  }
}


