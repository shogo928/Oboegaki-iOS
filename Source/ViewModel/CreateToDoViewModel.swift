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
    var isSelectionDate: Date { get set }
    var isSelectionTime: Date { get set }
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
        @Published var isSelectionDate: Date = Date()
        @Published var isSelectionTime: Date = Date()
        @Published var isEntryNoteTextField: String = ""
    }
    
    final class Output: CreateToDoViewModelOutputObject {}
    
    var input: Input
    
    var binding: Binding
    
    var output: Output
    
    private var ref: DatabaseReference!
    
    private var cancellables: [AnyCancellable] = []
    
    let date: Date
    let calendar: Calendar
    let dateFormatter: DateFormatter

    init(_ selectedDate: Date) {
        input = Input()
        binding = Binding()
        output = Output()
        self.ref = Database.database().reference()

        self.binding.isSelectionDate = selectedDate
        
        date = Date()
        calendar = Calendar(identifier: .gregorian)
        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        input.toEntryTitleTextField
            .sink(receiveValue: { [weak self] value in
                self?.binding.isEntryTitleTextField = value
            })
            .store(in: &cancellables)
        
        input.toEntryNoteTextField
            .sink(receiveValue: { [weak self] value in
                self?.binding.isEntryNoteTextField = value
            })
            .store(in: &cancellables)

        input.toSaveButtonTapped
            .sink(receiveCompletion: { [weak self] comp in
                
            }, receiveValue: { [weak self] value in
                
            })
    }
    
    deinit {
        self.binding.isEntryTitleTextField = ""
        self.binding.isEntryNoteTextField = ""
    }
    
    private func ratioSelectionTime() {
        
        // 現在の「日付け」より大きいなら、時間は24時間指定できるようにする
        if binding.isSelectionDate > Date() {
            binding.isSelectionTime = Date().fixed()
        } else if binding.isSelectionDate < Date() {
            
        } else if binding.isSelectionDate == Date() {
            
        }
    }
}
