//
//  UserDefaultsClient.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/09/13.
//

import Foundation

final class UserDefaultsClient {
    enum ObjectKey {
        case uid, style
    }
    
    private func userDefaultsKey(_ objectKey: ObjectKey) -> String {
        switch objectKey {
        case .uid: return "uid"
        case .style: return "style"
        }
    }
    
    func get<T>(objectKey: ObjectKey) -> T? {
        UserDefaults.standard.object(forKey: userDefaultsKey(objectKey).description) as? T
    }
    
    func set<T>(_ value: T, objectKey: ObjectKey) {
        UserDefaults.standard.set(value, forKey: userDefaultsKey(objectKey).description)
    }
    
    func remove(objectKey: ObjectKey) {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey(objectKey).description)
    }
}
