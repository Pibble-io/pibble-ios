//
//  MediaProcessingSchedulerServiceProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 19.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

protocol MediaProcessingSchedulerServiceProtocol {
  func scheduleOperations(_ operations: [(OperationTypes, Operation)]) 
}

