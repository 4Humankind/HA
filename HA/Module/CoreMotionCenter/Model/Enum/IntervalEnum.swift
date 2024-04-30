//
//  IntervalEnum.swift
//  HA
//
//  Created by SeoJunYoung on 4/30/24.
//

import Foundation

enum IntervalEnum {
    case hz30
    case hz60
    case hz120
}

extension IntervalEnum {
    var value: Double {
        switch self {
        case .hz30:
            return 1 / 30
        case .hz60:
            return 1 / 60
        case .hz120:
            return 1 / 120
        }
    }
}
