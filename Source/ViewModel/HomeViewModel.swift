//
//  HomeViewModel.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/08/23.
//

import Combine
import Foundation

// MARK: - HomeViewModelObject
protocol HomeViewModelObject: ViewModelObject where Input: HomeViewModelInputObject, Binding: HomeViewModelBindingObject, Output: HomeViewModelOutputObject {
    var input: Input { get }
    var binding: Binding { get set }
    var output: Output { get }
}

// MARK: - HomeViewModelObjectInputObject
protocol HomeViewModelInputObject: InputObject {
    var toEntryTodoViewButtonTapped: PassthroughSubject<Void, Never> { get }
    var toSettingViewButtonTapped: PassthroughSubject<Void, Never> { get }
}

// MARK: - HomeViewModelObjectBindingObject
protocol HomeViewModelBindingObject: BindingObject {
    var isTodoCount: Int { get set }
    var isTodoContanor: Array<NSObject> { get set }

    var isLoading: Bool { get set }
    var hasError: Bool { get set }
}

// MARK: - HomeViewModelOutputObject
protocol HomeViewModelOutputObject: OutputObject {}

// MARK: - HomeViewModel
class HomeViewModel: HomeViewModelObject {
    final class Input: HomeViewModelInputObject {
        var toEntryTodoViewButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        var toSettingViewButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    }
    
    final class Binding: HomeViewModelBindingObject {
        @Published var isTodoCount: Int = 0
        @Published var isTodoContanor: Array<NSObject> = []

        @Published var isLoading: Bool = false
        @Published var hasError: Bool = false
    }
    
    final class Output: HomeViewModelOutputObject {}
    
    var input: Input
    
    var binding: Binding
    
    var output: Output
    
    init() {
        input = Input()
        binding = Binding()
        output = Output()
    }
    
}
