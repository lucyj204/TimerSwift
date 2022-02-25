//
//  TimerModel.swift
//  TimerSwift
//
//  Created by Lucy Joyce on 22/02/2022.
//

import Foundation

struct TimerData: Codable {
    let id: UUID
    var name: String
    let startTime: Date?
    var completionTime: Date?
}


