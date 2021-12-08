//
//  SignInWithGoogleButton.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/08/23.
//

import GoogleSignIn
import Firebase
import SwiftUI

struct SignInWithGoogleButton: UIViewRepresentable {
    @Binding var signInFlag: Bool
    
    init(signInFlag: Binding<Bool>) {
        self._signInFlag = signInFlag
    }
    
    class Coordinator: NSObject {
        @Binding var signInFlag: Bool
        
        private var ref: DatabaseReference!

        init(signInFlag: Binding<Bool>) {
            self._signInFlag = signInFlag
            self.ref = Database.database().reference()
        }
        
        @objc func startSignInWithGoogleFlow() {
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            let config = GIDConfiguration(clientID: clientID)
            
            guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
            
            GIDSignIn.sharedInstance.signIn(with: config, presenting: presentingViewController) { user, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard
                    let authentication = user?.authentication,
                    let idToken = authentication.idToken
                else {
                    return
                }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: authentication.accessToken)
                
                Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                    
                    if let error = error {
                        
                        print(error.localizedDescription)
                        
                        return
                        
                    }
                    
                    if let user = authResult?.user {

                        self?.ref.child("user_info/user/").setValue(["uuid": user.uid])
                        
                        self?.signInFlag.toggle()
                        
                        return
                        
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(signInFlag: $signInFlag)
    }
    
    func makeUIView(context: Context) -> GIDSignInButton {
        let googleSingInButton = GIDSignInButton()
        googleSingInButton.style = .wide
        googleSingInButton.addTarget(context.coordinator,
                                     action: #selector(Coordinator.startSignInWithGoogleFlow),
                                     for: .touchUpInside)
        return googleSingInButton
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: Context) {}
}
