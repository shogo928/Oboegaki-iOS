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
            
            LinearGradient(gradient: Gradient(colors: [ColorComponents.primary, .white]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()
            
            
            
            TabView(selection: $viewModel.binding.isTabViewSelection) {
                
                // SignIn or SignUp View
                
                VStack(alignment: .center, spacing: 20) {
                    
                    // Description Image & Text
                    
                    VStack(alignment: .center, spacing: 15) {
                        
                        signInTitleImage
                        
                        signInDescriptionText
                        
                    }.frame(maxHeight: 100)
                    .padding(.vertical, 100)
                    
                    
                    // Service Description Text
                    
                    HStack(alignment: .center, spacing: 15) {
                        
                        termsOfServiceButton
                        
                        privacyPolicyButton
                        
                    }
                    
                    
                    // Auth Login Button
                    
                    VStack(alignment: .center, spacing: 15) {
                        
                        emailLoginText.padding(.vertical, 10)
                        
                        signInWithEmailButton
                        
                        accountLoginText.padding(.vertical, 10)
                        
                        signInWithAppleButton
                        
                        signInWithGoogleButton
                        
                        signInWithAnonymouslyButton
                        
                    }
                    
                    Spacer(minLength: 50)
                    
                }
                .padding(10)
                .animation(nil)
                .tag(0)
                
                
                
                // SignIn or SignUp With Email View
                
                VStack(alignment: .center, spacing: 20) {
                    
                    // Description Image & Text
                    
                    VStack(alignment: .center, spacing: 15) {
                        
                        entryFormImage
                        
                        entryFormDescriptionText
                        
                    }.frame(maxHeight: 100)
                    .padding(.vertical, 100)
                    
                    
                    // Email Form
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        emailHintText
                        
                        emailTextField.frame(maxWidth: .infinity - 20, maxHeight: 25)
                        
                        Rectangle()
                            .frame(height: 0.5)
                            .foregroundColor(Color(.white))
                            .cornerRadius(24)
                        
                    }
                    
                    
                    // Password Form
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        passwordHintText
                        
                        if !viewModel.binding.isEntryPasswordShowFlag {
                            
                            passwordHideTextField.frame(maxWidth: .infinity - 20, maxHeight: 25)
                            
                        } else {
                            
                            passwordOpenTextField.frame(maxWidth: .infinity - 20, maxHeight: 25)
                            
                        }
                        
                        Rectangle()
                            .frame(height: 0.5)
                            .foregroundColor(Color(.white))
                            .cornerRadius(24)
                        
                        HStack {
                            
                            Spacer()
                            
                            passwordShowActionText
                            
                        }.padding(.trailing, 10)
                        
                    }
                    
                    .onChange(of: viewModel.binding.isEntryPasswordTextField) { _ in
                        
                        viewModel.input.toPasswordTextFieldEntered.send(viewModel.binding.isEntryPasswordTextField)
                        
                    }
                    
                    
                    // Save Button
                    
                    VStack(alignment: .center, spacing: 15) {
                        
                        signInErrorText
                        
                        emailLoginButton
                        
                    }
                    
                    Spacer(minLength: 50)
                    
                }
                .padding(10)
                .animation(nil)
                .tag(1)
                
                
                
                // Email Verified View
                
                VStack(alignment: .center, spacing: 20) {
                    
                    // Description Image & Text
                    
                    VStack(alignment: .center, spacing: 15) {
                        
                        sendEmailImage
                        
                        sendEmailDescriptionText
                        
                    }.frame(maxHeight: 100)
                    .padding(.vertical, 100)
                    
                    
                    // Email Auth Result Text
                    
                    VStack(alignment: .leading, spacing: 15) {
                        
                        sentEmailText
                        
                        verificationResultText
                        
                    }
                    
                    Spacer()
                    
                    
                    // ReWrith Button
                    
                    VStack(alignment: .center, spacing: 15) {
                        
                        reWrithEmailButton
                        
                    }
                    
                    Spacer(minLength: 50)
                    
                }
                .padding(10)
                .animation(nil)
                .tag(2)
                
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.default)
            
            .onAppear(perform: {
                
                UIScrollView.appearance().isScrollEnabled = false
                
            })
            
            .onDisappear(perform: {
                
                UIScrollView.appearance().isScrollEnabled = true
                
            })
            
        }
        
        .onChange(of: viewModel.binding.isSignInStatus) { _ in
            
            presentationMode.wrappedValue.dismiss()
            
        }
        
    }
}



