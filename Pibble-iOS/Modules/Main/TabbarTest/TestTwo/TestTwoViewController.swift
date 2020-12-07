//
//  TestTwoViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: TestTwoView Class
final class TestTwoViewController: ViewController {
  @IBOutlet weak var backgroundImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    backgroundImageView.image = AssetsManager.Background.auth.asset
  }
}

//MARK: - TestTwoView API
extension TestTwoViewController: TestTwoViewControllerApi {
}

// MARK: - TestTwoView Viper Components API
fileprivate extension TestTwoViewController {
    var presenter: TestTwoPresenterApi {
        return _presenter as! TestTwoPresenterApi
    }
}
