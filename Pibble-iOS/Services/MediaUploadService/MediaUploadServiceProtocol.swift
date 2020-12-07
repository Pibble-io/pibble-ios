//
//  MediaUploadServiceProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 17.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

protocol UploadedMediaProtocol: Decodable {
  var token: String { get }
}

protocol MediaUploadServiceProtocol: class {
  func uploadFile(_ url: URL, originalMediaFileURL: URL?, asDigitalGood: Bool, postUUID: String, mediaUUID: String, callbackQueue: DispatchQueue, complete: @escaping ResultCompleteHandler<UploadedMediaProtocol, PibbleError>) 
  
  func createMediaUUID(callbackQueue: DispatchQueue, complete: @escaping ResultCompleteHandler<String, PibbleError>)
  
}
