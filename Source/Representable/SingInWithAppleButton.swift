//
//  SingInWithAppleButton.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/08/23.
//

import AuthenticationServices
import CryptoKit
import Firebase
import SwiftUI

struct SignInWithAppleButton: UIViewRepresentable {
    @Binding var signInFlag: Bool
    
    init(signInFlag: Binding<Bool>) {
        self._signInFlag = signInFlag
    }
    
    class Coordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
        @State var currentNonce: String?
        @Binding var signInFlag: Bool

        init(signInFlag: Binding<Bool>) {
            self._signInFlag = signInFlag
        }
        
        private func randomNonceString(length: Int = 32) -> String {
            precondition(length > 0)
            let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
            var result = ""
            var remainingLength = length
            
            while remainingLength > 0 {
                let randoms: [UInt8] = (0..<16).map { _ in
                    var random: UInt8 = 0
                    let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                    if errorCode != errSecSuccess {
                        fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                    }
                    return random
                }
                
                randoms.forEach { random in
                    if remainingLength == 0 {
                        return
                    }
                    
                    if random < charset.count {
                        result.append(charset[Int(random)])
                        remainingLength -= 1
                    }
                }
            }
            
            return result
        }
        
        @available(iOS 13, *)
        func sha256(_ input: String) -> String {
            let inputData = Data(input.utf8)
            let hashedData = SHA256.hash(data: inputData)
            let hashString = hashedData.compactMap {
                return String(format: "%02x", $0)
            }.joined()
            
            return hashString
        }
        
        @available(iOS 13, *)
        @objc func startSignInWithAppleFlow() {
            let nonce = randomNonceString()
            currentNonce = nonce
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            request.nonce = sha256(nonce)
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
        
        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
            guard let window = UIApplication.shared.delegate?.window else {
                fatalError()
            }
            return window!
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: A login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                let credential = OAuthProvider.credential(
                    withProviderID: "apple.com",
                    idToken: idTokenString,
                    rawNonce: nonce
                )
                Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    if authResult?.user != nil {
                        self?.signInFlag.toggle()
                        return
                    }
                }
            }
        }
        
        func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
            print(error.localizedDescription)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(signInFlag: $signInFlag)
    }
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        let appleLoginButton = ASAuthorizationAppleIDButton(
            authorizationButtonType: .default,
            authorizationButtonStyle: .whiteOutline
        )
        
        appleLoginButton.addTarget(context.coordinator,
                                   action: #selector(Coordinator.startSignInWithAppleFlow),
                                   for: .touchUpInside)
        return appleLoginButton
    }
    
    func updateUIView(_: ASAuthorizationAppleIDButton, context _: Context) {}
}
