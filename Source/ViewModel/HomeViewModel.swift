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
    var toNextMonthActioned: PassthroughSubject<Void, Never> { get }
    var toLastMonthActioned: PassthroughSubject<Void, Never> { get }
    
    var toColumnSelected: PassthroughSubject<String, Never> { get }
    var toDateSelected: PassthroughSubject<Int, Never> { get }
    
    var toScrollOffsetChanged: PassthroughSubject<Double, Never> { get }
    var toRePositionScrollOffsetChanged: PassthroughSubject<Double, Never> { get }
    var toCalendarViewHeightChanged: PassthroughSubject<Void, Never> { get }
    
    var toCreateToDoViewButtonTapped: PassthroughSubject<Void, Never> { get }
}

// MARK: - HomeViewModelObjectBindingObject
protocol HomeViewModelBindingObject: BindingObject {
    var isWhatMonth: Int { get set }
    
    var isSelectedColumn: String { get set }
    
    var isCalendarViewHeight: Int { get set }
    var isScrollOffset: Double { get set }
    
    var isActiveCreateToDoView: Bool { get set }
    var isTodoCount: Int { get set }
    
    var isLoading: Bool { get set }
    var hasError: Bool { get set }
}

// MARK: - HomeViewModelOutputObject
protocol HomeViewModelOutputObject: OutputObject {
    var isWeekArray: [String] { get set }
    var isSelectedDate: Date  { get set }
    var isCurrentYearInt: Int { get set }
    var isCurrentMonthInt: Int { get set }
    var isCurrentMonthDate: [CurrentMonthDate] { get set }
}

// MARK: - HomeViewModel
class HomeViewModel: HomeViewModelObject {
    final class Input: HomeViewModelInputObject {
        var toNextMonthActioned: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        var toLastMonthActioned: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        
        var toColumnSelected: PassthroughSubject<String, Never> = PassthroughSubject<String, Never>()
        var toDateSelected: PassthroughSubject<Int, Never> = PassthroughSubject<Int, Never>()
        
        var toScrollOffsetChanged: PassthroughSubject<Double, Never> = PassthroughSubject<Double, Never>()
        var toRePositionScrollOffsetChanged: PassthroughSubject<Double, Never> = PassthroughSubject<Double, Never>()
        var toCalendarViewHeightChanged: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()

        var toCreateToDoViewButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    }
    
    final class Binding: HomeViewModelBindingObject {
        @Published var isWhatMonth: Int = 0
        
        @Published var isSelectedColumn: String = UUID().uuidString
        
        @Published var isCalendarViewHeight: Int = 0
        @Published var isScrollOffset: Double = 0.0
        
        @Published var isActiveCreateToDoView: Bool = false
        @Published var isTodoCount: Int = 0
        
        @Published var isLoading: Bool = false
        @Published var hasError: Bool = false
    }
    
    final class Output: HomeViewModelOutputObject {
        @Published var isWeekArray: [String] = ["日","月","火","水","木","金","土"]
        @Published var isSelectedDate: Date = Date()
        @Published var isCurrentYearInt: Int = 0
        @Published var isCurrentMonthInt: Int = 0
        @Published var isCurrentMonthDate: [CurrentMonthDate] = []
    }
    
    var input: Input
    
    var binding: Binding
    
    var output: Output
    
    private var cancellables: [AnyCancellable] = []
    
    let date: Date
    var calendar: Calendar
    var dateComponents: DateComponents
    
