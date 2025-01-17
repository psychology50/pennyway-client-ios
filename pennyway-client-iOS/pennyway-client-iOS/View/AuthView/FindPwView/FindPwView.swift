import SwiftUI

struct FindPwView: View {
    @StateObject var phoneVerificationViewModel = PhoneVerificationViewModel()
    @State private var showCodeErrorPopUp = false
    @State private var showManyRequestPopUp = false
    @State private var showDiffNumberPopUp = false
    @State private var isNavigateToFindPwView: Bool = false
    @StateObject var viewModel = SignUpNavigationViewModel()
    @State private var isVerificationError: Bool = false

    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    VStack {
                        FindPwContentView(phoneVerificationViewModel: phoneVerificationViewModel, showManyRequestPopUp: $showManyRequestPopUp)
                    }
                }
                Spacer()

                CustomBottomButton(action: {
                    if !phoneVerificationViewModel.requestedPhoneNumber.isEmpty, phoneVerificationViewModel.requestedPhoneNumber != phoneVerificationViewModel.phoneNumber {
                        showDiffNumberPopUp = true
                    } else {
                        continueButtonAction()
                    }
                }, label: "확인", isFormValid: $phoneVerificationViewModel.isFormValid)
                    .padding(.bottom, 34 * DynamicSizeFactor.factor())

                NavigationLink(destination: ResetPwView(formViewModel: SignUpFormViewModel(), firstNaviLinkActive: .constant(true), entryPoint: .findPw), isActive: $isNavigateToFindPwView) {
                    EmptyView()
                }.hidden()
            }

            if showCodeErrorPopUp == true {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                ErrorCodePopUpView(showingPopUp: $showCodeErrorPopUp, titleLabel: "잘못된 인증번호예요", subLabel: "다시 한번 확인해주세요")
            }
            if showManyRequestPopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                ErrorCodePopUpView(showingPopUp: $showManyRequestPopUp, titleLabel: "인증 요청 제한 횟수를 초과했어요", subLabel: "24시간 후에 다시 시도해주세요")
            }
            if phoneVerificationViewModel.showErrorExistingUser {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                ErrorCodePopUpView(showingPopUp: $phoneVerificationViewModel.showErrorExistingUser, titleLabel: "사용자 정보를 찾을 수 없어요", subLabel: "다시 한번 확인해주세요")
            }

            if showDiffNumberPopUp {
                Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                CustomPopUpView(showingPopUp: $showDiffNumberPopUp,
                                titleLabel: "인증 요청 번호와\n현재 입력된 번호가 달라요",
                                subTitleLabel: "기존 번호(\(phoneVerificationViewModel.requestedPhoneNumber))로 인증할까요?",
                                firstBtnAction: { self.showDiffNumberPopUp = false },
                                firstBtnLabel: "취소",
                                secondBtnAction: {
                                    self.showDiffNumberPopUp = false
                                    phoneVerificationViewModel.phoneNumber = phoneVerificationViewModel.requestedPhoneNumber
                                    continueButtonAction()
                                },
                                secondBtnLabel: "인증할게요",
                                secondBtnColor: Color("Gray05"),
                                heightSize: 166)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle(Text("비밀번호 찾기"))
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
        .analyzeEvent(AuthCheckEvents.findPasswordView)
    }

    private func continueButtonAction() {
        phoneVerificationViewModel.requestPwVerifyVerificationCodeApi {
            checkFormValid()
        }
    }

    private func checkFormValid() {
        if !phoneVerificationViewModel.showErrorVerificationCode && !phoneVerificationViewModel.showErrorExistingUser && phoneVerificationViewModel.isFormValid {
            Log.debug("비밀번호 찾기 checkFormValid if문 시작")
            showCodeErrorPopUp = false
            isNavigateToFindPwView = true
            viewModel.continueButtonTapped()

            RegistrationManager.shared.code = phoneVerificationViewModel.code

        } else {
            if phoneVerificationViewModel.showErrorVerificationCode {
                showCodeErrorPopUp = true
                isVerificationError = true
                Log.debug("인증번호 오류: \(showCodeErrorPopUp)")
            }
        }
    }
}

#Preview {
    FindPwView()
}
