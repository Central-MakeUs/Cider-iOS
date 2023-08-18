//
//  FileResponse.swift
//  Cider
//
//  Created by 임영선 on 2023/08/18.
//

import Foundation

struct CiderResponse: Codable {
    let status: Int?
    let error: String?
    let message: String?
}
