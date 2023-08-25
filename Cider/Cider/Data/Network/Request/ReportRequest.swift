//
//  ReportRequest.swift
//  Cider
//
//  Created by 임영선 on 2023/08/25.
//

import Foundation

struct ReportRequest: Codable {
    let contentId: Int
    let reason: String
}
