//
//  CreateToDoView.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/09/05.
//

import Combine
import SwiftUI

struct CreateToDoView<T>: View where T: CreateToDoViewModelObject {
    @ObservedObject private var viewModel: T
    
    init(viewModel: T) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color("System246").edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer().frame(height: 20)

                Group {
                    TitleText
                    TitleTextField
                }.padding(.horizontal, 20)
                
                Spacer().frame(height: 20)

                Group {
                    DatePickerView
                }.padding(.horizontal, 20)
                
                Spacer().frame(height: 20)

                /*
                 Group {
                    SelectUserList
                 }.padding(.horizontal, 20)
                 
                 Spacer().frame(height: 20)
                 */

                Group {
                    NoteText
                    NoteTextField
                }.padding(.horizontal, 20)

                Spacer().frame(height: 20)

                SaveButton
                
                Spacer().frame(height: 20)
            }.background(Color(.white))
            .cornerRadius(16)
            .padding(20)
        }
    }
}

extension CreateToDoView {
    var TitleText: some View {
        HStack {
            Text("タイトル")
                .font(.system(size: 14, weight: .regular, design: .default))
                .foregroundColor(.black)

            Spacer()
        }
    }
    
    var TitleTextField: some View {
        VStack {
            TextField("タイトル", text: $viewModel.binding.isEntryTitleTextField)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .preferredColorScheme(.light)
                .autocapitalization(.none)
                .onChange(of: viewModel.binding.isEntryTitleTextField) { _ in
                    viewModel.input.toEntryTitleTextField.send(viewModel.binding.isEntryTitleTextField)
                }
        }
    }
    
    var DatePickerView: some View {
        VStack {
            DatePicker(selection: $viewModel.binding.isSectionDate) {
                Text("日時")
                    .font(.system(size: 14, weight: .regular, design: .default))
                    .accentColor(.black)
            }.accentColor(Color("Primary"))
            .environment(\.locale, Locale(identifier: "ja_JP"))
        }
    }
    
    var NoteText: some View {
        HStack {
            Text("本文")
                .font(.system(size: 14, weight: .regular, design: .default))
                .foregroundColor(.black)

            Spacer()
        }
    }
    
    var NoteTextField: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder()
                .foregroundColor(Color("Gray200"))
                .background(Color.clear)
            TextEditor(text: $viewModel.binding.isEntryNoteTextField)
                .padding()
                .foregroundColor(.black)
                .onChange(of: viewModel.binding.isEntryNoteTextField) { _ in
                    viewModel.input.toEntryNoteTextField.send(viewModel.binding.isEntryNoteTextField)
                }
        }
    }
    
    var SaveButton: some View {
        HStack {
            Spacer()
            
            Button(action: {
                viewModel.input.toSaveButtonTapped.send()
            }, label: {
                Text("保存")
                    .frame(width: 200, height: 40, alignment: .center)
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .background(Color("Primary").opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(9)
            }).frame(width: 200, height: 40, alignment: .center)

            Spacer()
        }
    }
}

struct CreateToDoView_Previews: PreviewProvider {
    static var previews: some View {
        CreateToDoView(viewModel: MockViewModel())
    }
}

extension CreateToDoView_Previews {
    final class MockViewModel: CreateToDoViewModelObject {
        final class Input: CreateToDoViewModelInputObject {
            var toEntryTitleTextField: PassthroughSubject<String, Never> = PassthroughSubject<String, Never>()
            var toEntryNoteTextField: PassthroughSubject<String, Never> = PassthroughSubject<String, Never>()
            var toSaveButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        }
        
        final class Binding: CreateToDoViewModelBindingObject {
            @Published var isEntryTitleTextField: String = ""
            @Published var isSectionDate: Date = Date()
            @Published var isEntryNoteTextField: String = ""
        }
        
        final class Output: CreateToDoViewModelOutputObject {
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
