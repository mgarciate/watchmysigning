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
    let client = EthereumClient(url:  URL(string: Constants.clientUrl)!)
    var currentAction = SigningAction(type: .address)
    
    init() {
        FirebaseServiceImpl().remove() { result in
            switch result {
            case .success: break
            case .failure: break
            }
        }
        FirebaseServiceImpl().currentAction { result in
            switch result {
            case .success(let action):
                #if DEBUG
                print("*** CURRENT DATA \(action.type)")
                #endif
                self.currentAction = action
                switch action.type {
                case.requestTx:
                    self.step = .two
                case.requestMessage:
                    self.step = .three
                case .address, .messageSigned, .txSigned:
                    break
                case .success:
                    self.successMessage = "All good, success"
                    self.step = .success
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func createQR(action: SigningAction) {
        switch action.type {
        case .address, .txSigned, .messageSigned, .success: break
        case .requestTx:
            createTxQR(action: action)
        case .requestMessage:
            createMessageSigned(action: action)
        }
    }
    
    private func createTxQR(action: SigningAction) {
        qrImageData = nil
        guard let account = try? EthereumAccount(keyStorage: MyEthereumKeyStorageProtocol(privateKey: Constants.secretKey)), let nonce = action.nonce, let address = action.address else { return }
        let tx = EthereumTransaction(from: nil, to: EthereumAddress(address), value: BigUInt(1700000), data: nil, nonce: nonce, gasPrice: BigUInt(50000000), gasLimit: BigUInt(500000), chainId: Constants.chainId)
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
    
    private func createMessageSigned(action: SigningAction) {
        qrImageData = nil
        guard let account = try? EthereumAccount(keyStorage: MyEthereumKeyStorageProtocol(privateKey: Constants.secretKey)), let message = action.message else { return }
        do {
            let dataSigned = try account.sign(message: message)
            print("sign: \(dataSigned.web3.hexString)")
            guard let jsonData = try? JSONEncoder().encode(SigningAction(type: .messageSigned, message: dataSigned.web3.hexString)) else { return }
            print(String(data: jsonData, encoding: .utf8)!)
            generateQRCode(from: String(data: jsonData, encoding: .utf8)!)
            moveNextStep()
        } catch {
            print("ERROR \(error)")
        }
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
