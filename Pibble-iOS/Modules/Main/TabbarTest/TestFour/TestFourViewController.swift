//
//  TestFourViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: TestFourView Class
final class TestFourViewController: ViewController {
  @IBAction func logoutAction(_ sender: Any) {
    ServicesContainer.shared.loginService.logout()
    if let module = AppModules.Auth.registration.build(),
      let window = UIApplication.shared.delegate?.window {
      module.router.show(inWindow: window, embedInNavController: true, animated: true)
    }
  }
}

//MARK: - TestFourView API
extension TestFourViewController: TestFourViewControllerApi {
}

// MARK: - TestFourView Viper Components API
fileprivate extension TestFourViewController {
    var presenter: TestFourPresenterApi {
        return _presenter as! TestFourPresenterApi
    }
}
