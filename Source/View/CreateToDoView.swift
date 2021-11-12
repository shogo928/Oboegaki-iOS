//
//  CreateToDoView.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/09/05.
//

import Combine
import SwiftUI

struct CreateToDoView<T>: View where T: CreateToDoViewModelObject {
    @Environment(\.presentationMode) var presentationMode

    @ObservedObject private var viewModel: T
    
    init(viewModel: T) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            ColorComponents.backGround246.edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    TitleText
                    TitleTextField
                    
                    DatePickerView
                    Divider().background(ColorComponents.gray200)
                    
                    TimePickerView
                    Divider().background(ColorComponents.gray200)

                    NoteText
                    NoteTextField
                    
                    SaveButton
                }.padding(10)
                
            }.background(Color(.white))
            .cornerRadius(16)
            .padding(10)
        }.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

extension CreateToDoView {
    var TitleText: some View {
        Text("タイトル")
            .font(.system(size: 14, weight: .bold, design: .default))
            .foregroundColor(ColorComponents.primary)
    }
    
    var TitleTextField: some View {
        TextField("タイトル", text: $viewModel.binding.isEntryTitleTextField)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .preferredColorScheme(.light)
            .autocapitalization(.none)
            .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(ColorComponents.gray200, lineWidth: 1.0)
            )
            .onChange(of: viewModel.binding.isEntryTitleTextField) { _ in
                viewModel.input.toEntryTitleTextField.send(viewModel.binding.isEntryTitleTextField)
            }
    }
    
    var DatePickerView: some View {
        DatePicker(selection: $viewModel.binding.isSelectionDate,
                   in: Date()...,
                   displayedComponents: .date) {
            Text("日付")
                .font(.system(size: 14, weight: .bold, design: .default))
                .foregroundColor(ColorComponents.primary)
        }.accentColor(ColorComponents.primary)
        .environment(\.locale, Locale(identifier: "ja_JP"))
    }
    
    var TimePickerView: some View {
        DatePicker(selection: $viewModel.binding.isSelectionTime,
                   in: Date()...,
                   displayedComponents: .hourAndMinute) {
            Text("時間")
                .font(.system(size: 14, weight: .bold, design: .default))
                .foregroundColor(ColorComponents.primary)
        }.accentColor(ColorComponents.primary)
        .environment(\.locale, Locale(identifier: "ja_JP"))
    }
    
    var NoteText: some View {
        Text("本文")
            .font(.system(size: 14, weight: .bold, design: .default))
            .foregroundColor(ColorComponents.primary)
    }
    
    var NoteTextField: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder()
                .foregroundColor(ColorComponents.gray200)
                .background(Color.clear)
            TextEditor(text: $viewModel.binding.isEntryNoteTextField)
                .padding()
                .foregroundColor(.black)
                .onChange(of: viewModel.binding.isEntryNoteTextField) { _ in
                    viewModel.input.toEntryNoteTextField.send(viewModel.binding.isEntryNoteTextField)
                }
        }.frame(height: 300)
    }
    
    var SaveButton: some View {
        HStack {
            Spacer()
            
            Button(action: {
                viewModel.input.toSaveButtonTapped.send()
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("保存")
                    .frame(width: 200, height: 40, alignment: .center)
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .background(ColorComponents.primary.opacity(0.5))
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
            @Published var isSelectionDate: Date = Date()
            @Published var isSelectionTime: Date = Date()
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
