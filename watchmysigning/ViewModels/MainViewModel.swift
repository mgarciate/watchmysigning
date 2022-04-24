//
//  MainViewModel.swift
//  watchmysigning
//
//  Created by mgarciate on 23/4/22.
//

import SwiftUI
import web3
import BigInt

final class MainViewModel: ObservableObject {
    
    @Published var selectedAddress: String = ""
    @Published var txHashSigned: String = ""
    @Published var errorMessage: String = ""
    
    init() {
        guard let clientUrl = URL(string: Constants.clientUrl) else { return }
        let client = EthereumClient(url: clientUrl)
        guard let account = try? EthereumAccount(keyStorage: MyEthereumKeyStorageProtocol(privateKey: Constants.secretKey)) else { return }
        EthereumRPC.execute(session: URLSession(configuration: URLSession.shared.configuration), url: client.url, method: "eth_getBalance", params: [account.address.value, EthereumBlock.Latest.stringValue], receive: String.self) { (error, response) in
            if let resString = response as? String, let balanceInt = BigUInt(hex: resString.web3.noHexPrefix) {
                print("eth_getBalance1 \(balanceInt.convertToEther())")
            } else {
                print("eth_getBalance1 \(error?.localizedDescription)")
            }
        }
        selectedAddress = account.address.value
        let tx = EthereumTransaction(from: nil, to: EthereumAddress(Constants.toAddress), value: BigUInt(1700000), data: nil, nonce: 3, gasPrice: BigUInt(50000000), gasLimit: BigUInt(500000), chainId: Constants.chainId)
        var transactionHex: String?
        do {
            transactionHex = try account.sign(transaction: tx).raw?.web3.hexString
            print("tx \(tx.data?.web3.hexString)")
            print("transactionHex \(transactionHex)")
            txHashSigned = transactionHex ?? "NO"
            let dataSigned = try account.sign(message: "273648723672483647832")
            print("sign: \(dataSigned.web3.hexString)")
//            print("check: \(try KeyUtil.recoverPublicKey(message: "Hello message!".web3.keccak256, signature: ""))")
            print("check: \(try MyKeyUtils.recoverPublicKey(message: "273648723672483647832".web3.keccak256, signature: dataSigned))")
        } catch {
            print("ERROR \(error)")
        }
        
        
        EthereumRPC.execute(session: URLSession(configuration: URLSession.shared.configuration), url: client.url, method: "eth_sendRawTransaction", params: [transactionHex], receive: String.self) { (error, response) in
            if let resDataString = response as? String {
                self.txHashSigned = resDataString
            } else {
                self.errorMessage = error?.localizedDescription ?? EthereumClientError.unexpectedReturnValue.localizedDescription
            }
        }
        
//        client.eth_sendRawTransaction(tx, withAccount: account) { (error, tx) in
//            print(error)
//            print(tx)
//            guard let tx = tx else {
//                if let error = error {
//                    self.errorMessage = error.localizedDescription
//                }
//                return
//            }
//            self.txHashSigned = tx
//        }
    }
}
