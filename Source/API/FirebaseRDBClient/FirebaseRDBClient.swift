//
//  FirebaseRDBClient.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/09/07.
//

import Combine
import Firebase

protocol FirebaseDataFetchable {
    func nameResponder() -> AnyPublisher<NameCoordinater, FirebaseRDBClientError>
    func uidResponder() -> AnyPublisher<UidCoordinater, FirebaseRDBClientError>
    func toDoResponder() -> AnyPublisher<ToDoCoordinater, FirebaseRDBClientError>
}

class FirebaseRDBClient {
    private var ref: DatabaseReference!
    
    enum Path {
        case userName, userUid, userTodo
    }
    
    private func pathChanger(path: Path) -> String {
        guard let userUID = UserDefaults.standard.string(forKey: "userUID") else { return "" }
        switch path {
        case .userName: return "user_info/\(userUID)/name"
        case .userUid: return "user_info/\(userUID)/uid"
        case .userTodo: return "user_info/\(userUID)/todo_list"
        }
    }
    
    private func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, FirebaseRDBClientError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        return Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                .disconnect(description: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - FirebaseDataFetchable
extension FirebaseRDBClient: FirebaseDataFetchable {
    func nameResponder() -> AnyPublisher<NameCoordinater, FirebaseRDBClientError> {
        firebaseDataReceiver(with: pathChanger(path: .userName))
    }
    
    func uidResponder() -> AnyPublisher<UidCoordinater, FirebaseRDBClientError> {
        firebaseDataReceiver(with: pathChanger(path: .userUid))
    }
    
    func toDoResponder() -> AnyPublisher<ToDoCoordinater, FirebaseRDBClientError> {
        firebaseDataReceiver(with: pathChanger(path: .userTodo))
    }
    
    private func firebaseDataReceiver<T>(with path: String) -> AnyPublisher<T, FirebaseRDBClientError> where T: Decodable {
        Deferred {
            Future<T, FirebaseRDBClientError> { [weak self] promiss in
                self?.ref.child("\(path)").observeSingleEvent(of: .value, with: { snapshot in
                    guard let snap = snapshot as? T else {
                        return promiss(.failure(.connect(description: "firebase is Not Data")))
                    }
                    return promiss(.success(snap))
                }, withCancel: { error in
                    return promiss(.failure(.disconnect(description: error.localizedDescription)))
                })
            }.mapError { error in
                .disconnect(description: error.localizedDescription)
            }.flatMap(maxPublishers: .max(1)) { pair in
                self.decode(pair as! Data)
            }
        }.eraseToAnyPublisher()
    }
}
