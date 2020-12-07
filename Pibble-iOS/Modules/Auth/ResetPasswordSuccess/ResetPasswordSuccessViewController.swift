//
//  ResetPasswordSuccessModuleView.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 27.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: ResetPasswordSuccessModuleView Class
final class ResetPasswordSuccessViewController: ViewController {
  @IBOutlet weak var loginButton: UIButton!
  
  //MARK:- Lyfecycle
  @IBAction func loginAction(_ sender: Any) {
    presenter.handleLoginAction()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  //MARK:- Properties
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
  }
}

//MARK: - ResetPasswordSuccessModuleView API
extension ResetPasswordSuccessViewController: ResetPasswordSuccessViewControllerApi {
}

// MARK: - ResetPasswordSuccessModuleView Viper Components API
fileprivate extension ResetPasswordSuccessViewController {
    var presenter: ResetPasswordSuccessPresenterApi {
        return _presenter as! ResetPasswordSuccessPresenterApi
    }
}

fileprivate extension ResetPasswordSuccessViewController {
  func setupView() {
    loginButton.clipsToBounds = true
    loginButton.layer.cornerRadius = loginButton.frame.size.height * 0.5
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let background = UIColor.pinkBackgroundGradient
    static let button = UIColor.purpleButtonGradient
  }
}
