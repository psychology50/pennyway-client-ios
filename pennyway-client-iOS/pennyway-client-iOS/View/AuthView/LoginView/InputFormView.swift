import SwiftUI

struct InputFormView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @EnvironmentObject var authViewModel: AppViewModel

    @State private var isLoginSuccessful = true

    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("친구들과 함께\n간편한 자산관리")
                    .font(.H1SemiboldFont())
                    .multilineTextAlignment(.leading)
                    .padding(.top, 40 * DynamicSizeFactor.factor())

                Spacer()
            }
            .padding(.leading, 20)

            if loginViewModel.showErrorCodeContent {
                Spacer().frame(height: 14 * DynamicSizeFactor.factor())
                ErrorCodeContentView(isCloseErrorPopUpView: $loginViewModel.isLoginSuccessful)
                Spacer().frame(height: 35)

            } else {
                Spacer().frame(height: 49 * DynamicSizeFactor.factor())
            }

            VStack(spacing: 9 * DynamicSizeFactor.factor()) {
                CustomInputView(inputText: $loginViewModel.username, placeholder: "아이디 입력", onCommit: {}, isSecureText: false, showDeleteButton: true,
                                deleteAction: {
                                    loginViewModel.username = ""
                                })

                CustomInputView(inputText: $loginViewModel.password, placeholder: "비밀번호 입력", onCommit: {}, isSecureText: true, showDeleteButton: true,
                                deleteAction: {
                                    loginViewModel.password = ""
                                })

                Spacer().frame(height: 4 * DynamicSizeFactor.factor())
            }
            VStack {
                CustomBottomButton(action: {
                    handleLogin()

                }, label: "로그인", isFormValid: .constant(true))
            }
        }
        .onAppear {
            loginViewModel.isLoginSuccessful = false
        }
    }

    func handleLogin() {
        loginViewModel.loginApi { success in
            DispatchQueue.main.async {
                if success {
                    authViewModel.login()
                } else {
                    Log.error("fail login")
                    loginViewModel.isLoginSuccessful = true
                    loginViewModel.username = ""
                    loginViewModel.password = ""
                }
            }
        }
    }
}

#Preview {
    InputFormView(loginViewModel: LoginViewModel())
}
