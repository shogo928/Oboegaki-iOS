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
    var toLoginButtonTapped: PassthroughSubject<Void, Never> { get }
    
    var toPasswordShowTextTapped: PassthroughSubject<Void, Never> { get }
    
    var toLoadingStarted: PassthroughSubject<Void, Never> { get }
    var toSignInWithAppleButtonTapped: PassthroughSubject<Void, Never> { get }
    var toSignInWithGoogleButtonTapped: PassthroughSubject<Void, Never> { get }
}

// MARK: - LoginViewModelObjectBindingObject
protocol LoginViewModelBindingObject: BindingObject {
    var isEntryEmailTextField: String { get set }
    var isEntryPasswordTextField: String { get set }
    var isEntryPasswordShowFlag: Bool { get set }
    
    var isSignedInWithFirebaseAuth: Bool { get set }
}

// MARK: - LoginViewModelOutputObject
protocol LoginViewModelOutputObject: OutputObject {}

// MARK: - LoginViewModel
class LoginViewModel: LoginViewModelObject {
    final class Input: LoginViewModelInputObject {
        var toLoginButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        
        var toPasswordShowTextTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        
        var toLoadingStarted: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        var toSignInWithAppleButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        var toSignInWithGoogleButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    }
    
    final class Binding: LoginViewModelBindingObject {
        @Published var isEntryEmailTextField: String = ""
        @Published var isEntryPasswordTextField: String = ""
        @Published var isEntryPasswordShowFlag: Bool = false
        
        @Published var isSignedInWithFirebaseAuth: Bool = false
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
    }
    
    private func registerAccount(email: String?, password: String?) {
        if let email = email,
           let password = password {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if error != nil {
                    self.binding.isSignedInWithFirebaseAuth.toggle()
                }
            }
        } else {
            
        }
    }
}
