//
//  ResetPasswordEmailSentModuleView.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 25.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: ResetPasswordEmailSentModuleView Class
final class ResetPasswordEmailSentViewController: ViewController {
  //MARK:- IBOutlets
  @IBOutlet weak var hideButton: UIButton!
  
  @IBOutlet weak var backgroundImageView: UIImageView!
  @IBOutlet weak var emailSentLabel: UILabel!
  
  //MARK:- IBActions
  
  @IBAction func nextStepAction(_ sender: Any) {
    presenter.handleNextStepAction()
  }
  
  //MARK:- Lyfecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }
  
  //MARK:- Properties
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
  }
}

//MARK: - ResetPasswordEmailSentModuleView API

extension ResetPasswordEmailSentViewController: ResetPasswordEmailSentViewControllerApi {
  func setEmailSentText(_ value: String) {
    emailSentLabel.text = value
  }
}

// MARK: - ResetPasswordEmailSentModuleView Viper Components API

fileprivate extension ResetPasswordEmailSentViewController {
    var presenter: ResetPasswordEmailSentPresenterApi {
        return _presenter as! ResetPasswordEmailSentPresenterApi
    }
}

//MARK:- Helpers

fileprivate extension ResetPasswordEmailSentViewController {
  func setupView() {
    backgroundImageView.image = AssetsManager.Background.auth.asset
    hideButton.clipsToBounds = true
    hideButton.layer.cornerRadius = hideButton.bounds.height * 0.5
  }
}

fileprivate enum UIConstants {
  enum Colors {
    static let background = UIColor.pinkBackgroundGradient
  }
}
