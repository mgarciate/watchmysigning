//
//  SignTransactionViewModel.swift
//  watchmysigning
//
//  Created by mgarciate on 23/4/22.
//

import SwiftUI
import EFQRCode

enum SignTransactionSteps: Int {
    case one = 1, two, three, four
}

final class SignTransactionViewModel: ObservableObject {
    @Published var qrImageData: CGImage?
    @Published var step: SignTransactionSteps = .one
    
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
    
    func moveNextStep() {
        let nextStepInt = step.rawValue + 1
        guard let nextStep = SignTransactionSteps(rawValue: nextStepInt) else { return }
        step = nextStep
    }
}
