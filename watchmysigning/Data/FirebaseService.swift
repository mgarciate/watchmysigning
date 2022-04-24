//
//  FirebaseService.swift
//  watchmysigning
//
//  Created by mgarciate on 24/4/22.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

protocol FirebaseService {
    func currentAction(completion: @escaping (Result<SigningAction, Error>) -> Void)
    func save(action: SigningAction)
    func remove(completion: @escaping (Result<Bool, Error>) -> Void)
}

class FirebaseServiceImpl: FirebaseService {
    let ref: DatabaseReference
    
    init() {
        ref = Database.database().reference()
    }
    
    func currentAction(completion: @escaping (Result<SigningAction, Error>) -> Void) {
        ref.child("/sharedAction").observe(.value) { snapshot in
            // Get gas price value
            guard let value = snapshot.value as? NSDictionary,
                  let type = value["type"] as? String,
                  let actionType = SigningActionType(rawValue: type) else { return }
            let address = value["address"] as? String
            let amount = value["amount"] as? Int
            let nonce = value["nonce"] as? Int
            let message = value["message"] as? String
            completion(.success(SigningAction(type: actionType, address: address, amount: amount, nonce: nonce, message: message)))
        }
    }
    
    func save(action: SigningAction) {
        let post: [String: Any] = [
            "type": action.type.rawValue,
            "address": action.address,
            "amount": action.amount,
            "nonce" : action.nonce,
            "message": action.message
        ]
        let childUpdates = ["/sharedAction": post]
        ref.updateChildValues(childUpdates)
    }
    
    func remove(completion: @escaping (Result<Bool, Error>) -> Void) {
        let childUpdates = ["/sharedAction": []]
        ref.updateChildValues(childUpdates) { error, ref in
            guard let error = error else {
                completion(.success(true))
                return
            }
            completion(.failure(error))
        }
    }
}
