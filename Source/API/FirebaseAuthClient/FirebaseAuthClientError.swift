//
//  FirebaseAuthClientError.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/09/13.
//

import Foundation

// MARK: - FirebaseAuthClientError
enum FirebaseAuthClientError: Error {
    case connect(description: String)
    case disconnect(description: String)
}
