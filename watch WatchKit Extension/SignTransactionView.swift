//
//  SignTransactionView.swift
//  watch WatchKit Extension
//
//  Created by mgarciate on 23/4/22.
//

import SwiftUI
import web3

struct SignTransactionView: View {
    let address: String?
    @StateObject var viewModel = SignTransactionViewModel()
    
    var body: some View {
        VStack {
            switch viewModel.step {
            case .one:
                Text("one")
            case .two:
                if let cgImage = viewModel.qrImageData, let image = UIImage(cgImage: cgImage) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("NO QR")
                }
            case .three:
                Text("three")
            case .four:
                Text("four")
            }
        }
        .onAppear() {
            guard let address = address else { return }
            viewModel.generateQRCode(from: address)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.viewModel.moveNextStep()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.viewModel.moveNextStep()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.viewModel.moveNextStep()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.viewModel.moveNextStep()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.viewModel.moveNextStep()
                            }
                        }
                    }
                }
            }
        }
    }
}

struct SignTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        SignTransactionView(address: "0x0")
    }
}
