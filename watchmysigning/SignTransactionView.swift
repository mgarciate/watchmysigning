//
//  SignTransactionView.swift
//  watchmysigning
//
//  Created by mgarciate on 23/4/22.
//

import SwiftUI

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
                        .frame(width: 200, height: 200)
                } else {
                    Text("NO QR")
                }
            case .three:
                Text("three")
            case .success:
                Text(viewModel.successMessage ?? "")
            case .error:
                Text(viewModel.errorMessage ?? "")
                    .foregroundColor(.red)
            }
            
        }
        .navigationTitle("Sign transaction")
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
        NavigationView {
            SignTransactionView(address: "0x0")
        }
    }
}
