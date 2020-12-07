//
//  Interactor.swift
//  Pibble
//
//  Created by Kazakov Sergey on 15.06.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

protocol InteractorProtocol: class {
  var _presenter: PresenterProtocol! { get set }
  
}

class BaseInteractor: InteractorProtocol {
  weak var _presenter: PresenterProtocol!
}
