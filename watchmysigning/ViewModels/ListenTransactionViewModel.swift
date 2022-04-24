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
    case one = 1, two, success, error
}

final class ListenTransactionViewModel: ObservableObject {
    @Published var step: ListenTransactionSteps = .one
    @Published var nonce: Int?
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var isShowingScanner = false
    let client = EthereumClient(url:  URL(string: Constants.clientUrl)!)
    var type: ListenTransactionType = .tx
    let service = FirebaseServiceImpl()
    
    init() {
        FirebaseServiceImpl().remove() { result in
            switch result {
            case .success: break
            case .failure: break
            }
        }
    }
    
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
            switch type {
            case .tx:
                print("search nonce")
                client.eth_getTransactionCount(address: EthereumAddress(Constants.fromAddress), block: .Pending) { (error, count) in
                    guard let nonce = count else {
                        print("eth_getTransactionCount \(error)")
                        return
                    }
                    print(nonce)
                    self.service.save(action: SigningAction(type: .requestTx, address: Constants.toAddress, amount: 1750000, nonce: nonce))
                    self.moveNextStep()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.isShowingScanner = true
                    }
                }
            case .message:
                self.service.save(action: SigningAction(type: .requestMessage, address: Constants.toAddress, message: Constants.message))
                self.moveNextStep()
                self.moveNextStep()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isShowingScanner = true
                }
            }
            
        case .requestTx, .requestMessage, .success:
            break
        case .txSigned:
            print(action)
            guard let txSignedHex = action.message else { return }
            EthereumRPC.execute(session: URLSession(configuration: URLSession.shared.configuration), url: client.url, method: "eth_sendRawTransaction", params: [txSignedHex], receive: String.self) { (error, response) in
                if let resDataString = response as? String {
                    self.service.save(action: SigningAction(type: .success, message: "Transaction submited with Id: \(resDataString)"))
                    self.successMessage = "Transaction submited with Id: \(resDataString)"
                    self.step = .success
                } else {
                    self.showError(message: error?.localizedDescription ?? EthereumClientError.unexpectedReturnValue.localizedDescription)
                }
            }
        case .messageSigned:
            guard let message = action.message, let hexData = message.web3.hexData, let address = try? MyKeyUtils.recoverPublicKey(message: Constants.message.web3.keccak256, signature: hexData) else {
                showError(message: "Problem with message \(action.message)")
                return
            }
            successMessage = "Message from address \(address.lowercased() == Constants.toAddress.lowercased())"
            self.service.save(action: SigningAction(type: .success, message: "Message from address \(address.lowercased() == Constants.toAddress.lowercased())"))
            step = .success
        }
    }
    
    private func showError(message: String) {
        self.errorMessage = message
        self.step = .error
    }
}