    init() {
        input = Input()
        binding = Binding()
        output = Output()
        
        date = Date()
        calendar = Calendar(identifier: .gregorian)
        dateComponents = Calendar.current.dateComponents([.year], from: date)
        dateComponents.calendar = calendar
        dateComponents.month = calendar.component(.month, from: date)
        
        binding.isWhatMonth = calendar.component(.month, from: date)
        output.isCurrentMonthDate = calendarDateGenerater()
        binding.isSelectedColumn = todaySelectedDateConverter()
        calendarSizeGenerater()

        input.toNextMonthActioned
            .sink(receiveValue: { [weak self] in
                self?.binding.isWhatMonth += 1
                
                if let calendarDate = self?.calendarDateGenerater() {
                    self?.output.isCurrentMonthDate = calendarDate
                }
            })
            .store(in: &cancellables)
        
        input.toLastMonthActioned
            .sink(receiveValue: { [weak self] in
                self?.binding.isWhatMonth -= 1
                
                if let calendarDate = self?.calendarDateGenerater() {
                    self?.output.isCurrentMonthDate = calendarDate
                }
            })
            .store(in: &cancellables)
        
        input.toColumnSelected
            .sink(receiveValue: { [weak self] value in
                self?.binding.isSelectedColumn = value
            })
            .store(in: &cancellables)
        
        input.toDateSelected
            .sink(receiveValue: { [weak self] value in
                self?.selectedDateConverter(selectedDay: value)
            })
            .store(in: &cancellables)
        
        input.toScrollOffsetChanged
            .sink(receiveValue: { [weak self] value in
                self?.binding.isScrollOffset = Double(value)
            })
            .store(in: &cancellables)
        
        input.toRePositionScrollOffsetChanged
            .sink(receiveValue: { [weak self] value in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self?.binding.isScrollOffset = Double(value)
                }
            })
            .store(in: &cancellables)
        
        input.toCalendarViewHeightChanged
            .sink(receiveValue: { [weak self] in
                self?.calendarSizeGenerater()
            })
            .store(in: &cancellables)
        
        input.toCreateToDoViewButtonTapped
            .sink(receiveValue: { [weak self] in
                self?.binding.isActiveCreateToDoView.toggle()
            })
            .store(in: &cancellables)
    }
    
    private func calendarDateGenerater() -> [CurrentMonthDate] {
        dateComponents.month = binding.isWhatMonth
        
        guard let currentDateComponent = calendar.date(from: dateComponents),
              let currentDateComponentRange = calendar.range(of: .day, in: .month, for: currentDateComponent)
        else { return [] }
        
        output.isCurrentYearInt = calendar.component(.year, from: currentDateComponent)
        output.isCurrentMonthInt = calendar.component(.month, from: currentDateComponent)
        
        var currentMonthArray: [Int] = []
        for _ in 1..<Calendar.current.component(Calendar.Component.weekday, from: currentDateComponent) {
            currentMonthArray += [0]
        }
        
        currentMonthArray += currentDateComponentRange
        
        return currentMonthArray.compactMap { day -> CurrentMonthDate in
            return CurrentMonthDate(day: day, date: date.fixed(year: output.isCurrentYearInt, month: output.isCurrentMonthInt, day: day))
        }
    }
    
    private func calendarSizeGenerater() {
        let weekOfMonthDouble: Double = Double(output.isCurrentMonthDate.count) / 7.0
        let weekOfMonthInt: Int = output.isCurrentMonthDate.count / 7
        
        if weekOfMonthDouble - Double(weekOfMonthInt) > 0 {
            binding.isCalendarViewHeight = (weekOfMonthInt + 1) * (55 + 10)
        } else if weekOfMonthDouble - Double(weekOfMonthInt) == 0 {
            binding.isCalendarViewHeight = (weekOfMonthInt) * (55 + 10)
        }
    }
    
    private func selectedDateConverter(selectedDay: Int) {
        output.isSelectedDate = date.fixed(year: output.isCurrentYearInt, month: output.isCurrentMonthInt, day: selectedDay)
    }
    
    private func todaySelectedDateConverter() -> String {
        let today = date.fixed(year: calendar.component(.year, from: date), month: calendar.component(.month, from: date), day: calendar.component(.day, from: date))
        
        var comp = ""
        
        for item in 0..<output.isCurrentMonthDate.count {
            if output.isCurrentMonthDate[item].date == today {
                comp = output.isCurrentMonthDate[item].id
            }
        }
        
        return comp
    }
}
