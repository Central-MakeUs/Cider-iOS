//
//  String+Extension.swift
//  Cider
//
//  Created by 임영선 on 2023/07/16.
//

import Foundation

extension String {
    
    func substring(start: Int, end: Int) -> String {
        let start = self.index(self.startIndex, offsetBy: start)
        let end = self.index(self.startIndex, offsetBy: end)
        return String(self[start..<end])
    }
    
}