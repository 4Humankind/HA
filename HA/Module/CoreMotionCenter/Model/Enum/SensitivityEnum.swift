//
//  SensitivityEnum.swift
//  HA
//
//  Created by SeoJunYoung on 4/30/24.
//

import Foundation

enum SensitivityEnum {
    case sensitive
    case normal
    case insensitive
}

extension SensitivityEnum {
    var value: Double {
        switch self {
        case .sensitive:
            return 1
        case .normal:
            return 5
        case .insensitive:
            return 10
        }
    }
}
