//
//  UsernamePickerViewController.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 21/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import UIKit

//MARK: UsernamePickerView Class
final class UsernamePickerViewController: ViewController {
  @IBOutlet weak var usernameTextField: UITextField!
  @IBOutlet weak var doneButton: UIButton!
  
  @IBAction func usernameTextFieldEditingChangeAction(_ sender: UITextField) {
    presenter.handleUsernameTextChange(sender.text ?? "")
  }
  
  @IBAction func hideAction(_ sender: Any) {
    presenter.handleHideAction()
  }
  
  @IBAction func doneAction(_ sender: Any) {
    doneButton.isEnabled = false
    view.endEditing(true)
    presenter.handleDoneAction()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    usernameTextField.becomeFirstResponder()
  }
}

//MARK: - UsernamePickerView API
extension UsernamePickerViewController: UsernamePickerViewControllerApi {
  func setUsername(_ text: String) {
    usernameTextField.text = text
    doneButton.isEnabled = true
    usernameTextField.becomeFirstResponder()
  }
}

// MARK: - UsernamePickerView Viper Components API
fileprivate extension UsernamePickerViewController {
  var presenter: UsernamePickerPresenterApi {
    return _presenter as! UsernamePickerPresenterApi
  }
}
