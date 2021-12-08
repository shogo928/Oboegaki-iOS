//
//  LoginViewModel.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/08/23.
//

import Combine
import Firebase

// MARK: - LoginViewModelObject
protocol LoginViewModelObject: ViewModelObject where Input: LoginViewModelInputObject, Binding: LoginViewModelBindingObject, Output: LoginViewModelOutputObject {
    var input: Input { get }
    var binding: Binding { get set }
    var output: Output { get }
}

// MARK: - LoginViewModelObjectInputObject
protocol LoginViewModelInputObject: InputObject {
    var toPasswordTextFieldEntered: PassthroughSubject<String, Never> { get }
    
    var toPasswordShowTextTapped: PassthroughSubject<Void, Never> { get }
    var toLoginButtonTapped: PassthroughSubject<Void, Never> { get }
    var toTermsOfServiceButtonTapped: PassthroughSubject<Void, Never> { get }
    var toPrivacyPolicyButtonTapped: PassthroughSubject<Void, Never> { get }
    
    var toSignInWithAnonymouslyButtonTapped: PassthroughSubject<Void, Never> { get }
    var toSignInWithAppleButtonTapped: PassthroughSubject<Void, Never> { get }
    var toSignInWithGoogleButtonTapped: PassthroughSubject<Void, Never> { get }
    
    var toReWrithButtonTapped: PassthroughSubject<Void, Never> { get }
}

// MARK: - LoginViewModelObjectBindingObject
protocol LoginViewModelBindingObject: BindingObject {
    var isTermsOfServiceSheetFlag: Bool { get set }
    var isPrivacyPolicySheetFlag: Bool { get set }
    
    var isEntryEmailTextField: String { get set }
    var isEntryPasswordTextField: String { get set }
    var isEntryPasswordShowFlag: Bool { get set }
    
    var isSignInStatus: Bool { get set }
    
    var isScrollOffsetFlag: Bool { get set }
}

// MARK: - LoginViewModelOutputObject
protocol LoginViewModelOutputObject: OutputObject {
    var isSignInErrorMessege: String { get set }
    var isSignInResultMessege: String { get set }
}

// MARK: - LoginViewModel
class LoginViewModel: LoginViewModelObject {
    final class Input: LoginViewModelInputObject {
        var toPasswordTextFieldEntered: PassthroughSubject<String, Never> = PassthroughSubject<String, Never>()
        
        var toPasswordShowTextTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        var toLoginButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        var toTermsOfServiceButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        var toPrivacyPolicyButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        
        var toSignInWithAnonymouslyButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        var toSignInWithAppleButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        var toSignInWithGoogleButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        
        var toReWrithButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    }
    
    final class Binding: LoginViewModelBindingObject {
        @Published var isTermsOfServiceSheetFlag: Bool = false
        @Published var isPrivacyPolicySheetFlag: Bool = false
        
        @Published var isEntryEmailTextField: String = ""
        @Published var isEntryPasswordTextField: String = ""
        @Published var isEntryPasswordShowFlag: Bool = false
        
        @Published var isSignInStatus: Bool = false
        
        @Published var isScrollOffsetFlag: Bool = false
    }
    
    final class Output: LoginViewModelOutputObject {
        @Published var isSignInErrorMessege: String = ""
        @Published var isSignInResultMessege: String = ""
    }
    
    var input: Input
    
    var binding: Binding
    
    var output: Output
    
    private var ref: DatabaseReference!
    
    private var cancellables: [AnyCancellable] = []
    
    init(_ isFirebaseAuth: Bool) {
        input = Input()
        binding = Binding()
        output = Output()
        
        ref = Database.database().reference()
        Auth.auth().languageCode = "ja_JP"
        
        if isFirebaseAuth {
            
        } else {
            
        }
        
        input.toPasswordTextFieldEntered
            .sink(receiveValue: { [weak self] value in
                if value.count > 16 {
                    self?.binding.isEntryPasswordTextField = String(value.prefix(16))
                }
            })
            .store(in: &cancellables)
        
        input.toPasswordShowTextTapped
            .sink(receiveValue: { [weak self] in
                self?.binding.isEntryPasswordShowFlag.toggle()
            })
            .store(in: &cancellables)
        
        input.toLoginButtonTapped
            .sink(receiveValue: { [weak self] in
                self?.createEmailAccount(email: self?.binding.isEntryEmailTextField,
                                         password: self?.binding.isEntryPasswordTextField)
            })
            .store(in: &cancellables)
        
        input.toTermsOfServiceButtonTapped
            .sink(receiveValue: { [weak self] in
                self?.binding.isTermsOfServiceSheetFlag.toggle()
            })
            .store(in: &cancellables)
        
        input.toPrivacyPolicyButtonTapped
            .sink(receiveValue: { [weak self] in
                self?.binding.isPrivacyPolicySheetFlag.toggle()
            })
            .store(in: &cancellables)
        
        input.toSignInWithAnonymouslyButtonTapped
            .sink(receiveValue: { [weak self] in
                self?.registerAnonymouslyAccount()
            })
            .store(in: &cancellables)
        
        input.toReWrithButtonTapped
            .sink(receiveValue: { [weak self] in
                self?.binding.isScrollOffsetFlag = false
                self?.binding.isEntryEmailTextField = ""
                self?.binding.isEntryPasswordTextField = ""
            })
            .store(in: &cancellables)
    }
    
    
    
