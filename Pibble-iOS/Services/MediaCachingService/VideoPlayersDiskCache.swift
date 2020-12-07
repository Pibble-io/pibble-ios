//
//  VideoPlayersDiskCache.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 27/08/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import AVKit

class VideoPlayersDiskCache {
  fileprivate var preparedPlayers: [String: VideoPlayerServiceProtocol] = [:]
  fileprivate var preparedPlayersKeysQueue: [String] = []
  fileprivate let preparedPlayersMaxCapacity: Int = 11
  
  fileprivate var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
  
  fileprivate var dirUrlForCachedMediaFiles: URL {
    let mediaCacheDirName = "CachedMedia"
    var url = URL(fileURLWithPath: NSTemporaryDirectory())
    url.appendPathComponent(mediaCacheDirName)
    return url
  }
  
  fileprivate func urlStringToFilename(_ urlString: String) -> String {
    let stringWithoutHttp = urlString.stringByRemovingHttpPrefix
    return stringWithoutHttp.replacingOccurrences(of: "/", with: "_")
  }
  
  fileprivate func urlToCachedMediaFile(_ url: URL) -> URL {
    let urlStringToCachedMediaFilename = urlStringToFilename(url.absoluteString)
    
    var url = dirUrlForCachedMediaFiles
    url.appendPathComponent(urlStringToCachedMediaFilename)
    
    return url
  }
  
