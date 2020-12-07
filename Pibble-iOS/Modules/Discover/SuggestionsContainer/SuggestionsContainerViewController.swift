//
//   SuggestionsContainerViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 22.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK:  SuggestionsContainerView Class
final class  SuggestionsContainerViewController: ViewController {
  
  @IBOutlet var suggestionContentSections: [UIView]!
  
}

//MARK: -  SuggestionsContainerView API
extension  SuggestionsContainerViewController:  SuggestionsContainerViewControllerApi {
}

// MARK: -  SuggestionsContainerView Viper Components API
fileprivate extension  SuggestionsContainerViewController {
    var presenter:  SuggestionsContainerPresenterApi {
        return _presenter as!  SuggestionsContainerPresenterApi
    }
}
