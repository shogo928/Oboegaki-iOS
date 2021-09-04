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
            LinearGradient(gradient: Gradient(colors: [Color("Primary"), .white]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                TitllText
                
                Spacer().frame(height:20)
                
                signInStatusText
                
                Spacer().frame(height:20)

                Group {
                    Group {
                        VStack {
                            HStack {
                                emailHintText
                                Spacer()
                            }
                            emailTextField
                        }.padding(.horizontal, 10)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.white)
                            .cornerRadius(24)
                    }
                    
                    Spacer().frame(height:20)
                    
                    Group {
                        VStack {
                            HStack {
                                passwordHintText
                                Spacer()
                            }
                            if !viewModel.binding.isEntryPasswordShowFlag {
                                passwordHideTextField
                            } else {
                                passwordOpenTextField
                            }
                        }.padding(.horizontal, 10)
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.white)
                            .cornerRadius(24)
                        HStack {
                            Spacer()
                            passwordShowActionText
                        }.padding(.horizontal, 10)
                    }.onChange(of: viewModel.binding.isEntryPasswordTextField) { _ in
                        viewModel.input.toPasswordTextFieldEntered.send(viewModel.binding.isEntryPasswordTextField)
                    }
                    
                    Spacer().frame(height:20)
                    
                    emailLoginButton
                    
                    Spacer().frame(height:20)
                    
                    termsOfServiceText
                    
                    Spacer().frame(height:20)

                    privacyPolicyText
                }.padding(.horizontal, 20)
                
                Spacer()
                
                Group {
                    accountLoginText
                    
                    Spacer().frame(height:26)
                    
                    signInWithGoogleButton
                    
                    Spacer().frame(height:26)
                    
                    signInWithAppleButton
                    
                    Spacer().frame(height:100)
                }
            }.onChange(of: viewModel.binding.isSignInStatus) { _ in
                presentationMode.wrappedValue.dismiss()
            }
            .fullScreenCover(isPresented: $viewModel.binding.isTermsOfServiceSheetFlag) {
                TermsOfServiceView()
            }
            .fullScreenCover(isPresented: $viewModel.binding.isPrivacyPolicySheetFlag) {
                PrivacyPolicyView()
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
    
    var signInStatusText: some View {
        Text("\(viewModel.binding.isSignInStatusMessege)")
            .font(.system(size: 16, weight: .light, design: .default))
            .foregroundColor(viewModel.binding.isSignInStatusMessegeColorFlag ? .white : .red)
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
        VStack {
            TextField("メールアドレス", text: $viewModel.binding.isEntryEmailTextField)
                .preferredColorScheme(.light)
                .autocapitalization(.none)
        }
    }
    
    var passwordHideTextField: some View {
        VStack {
            SecureField("8〜16文字のパスワード", text: $viewModel.binding.isEntryPasswordTextField)
                .preferredColorScheme(.light)
                .autocapitalization(.none)
        }
    }
    
    var passwordOpenTextField: some View {
        VStack {
            TextField("8〜16文字のパスワード", text: $viewModel.binding.isEntryPasswordTextField)
                .preferredColorScheme(.light)
                .autocapitalization(.none)
        }
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
                    .background(Color("ClearWhite"))
                    .foregroundColor(.white)
                    .cornerRadius(9)
            }
        )
        .frame(width: 200, height: 40, alignment: .center)
    }
    
    var termsOfServiceText: some View {
        Button(
            action: {
                viewModel.input.toTermsOfServiceButtonTapped.send()
            }, label: {
                Text("利用規約")
                    .foregroundColor(.white)
                    .underline()
            }
        )
    }
    
    var privacyPolicyText: some View {
        Button(
            action: {
                viewModel.input.toPrivacyPolicyButtonTapped.send()
            }, label: {
                Text("プライバシーポリシー")
                    .foregroundColor(.white)
                    .underline()
            }
        )
    }
    
    var accountLoginText: some View {
        HStack {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("MediumGray"))
                .cornerRadius(24)
            Spacer()
            Text("サービスで開始する")
                .font(.system(size: 16, weight: .light, design: .default))
                .foregroundColor(Color("MediumGray"))
                .lineLimit(1)
                .frame(width: 140)
            Spacer()
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color("MediumGray"))
                .cornerRadius(24)
        }.padding(.horizontal, 20)
    }
    
    var signInWithGoogleButton: some View {
        HStack {
            Spacer()
            SignInWithGoogleButton(signInFlag: $viewModel.binding.isSignInStatus)
                .frame(width: 206, height: 50, alignment: .center)
            Spacer()
        }
    }
    
    var signInWithAppleButton: some View {
        HStack {
            Spacer()
            SignInWithAppleButton(signInFlag: $viewModel.binding.isSignInStatus)
                .frame(width: 200, height: 40, alignment: .center)
            Spacer()
        }
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
            
            var toSignInWithAppleButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
            var toSignInWithGoogleButtonTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
        }
        
        final class Binding: LoginViewModelBindingObject {
            @Published var isTermsOfServiceSheetFlag: Bool = false
            @Published var isPrivacyPolicySheetFlag: Bool = false
            
            @Published var isEntryEmailTextField: String = ""
            @Published var isEntryPasswordTextField: String = ""
            @Published var isEntryPasswordShowFlag: Bool = false
            
            @Published var isSignInStatus: Bool = false
            @Published var isSignInStatusMessege: String = ""
            @Published var isSignInStatusMessegeColorFlag: Bool = false
        }
        
        final class Output: LoginViewModelOutputObject {
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
