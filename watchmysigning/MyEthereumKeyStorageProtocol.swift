//
//  MyEthereumKeyStorageProtocol.swift
//  watchmysigning
//
//  Created by mgarciate on 23/4/22.
//

import Foundation
import web3

struct MyEthereumKeyStorageProtocol: EthereumKeyStorageProtocol {
    let privateKey: String
    
    func storePrivateKey(key: Data) throws {
        // do nothing
    }
    
    func loadPrivateKey() throws -> Data {
        return privateKey.web3.hexData!
    }
}
