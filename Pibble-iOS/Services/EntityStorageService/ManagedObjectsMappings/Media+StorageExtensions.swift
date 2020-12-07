//
//  Media+StorageExtensions.swift
//  Pibble
//
//  Created by Kazakov Sergey on 03.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation
import CoreData

extension MediaManagedObject: MappableManagedObject {
  typealias ID = Int64
  
  static func replaceOrCreate(with object: MediaProtocol, in context: NSManagedObjectContext) -> MediaManagedObject {
    let managedObject = MediaManagedObject.findOrCreate(with: object.identifier, in: context)
    managedObject.id = Int64(object.identifier)
    managedObject.s3Id = object.fileIdentifier
    
    managedObject.type = object.contentMimeType
    managedObject.urlString = object.mediaUrl
    managedObject.thumbnailUrlString = object.thumbnailUrl
    managedObject.posterUrlString = object.posterUrl
    managedObject.width = object.contentWidth
    managedObject.height = object.contentHeight
    
    managedObject.originalWidth = object.contentOriginalWidth
    managedObject.originalHeight = object.contentOriginalHeight
    
    managedObject.shouldPassVerification = object.shouldPassBitDNA
    managedObject.passedVerification = object.passedBitDNA
    managedObject.sortId = Int32(object.postSortId)
    managedObject.originalUrlString = object.originalMediaUrl
    
    
    return managedObject
  }
}

extension MediaManagedObject: MediaProtocol {
  var fileIdentifier: String {
    return s3Id ?? ""
  }
  
  var originalMediaUrl: String {
    return originalUrlString ?? ""
  }
  
  var contentOriginalWidth: Double {
    return originalWidth
  }
  
  var contentOriginalHeight: Double {
    return originalHeight
  }
  
  var posterUrl: String {
    return posterUrlString ?? ""
  }
  
  var mediaUrl: String {
    return urlString ?? ""
  }
  
  var postSortId: Int {
    return Int(sortId)
  }
  
  var shouldPassBitDNA: Bool {
    return shouldPassVerification
  }
  
  var passedBitDNA: Bool {
    return passedVerification
  }
  
  var contentWidth: Double {
    return width
  }
  
  var contentHeight: Double {
    return height
  }
  
  var thumbnailUrl: String {
    return thumbnailUrlString ?? ""
  }
  
  var identifier: Int {
    return Int(id)
  }
  
  var url: String {
    return urlString ?? ""
  }
  
  var contentMimeType: String {
    return type ?? ""
  }
}

extension MediaProtocol {
  func updateOrCreateManagedObject(in context: NSManagedObjectContext) {
    let _ = MediaManagedObject.replaceOrCreate(with: self, in: context)
  }
  
  func delete(in context: NSManagedObjectContext) {
    let managedObject = MediaManagedObject.replaceOrCreate(with: self, in: context)
    context.delete(managedObject)
  }
}
