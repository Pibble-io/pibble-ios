//
//  SuggestionsViewController.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 22.12.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import UIKit

//MARK: SuggestionsView Class
final class SuggestionsViewController: ViewController {
}

//MARK: - SuggestionsView API
extension SuggestionsViewController: SuggestionsViewControllerApi {
}

// MARK: - SuggestionsView Viper Components API
fileprivate extension SuggestionsViewController {
    var presenter: SuggestionsPresenterApi {
        return _presenter as! SuggestionsPresenterApi
    }
}
