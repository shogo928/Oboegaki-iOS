//
//  StartupViewModel.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/08/23.
//

import Combine
import Firebase

// MARK: - StartupViewModelObject
protocol StartupViewModelObject: ViewModelObject where Input: StartupViewModelInputObject, Binding: StartupViewModelBindingObject, Output: StartupViewModelOutputObject {
    var input: Input { get }
    var binding: Binding { get set }
    var output: Output { get }
}

// MARK: - StartupViewModelObjectInputObject
protocol StartupViewModelInputObject: InputObject {
    var toAnimationStarted: PassthroughSubject<Void, Never> { get }
    var toLoadingStarted: PassthroughSubject<Void, Never> { get }
}

// MARK: - StartupViewModelObjectBindingObject
protocol StartupViewModelBindingObject: BindingObject {
    var isAnimating: Bool { get set }
    var isLoading: Bool { get set }
    var isFirebaseLoginStatus: Bool { get set }
}

// MARK: - StartupViewModelOutputObject
protocol StartupViewModelOutputObject: OutputObject {}

// MARK: - StartupViewModel
class StartupViewModel: StartupViewModelObject {
    final class Input: StartupViewModelInputObject {
        var toAnimationStarted: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        var toLoadingStarted: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    }
    
    final class Binding: StartupViewModelBindingObject {
        @Published var isAnimating: Bool = false
        @Published var isLoading: Bool = false
        @Published var isFirebaseLoginStatus: Bool = false
    }
    
    final class Output: StartupViewModelOutputObject {}
    
    var input: Input
    
    var binding: Binding
    
    var output: Output
    
    private var ref: DatabaseReference!
    
    private var cancellables: [AnyCancellable] = []
    
    init() {
        input = Input()
        binding = Binding()
        output = Output()
        self.ref = Database.database().reference()
                
        input.toAnimationStarted
            .sink(receiveValue: { [weak self] in self?.binding.isAnimating.toggle()})
            .store(in: &cancellables)
        
        input.toLoadingStarted
            .sink(receiveValue: { [weak self] in
                self?.checkLogin()
            })
            .store(in: &cancellables)
    }
    
    private func checkLogin() {
            if let user = Auth.auth().currentUser {
                
                if !user.uid.isEmpty {
                    
                    ref.child("user_info/users").observeSingleEvent(of: .value, with: { snapshot in

                        if snapshot.hasChild(user.uid) {
                            
                            self.binding.isFirebaseLoginStatus = true
                        
                        } else {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                
                                self.binding.isFirebaseLoginStatus = false
                                self.binding.isLoading.toggle()
                                
                            }
                            
                        }
                        
                    })
                    
                } else {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        
                        self.binding.isFirebaseLoginStatus = false
                        self.binding.isLoading.toggle()
                        
                    }
                    
                }
                
            }
    }
}
