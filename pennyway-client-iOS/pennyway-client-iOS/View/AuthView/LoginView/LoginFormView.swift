import SwiftUI

struct LoginFormView: View {
    @ObservedObject var viewModel: LoginFormViewModel

    var body: some View {
        NavigationAvailable {
            ZStack {
                VStack {
                    ScrollView {
                        InputFormView(viewModel: viewModel) // Id, Pw 입력 폼

                        LoginOAuthButtonView()

                        AdditionalOptionView()
                        Spacer()
                    }
                }

                VStack {
                    Spacer()
                    Button(action: {}, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 14)
                                .frame(maxWidth: 115 * DynamicSizeFactor.factor(), maxHeight: 25 * DynamicSizeFactor.factor())
                                .platformTextColor(color: Color("Gray02"))

                            Text("로그인에 문제가 발생했나요?")
                                .platformTextColor(color: Color("Gray04"))
                                .font(.B3MediumFont())
                                .padding(.horizontal, 8 * DynamicSizeFactor.factor())
                        }
                        .padding(.bottom, 34)
                    })
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            NavigationLink(destination: MainTabView(), isActive: $viewModel.isLoginSuccessful) {}
        }
    }
}

#Preview {
    LoginFormView(viewModel: LoginFormViewModel(appViewModel: AppViewModel()))
}