//
//  FirebaseDataResponse.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/09/07.
//

import Foundation

// MARK: - FirebaseDataResponse
struct FirebaseDataResponse: Codable {
    let userInfo: [UserInfo]
    
    enum CodingKeys: String, CodingKey {
        case userInfo = "user_info"
    }

    struct UserInfo: Codable {
        let name: String
        let toDoList: [ToDoList]
        let uid: String
    
        enum CodingKeys: String, CodingKey {
            case name
            case toDoList = "todo_list"
            case uid
        }
        
        struct ToDoList: Codable {
            let note: String
            let scheduleDate: Date
            let completed: Bool
            let title: String
            let createdDate: Data
        }
    }
}

// MARK: - NameCoordinater
struct NameCoordinater: Codable {
    let name: String
}

// MARK: - UidCoordinater
struct UidCoordinater: Codable {
    let uid: String
}

// MARK: - ToDoCoordinater
struct ToDoCoordinater: Codable {
    let todoList: [ToDoCoordinater]

    enum CodingKeys: String, CodingKey {
        case todoList = "todo_list"
    }
    
    // MARK: - ToDoListCoordinater at ToDoCoordinater
    struct ToDoCoordinater: Codable {
        let note: String
        let scheduleDate: Date
        let completed: Bool
        let title: String
        let createdDate: Date
    }
}
