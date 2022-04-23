//
//  SignTransactionViewModel.swift
//  watchmysigning
//
//  Created by mgarciate on 23/4/22.
//

import SwiftUI
import EFQRCode

final class SignTransactionViewModel: ObservableObject {
    @Published var qrImageData: CGImage?
    
    init() {}
    
    func generateQRCode(from string: String) {
        
        if let image = EFQRCode.generate(
            for: string
        ) {
            print("Create QRCode image success \(image)")
            qrImageData = image
        } else {
            print("Create QRCode image failed!")
            qrImageData = nil
        }
    }
}
