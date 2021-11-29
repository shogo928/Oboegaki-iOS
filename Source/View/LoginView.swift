//
//  LoginView.swift
//  Oboegaki-iOS
//
//  Created by sakumashogo on 2021/08/23.
//

import Combine
import SwiftUI

struct LoginView<T>: View where T: LoginViewModelObject {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var viewModel: T
    
    init(viewModel: T) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            
            // Background Gradient Effect

            LinearGradient(gradient: Gradient(colors: [Color("Primary"), .white]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            
            
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        
                        // Login View
                        
                        VStack(alignment: .center, spacing: 0) {
                            
                            TitllText.padding(.vertical, 20)
                            
                            
                            
                            // Email
                            
                            VStack(alignment: .leading, spacing: 10) {
                                
                                emailHintText
                                
                                emailTextField.frame(width: geometry.size.width - 20, height: 25)
                                
                                        Rectangle()
                                            .frame(height: 0.5)
                                            .foregroundColor(Color(.white))
                                            .cornerRadius(24)
                                
                            }.padding(.horizontal, 10)
                            .padding(.bottom, 10)
                            
                            
                            
                            // Password
                            
                            VStack(alignment: .leading, spacing: 10) {
                                
                                passwordHintText
                                
                                if !viewModel.binding.isEntryPasswordShowFlag {
                                    
                                    passwordHideTextField.frame(width: geometry.size.width - 20, height: 25)
                                    
                                } else {
                                    
                                    passwordOpenTextField.frame(width: geometry.size.width - 20, height: 25)
                                    
                                }
                                
                                Rectangle()
                                    .frame(height: 0.5)
                                    .foregroundColor(Color(.white))
                                    .cornerRadius(24)
                                
                                HStack {

                                    Spacer()
                                    
                                    passwordShowActionText
                                    
                                }.padding(.trailing, 10)
                                
                            }.padding(.horizontal, 10)
                            
                            .onChange(of: viewModel.binding.isEntryPasswordTextField) { _ in
                                
                                viewModel.input.toPasswordTextFieldEntered.send(viewModel.binding.isEntryPasswordTextField)
                            
                            }
                            
                            
                            
                            // Save Button
                            
                            VStack(alignment: .center, spacing: 0) {
                                
                                signInErrorText
                                    .frame(height:30)
                                    .padding(.vertical, 10)

                                emailLoginButton

                                HStack(alignment: .center, spacing: 15) {
                                    
                                    termsOfServiceButton

                                    privacyPolicyButton

                                }.padding(.vertical, 30)
                                
                            }.padding(.horizontal, 10)

                            
                            
                            // Auth Login Button
                            
                            VStack(alignment: .center, spacing: 15) {
                                
                                accountLoginText.padding(.bottom, 10)
                                
                                signInWithAppleButton

                                signInWithGoogleButton
                                
                                signInWithAnonymouslyButton

                            }
                            .padding(.horizontal, 10)
                            
                        }.frame(width: geometry.size.width, height: geometry.size.height)
                        
                        
                        
                        // Check Email View
                        
                        VStack(spacing: 0) {
                            
                            Spacer()
                            
                            Text("メールを送信しました\n送付先：\(viewModel.binding.isEntryEmailTextField)\nメールボックスを確認してください")
                                .font(.system(size: 16, weight: .bold, design: .default))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text("\(viewModel.output.isSignInResultMessege)")
                                .font(.system(size: 16, weight: .bold, design: .default))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(
                                action: {
                                    viewModel.input.toReWrithButtonTapped.send()
                                }, label: {
                                    Text("入力し直す")
                                        .frame(width: 200, height: 40, alignment: .center)
                                        .font(.system(size: 16, weight: .regular, design: .default))
                                        .background(Color("Primary"))
                                        .foregroundColor(.white)
                                        .cornerRadius(9)
                                }
                            ).frame(width: 200, height: 40, alignment: .center)
                            
                            Spacer()
                            
                        }.frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }.content.offset(x: CGFloat(viewModel.binding.isScrollOffsetFlag ? -geometry.size.width : 0.0))
                .animation(.default)
                .frame(width: geometry.size.width * 2)
                
            }
            
            .onChange(of: viewModel.binding.isSignInStatus) { _ in

                presentationMode.wrappedValue.dismiss()
            
            }
        }
    }
}

extension LoginView {
    var TitllText: some View {
        Text("Oboegaki")
            .font(.system(size: 50, weight: .black, design: .default))
            .foregroundColor(.white)
            .italic()
    }
    
    var signInErrorText: some View {
        Text("\(viewModel.output.isSignInErrorMessege)")
            .font(.system(size: 16, weight: .light, design: .default))
            .foregroundColor(.red)
    }

    var emailHintText: some View {
        Text("メールアドレス")
            .font(.system(size: 14, weight: .medium, design: .default))
            .foregroundColor(.white)
    }
    
    var passwordHintText: some View {
        Text("パスワード")
            .font(.system(size: 14, weight: .medium, design: .default))
            .foregroundColor(.white)
    }
    
    var emailTextField: some View {
            TextField("メールアドレス", text: $viewModel.binding.isEntryEmailTextField)
                .preferredColorScheme(.light)
                .autocapitalization(.none)
    }
    
