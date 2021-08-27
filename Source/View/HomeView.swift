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
            var toEntryTodoViewButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
            var toSettingViewButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        }
        
        final class Binding: HomeViewModelBindingObject {
            @Published var isTodoCount: Int = 0
            @Published var isTodoContanor: Array<NSObject> = []

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
