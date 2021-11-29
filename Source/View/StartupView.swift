//
//  ContentView.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/08/23.
//

import Combine
import SwiftUI

struct StartupView<T>: View where T: StartupViewModelObject {
    @ObservedObject private var viewModel: T
    
    init(viewModel: T) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color(.white).edgesIgnoringSafeArea(.all)
            
            animationView
                .fullScreenCover(isPresented: $viewModel.binding.isLoading,
                                 onDismiss: { viewModel.input.toLoadingStarted.send() }) {
                    
                if viewModel.binding.isFirebaseAuth {
                    
                    TabBarView()
                    
                } else {
                    
                    LoginView(viewModel: LoginViewModel(viewModel.binding.isFirebaseAuth)).edgesIgnoringSafeArea(.all)
                    
                }
            }
        }
    }
}

private extension StartupView {
    var animationView: some View {
        GeometryReader { geometry in
            VStack {
                Text("Oboegaki")
                    .font(.system(size: 50, weight: .black, design: .default))
                    .foregroundColor(Color("Secondary"))
                    .italic()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(x: viewModel.binding.isAnimating ? 0 : -geometry.size.width)
                    .onAppear() {
                        withAnimation(.easeIn) {
                            viewModel.input.toAnimationStarted.send()
                        }
                        viewModel.input.toLoadingStarted.send()
                    }
            }
        }
    }
}

struct StartupView_Previews: PreviewProvider {
    static var previews: some View {
        StartupView(viewModel: MockViewModel())
    }
}

extension StartupView_Previews {
    final class MockViewModel: StartupViewModelObject {
        final class Input: StartupViewModelInputObject {
            var toAnimationStarted: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
            var toLoadingStarted: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        }
        
        final class Binding: StartupViewModelBindingObject {
            @Published var isAnimating: Bool = false
            @Published var isLoading: Bool = false
            @Published var hasError: Bool = false
            
            @Published var isFirebaseAuth: Bool = false
            @Published var isUserName: Bool = false
        }
        
        final class Output: StartupViewModelOutputObject {
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
