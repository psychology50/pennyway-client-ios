
import SwiftUI

struct EditUsernameView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var formViewModel = EditViewModel()

    private let maxLength = 8

    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                Spacer().frame(height: 35 * DynamicSizeFactor.factor())

                CustomInputView(inputText: $formViewModel.name, titleText: "이름 입력", placeholder: "최대 8자로 입력해주세요", onCommit: {
                    formViewModel.validateName()
                }, isSecureText: false, isCustom: false, showDeleteButton: true, deleteAction: {
                    formViewModel.name = ""
                })
                .onChange(of: formViewModel.name) { newValue in
                    if newValue.count > maxLength {
                        formViewModel.name = String(newValue.prefix(maxLength))
                    }
                    formViewModel.validateName()
                }

                Spacer().frame(height: 12 * DynamicSizeFactor.factor())

                HStack {
                    if let userData = getUserData() {
                        Text("현재 이름 : \(userData.name)")
                            .font(.B1MediumFont())
                            .platformTextColor(color: Color("Gray05"))
                    }

                    Spacer()

                    HStack(spacing: 0) {
                        Text("\(formViewModel.name.count)")
                            .platformTextColor(color: formViewModel.name.isEmpty ? Color("Gray03") : Color("Gray05"))
                        Text("/\(maxLength)")
                            .platformTextColor(color: Color("Gray03"))
                    }
                    .font(.B1MediumFont())
                }
                .padding(.horizontal, 20)

                Spacer()

                CustomBottomButton(action: {
                    if formViewModel.isFormValid {
                        formViewModel.editUsernameApi { success in
                            if success {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                }, label: "완료", isFormValid: $formViewModel.isFormValid)
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .setTabBarVisibility(isHidden: true)
        .navigationBarColor(UIColor(named: "White01"), title: "이름 수정하기")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
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

#Preview {
    EditUsernameView()
}
