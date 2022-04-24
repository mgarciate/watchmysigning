//
//  SigningAction.swift
//  watchmysigning
//
//  Created by mgarciate on 24/4/22.
//

import Foundation

enum SigningActionType: String, Codable {
    case address, requestTx, requestMessage, txSigned, messageSigned
}

class SigningAction: Codable {
    let type: SigningActionType
    let address: String?
    let amount: Int?
    let nonce: Int?
    let message: String?
    
    init(type: SigningActionType,
         address: String? = nil,
         amount: Int? = nil,
         to: String? = nil,
         nonce: Int? = nil,
         message: String? = nil) {
        self.type = type
        self.address = address
        self.amount = amount
        self.nonce = nonce
        self.message = message
    }
}
