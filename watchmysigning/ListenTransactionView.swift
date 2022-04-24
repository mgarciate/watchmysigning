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
    
    var body: some View {
        VStack {
            switch viewModel.step {
            case .one:
                Text("Scan QR address")
            case .two:
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
        .sheet(isPresented: $viewModel.isShowingScanner) {
            CodeScannerView(codeTypes: [.qr]) { result in
                switch result {
                case .success(let qr):
                    guard let qrData = qr.string.data(using: .utf8), let action = try? JSONDecoder().decode(SigningAction.self, from: qrData) else { return }
                    print(action)
                    viewModel.isShowingScanner = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.viewModel.handleAction(action)
                    }
                case .failure(let error):
                    print("Scanning failed: \(error.localizedDescription)")
                }
            }
        }
        .onAppear() {
            viewModel.type = type
            viewModel.isShowingScanner = true
        }
    }
}

struct ListenTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        ListenTransactionView(type: .tx)
    }
}
