//
//  VideoRecordingItemsManager.swift
//  Pibble
//
//  Created by Kazakov Sergey on 11.07.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import AVFoundation
import UIKit

typealias AssetExportCompleteHandler = ResultCompleteHandler<URL, CameraCaptureServiceError>
extension CameraCaptureService {
  class VideoRecordingItemsManager {
    //MARK:- Properties
    let settings: MediaExportSettings
    
    let identifier: String
    private(set) var videoRecordings: [VideoRecordingItemInfo] = []
    
    var duration: TimeInterval {
      return videoRecordings
        .filter { $0.state != .failed }
        .map { return $0.length }
        .reduce(0, +)
    }
    
    var isReadyForExport: Bool {
      return videoRecordings.first { $0.state == .recording } == nil
    }
    
    //MARK:- Private properties
    
    fileprivate var videoRecordingsDict: [URL: VideoRecordingItemInfo] = [:]
    
    //MARK:- Init
    
    init(settings: MediaExportSettings) {
      identifier = String(Date().timeIntervalSince1970)
      self.settings = settings
    }
    
    //MARK:- Methods
    
    func exportVideo(complete: @escaping AssetExportCompleteHandler) {
      let assets = videoRecordings
        .filter { $0.state == .recoredToFile }
        .map { return $0.getAsset() }
      mergeToSingleVideo(assetsToMerge: assets, completion: complete)
    }
    
    func finishLastVideoRecording() {
      videoRecordings.last?.finish()
    }
    
    func setRecordingToFileStateFinishedFor(_ url: URL, successfully: Bool) {
      videoRecordingsDict[url]?.setRecordingToFileFinished(successfully)
    }
    
    func createNewVideoRecordingItem() -> VideoRecordingItemInfo? {
      var outputFileUrl = URL(fileURLWithPath:NSTemporaryDirectory())
      
      let fileId = String(videoRecordings.count)
      outputFileUrl = outputFileUrl.appendingPathComponent("\(identifier)_\(fileId).mp4")
      let videoRecordingInfo = VideoRecordingItemInfo(fileUrl: outputFileUrl)
      videoRecordings.append(videoRecordingInfo)
      videoRecordingsDict[outputFileUrl] = videoRecordingInfo
      
      return videoRecordingInfo
    }
    
    //MARK:- Private methods
    
    fileprivate func mergedAVAssetFor(assets: [AVAsset]) -> Result<AVAsset, CameraCaptureServiceError>  {
      guard let firstVideo = assets.first else {
        return Result(error: .videoNotRecorded)
      }
      
      guard assets.count > 1 else {
        return Result(value: firstVideo)
      }
      
      let mainComposition = AVMutableComposition()
      let compositionVideoTrack = mainComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
      
      if let track = assets.first?.tracks(withMediaType: .video).first {
        compositionVideoTrack?.preferredTransform = track.preferredTransform
      }
      
      let soundtrackTrack = mainComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)
      
      var insertTime = CMTime.zero
      do {
        for videoAsset in assets {
          guard let videoTrack = videoAsset.tracks(withMediaType: .video).first else {
            continue
          }
          
          guard let audioTrack = videoAsset.tracks(withMediaType: .audio).first else {
            continue
          }
          
          try compositionVideoTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: videoTrack, at: insertTime)
          
          try soundtrackTrack?.insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: videoAsset.duration), of: audioTrack, at: insertTime)
          
          insertTime = CMTimeAdd(insertTime, videoAsset.duration)
        }
      } catch {
        return Result(error: .mergingVideoFailed(error))
      }
      
      return Result(value: mainComposition)
    }
    
    fileprivate func mergeToSingleVideo(assetsToMerge: [AVAsset], completion: @escaping AssetExportCompleteHandler) {
      let outputFileURL = URL(fileURLWithPath: NSTemporaryDirectory() + "\(identifier).mp4")
      let fileManager = FileManager()
      try? fileManager.removeItem(at: outputFileURL)
      
      let mergedAssetsResult = mergedAVAssetFor(assets: assetsToMerge)
      switch mergedAssetsResult {
      case .success(let mergedAsset):
        guard let exporter = AVAssetExportSession(asset: mergedAsset, presetName: settings.recordedVideoFileExportPreset) else {
          completion(Result(error: .exportVideoSessionFailed))
          return
        }
        
        exporter.outputURL = outputFileURL
        exporter.outputFileType = settings.outputFileType
        exporter.shouldOptimizeForNetworkUse = settings.shouldOptimizeForNetworkUse
        
        exporter.exportAsynchronously {
          DispatchQueue.main.async {
            switch exporter.status {
            case .unknown:
              break
            case .waiting:
              break
            case .exporting:
              break
            case .completed:
              completion(Result(value: outputFileURL))
            case .failed:
              AppLogger.error(exporter.error ?? "")
              completion(Result(error: .exportVideoSessionFailed))
            case .cancelled:
              completion(Result(value: outputFileURL))
            }
          }
        }
      case .failure(let error):
        completion(Result(error: error))
        return
      }
    }
  }
}

