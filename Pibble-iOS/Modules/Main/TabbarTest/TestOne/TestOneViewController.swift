//
//  TestOneViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 28.06.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: TestOneView Class
final class TestOneViewController: ViewController {
  
}

//MARK: - TestOneView API
extension TestOneViewController: TestOneViewControllerApi {
}

// MARK: - TestOneView Viper Components API
fileprivate extension TestOneViewController {
    var presenter: TestOnePresenterApi {
        return _presenter as! TestOnePresenterApi
    }
}