// TabView tag 0
extension LoginView {
    var appTitleText: some View {
        Text("Oboegaki")
            .font(.system(size: 50, weight: .black, design: .default))
            .foregroundColor(.white)
            .italic()
    }
    
    var signInTitleImage: some View {
        Image(systemName: "person.fill.viewfinder")
            .resizable()
            .scaledToFit()
            .foregroundColor(.white)
            .frame(width: 50, height: 50)
    }
    
    var signInDescriptionText: some View {
        Text("Oboegaki に使用するアカウントを選択してください")
            .font(.system(size: 14, weight: .black, design: .default))
            .foregroundColor(.white)
            .italic()
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
    
    var emailLoginText: some View {
        HStack(alignment: .center, spacing: 15) {
            
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(ColorComponents.gray100)
                .cornerRadius(24)
            
            Text("メールアドレスで開始する")
                .font(.system(size: 14, weight: .light, design: .default))
                .foregroundColor(ColorComponents.gray100)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .frame(width: 160)
            
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(ColorComponents.gray100)
                .cornerRadius(24)
            
        }
    }
    
    var signInWithEmailButton: some View {
        Button(
            action: {
                
                viewModel.input.toStartEmailTapped.send()
                
            }, label: {
                
                Text("メールアドレスで開始する")
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
                .minimumScaleFactor(0.5)
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



// TabView tag 1
extension LoginView {
    var entryFormImage: some View {
        Image(systemName: "rectangle.and.pencil.and.ellipsis")
            .resizable()
            .scaledToFit()
            .foregroundColor(.white)
            .frame(width: 50, height: 50)
    }
    
    var entryFormDescriptionText: some View {
        Text("メールアドレスを入力してください")
            .font(.system(size: 14, weight: .black, design: .default))
            .foregroundColor(.white)
            .italic()
    }
    
    var signInErrorText: some View {
        Text("\(viewModel.output.isSignInErrorMessege)")
            .font(.system(size: 16, weight: .light, design: .default))
            .foregroundColor(.red)
            .frame(height:30)
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
    
}



// TabView tag 2
extension LoginView {
    var sendEmailImage: some View {
        Image(systemName: "envelope.badge")
            .resizable()
            .scaledToFit()
            .foregroundColor(.white)
            .frame(width: 50, height: 50)
    }
    
    var sendEmailDescriptionText: some View {
        Text("メールを送信しました")
            .font(.system(size: 14, weight: .black, design: .default))
            .foregroundColor(.white)
            .italic()
    }
    
    var sentEmailText: some View {
        Text("メールボックスを確認してください\n送付先：\n\(viewModel.binding.isEntryEmailTextField)")
            .font(.system(size: 14, weight: .black, design: .default))
            .foregroundColor(.white)
    }
    
    var verificationResultText: some View {
        Text("認証結果：\n\(viewModel.output.isSignInResultMessege)")
            .font(.system(size: 16, weight: .black, design: .default))
            .foregroundColor(.white)
    }
    
    var reWrithEmailButton: some View {
        Button(
            action: {
                viewModel.input.toReWrithButtonTapped.send()
            }, label: {
                Text("入力し直す")
                    .frame(width: 200, height: 40, alignment: .center)
                    .font(.system(size: 16, weight: .black, design: .default))
                    .background(Color("Primary"))
                    .foregroundColor(.white)
                    .cornerRadius(9)
            }
        ).frame(width: 200, height: 40, alignment: .center)
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
            var toStartEmailTapped: PassthroughSubject<Void, Never> = PassthroughSubject<Void, Never>()
            
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
            @Published var isTabViewSelection: Int = 0
            
            @Published var isTermsOfServiceSheetFlag: Bool = false
            @Published var isPrivacyPolicySheetFlag: Bool = false
            
            @Published var isEntryEmailTextField: String = ""
            @Published var isEntryPasswordTextField: String = ""
            @Published var isEntryPasswordShowFlag: Bool = false
            
            @Published var isSignInStatus: Bool = false
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
