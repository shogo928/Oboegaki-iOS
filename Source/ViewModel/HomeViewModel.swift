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
    var toNextMonthButtonTapped: PassthroughSubject<Void, Never> { get }
    var toLastMonthButtonTapped: PassthroughSubject<Void, Never> { get }

    var toEntryTodoViewButtonTapped: PassthroughSubject<Void, Never> { get }
    var toSettingViewButtonTapped: PassthroughSubject<Void, Never> { get }
}

// MARK: - HomeViewModelObjectBindingObject
protocol HomeViewModelBindingObject: BindingObject {
    var isYearAndMonthString: String { get set }

    var isDayOfWeekStringArray: Array<String> { get set }

    var isMonthCounter: Int { get set }
    var isFirstWeekLength: Int { get set }

    var isTodoCount: Int { get set }
    var isTodoContanor: Array<NSObject> { get set }

    var isLoading: Bool { get set }
    var hasError: Bool { get set }
}

// MARK: - HomeViewModelOutputObject
protocol HomeViewModelOutputObject: OutputObject {
    var isFirstWeekOfMonth: Range<Int> { get set }
    var isSecondWeekOfMonth: Range<Int> { get set }
    var isThirdWeekOfMonth: Range<Int> { get set }
    var isFourthWeekOfMonth: Range<Int> { get set }
    var isFifthWeekOfMonth: Range<Int> { get set }
}

// MARK: - HomeViewModel
class HomeViewModel: HomeViewModelObject {
    final class Input: HomeViewModelInputObject {
        var toNextMonthButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        var toLastMonthButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()

        var toEntryTodoViewButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        var toSettingViewButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    }
    
    final class Binding: HomeViewModelBindingObject {
        @Published var isYearAndMonthString: String = ""
        @Published var isDayOfWeekStringArray: Array<String> = []
        
        @Published var isMonthCounter: Int = 0
        @Published var isFirstWeekLength: Int = 0

        @Published var isTodoCount: Int = 0
        @Published var isTodoContanor: Array<NSObject> = []

        @Published var isLoading: Bool = false
        @Published var hasError: Bool = false
    }
    
    final class Output: HomeViewModelOutputObject {
        @Published var isFirstWeekOfMonth: Range<Int> = 0..<0
        @Published var isSecondWeekOfMonth: Range<Int> = 0..<0
        @Published var isThirdWeekOfMonth: Range<Int> = 0..<0
        @Published var isFourthWeekOfMonth: Range<Int> = 0..<0
        @Published var isFifthWeekOfMonth: Range<Int> = 0..<0
    }
    
    var input: Input
    
    var binding: Binding
    
    var output: Output

    private var cancellables: [AnyCancellable] = []

    let date: Date
    let dateFormatter: DateFormatter
    let calendar: Calendar
    var dateComponents: DateComponents

    init() {
        input = Input()
        binding = Binding()
        output = Output()
        
        date = Date()
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月"
        
        calendar = Calendar(identifier: .gregorian)
        dateComponents = Calendar.current.dateComponents([.year], from: date)
        dateComponents.calendar = calendar

        binding.isDayOfWeekStringArray = ["日","月","火","水","木","金","土"]
        binding.isMonthCounter = calendar.component(.month, from: date)
        
        dateGenerater()
        WeekDays()
        
        input.toNextMonthButtonTapped
            .sink(receiveValue: { [weak self] in
                self?.binding.isMonthCounter += 1
                self?.dateGenerater()
                self?.WeekDays()
            })
            .store(in: &cancellables)

        input.toLastMonthButtonTapped
            .sink(receiveValue: { [weak self] in
                self?.binding.isMonthCounter -= 1
                self?.dateGenerater()
                self?.WeekDays()
            })
            .store(in: &cancellables)
    }
    
    private func dateGenerater() {
        dateComponents.month = binding.isMonthCounter
        guard let dateComponent = calendar.date(from: dateComponents) else { return }
        binding.isYearAndMonthString = dateFormatter.string(from: dateComponent)
    }
    
    private func WeekDays() {
        guard let dateComponent = calendar.date(from: dateComponents),
              let dateComponentRange = calendar.range(of: .day, in: .month, for: dateComponent)
              else { return }
        
        binding.isFirstWeekLength = dateComponentRange.count
        
        var weekendArray = []
        var weeksFirstArray = []
        var weekend = dateComponentRange.count - (weekendArray.count * 7 + 8)
        var weeksFirst = dateComponentRange.count - (weeksFirstArray.count * 7 + 8)

        switch Calendar.current.component(Calendar.Component.weekday, from: dateComponent) {
        case 1: // 日曜日
            output.isFirstWeekOfMonth = 1..<8
            output.isSecondWeekOfMonth = 9..<16
            output.isThirdWeekOfMonth = 17..<24
        case 2: // 月曜日
            output.isFirstWeekOfMonth = 2..<8
        case 3: // 火曜日
            output.isFirstWeekOfMonth = 3..<8
        case 4: // 水曜日
            output.isFirstWeekOfMonth = 4..<8
        case 5: // 木曜日
            output.isFirstWeekOfMonth = 5..<8
        case 6: // 金曜日
            output.isFirstWeekOfMonth = 6..<8
        case 7: // 土曜日
            output.isFirstWeekOfMonth = 7..<8
        default: break
        }
    }
}

