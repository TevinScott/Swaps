//
//  String+ToBoolean.swift
//  Swaps
//
//  Created by Tevin Scott on 10/21/17.
//  Copyright © 2017 Tevin Scott. All rights reserved.
//

import Foundation
extension String {
    func toBool() -> Bool? {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return nil
        }
    }
}
