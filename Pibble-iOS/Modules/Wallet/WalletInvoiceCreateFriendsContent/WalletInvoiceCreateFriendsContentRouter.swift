//
//  WalletInvoiceCreateFriendsContentRouter.swift
//  Pibble-iOS
//
//  Created by Kazakov Sergey on 01.09.2018.
//Copyright © 2018 com.kazai. All rights reserved.
//

import Foundation

// MARK: - WalletInvoiceCreateFriendsContentRouter class
final class WalletInvoiceCreateFriendsContentRouter: Router {
}

// MARK: - WalletInvoiceCreateFriendsContentRouter API
extension WalletInvoiceCreateFriendsContentRouter: WalletInvoiceCreateFriendsContentRouterApi {
}

// MARK: - WalletInvoiceCreateFriendsContent Viper Components
fileprivate extension WalletInvoiceCreateFriendsContentRouter {
    var presenter: WalletInvoiceCreateFriendsContentPresenterApi {
        return _presenter as! WalletInvoiceCreateFriendsContentPresenterApi
    }
}
