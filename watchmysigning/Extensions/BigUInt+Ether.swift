//
//  BigUInt+Ether.swift
//  watchmysigning
//
//  Created by mgarciate on 23/4/22.
//

import Foundation
import BigInt

extension BigUInt {
    func convertToEther() -> Float {
        Float(self) / pow(10, 18)
    }
}
