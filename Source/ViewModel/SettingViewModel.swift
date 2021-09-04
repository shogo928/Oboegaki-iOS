//
//  SettingViewModel.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/09/04.
//

import Combine
import Firebase

// MARK: - SettingViewModelObject
protocol SettingViewModelObject: ViewModelObject where Input: SettingViewModelInputObject, Binding: SettingViewModelBindingObject, Output: SettingViewModelOutputObject {
    var input: Input { get }
    var binding: Binding { get set }
    var output: Output { get }
}

// MARK: - SettingViewModelObjectInputObject
protocol SettingViewModelInputObject: InputObject {
    var toUserNameButtonTapped: PassthroughSubject<Void, Never> { get }
    
    var toLogoutButtonTapped: PassthroughSubject<Void, Never> { get }
    var toWithdrawalButtonTapped: PassthroughSubject<Void, Never> { get }
    
    var toSystemColorButtonTapped: PassthroughSubject<Void, Never> { get }
    
    var toVersionButtonTapped: PassthroughSubject<Void, Never> { get }
    var toReviewButtonTapped: PassthroughSubject<Void, Never> { get }
}

// MARK: - SettingViewModelObjectBindingObject
protocol SettingViewModelBindingObject: BindingObject {
    var isLoading: Bool { get set }
}

// MARK: - SettingViewModelOutputObject
protocol SettingViewModelOutputObject: OutputObject {
    var isSettingUserArray: Array<String> { get }
    var isSettingAccountArray: Array<String> { get }
    var isSettingThemeArray: Array<String> { get }
    var isSettingOboegakiArray: Array<String> { get }
}

// MARK: - SettingViewModel
class SettingViewModel: SettingViewModelObject {
    final class Input: SettingViewModelInputObject {
        var toUserNameButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        
        var toLogoutButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        var toWithdrawalButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        
        var toSystemColorButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        
        var toVersionButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        var toReviewButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    }
    
    final class Binding: SettingViewModelBindingObject {
        @Published var isLoading: Bool = false
    }
    
    final class Output: SettingViewModelOutputObject {
        @Published var isSettingUserArray: Array<String> = []
        @Published var isSettingAccountArray: Array<String> = []
        @Published var isSettingThemeArray: Array<String> = []
        @Published var isSettingOboegakiArray: Array<String> = []
    }
    
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
        
        output.isSettingUserArray += ["名前"]
        output.isSettingAccountArray += ["ログアウト","退会"]
        output.isSettingThemeArray += ["システムカラー"]
        output.isSettingOboegakiArray += ["バージョン","レビューを書く"]

        input.toUserNameButtonTapped
            .sink(receiveValue: { [weak self] in
                
            })
            .store(in: &cancellables)

        input.toLogoutButtonTapped
            .sink(receiveValue: { [weak self] in
                
            })
            .store(in: &cancellables)

        input.toWithdrawalButtonTapped
            .sink(receiveValue: { [weak self] in
                
            })
            .store(in: &cancellables)

        input.toSystemColorButtonTapped
            .sink(receiveValue: { [weak self] in
                
            })
            .store(in: &cancellables)

        input.toVersionButtonTapped
            .sink(receiveValue: { [weak self] in
                
            })
            .store(in: &cancellables)

        input.toReviewButtonTapped
            .sink(receiveValue: { [weak self] in
                
            })
            .store(in: &cancellables)

    }
}
