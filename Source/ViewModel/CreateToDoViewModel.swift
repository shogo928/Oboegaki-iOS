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
    var toSelectionDateChanged: PassthroughSubject<Date, Never> { get }
    var toSaveButtonTapped: PassthroughSubject<Void, Never> { get }
}

// MARK: - CreateToDoViewModelObjectBindingObject
protocol CreateToDoViewModelBindingObject: BindingObject {
    var isEntryTitleTextField: String { get set }
    var isSelectionDate: Date { get set }
    var isSelectionTime: Date { get set }
    var isEntryNoteTextField: String { get set }
    var isShowingAlert: Bool { get set }
    var isLoading: Bool { get set }
}

// MARK: - CreateToDoViewModelOutputObject
protocol CreateToDoViewModelOutputObject: OutputObject {
    var isPickerDateRange: Date { get set }
}

// MARK: - CreateToDoViewModel
class CreateToDoViewModel: CreateToDoViewModelObject {
    final class Input: CreateToDoViewModelInputObject {
        var toEntryTitleTextField: PassthroughSubject<String, Never> = PassthroughSubject<String, Never>()
        var toEntryNoteTextField: PassthroughSubject<String, Never> = PassthroughSubject<String, Never>()
        var toSelectionDateChanged: PassthroughSubject<Date, Never> = PassthroughSubject<Date, Never>()
        var toSaveButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    }

    final class Binding: CreateToDoViewModelBindingObject {
        @Published var isEntryTitleTextField: String = ""
        @Published var isSelectionDate: Date = Date()
        @Published var isSelectionTime: Date = Date()
        @Published var isEntryNoteTextField: String = ""
        @Published var isShowingAlert: Bool = false
        @Published var isLoading: Bool = false
    }
    
    final class Output: CreateToDoViewModelOutputObject {
        @Published var isPickerDateRange: Date = Date()
    }
    
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

        date = Date()
        calendar = Calendar(identifier: .gregorian)
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium

        self.binding.isSelectionDate = selectedDate
        self.ratioSelectionDate(selectedDate: selectedDate)

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
        
        input.toSelectionDateChanged
            .sink(receiveValue: { [weak self] value in
                self?.ratioSelectionDate(selectedDate: value)
            })
            .store(in: &cancellables)
        
        input.toSaveButtonTapped
            .sink(receiveValue: { [weak self] _ in
                if let now = self?.date {
                    self?.savwButtonAction(now: now)
                }
            })
            .store(in: &cancellables)
    }
    
    deinit {
        self.binding.isEntryTitleTextField = ""
        self.binding.isEntryNoteTextField = ""
    }
    
    private func ratioSelectionDate(selectedDate: Date) {
        if selectedDate.zeroTime == date.zeroTime {
            output.isPickerDateRange = date
        } else {
            output.isPickerDateRange = selectedDate.fixed(hour: 0, minute: 0, second: 0)
        }
    }
    
    private func savwButtonAction(now: Date) {
        if self.binding.isSelectionTime.compare(now) == .orderedAscending {
            
            // 現時刻より前
            
            self.binding.isShowingAlert.toggle()
            
        } else if self.binding.isSelectionTime.compare(now) == .orderedDescending {
            let user = Auth.auth().currentUser
                
                let todoList: [String: Any] = ["completed": false,
                                               "title": "\(self.binding.isEntryTitleTextField)",
                                               "note": "\(self.binding.isEntryNoteTextField)",
                                               "scheduleDate": "",
                                               "createdDate": "\(self.date)"]
                   
            self.ref.child("user_info/\(user)/todo_list").setValue(todoList)

                // 現時刻より後
                
                self.binding.isLoading = true

            
        }
    }
}
