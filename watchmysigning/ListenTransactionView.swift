//
//  ListenTransactionView.swift
//  watchmysigning
//
//  Created by mgarciate on 23/4/22.
//

import SwiftUI
import CodeScanner

enum ListenTransactionType {
    case tx, message
}

struct ListenTransactionView: View {
    let type: ListenTransactionType
    @StateObject var viewModel = ListenTransactionViewModel()
    @State private var isShowingScanner = false
    
    var body: some View {
        VStack {
            switch viewModel.step {
            case .one:
                Text("Scan QR address")
            case .two:
                // Request transaction
                if let cgImage = viewModel.qrImageData, let image = UIImage(cgImage: cgImage) {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 200, height: 200)
                        .onTapGesture {
                            viewModel.moveNextStep()
                            isShowingScanner = true
                        }
                } else {
                    Text("NO QR")
                }
            case .three:
                switch type {
                case .tx:
                    Text("Scan QR tx")
                case .message:
                    Text("Scan QR message")
                }
            case .success:
                Text(viewModel.successMessage ?? "")
            case .error:
                Text(viewModel.errorMessage ?? "")
                    .foregroundColor(.red)
            }
        }
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr]) { result in
                switch result {
                case .success(let qr):
                    guard let qrData = qr.string.data(using: .utf8), let action = try? JSONDecoder().decode(SigningAction.self, from: qrData) else { return }
                    print(action)
                    isShowingScanner = false
                    viewModel.handleAction(action)
                case .failure(let error):
                    print("Scanning failed: \(error.localizedDescription)")
                }
            }
        }
        .onAppear() {
            viewModel.type = type
            isShowingScanner = true
        }
    }
}

struct ListenTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        ListenTransactionView(type: .tx)
    }
}
