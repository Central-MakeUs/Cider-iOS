//
//  ViewModelType.swift
//  Cider
//
//  Created by 임영선 on 2023/07/07.
//

import Foundation
import Combine

public protocol ViewModelType {
    associatedtype ViewModelState
    
    var state: AnyPublisher<ViewModelState, Never> { get }
}
