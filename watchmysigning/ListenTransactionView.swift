//
//  ListenTransactionView.swift
//  watchmysigning
//
//  Created by mgarciate on 23/4/22.
//

import SwiftUI
import CodeScanner

struct ListenTransactionView: View {
    @State private var isShowingScanner = false
    
    var body: some View {
        VStack {
            Button("Show Scanner") {
                isShowingScanner = true
            }
        }
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr]) { result in
                switch result {
                case .success(let qr):
                    print("result: \(qr.string)")
                case .failure(let error):
                    print("Scanning failed: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
       isShowingScanner = false
       // more code to come
    }
}

struct ListenTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        ListenTransactionView()
    }
}
