//
//  CurrentMonthDate.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/10/23.
//

import Foundation

struct CurrentMonthDate: Identifiable, Equatable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
