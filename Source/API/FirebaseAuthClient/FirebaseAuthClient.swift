//
//  FirebaseAuthClient.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/09/13.
//

import Combine
import FirebaseAuth
import GoogleSignIn


protocol FirebaseAuthClientSignInable {
    func signInToFirebaseWithApple(credential: AuthCredential) -> AnyPublisher<AuthDataResult, FirebaseAuthClientError>
    func signInToFirebaseWithGoogle(credential: AuthCredential) -> AnyPublisher<AuthDataResult, FirebaseAuthClientError>
}

class FirebaseAuthClient {
    let userDefaultsClient: UserDefaultsClient
    
    init() {
        self.userDefaultsClient = UserDefaultsClient()
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

// MARK: - FirebaseAuthClientSignInable
extension FirebaseAuthClient: FirebaseAuthClientSignInable {
    func signInToFirebaseWithApple(credential: AuthCredential) -> AnyPublisher<AuthDataResult, FirebaseAuthClientError> {
        signIn(credential: credential)
    }

    func signInToFirebaseWithGoogle(credential: AuthCredential) -> AnyPublisher<AuthDataResult, FirebaseAuthClientError> {
        signIn(credential: credential)
    }
    
    func signIn<T>(credential: AuthCredential) -> AnyPublisher<T, FirebaseAuthClientError> where T: AuthDataResult {
        Deferred {
            Future<T, FirebaseAuthClientError> { promiss in
                Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                    if let error = error {
                        return promiss(.failure(FirebaseAuthClientError.disconnect(description: error.localizedDescription)))
                    }
                    
                    if let result = authResult as? T {
                        self?.userDefaultsClient.set(String(result.user.uid), objectKey: .uid)
                        return promiss(.success(result))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}
