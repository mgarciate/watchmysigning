//
//  ListenTransactionViewModel.swift
//  watchmysigning
//
//  Created by mgarciate on 24/4/22.
//

import SwiftUI
import web3
import EFQRCode

enum ListenTransactionSteps: Int {
    case one = 1, two, three, success, error
}

final class ListenTransactionViewModel: ObservableObject {
    @Published var qrImageData: CGImage?
    @Published var step: ListenTransactionSteps = .one
    @Published var nonce: Int?
    @Published var errorMessage: String?
    @Published var successMessage: String?
    let client = EthereumClient(url:  URL(string: Constants.clientUrl)!)
    
    func moveNextStep() {
        DispatchQueue.main.async {
            let nextStepInt = self.step.rawValue + 1
            guard let nextStep = ListenTransactionSteps(rawValue: nextStepInt) else { return }
            self.step = nextStep
        }
    }
    
    func handleAction(_ action: SigningAction) {
        print(action)
        switch action.type {
        case .address:
            print("search nonce")
            client.eth_getTransactionCount(address: EthereumAddress(Constants.fromAddress), block: .Pending) { (error, count) in
                guard let nonce = count else {
                    print("eth_getTransactionCount \(error)")
                    return
                }
                print(nonce)
                guard let jsonData = try? JSONEncoder().encode(SigningAction(type: .requestTx, address: Constants.toAddress, amount: 1750000, nonce: nonce)) else { return }
                self.generateQRCode(from: String(data: jsonData, encoding: .utf8)!)
                self.moveNextStep()
            }
        case .requestTx, .requestMessage:
            break
        case .txSigned:
            print(action)
            guard let txSignedHex = action.message else { return }
            EthereumRPC.execute(session: URLSession(configuration: URLSession.shared.configuration), url: client.url, method: "eth_sendRawTransaction", params: [txSignedHex], receive: String.self) { (error, response) in
                if let resDataString = response as? String {
                    self.successMessage = "Transaction submited with Id: \(resDataString)"
                    self.step = .success
                } else {
                    self.showError(message: error?.localizedDescription ?? EthereumClientError.unexpectedReturnValue.localizedDescription)
                }
            }
        case .messageSigned:
            print("not implemented")
        }
    }
    
    private func showError(message: String) {
        self.errorMessage = message
        self.step = .error
    }
    
    private func generateQRCode(from string: String) {
        DispatchQueue.main.async {
            if let image = EFQRCode.generate(
                for: string
            ) {
                print("Create QRCode image success \(image)")
                self.qrImageData = image
            } else {
                print("Create QRCode image failed!")
                self.qrImageData = nil
            }
        }
    }
}
