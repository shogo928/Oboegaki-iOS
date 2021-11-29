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
        
        UINavigationBarAppearance().configureWithOpaqueBackground()
        UINavigationBar.appearance().barTintColor = UIColor(ColorComponents.primary)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = .white
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                ColorComponents.backGround246.edgesIgnoringSafeArea(.all)
                
                ScrollView(.vertical, showsIndicators: false) {
                    Spacer().frame(height: 10)
                    
                    VStack(spacing: 0) {
                        yearView
                        
                        weekView
                        
                        Divider().background(ColorComponents.gray100)

                        calendarView
                        
                    }.padding(.horizontal, 10)
                    .background(Color(.white))
                    .cornerRadius(14)
                    
                    Spacer().frame(height: 10)
                    
                    VStack(spacing: 0) {
                        todoToolBarView
                        
                        Divider().background(ColorComponents.gray100)

                        if viewModel.binding.isTodoCount != 0 {
                            validTodoListView
                        } else {
                            invalidTodoListView
                        }
                        
                        Spacer().frame(height: 10)
                        
                    }.frame(height: 300)
                    .padding(.horizontal, 10)
                    .background(Color(.white))
                    .cornerRadius(14)
                    
                    Spacer().frame(height: 10)
                    
                }.padding(.horizontal, 10)
                .background(ColorComponents.backGround246)
            }
        }
    }
}

extension HomeView {
    var yearView: some View {
        HStack {
            Text("\(viewModel.output.isCurrentYearInt)年" + "\(viewModel.output.isCurrentMonthInt)月")
                .font(.system(size: 20, weight: .bold, design: .default))
                .foregroundColor(ColorComponents.primary)
            
            Spacer()
            
            Button(action: {
                viewModel.input.toLastMonthActioned.send()
            }, label: {
                Text("＜")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(ColorComponents.primary)
            })
            
            Spacer().frame(width: 20)
            
            Button(action: {
                viewModel.input.toNextMonthActioned.send()
            }, label: {
                Text("＞")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(ColorComponents.primary)
            })
        }.padding(.vertical, 10)
    }
    
    var weekView: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0, alignment: .top), count: 7), spacing: 10) {
            ForEach(0..<viewModel.output.isWeekArray.count) {
                switch viewModel.output.isWeekArray[$0] {
                case "日":
                    Text("\(viewModel.output.isWeekArray[$0])")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundColor(.red)
                case "土":
                    Text("\(viewModel.output.isWeekArray[$0])")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundColor(.blue)
                default :
                    Text("\(viewModel.output.isWeekArray[$0])")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundColor(ColorComponents.gray100)
                }
            }
        }.frame(height: 25)
    }
    
    var calendarView: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0, alignment: .top), count: 7), spacing: 10) {
                        ForEach(viewModel.output.isCurrentMonthDate, id: \.id) { currentMonthDate in
                            if currentMonthDate.day == 0 {
                                VStack {}
                            } else {
                                VStack(spacing: 0) {
                                    Text("\(currentMonthDate.day)")
                                        .frame(height: 55, alignment: .top)
                                        .font(.system(size: 14, weight: .light, design: .default))
                                        .foregroundColor(Color(viewModel.binding.isSelectedColumn == currentMonthDate.id ? .white : UIColor(ColorComponents.gray50)))
                                    
                                    Divider().background(ColorComponents.gray200)
                                }.background(
                                    Color(viewModel.binding.isSelectedColumn == currentMonthDate.id ? UIColor(ColorComponents.primary) : .clear)
                                        .cornerRadius(9)
                                        .offset(y: -5)
                                ).onTapGesture {
                                    viewModel.input.toDateSelected.send(currentMonthDate.day)
                                    withAnimation {
                                        viewModel.input.toColumnSelected.send(currentMonthDate.id)
                                    }
                                }
                            }
                        }
                    }.contentShape(RoundedRectangle(cornerRadius: 0))
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
        .padding(.vertical, 10)
        .onChange(of: viewModel.output.isCurrentMonthDate) { _ in
            withAnimation {
                viewModel.input.toCalendarViewHeightChanged.send()
            }
        }
    }
    
    var todoToolBarView: some View {
        HStack {
            Text("ToDo")
                .font(.system(size: 20, weight: .bold, design: .default))
                .foregroundColor(ColorComponents.primary)
            
            Spacer()
            
            NavigationLink(destination: CreateToDoView(viewModel: CreateToDoViewModel(viewModel.output.isSelectedDate))            .environmentObject(HomeViewModel())) {
                Image(systemName: "pencil")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(ColorComponents.primary)
            }.navigationTitle("スケジュール")
            .navigationBarTitleDisplayMode(.inline)
        }.frame(height: 30)
        .padding(.vertical, 6)
    }
    
    var validTodoListView: some View {
        List {
            ForEach(0..<viewModel.binding.isTodoCount + 1) { index in
                HStack {
                    Text("")
                    
                }.listRowBackground((index % 2 == 0) ? ColorComponents.white245 : .white)
                
                if index == viewModel.binding.isTodoCount {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            viewModel.input.toCreateToDoViewButtonTapped.send()
                        }, label: {
                            Image(systemName: "pencil")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(ColorComponents.primary)
                        }).sheet(isPresented: $viewModel.binding.isActiveCreateToDoView) {
                            CreateToDoView(viewModel: CreateToDoViewModel(viewModel.output.isSelectedDate))
                        }
                        
                        Spacer()
                    }
                }
            }
        }
    }
    
    var invalidTodoListView: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("予定がありません。")
                .font(.system(size: 16, weight: .regular, design: .default))
                .foregroundColor(ColorComponents.primary)
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
        
        init() {
            input = Input()
            binding = Binding()
            output = Output()
        }
    }
}

