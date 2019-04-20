//
//  roomNumGenerator.swift
//  assassinGame
//
//  Created by David Kang on 4/20/19.
//  Copyright © 2019 Divi Schmidt. All rights reserved.
//

import Foundation

class roomNumGenerator {
    static func generateRoomNumber() -> Int {
        
        let digits = 0...9
        let shuffledDigits = digits.shuffled()
        let fourDigits = shuffledDigits.prefix(4)
        let value = fourDigits.reduce(0) {
            $0*10 + $1
        }
        return value
    }
}
