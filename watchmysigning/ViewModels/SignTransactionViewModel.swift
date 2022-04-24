//
//  SignTransactionViewModel.swift
//  watchmysigning
//
//  Created by mgarciate on 23/4/22.
//

import SwiftUI
import EFQRCode
import web3
import BigInt

enum SignTransactionSteps: Int {
    case one = 1, two, three, success, error
}

final class SignTransactionViewModel: ObservableObject {
    @Published var qrImageData: CGImage?
    @Published var step: SignTransactionSteps = .one
    @Published var errorMessage: String?
    @Published var successMessage: String? = "Success"
    let nonce = 5
    let client = EthereumClient(url:  URL(string: Constants.clientUrl)!)
    
    init() {}
    
    func createTxQR() {
        qrImageData = nil
        guard let account = try? EthereumAccount(keyStorage: MyEthereumKeyStorageProtocol(privateKey: Constants.secretKey)) else { return }
        let tx = EthereumTransaction(from: nil, to: EthereumAddress(Constants.toAddress), value: BigUInt(1700000), data: nil, nonce: nonce, gasPrice: BigUInt(50000000), gasLimit: BigUInt(500000), chainId: Constants.chainId)
        var transactionHex: String?
        do {
            transactionHex = try account.sign(transaction: tx).raw?.web3.hexString
            print("tx \(tx.data?.web3.hexString)")
            print("transactionHex \(transactionHex)")
        } catch {
            print("ERROR \(error)")
        }
        guard let jsonData = try? JSONEncoder().encode(SigningAction(type: .txSigned, message: transactionHex)) else { return }
        generateQRCode(from: String(data: jsonData, encoding: .utf8)!)
        moveNextStep()
    }
    
    func generateQRCode(from string: String) {
        
        if let image = EFQRCode.generate(
            for: string
        ) {
            print("Create QRCode image success \(image)")
            qrImageData = image
        } else {
            print("Create QRCode image failed!")
            qrImageData = nil
        }
    }
    
    func moveNextStep() {
        DispatchQueue.main.async {
            let nextStepInt = self.step.rawValue + 1
            guard let nextStep = SignTransactionSteps(rawValue: nextStepInt) else { return }
            self.step = nextStep
        }
    }
}
