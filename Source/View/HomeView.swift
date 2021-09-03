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
            Color("backgroundGray").edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack {
                    yearView
                }.background(Color(.white))
                .cornerRadius(16)
                .padding(.horizontal, 20)
                
                Spacer()

                VStack {
                    dayView
                }.background(Color(.white))
                .cornerRadius(16)
                .padding(.horizontal, 20)
                
                Spacer()
                
                VStack {
                    todoView
                }.background(Color(.white))
                .cornerRadius(16)
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
}

extension HomeView {
    var yearView: some View {
        HStack {
            Button(action: {
                viewModel.input.toLastMonthButtonTapped.send()
            }, label: {
                Text("＜")
                    .foregroundColor(Color("Primary"))
            }).padding(.leading, 10)
            
            Spacer()
            
            Text("\(viewModel.binding.isYearAndMonthString)")
                .font(.system(size: 20))
                .foregroundColor(Color("Primary"))

            Spacer()
            
            Button(action: {
                viewModel.input.toNextMonthButtonTapped.send()
            }, label: {
                Text("＞")
                    .foregroundColor(Color("Primary"))
            }).padding(.trailing, 10)
        }
    }
    
    var dayView: some View {
        CalendarView(dayOfMonthCount: $viewModel.binding.isDayOfMonth)
    }
    
    var todoView: some View {
        VStack {
            if viewModel.binding.isTodoCount != 0 {
                List {
                    ForEach(0..<viewModel.binding.isTodoCount) { index in
                        Text("").listRowBackground((index  % 2 == 0) ? Color(.systemBlue) : Color(.white))

                    }
                    Spacer(minLength: 40)
                }
            } else {
                GeometryReader { geometry in
                    Button(action: {
                        viewModel.input.toEntryTodoViewButtonTapped.send()
                    }, label: {
                        Text("＋")
                            .font(.system(size: 50, weight: .black, design: .default))
                            .frame(width: geometry.size.width / 3, height: geometry.size.width / 3)
                            .foregroundColor(Color(.white))
                            .background(Color("Primary"))
                            .cornerRadius(geometry.size.width / 3)
                    }).frame(width: geometry.size.width, height: geometry.size.width)
                }
            }
        }
    }
    
    var drag: some Gesture {
        DragGesture()
        .onEnded({ _ in
        })
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
            @Published var isWhatMonth: Int = 0
            @Published var isDayOfMonth: Array<Int> = []
            
            @Published var isTodoCount: Int = 0
            
            @Published var isLoading: Bool = false
            @Published var hasError: Bool = false
        }
        
        final class Output: HomeViewModelOutputObject {
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
