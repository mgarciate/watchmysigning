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
    private static let secretKey = "SK"
    private static let toAddress = "TO"
    private static let fromAddress = "FROM"
    
    @Published var selectedAddress: String = ""
    @Published var txHashSigned: String = ""
    @Published var errorMessage: String = ""
    
    init() {
        guard let clientUrl = URL(string: "https://kovan.optimism.io") else { return }
        let client = EthereumClient(url: clientUrl)
        guard let account = try? EthereumAccount(keyStorage: MyEthereumKeyStorageProtocol(privateKey: MainViewModel.secretKey)) else { return }
        EthereumRPC.execute(session: URLSession(configuration: URLSession.shared.configuration), url: client.url, method: "eth_getBalance", params: [account.address.value, EthereumBlock.Latest.stringValue], receive: String.self) { (error, response) in
            if let resString = response as? String, let balanceInt = BigUInt(hex: resString.web3.noHexPrefix) {
                print("eth_getBalance1 \(balanceInt.convertToEther())")
            } else {
                print("eth_getBalance1 \(error?.localizedDescription)")
            }
        }
        selectedAddress = account.address.value
        let tx = EthereumTransaction(from: nil, to: EthereumAddress(MainViewModel.toAddress), value: BigUInt(1700000), data: nil, nonce: 3, gasPrice: BigUInt(50000000), gasLimit: BigUInt(500000), chainId: 69)
        var transactionHex: String?
        do {
            transactionHex = try account.sign(transaction: tx).raw?.web3.hexString
            print("tx \(tx.data?.web3.hexString)")
            print("transactionHex \(transactionHex)")
            txHashSigned = transactionHex ?? "NO"
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
