//
//  VideoPlayersInMemoryCache.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 27/08/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import AVKit

class VideoStreamingPlayersInMemoryCache {
  fileprivate var preparedPlayers: [String: VideoPlayerServiceProtocol] = [:]
  fileprivate var preparedPlayersKeysQueue: [String] = []
  fileprivate let preparedPlayersMaxCapacity: Int = 3
  
  fileprivate lazy var resourceLoaderDelegate: AVAssetResourceLoaderDelegate = {
    return ResourceLoaderDelegate()
  }()
}

//MARK:- VideoPlayersCacheProtocol

extension VideoStreamingPlayersInMemoryCache: VideoPlayersCacheProtocol {
  func hasCacheFor(_ urlString: String) -> Bool {
    return preparedPlayers[urlString] != nil
  }
  
  func getOrCreatePlayerFor(_ urlString: String) -> VideoPlayerServiceProtocol? {
    if let player = preparedPlayers[urlString],
      !player.isFailed {
      return player
    }
    
    guard let url = URL(string: urlString) else {
      return nil
    }
    
    let player: VideoPlayerService
    
    player = VideoPlayerService(url: url, delegate: resourceLoaderDelegate)
    AppLogger.debug("using streaming player for: \(urlString)")
    
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


//MARK:- ResourceLoaderDelegate

//ResourceLoaderDelegate is required for writing players items to disk

fileprivate class ResourceLoaderDelegate: NSObject, AVAssetResourceLoaderDelegate {
  
}
