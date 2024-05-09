import SwiftUI

struct LoginView: View {
    // MARK: Private

    @EnvironmentObject var appViewModel: AppViewModel
    @State private var isSplashShown = true
    @State private var isActiveLink = false

    var body: some View {
        VStack {
            if isSplashShown {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                isSplashShown = false
                            }
                        }
                    }
            } else {
                LoginFormView(viewModel: LoginFormViewModel(appViewModel: appViewModel))
            }
        }
    }
}

#Preview {
    LoginView()
}