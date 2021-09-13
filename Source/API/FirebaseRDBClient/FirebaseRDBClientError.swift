//
//  FirebaseRDBClientError.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/09/07.
//

import Foundation

// MARK: - FirebaseRDBClientError
enum FirebaseRDBClientError: Error {
    case connect(description: String)
    case disconnect(description: String)
}
