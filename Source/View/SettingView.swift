//
//  SettingView.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/09/04.
//

import Combine
import SwiftUI

struct SettingView<T>: View where T: SettingViewModelObject {
    @ObservedObject private var viewModel: T
    
    init(viewModel: T) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color("Primary").edgesIgnoringSafeArea(.all)
            
            VStack {
                settingText
                settingListView
            }
        }
    }
}

private extension SettingView {
    var settingText: some View {
        Text("設定")
            .font(.system(size: 20, weight: .bold, design: .default))
            .foregroundColor(Color(.white))
    }
    
    var settingListView: some View {
        List {
            Section(header: Text("ユーザー")){
                ForEach(0..<viewModel.output.isSettingUserArray.count, id: \.self) { value in
                    HStack {
                        Text(viewModel.output.isSettingUserArray[value])
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.input.toUserNameButtonTapped.send()
                        }, label: {
                            Text("＞")
                                .frame(width: 40, height: 40, alignment: .center)
                                .foregroundColor(.gray)
                        }).frame(width: 40, height: 40, alignment: .center)
                    }
                }
            }
            Section(header: Text("アカウント")){
                ForEach(0..<viewModel.output.isSettingAccountArray.count, id: \.self) { value in
                    HStack {
                        Text(viewModel.output.isSettingAccountArray[value])
                        
                        Spacer()
                        
                        Button(action: {
                            if value == 0 {
                                viewModel.input.toLogoutButtonTapped.send()
                            } else {
                                viewModel.input.toWithdrawalButtonTapped.send()
                            }
                        }, label: {
                            Text("＞")
                                .frame(width: 40, height: 40, alignment: .center)
                                .foregroundColor(.gray)
                        }).frame(width: 40, height: 40, alignment: .center)
                    }
                }
            }
            Section(header: Text("テーマ")){
                ForEach(0..<viewModel.output.isSettingThemeArray.count, id: \.self) { value in
                    HStack {
                        Text(viewModel.output.isSettingThemeArray[value])
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.input.toSystemColorButtonTapped.send()
                        }, label: {
                            Text("＞")
                                .frame(width: 40, height: 40, alignment: .center)
                                .foregroundColor(.gray)
                        }).frame(width: 40, height: 40, alignment: .center)
                    }
                }
            }
            Section(header: Text("本アプリについて")){
                ForEach(0..<viewModel.output.isSettingOboegakiArray.count, id: \.self) { value in
                    HStack {
                        Text(viewModel.output.isSettingOboegakiArray[value])
                        
                        Spacer()
                        
                        Button(action: {
                            if value == 0 {
                                viewModel.input.toVersionButtonTapped.send()
                            } else {
                                viewModel.input.toReviewButtonTapped.send()
                            }
                        }, label: {
                            Text("＞")
                                .frame(width: 40, height: 40, alignment: .center)
                                .foregroundColor(.gray)
                        }).frame(width: 40, height: 40, alignment: .center)
                    }
                }
            }
        }.listStyle(InsetGroupedListStyle())
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView(viewModel: MockViewModel())
    }
}

extension SettingView_Previews {
    final class MockViewModel: SettingViewModelObject {
        final class Input: SettingViewModelInputObject {
            var toUserNameButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
            
            var toLogoutButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
            var toWithdrawalButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
            
            var toSystemColorButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
            
            var toVersionButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
            var toReviewButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        }
        
        final class Binding: SettingViewModelBindingObject {
            @Published var isLoading: Bool = false        }
        
        final class Output: SettingViewModelOutputObject {
            @Published var isSettingUserArray: Array<String> = []
            @Published var isSettingAccountArray: Array<String> = []
            @Published var isSettingThemeArray: Array<String> = []
            @Published var isSettingOboegakiArray: Array<String> = []
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
