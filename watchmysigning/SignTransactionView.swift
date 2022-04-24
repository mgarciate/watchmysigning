//
//  SignTransactionView.swift
//  watchmysigning
//
//  Created by mgarciate on 23/4/22.
//

import SwiftUI
import web3

struct SignTransactionView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let address: String?
    @StateObject var viewModel = SignTransactionViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                switch viewModel.step {
                case .one:
                    if let cgImage = viewModel.qrImageData, let image = UIImage(cgImage: cgImage) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("Creating QR")
                    }
                case .two:
                    VStack {
                        Text("Transfer 0.0123 ETH?")
                        Button("OK", role: .none) {
                            viewModel.createQR(action: SigningAction(type: .requestMessage, address: Constants.toAddress, message: Constants.message))
                        }
                        Button("Cancel", role: .destructive) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .padding()
                case .three:
                    if let cgImage = viewModel.qrImageData, let image = UIImage(cgImage: cgImage) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .onTapGesture {
                                viewModel.step = .success
                            }
                    } else {
                        Text("Creating QR")
                    }
                case .success:
                    Text(viewModel.successMessage ?? "")
                case .error:
                    Text(viewModel.errorMessage ?? "")
                        .foregroundColor(.red)
                }
            }
            .onTapGesture {
                viewModel.moveNextStep()
            }
        }
        .onAppear() {
            guard let address = address else { return }
            guard let jsonData = try? JSONEncoder().encode(SigningAction(type: .address, address: address)) else { return }
            viewModel.generateQRCode(from: String(data: jsonData, encoding: .utf8)!)
        }
    }
}

struct SignTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        SignTransactionView(address: "0x0")
    }
}
