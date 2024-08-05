//
//  Extension+Double.swift
//  SimpleMovieApp
//
//  Created by Tow Ching Shen on 04/08/2024.
//

import Foundation

extension Double {
    func round(to decimalPlaces: Int) -> Double {
        let precisionNumber = pow(10,Double(decimalPlaces))
        var n = self // self is a current value of the Double that you will round
        n = n * precisionNumber
        n.round()
        n = n / precisionNumber
        return n
    }
}