    var passwordHideTextField: some View {
            SecureField("8〜16文字のパスワード", text: $viewModel.binding.isEntryPasswordTextField)
                .preferredColorScheme(.light)
                .autocapitalization(.none)
    }
    
    var passwordOpenTextField: some View {
            TextField("8〜16文字のパスワード", text: $viewModel.binding.isEntryPasswordTextField)
                .preferredColorScheme(.light)
                .autocapitalization(.none)
    }
    
    var passwordShowActionText: some View {
        Text("パスワードを表示する")
            .font(.system(size: 11, weight: .medium, design: .default))
            .foregroundColor(.white)
            .onTapGesture {
                viewModel.input.toPasswordShowTextTapped.send()
            }
    }
    
    var emailLoginButton: some View {
        Button(
            action: {
                viewModel.input.toLoginButtonTapped.send()
            }, label: {
                Text("開始する")
                    .frame(width: 200, height: 40, alignment: .center)
                    .font(.system(size: 16, weight: .black, design: .default))
                    .background(Color("Primary").opacity(viewModel.binding.isEntryEmailTextField.isEmpty || viewModel.binding.isEntryPasswordTextField.isEmpty ? 0.3 : 0.9))
                    .foregroundColor(.white)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(ColorComponents.gray200, lineWidth: 0.5)
                    )
            }
        )
        .frame(width: 200, height: 40, alignment: .center)
        .disabled(viewModel.binding.isEntryEmailTextField.isEmpty || viewModel.binding.isEntryPasswordTextField.isEmpty)
    }
    
    var termsOfServiceButton: some View {
        Button(
            
            action: {
            
                viewModel.input.toTermsOfServiceButtonTapped.send()
                
            }, label: {
                
                Text("利用規約")
                    .foregroundColor(.white)
                    .underline()
                
            }
            
        ).fullScreenCover(isPresented: $viewModel.binding.isTermsOfServiceSheetFlag) {
            
            TermsOfServiceView()
            
        }
    }
    
    var privacyPolicyButton: some View {
        Button(
            
            action: {
                
                viewModel.input.toPrivacyPolicyButtonTapped.send()
            
            }, label: {
            
                Text("プライバシーポリシー")
                    .foregroundColor(.white)
                    .underline()
            
            }
        
        ).fullScreenCover(isPresented: $viewModel.binding.isPrivacyPolicySheetFlag) {
            
            PrivacyPolicyView()
        
        }
    }
    
    var accountLoginText: some View {
        HStack(alignment: .center, spacing: 15) {
            
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(ColorComponents.gray100)
                .cornerRadius(24)
            
            Text("サービスで開始する")
                .font(.system(size: 16, weight: .light, design: .default))
                .foregroundColor(ColorComponents.gray100)
                .lineLimit(1)
                .frame(width: 140)
            
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(ColorComponents.gray100)
                .cornerRadius(24)
            
        }
    }
    
    var signInWithAnonymouslyButton: some View {
        Button(
            action: {
                
                viewModel.input.toSignInWithAnonymouslyButtonTapped.send()
            
            }, label: {
            
                Text("ゲストで開始する")
                    .frame(width: 200, height: 40, alignment: .center)
                    .font(.system(size: 16, weight: .black, design: .default))
                    .background(ColorComponents.primary)
                    .foregroundColor(.white)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(ColorComponents.gray200, lineWidth: 0.5)
                    )

            }
        ).frame(width: 200, height: 40, alignment: .center)
    }
    
    var signInWithGoogleButton: some View {
            SignInWithGoogleButton(signInFlag: $viewModel.binding.isSignInStatus)
                .frame(width: 206, height: 50, alignment: .center)
    }
    
    var signInWithAppleButton: some View {
            SignInWithAppleButton(signInFlag: $viewModel.binding.isSignInStatus)
                .frame(width: 200, height: 40, alignment: .center)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: MockViewModel())
    }
}

extension LoginView_Previews {
    final class MockViewModel: LoginViewModelObject {
        final class Input: LoginViewModelInputObject {
            var toPasswordTextFieldEntered: PassthroughSubject<String, Never> = PassthroughSubject<String, Never>()
            
            var toPasswordShowTextTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
            var toLoginButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
            var toTermsOfServiceButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
            var toPrivacyPolicyButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
            
            var toSignInWithAnonymouslyButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
            var toSignInWithAppleButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
            var toSignInWithGoogleButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
            
            var toReWrithButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        }
        
        final class Binding: LoginViewModelBindingObject {
            @Published var isTermsOfServiceSheetFlag: Bool = false
            @Published var isPrivacyPolicySheetFlag: Bool = false
            
            @Published var isEntryEmailTextField: String = ""
            @Published var isEntryPasswordTextField: String = ""
            @Published var isEntryPasswordShowFlag: Bool = false
            
            @Published var isSignInStatus: Bool = false
            
            @Published var isScrollOffsetFlag: Bool = false
        }
        
        final class Output: LoginViewModelOutputObject {
            @Published var isSignInErrorMessege: String = ""
            @Published var isSignInResultMessege: String = ""
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
