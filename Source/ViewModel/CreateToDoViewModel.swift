//
//  CreateToDoViewModel.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/09/05.
//

import Combine
import Firebase

// MARK: - CreateToDoViewModelObject
protocol CreateToDoViewModelObject: ViewModelObject where Input: CreateToDoViewModelInputObject, Binding: CreateToDoViewModelBindingObject, Output: CreateToDoViewModelOutputObject {
    var input: Input { get }
    var binding: Binding { get set }
    var output: Output { get }
}

// MARK: - CreateToDoViewModelObjectInputObject
protocol CreateToDoViewModelInputObject: InputObject {
    var toEntryTitleTextField: PassthroughSubject<String, Never> { get }
    var toEntryNoteTextField: PassthroughSubject<String, Never> { get }
    var toSaveButtonTapped: PassthroughSubject<Void, Never> { get }
}

// MARK: - CreateToDoViewModelObjectBindingObject
protocol CreateToDoViewModelBindingObject: BindingObject {
    var isEntryTitleTextField: String { get set }
    var isSectionDate: Date { get set }
    var isEntryNoteTextField: String { get set }
}

// MARK: - CreateToDoViewModelOutputObject
protocol CreateToDoViewModelOutputObject: OutputObject {}

// MARK: - CreateToDoViewModel
class CreateToDoViewModel: CreateToDoViewModelObject {
    final class Input: CreateToDoViewModelInputObject {
        var toEntryTitleTextField: PassthroughSubject<String, Never> = PassthroughSubject<String, Never>()
        var toEntryNoteTextField: PassthroughSubject<String, Never> = PassthroughSubject<String, Never>()
        var toSaveButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    }

    final class Binding: CreateToDoViewModelBindingObject {
        @Published var isEntryTitleTextField: String = ""
        @Published var isSectionDate: Date = Date()
        @Published var isEntryNoteTextField: String = ""
    }
    
    final class Output: CreateToDoViewModelOutputObject {}
    
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
                
        input.toEntryTitleTextField
            .sink(receiveValue: { [weak self] value in
            
            })
            .store(in: &cancellables)
        
        input.toEntryNoteTextField
            .sink(receiveValue: { [weak self] value in
            
            })
            .store(in: &cancellables)

    }
}
