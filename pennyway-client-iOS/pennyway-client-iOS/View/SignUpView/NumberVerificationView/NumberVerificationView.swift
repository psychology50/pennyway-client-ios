import SwiftUI

struct NumberVerificationView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var phoneNumber: String = ""
    @State private var verificationCode: String = ""
    @State private var showingPopUp = false
    @State var showErrorVerificationCode = true
    @StateObject var viewModel = SignUpNavigationViewModel()
    
    var body: some View {
        NavigationAvailable {
            ZStack{
                VStack{
                    Spacer().frame(height: 15)
                    
                    NavigationCountView(selectedText: $viewModel.selectedText)
                        .onAppear {
                            viewModel.selectedText = 1
                        }
                    
                    Spacer().frame(height: 14)
                    
                    NumberVerificationContentView(showErrorVerificationCode: $showErrorVerificationCode)
                    
                    Spacer()
                    
                    CustomBottomButton(action: {
                        if !showErrorVerificationCode {
                            showingPopUp = false
                            viewModel.continueButtonTapped()
                        } else {
                            showingPopUp = true
                        }
                    }, label: "계속하기")
                    .padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! + 34)
                    
                    NavigationLink(destination: SignUpView(viewModel: viewModel), tag: 2, selection: $viewModel.selectedText) {
                        EmptyView()
                    }
                }
                
                if showingPopUp {
                    Color.black.opacity(0.1).edgesIgnoringSafeArea(.all)
                    ErrorCodePopUpView(showingPopUp: $showingPopUp)
                }
                    
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        NavigationBackButton()
                            .padding(.leading, 5)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                        
                    }.offset(x: -10)
                }
            }
        }
    }
}

#Preview {
    NumberVerificationView()
}