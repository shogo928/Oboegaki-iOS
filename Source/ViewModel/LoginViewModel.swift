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
    
    var toSignInWithAppleButtonTapped: PassthroughSubject<Void, Never> { get }
    var toSignInWithGoogleButtonTapped: PassthroughSubject<Void, Never> { get }
}

// MARK: - LoginViewModelObjectBindingObject
protocol LoginViewModelBindingObject: BindingObject {
    var isTermsOfServiceSheetFlag: Bool { get set }
    var isPrivacyPolicySheetFlag: Bool { get set }
    
    var isEntryEmailTextField: String { get set }
    var isEntryPasswordTextField: String { get set }
    var isEntryPasswordShowFlag: Bool { get set }
    
    var isSignInStatus: Bool { get set }
    var isSignInStatusMessege: String { get set }
    var isSignInStatusMessegeColorFlag: Bool { get set }
}

// MARK: - LoginViewModelOutputObject
protocol LoginViewModelOutputObject: OutputObject {}

// MARK: - LoginViewModel
class LoginViewModel: LoginViewModelObject {
    final class Input: LoginViewModelInputObject {
        var toPasswordTextFieldEntered: PassthroughSubject<String, Never> = PassthroughSubject<String, Never>()
        
        var toPasswordShowTextTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        var toLoginButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        var toTermsOfServiceButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        var toPrivacyPolicyButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        
        var toSignInWithAppleButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        var toSignInWithGoogleButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    }
    
    final class Binding: LoginViewModelBindingObject {
        @Published var isTermsOfServiceSheetFlag: Bool = false
        @Published var isPrivacyPolicySheetFlag: Bool = false
        
        @Published var isEntryEmailTextField: String = ""
        @Published var isEntryPasswordTextField: String = ""
        @Published var isEntryPasswordShowFlag: Bool = false
        
        @Published var isSignInStatus: Bool = false
        @Published var isSignInStatusMessege: String = ""
        @Published var isSignInStatusMessegeColorFlag: Bool = false
    }
    
    final class Output: LoginViewModelOutputObject {}
    
    var input: Input
    
    var binding: Binding
    
    var output: Output
    
    private var cancellables: [AnyCancellable] = []
    
    init(_ isFirebaseAuth: Bool) {
        input = Input()
        binding = Binding()
        output = Output()
        
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
                self?.registerAccount(email: self?.binding.isEntryEmailTextField,
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
    }
    
    private func registerAccount(email: String?, password: String?) {
        if let email = email,
           let password = password {
            if password.trimmingCharacters(in: .whitespacesAndNewlines).count >= 8 {
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let user = authResult?.user {
                        user.sendEmailVerification(completion: { error in
                            if error == nil {
                                print("send mail success.")
                            }
                        })
                        self.binding.isSignInStatusMessege = "ログイン完了"
                        self.binding.isSignInStatusMessegeColorFlag = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.binding.isSignInStatus = true
                        }
                    }
                    
                    if let error = error as NSError?, let errorCode = AuthErrorCode(rawValue: error.code) {
                        switch errorCode {
                        case .invalidEmail:
                            self.binding.isSignInStatusMessege = "メールアドレスの形式が正しくありません"
                            self.binding.isSignInStatusMessegeColorFlag = false
                        case .emailAlreadyInUse:
                            print("このメールアドレスは既に登録されています")
                            
                            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                                if let user = authResult?.user {
                                    if user.isEmailVerified {
                                        self.binding.isSignInStatusMessege = "ログイン完了"
                                        self.binding.isSignInStatusMessegeColorFlag = true
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            self.binding.isSignInStatus = true
                                        }
                                    } else {
                                        self.binding.isSignInStatusMessege = "メールボックスを確認してください"
                                    }
                                }
                            }
                        case .weakPassword:
                            print("パスワードは６文字以上で入力してください")
                        default:
                            print("その他のエラー")
                        }
                    } else {
                        print("ユーザー登録成功")
                    }
                }
            } else {
                self.binding.isSignInStatusMessege = "8〜16文字のパスワードにする必要があります"
                self.binding.isSignInStatusMessegeColorFlag = false
            }
        }
    }
}
