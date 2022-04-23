//
//  SignTransactionView.swift
//  watchmysigning
//
//  Created by mgarciate on 23/4/22.
//

import SwiftUI

struct SignTransactionView: View {
    @StateObject var viewModel = SignTransactionViewModel()
    
    var body: some View {
        VStack {
            if let cgImage = viewModel.qrImageData, let image = UIImage(cgImage: cgImage) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 200, height: 200)
            } else {
                Text("NO QR")
            }
        }
        .navigationTitle("Sign transaction")
    }
}

struct SignTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignTransactionView()
        }
    }
}
