//
//  LocationSearchServiceProtocol.swift
//  Pibble
//
//  Created by Kazakov Sergey on 21.08.2018.
//  Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

protocol LocationSearchServiceProtocol {
  func searchLocation(_ location: String, complete: @escaping
    ResultCompleteHandler<[SearchAutocompleteLocationProtocol], PibbleError>)
  
  func searchGooglePlace(_ placeId: String, complete: @escaping
    ResultCompleteHandler<SearchLocationProtocol, PibbleError>)
}
