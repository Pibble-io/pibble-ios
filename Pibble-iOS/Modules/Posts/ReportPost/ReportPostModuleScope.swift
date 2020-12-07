//
//  ReportPostModuleScope.swift
//  Pibble-iOS
//
//  Created by Sergey Kazakov on 01/05/2019.
//Copyright © 2019 com.kazai. All rights reserved.
//

import Foundation

enum ReportPost {
  struct ItemViewModel: ReportPostItemViewModelProtocol {
    var title: String
    
    init(reason: PostReportReasonProtocol) {
      title = reason.reasonTitle
    }
    
  }
}

extension ReportPostReason: ReportPostItemViewModelProtocol {
  
}
 
