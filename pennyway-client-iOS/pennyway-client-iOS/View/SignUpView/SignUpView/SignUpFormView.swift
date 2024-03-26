import SwiftUI

struct SignUpFormView: View {
    
    @StateObject private var viewModel = SignUpFormViewModel()
    
    var body: some View {
        ScrollView() {
            VStack(alignment: .leading){
                Text("회원가입")
                    .font(.pretendard(.semibold, size: 24))
                    .padding(.horizontal,20)
                
                Spacer().frame(height: 32)
                
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 21){
                        VStack(alignment:.leading, spacing: 9) {
                            CustomInputView(inputText: $viewModel.name, titleText: "이름", onCommit: {
                                viewModel.validateName()
                            })
                            
                            if viewModel.showErrorName{
                                Text("입력 포멧 관련 문구")
                                    .padding(.leading, 20)
                                    .font(.pretendard(.medium, size: 12))
                                    .platformTextColor(color: Color("Red03"))
                            }
                        }
                        
                        VStack(alignment:.leading, spacing: 9) {
                            CustomInputView(inputText: $viewModel.id, titleText: "아이디", onCommit: {
                                viewModel.validateID()
                            })
                            
                            if viewModel.showErrorID{
                                Text("입력 포멧 관련 문구")
                                    .padding(.leading, 20)
                                    .font(.pretendard(.medium, size: 12))
                                    .platformTextColor(color: Color("Red03"))
                            }
                        }
                        
                        VStack(alignment:.leading, spacing:9) {
                            CustomInputView(inputText: $viewModel.password, titleText: "비밀번호", onCommit: {
                                viewModel.validatePassword()
                            })
                            
                            if viewModel.showErrorPassword{
                                Text("입력 포멧 관련 문구")
                                    .padding(.leading, 20)
                                
                                    .font(.pretendard(.medium, size: 12))
                                    .platformTextColor(color: Color("Red03"))
                            }
                        }
                        
                        VStack(alignment:.leading, spacing:9) {
                            CustomInputView(inputText: $viewModel.confirmPw, titleText: "비밀번호 확인", onCommit: {
                                viewModel.validateConfirmPw()
                            })
                            
                            if viewModel.showErrorConfirmPw{
                                Text("입력 포멧 관련 문구")
                                    .padding(.leading, 20)
                                    .font(.pretendard(.medium, size: 12))
                                    .platformTextColor(color: Color("Red03"))
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SignUpFormView()
}