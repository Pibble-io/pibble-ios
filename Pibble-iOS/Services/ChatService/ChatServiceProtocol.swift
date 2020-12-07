//
//  ChatServiceProtocol.swift
//  Pibble
//
//  Created by Sergey Kazakov on 14/02/2019.
//  Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

protocol ChatServiceProtocol {
  func createChatRoomFor(_ users: [UserProtocol], complete: @escaping ResultCompleteHandler<PartialChatRoomProtocol, PibbleError>)
  func createChatRoomFor(_ post: PostingProtocol, complete: @escaping ResultCompleteHandler<PartialChatRoomProtocol, PibbleError>)
  
  func createTextMessageFor(_ room: ChatRoomProtocol, text: String, complete: @escaping ResultCompleteHandler<PartialChatMessageEntity, PibbleError>)
  
  func showChatRoom(_ roomId: Int, complete: @escaping ResultCompleteHandler<PartialChatRoomProtocol, PibbleError>)
  
  func getMessagesForRoom(_ room: ChatRoomProtocol, page: Int, perPage: Int, complete: @escaping ResultCompleteHandler<([PartialChatMessageEntity], PaginationInfoProtocol), PibbleError>)
  
  func createChatMessageForPost(_ post: PostingProtocol, complete: @escaping CompleteHandler)
  
  func getRooms(page: Int, perPage: Int, complete: @escaping ResultCompleteHandler<([PartialChatRoomProtocol], PaginationInfoProtocol), PibbleError>)
  
  func getPrivateChatRooms(page: Int, perPage: Int, complete: @escaping ResultCompleteHandler<([PartialChatRoomProtocol], PaginationInfoProtocol), PibbleError>)

  func getCommerceRoomsGroups(page: Int, perPage: Int, complete: @escaping ResultCompleteHandler<([PartialChatRoomsGroupProtocol], PaginationInfoProtocol), PibbleError>)
  
  func getChatRoomsForPostGroup(_ postId: Int, page: Int, perPage: Int, complete: @escaping ResultCompleteHandler<PartialChatRoomsGroupProtocol, PibbleError>)
  
  func markAllMessagesAsRead(_ room: ChatRoomProtocol, complete: @escaping CompleteHandler)
  
  func setLeaveStateForRoom(_ room: ChatRoomProtocol, left: Bool, complete: @escaping CompleteHandler)
  
  func setMuteStateForRoom(_ room: ChatRoomProtocol, muted: Bool, complete: @escaping CompleteHandler)
}
