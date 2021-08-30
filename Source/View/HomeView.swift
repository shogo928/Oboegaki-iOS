//
//  HomeView.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/08/23.
//

import Combine
import SwiftUI

struct HomeView<T>: View where T: HomeViewModelObject {
    @ObservedObject private var viewModel: T
    
    init(viewModel: T) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color(.white).edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack {
                    calendarYearMonthContainer
                    calendarWeekContainer
                    calendarDayContainer
                }.padding(.horizontal, 20)

            }
        }
    }
}

extension HomeView {
    var calendarYearMonthContainer: some View {
        HStack {
            Button(action: {
                viewModel.input.toLastMonthButtonTapped.send()
            }, label: {
                Text("＜")
            })
            
            Spacer()
            
            Text("\(viewModel.binding.isYearAndMonthString)")
                .font(.system(size: 20))
                .foregroundColor(.black)
            
            Spacer()

            Button(action: {
                viewModel.input.toNextMonthButtonTapped.send()
            }, label: {
                Text("＞")
            })
        }.background(Color("backgroundGray"))
        .padding(.top, 10)
    }
    
    var calendarWeekContainer: some View {
        HStack {
            Spacer()
            ForEach(0..<viewModel.binding.isDayOfWeekStringArray.count) { index in
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width:40,height:40)
                        .foregroundColor(Color.clear)
                    
                    Text("\(viewModel.binding.isDayOfWeekStringArray[index])")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
    }
    
    var calendarDayContainer: some View {
        HStack{
            Spacer()
            ForEach(viewModel.output.isFirstWeekOfMonth, id:\.self) { index in
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width:40,height:40)
                        .foregroundColor(Color.clear)
                    
                    Text("\(viewModel.output.isFirstWeekOfMonth[index])")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: MockViewModel())
    }
}

extension HomeView_Previews {
    final class MockViewModel: HomeViewModelObject {
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
        
        init() {
            input = Input()
            binding = Binding()
            output = Output()
        }
    }
}
