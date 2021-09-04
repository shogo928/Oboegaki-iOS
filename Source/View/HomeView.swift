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
                    ForEach(0..<viewModel.binding.isTodoCount + 1) { index in
                        HStack {
                            Text("")

                        }.listRowBackground((index  % 2 == 0) ? Color(.systemBlue) : Color(.white))

                        if index == viewModel.binding.isTodoCount {
                            HStack {
                                Spacer()

                                Button(action: {
                                    viewModel.input.toEntryTodoViewButtonTapped.send()
                                }, label: {
                                    Text("＋")
                                        .font(.system(size: 35, weight: .light, design: .default))
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(Color(.white))
                                        .background(Color("Primary"))
                                        .cornerRadius(50)
                                }).frame(width: 50, height: 50)
                                
                                Spacer()
                            }
                        }
                    }
                }
            } else {
                List {
                    ForEach(0..<1) { index in
                        HStack {
                            Spacer()

                            Button(action: {
                                viewModel.input.toEntryTodoViewButtonTapped.send()
                            }, label: {
                                Text("＋")
                                    .font(.system(size: 50, weight: .black, design: .default))
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(Color(.white))
                                    .background(Color("Primary"))
                                    .cornerRadius(50)
                            }).frame(width: 50, height: 50)

                            Spacer()
                        }
                    }
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