  init() {
    NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    
    NotificationCenter.default.addObserver(
      self, selector: #selector(cleanExpiredDiskCache), name: UIApplication.willTerminateNotification, object: nil)
    NotificationCenter.default.addObserver(
      self, selector: #selector(backgroundCleanExpiredDiskCache), name: UIApplication.didEnterBackgroundNotification, object: nil)
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  

  @objc func playerItemDidReachEnd(notification: NSNotification) {
    guard let notificationObject = notification.object as? AVPlayerItem else {
      return
    }
    
    guard let videoAsset = notificationObject.asset as? AVURLAsset else {
      return
    }
    
    let videoAssetUrl = videoAsset.url
    
    guard !videoAssetUrl.isFileURL else {
      return
    }
    
    AppLogger.debug("asset: \(videoAssetUrl)")
    
    //      player.pause()
    //      player.seekToTime(CMTime.zero)
    //      player.play()
    
    /*--------------------*/
    
    //    let url = videoAsset.url.urlToCachedMediaFile
    guard let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality) else {
      return
    }
    
    //    let filename = url.absoluteString.urlStringToCachedMediaFilename
    //
    let outputFileURL = urlToCachedMediaFile(videoAssetUrl)
    let fileManager = FileManager.default
    
    let dir = dirUrlForCachedMediaFiles
    
    if !fileManager.fileExists(atPath: dir.path) {
      try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
    }
    
    guard !fileManager.fileExists(atPath: outputFileURL.path) else {
      AppLogger.warning("video file already exists! \(outputFileURL.absoluteString)")
      return
    }
    
    exporter.outputURL = outputFileURL
    exporter.outputFileType = AVFileType.mp4
    
    exporter.exportAsynchronously(completionHandler: {
      switch exporter.status {
      case .unknown:
        AppLogger.debug("writing status unknown")
      case .waiting:
        AppLogger.debug("writing waiting")
      case .exporting:
        AppLogger.debug("writing status exporting")
      case .completed:
        AppLogger.debug("writing completed")
        
      case .failed:
        AppLogger.error("writing failed: \(exporter.error)")
      case .cancelled:
        AppLogger.debug("writing cancelled")
      }
    })
  }
  
  
  fileprivate var diskCachePath: URL {
    return dirUrlForCachedMediaFiles
  }
  
  fileprivate var diskCacheLastUseDateForVideoFiles: Date {
    return Date().addingTimeInterval(-TimeInterval.daysInterval(7))
  }
  
  fileprivate var ioQueue: DispatchQueue {
    return DispatchQueue.global(qos: .background)
  }
  
  fileprivate var maxDiskCacheSize: UInt {
    return 0
  }
  
  fileprivate var fileManager: FileManager {
    return FileManager.default
  }
  
  fileprivate func travelCachedFiles(onlyForCacheSize: Bool) -> (urlsToDelete: [URL], diskCacheSize: UInt, cachedFiles: [URL: URLResourceValues]) {
    
    let diskCacheURL = diskCachePath
    let resourceKeys: Set<URLResourceKey> = [.isDirectoryKey, .contentAccessDateKey, .totalFileAllocatedSizeKey]
    let expiredDate: Date? = diskCacheLastUseDateForVideoFiles
    
    var cachedFiles = [URL: URLResourceValues]()
    var urlsToDelete = [URL]()
    var diskCacheSize: UInt = 0
    
    
    for fileUrl in (try? fileManager.contentsOfDirectory(at: diskCacheURL, includingPropertiesForKeys: Array(resourceKeys), options: .skipsHiddenFiles)) ?? [] {
      
      do {
        let resourceValues = try fileUrl.resourceValues(forKeys: resourceKeys)
        // If it is a Directory. Continue to next file URL.
        if resourceValues.isDirectory == true {
          continue
        }
        
        // If this file is expired, add it to URLsToDelete
        if !onlyForCacheSize,
          let expiredDate = expiredDate,
          let lastAccessData = resourceValues.contentAccessDate,
          (lastAccessData as NSDate).laterDate(expiredDate) == expiredDate
        {
          urlsToDelete.append(fileUrl)
          continue
        }
        
        if let fileSize = resourceValues.totalFileAllocatedSize {
          diskCacheSize += UInt(fileSize)
          if !onlyForCacheSize {
            cachedFiles[fileUrl] = resourceValues
          }
        }
      } catch _ { }
    }
    
    return (urlsToDelete, diskCacheSize, cachedFiles)
  }
  
  func cleanExpiredDiskCache(completion handler: (()->())? = nil) {
    
    // Do things in concurrent io queue
    ioQueue.async {
      var (URLsToDelete, diskCacheSize, cachedFiles) = self.travelCachedFiles(onlyForCacheSize: false)
      
      for fileURL in URLsToDelete {
        do {
          try self.fileManager.removeItem(at: fileURL)
        } catch _ { }
      }
      
      if self.maxDiskCacheSize > 0 && diskCacheSize > self.maxDiskCacheSize {
        let targetSize = self.maxDiskCacheSize / 2
        
        // Sort files by last modify date. We want to clean from the oldest files.
        let sortedFiles = cachedFiles.keysSortedByValue {
          resourceValue1, resourceValue2 -> Bool in
          
          if let date1 = resourceValue1.contentAccessDate,
            let date2 = resourceValue2.contentAccessDate
          {
            return date1.compare(date2) == .orderedAscending
          }
          
          // Not valid date information. This should not happen. Just in case.
          return true
        }
        
        for fileURL in sortedFiles {
          
          do {
            try self.fileManager.removeItem(at: fileURL)
          } catch { }
          
          URLsToDelete.append(fileURL)
          
          if let fileSize = cachedFiles[fileURL]?.totalFileAllocatedSize {
            diskCacheSize -= UInt(fileSize)
          }
          
          if diskCacheSize < targetSize {
            break
          }
        }
      }
      
      DispatchQueue.main.async {
        handler?()
      }
    }
  }
  
  @objc fileprivate func cleanExpiredDiskCache() {
    cleanExpiredDiskCache(completion: nil)
  }
  
  @objc func backgroundCleanExpiredDiskCache() {
    backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask  { [weak self] in
      self?.endBackgroundTask()
    }
    
    AppLogger.debug("cleanExpiredDiskCache started")
    cleanExpiredDiskCache { [weak self] in
      self?.endBackgroundTask()
    }
  }
  
  func endBackgroundTask() {
    AppLogger.debug("Background task ended.")
    guard let backgroundTask = backgroundTaskIdentifier else {
      return
    }
    
    UIApplication.shared.endBackgroundTask(backgroundTask)
    backgroundTaskIdentifier = .invalid
  }
}


//MARL:- VideoPlayersCacheProtocol

extension VideoPlayersDiskCache: VideoPlayersCacheProtocol {
  func hasCacheFor(_ urlString: String) -> Bool {
    guard let url = URL(string: urlString) else {
      return false
    }
    
    let urlToCachedFile = urlToCachedMediaFile(url)
    
    return fileManager.fileExists(atPath: urlToCachedFile.path)
  }
  
  func getOrCreatePlayerFor(_ urlString: String) -> VideoPlayerServiceProtocol? {
    if let player = preparedPlayers[urlString],
      !player.isFailed {
      return player
    }
    
    guard let url = URL(string: urlString) else {
      return nil
    }
    
    let urlToCachedFile = urlToCachedMediaFile(url)
    
    guard fileManager.fileExists(atPath: urlToCachedFile.path) else {
      return nil
    }
    
    AppLogger.debug("using cached file for: \(urlString)")
    let player = VideoPlayerService(url: urlToCachedFile, delegate: nil)
    
    preparedPlayers[urlString] = player
    preparedPlayersKeysQueue.append(urlString)
    
    if preparedPlayers.count > preparedPlayersMaxCapacity {
      let itemsToRemoveCount =  preparedPlayers.count - preparedPlayersMaxCapacity
      
      for _ in 0..<itemsToRemoveCount {
        let indexToRemove = preparedPlayersKeysQueue.enumerated().first {
          let isPlaying = (preparedPlayers[$0.element]?.isPlaying ?? false)
          return !isPlaying
        }
        
        guard let index = indexToRemove else {
          break
        }
        
        let key = preparedPlayersKeysQueue.remove(at: index.offset)
        
        preparedPlayers[key]?.pause()
        preparedPlayers[key]?.cancel()
        preparedPlayers.removeValue(forKey: key)
        
        AppLogger.debug("removed player for \(key), total players: \(preparedPlayers.count)")
      }
    }
    
    player.prepare()
    return player
  }
}

//MARK:- Dictionary extensions

extension Dictionary {
  fileprivate func keysSortedByValue(_ isOrderedBefore: (Value, Value) -> Bool) -> [Key] {
    return Array(self).sorted{ isOrderedBefore($0.1, $1.1) }.map{ $0.0 }
  }
}
