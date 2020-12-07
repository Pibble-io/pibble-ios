//
//  MediaDownloadServiceProtocol.swift
//  Pibble
//
//  Created by Sergey Kazakov on 28/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

protocol MediaDownloadServiceProtocol {
  func downloadDigitalGoodForPost(_ post: PostingProtocol, complete: @escaping ResultCompleteHandler<URL, PibbleError>)
  func unzipDownloadedFilesAt(_ url: URL, complete: @escaping ResultCompleteHandler<URL, PibbleError>)
  func downloadDigitalGoodForPostAndUnzip(_ post: PostingProtocol, complete: @escaping ResultCompleteHandler<URL, PibbleError>)
  func downloadDigitalGoodForPostAndGetContentFiles(_ post: PostingProtocol, complete: @escaping ResultCompleteHandler<[URL], PibbleError>)
  
  func getUrlStringForDigitalGoodOriginal(_ media: MediaProtocol) -> String 
}
