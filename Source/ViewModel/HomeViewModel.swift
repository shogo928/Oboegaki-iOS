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
    var isWhatMonth: Int { get set }
    var isDayOfMonth: Array<Int> { get set }

    var isTodoCount: Int { get set }
    
    var isLoading: Bool { get set }
    var hasError: Bool { get set }
}

// MARK: - HomeViewModelOutputObject
protocol HomeViewModelOutputObject: OutputObject {
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
        @Published var isWhatMonth: Int = 0
        @Published var isDayOfMonth: Array<Int> = []
        
        @Published var isTodoCount: Int = 9
        
        @Published var isLoading: Bool = false
        @Published var hasError: Bool = false
    }
    
    final class Output: HomeViewModelOutputObject {
    }
    
    var input: Input
    
    var binding: Binding
    
    var output: Output
    
    private var cancellables: [AnyCancellable] = []
    
    let date: Date
    let dateFormatter: DateFormatter
    var calendar: Calendar
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
        dateComponents.month = calendar.component(.month, from: date)
        
        binding.isWhatMonth = calendar.component(.month, from: date)
        
        dateGenerater()
        weekDays()
        
        input.toNextMonthButtonTapped
            .sink(receiveValue: { [weak self] in
                self?.binding.isDayOfMonth.removeAll()
                self?.binding.isWhatMonth += 1
                self?.dateGenerater()
                self?.weekDays()
            })
            .store(in: &cancellables)
        
        input.toLastMonthButtonTapped
            .sink(receiveValue: { [weak self] in
                self?.binding.isDayOfMonth.removeAll()
                self?.binding.isWhatMonth -= 1
                self?.dateGenerater()
                self?.weekDays()
            })
            .store(in: &cancellables)
    }
    
    private func dateGenerater() {
        dateComponents.month = binding.isWhatMonth
        guard let dateComponent = calendar.date(from: dateComponents) else { return }
        binding.isYearAndMonthString = dateFormatter.string(from: dateComponent)
    }
    
    private func weekDays() {
        guard let dateComponent = calendar.date(from: dateComponents),
              let dateComponentRange = calendar.range(of: .day, in: .month, for: dateComponent)
        else { return }
        
        for _ in 1..<Calendar.current.component(Calendar.Component.weekday, from: dateComponent) {
            binding.isDayOfMonth += [0]
        }
        
        binding.isDayOfMonth += dateComponentRange
    }
}

/*
 
 switch weekday {
 case 1: // 日曜日
 case 2: // 月曜日
 case 3: // 火曜日
 
 case 4: // 水曜日
 
 case 5: // 木曜日
 
 case 6: // 金曜日
 
 case 7: // 土曜日
 
 default: break
 }
 
 */
