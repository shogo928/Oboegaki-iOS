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
            Color("Primary").edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack {
                    viewTitleText
                }.padding(.bottom, 10)
                
                VStack {
                    Spacer().frame(height: 16)
                    
                    calendarView
                        .background(Color(.white))
                        .cornerRadius(14)
                        .padding(.horizontal, 16)
                    
                    Spacer().frame(height: 16)
                    
                    todoView
                        .background(Color(.white))
                        .cornerRadius(14)
                        .padding(.horizontal, 16)
                    
                    Spacer().frame(height: 16)
                }.background(Color("System246"))
            }
        }
    }
}

extension HomeView {
    var viewTitleText: some View {
        Text("スケジュール")
            .font(.system(size: 20, weight: .bold, design: .default))
            .foregroundColor(Color(.white))
    }
    
    var calendarView: some View {
        VStack {
            HStack {
                Text("\(viewModel.binding.isYearAndMonthString)")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(Color("Primary"))
                
                Spacer()
                
                Button(action: {
                    viewModel.input.toLastMonthActioned.send()
                }, label: {
                    Text("＜")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .foregroundColor(Color("Primary"))
                })
                
                Button(action: {
                    viewModel.input.toNextMonthActioned.send()
                }, label: {
                    Text("＞")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .foregroundColor(Color("Primary"))
                })
            }.padding(.horizontal, 10)
            .padding(.top, 10)
            
            WeekView()
                .frame(height: 30)
            
            GeometryReader { geometry in
                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top) {
                            CalendarView($viewModel.binding.isLatestMonthArray)
                        }
                    }.content.offset(x: CGFloat(viewModel.binding.isScrollOffset))
                    .gesture(DragGesture()
                                .onChanged { value in
                                    viewModel.input.toScrollOffsetChanged.send(Double(value.translation.width))
                                }
                                .onEnded { value in
                                    if value.predictedEndTranslation.width > geometry.size.width / 2 {
                                        viewModel.input.toLastMonthActioned.send()
                                        
                                        withAnimation(.easeOut(duration: 0.2)) {
                                            viewModel.input.toScrollOffsetChanged.send(Double(geometry.size.width))
                                        }
                                        
                                        viewModel.input.toRePositionScrollOffsetChanged.send(-Double(geometry.size.width))
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.21) {
                                            withAnimation(.easeOut(duration: 0.2)) {
                                                viewModel.input.toScrollOffsetChanged.send(0.0)
                                            }
                                        }

                                    } else if value.predictedEndTranslation.width < -geometry.size.width / 2 {
                                        viewModel.input.toNextMonthActioned.send()
                                        
                                        withAnimation(.easeOut(duration: 0.2)) {
                                            viewModel.input.toScrollOffsetChanged.send(-Double(geometry.size.width))
                                        }
                                        
                                        viewModel.input.toRePositionScrollOffsetChanged.send(Double(geometry.size.width))
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.21) {
                                            withAnimation(.easeOut(duration: 0.2)) {
                                                viewModel.input.toScrollOffsetChanged.send(0.0)
                                            }
                                        }
                                    }
                                    
                                    if value.predictedEndTranslation.width > -geometry.size.width / 2 && value.predictedEndTranslation.width < geometry.size.width / 2 {
                                        withAnimation {
                                            viewModel.input.toScrollOffsetChanged.send(0.0)
                                        }
                                    }
                                }
                    )
                }
            }.frame(height: CGFloat(viewModel.binding.isCalendarViewHeight))
            .onChange(of: viewModel.binding.isLatestMonthArray) { _ in
                withAnimation {
                    viewModel.input.toCalendarViewHeightChanged.send()
                }
            }
        }
        .padding(.horizontal, 10)
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
                                        .font(.system(size: 30, weight: .regular, design: .default))
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(Color(.white))
                                        .background(Color("Primary"))
                                        .cornerRadius(40)
                                }).frame(width: 40, height: 40)
                                
                                Spacer()
                            }
                        }
                    }
                }
            } else {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            viewModel.input.toEntryTodoViewButtonTapped.send()
                        }, label: {
                            Text("＋")
                                .font(.system(size: 30, weight: .regular, design: .default))
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color(.white))
                                .background(Color("Primary"))
                                .cornerRadius(40)
                        }).frame(width: 40, height: 40)
                        
                        Spacer()
                    }
                    Spacer()
                    
                }
            }
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
            @Published var lastMonthArray: Array<Int> = []
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