    private func createEmailAccount(email: String?, password: String?) {
        
        guard let email = email,
              let password = password else {
            return
        }
        
        if password.trimmingCharacters(in: .whitespacesAndNewlines).count >= 8 {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                // User Registration Process
                
                if let user = authResult?.user {
                    
                    user.sendEmailVerification(completion: { error in
                        
                        if error == nil {
                            
                            self.binding.isScrollOffsetFlag = true
                            
                            var timerStore: AnyCancellable!
                            timerStore = Timer.publish(every: 1.0, on: .main, in: .common)
                                .autoconnect()
                                .receive(on: DispatchQueue.main)
                                .sink(receiveValue: { [weak self] _ in
                                    
                                    user.reload()
                                    
                                    if user.isEmailVerified {
                                        
                                        self?.ref.child("user_info/user/").setValue(["uuid": user.uid])

                                        self?.output.isSignInResultMessege = "アドレスが確認出来ました"
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                            
                                            self?.binding.isSignInStatus = true
                                            
                                        }
                                        
                                        timerStore.cancel()
                                        
                                    }
                                    
                                })
                            
                        }
                        
                    })
                    
                }
                
                
                // User Registration Failure
                
                if let error = error as NSError?, let errorCode = AuthErrorCode(rawValue: error.code) {
                    
                    switch errorCode {
                    
                    case .invalidEmail:
                        
                        self.output.isSignInErrorMessege = "メールアドレスの形式が正しくありません"
                        
                    case .emailAlreadyInUse:
                        
                        self.loginEmailAccount(email: email, password: password)
                        
                    default:
                        
                        print("その他のエラー")
                        
                    }
                }
                
            }
            
        } else {
            
            self.output.isSignInErrorMessege = "8〜16文字のパスワードにする必要があります"
            
        }
    }
    
    
    
    private func loginEmailAccount(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
            // User SignIn Process
            
            if let user = authResult?.user {
                
                if user.isEmailVerified {
                    
                    self.ref.child("user_info/user/").setValue(["uuid": user.uid])

                    self.output.isSignInResultMessege = "ログインに成功しました"
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        
                        self.binding.isSignInStatus = true
                        
                    }
                    
                } else {
                    
                    user.sendEmailVerification(completion: { error in
                        
                        if error == nil {
                            
                            self.binding.isScrollOffsetFlag = true
                            
                            var timerStore: AnyCancellable!
                            timerStore = Timer.publish(every: 1.0, on: .main, in: .common)
                                .autoconnect()
                                .receive(on: DispatchQueue.main)
                                .sink(receiveValue: { [weak self] _ in
                                    
                                    user.reload()
                                    
                                    if user.isEmailVerified {
                                        
                                        self?.ref.child("user_info/user/").setValue(["uuid": user.uid])

                                        self?.output.isSignInResultMessege = "アドレスが確認出来ました"
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                            
                                            self?.binding.isSignInStatus = true
                                            
                                        }
                                        
                                        timerStore.cancel()
                                        
                                    }
                                    
                                })
                            
                        }
                        
                    })
                    
                }
                
            }
            
            
            // User SignIn Error
            
            if let error = error as NSError?, let errorCode = AuthErrorCode(rawValue: error.code) {
                
                switch errorCode {
                
                case .userNotFound, .wrongPassword:
                    
                    self.output.isSignInErrorMessege = "メールアドレス、またはパスワードが間違っています"
                    
                case .userDisabled:
                    
                    self.output.isSignInErrorMessege = "このユーザーアカウントは無効化されています"
                    
                default:
                    
                    self.output.isSignInErrorMessege = error.domain
                    
                }
                
            }
            
        }
    }
    
    
    
    private func registerAnonymouslyAccount() {
        
        Auth.auth().signInAnonymously { authResult, error in
            
            // User SignIn Process
            
            if let user = authResult?.user {
                
                if user.isAnonymous {
                    
                    self.ref.child("user_info/user").child(user.uid).setValue(["uid": user.uid])
                    
                    self.binding.isSignInStatus = true
                    
                } else {
                    
                    self.output.isSignInErrorMessege = "ゲストログイン出来ませんでした"
                    
                }
                
            }
            
            
            // User SignIn Error
            
            if let error = error as NSError? {
                
                self.output.isSignInErrorMessege = "\(error.localizedDescription)"
                
            }
            
        }
    }
    
}
