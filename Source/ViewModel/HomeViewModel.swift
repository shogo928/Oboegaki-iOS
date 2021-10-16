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
    
    var toScrollOffsetChanged: PassthroughSubject<Double, Never> { get }
    var toRePositionScrollOffsetChanged: PassthroughSubject<Double, Never> { get }

    var toCalendarViewHeightChanged: PassthroughSubject<Void, Never> { get }

    var toEntryTodoViewButtonTapped: PassthroughSubject<Void, Never> { get }
}

// MARK: - HomeViewModelObjectBindingObject
protocol HomeViewModelBindingObject: BindingObject {
    var isYearAndMonthString: String { get set }
    var isNowMonthString: String { get set }
    var isWeekArray: [String] { get set }
    var isWhatMonth: Int { get set }
    var isWhatToday: Int { get set }
    var isLatestMonthArray: [Int] { get set }
    
    var isCalendarViewHeight: Int { get set }
    var isScrollOffset: Double { get set }

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
        var toNextMonthActioned: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        var toLastMonthActioned: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        
        var toScrollOffsetChanged: PassthroughSubject<Double, Never> = PassthroughSubject<Double, Never>()
        var toRePositionScrollOffsetChanged: PassthroughSubject<Double, Never> = PassthroughSubject<Double, Never>()

        var toCalendarViewHeightChanged: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()

        var toEntryTodoViewButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
    }
    
    final class Binding: HomeViewModelBindingObject {
        @Published var isYearAndMonthString: String = ""
        @Published var isNowMonthString: String = ""
        @Published var isWeekArray: [String] = []
        @Published var isWhatMonth: Int = 0
        @Published var isWhatToday: Int = 0
        @Published var isLatestMonthArray: [Int] = []
        
        @Published var isCalendarViewHeight: Int = 0
        @Published var isScrollOffset: Double = 0.0

        @Published var isTodoCount: Int = 0
        
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
        
        binding.isNowMonthString = dateFormatter.string(from: calendar.date(from: dateComponents)!)
        binding.isWeekArray = ["日","月","火","水","木","金","土"]
        binding.isWhatMonth = calendar.component(.month, from: date)
        binding.isWhatToday = calendar.component(.day, from: date)
        
        calendarDateGenerater()
        calendarSizeGenerater()
        
        input.toNextMonthActioned
            .sink(receiveValue: { [weak self] in
                self?.binding.isLatestMonthArray.removeAll()
                self?.binding.isWhatMonth += 1
                self?.calendarDateGenerater()
            })
            .store(in: &cancellables)
        
        input.toLastMonthActioned
            .sink(receiveValue: { [weak self] in
                self?.binding.isLatestMonthArray.removeAll()
                self?.binding.isWhatMonth -= 1
                self?.calendarDateGenerater()
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
    }
    
    private func calendarDateGenerater() {
        dateComponents.month = binding.isWhatMonth

        guard let yMDateComponent = calendar.date(from: dateComponents) else { return }
        binding.isYearAndMonthString = dateFormatter.string(from: yMDateComponent)

        guard let daysDateComponent = calendar.date(from: dateComponents),
              let daysDateComponentRange = calendar.range(of: .day, in: .month, for: daysDateComponent)
        else { return }
        
        for _ in 1..<Calendar.current.component(Calendar.Component.weekday, from: daysDateComponent) {
            binding.isLatestMonthArray += [0]
        }
        
        binding.isLatestMonthArray += daysDateComponentRange
    }
    
    private func calendarSizeGenerater() {
        let weekOfMonthDouble: Double = Double(binding.isLatestMonthArray.count) / 7.0
        let weekOfMonthInt: Int = binding.isLatestMonthArray.count / 7

        if weekOfMonthDouble - Double(weekOfMonthInt) > 0 {
            binding.isCalendarViewHeight = (weekOfMonthInt + 1) * 40
        } else if weekOfMonthDouble - Double(weekOfMonthInt) == 0 {
            binding.isCalendarViewHeight = (weekOfMonthInt) * 40
        }
    }
}
