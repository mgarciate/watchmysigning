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
            if let cgImage = viewModel.qrImageData, let image = UIImage(cgImage: cgImage) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("NO QR")
            }
        }
        .onAppear() {
            guard let address = address else { return }
            viewModel.generateQRCode(from: address)
        }
    }
}

struct SignTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        SignTransactionView(address: "0x0")
    }
}
