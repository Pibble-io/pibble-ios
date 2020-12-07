//
//  VideoRecordingInfo.swift
//  Pibble
//
//  Created by Kazakov Sergey on 11.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import AVFoundation

extension CameraCaptureService {
  enum VideoRecordingItemInfoState {
    case recording
    case recoredToFile
    case failed
  }
  
  class VideoRecordingItemInfo {
    //MARK:- Properties
    
    let fileUrl: URL
    let startTimestamp: Date
    
    var length: TimeInterval {
      let finishDate = finishTimestamp ?? Date()
      return abs(finishDate.timeIntervalSince(startTimestamp))
    }
    
    //MARK:- Private properties
    
    private(set) var finishTimestamp: Date?
    //private(set) var isRecordingToFileFinished: Bool = false
    
    private(set) var state: VideoRecordingItemInfoState = .recording
    
    //MARK:- Methods
    
    func getAsset() -> AVAsset {
      return AVAsset(url: fileUrl)
    }
    
    func setRecordingToFileFinished(_ successFully: Bool) {
      state = successFully ? .recoredToFile : .failed
    }
    
    func finish() {
      if finishTimestamp == nil {
        finishTimestamp = Date()
      }
    }
    
    //MARK:- Init
    init(fileUrl: URL) {
      self.fileUrl = fileUrl
      self.startTimestamp = Date()
    }
  }

}


