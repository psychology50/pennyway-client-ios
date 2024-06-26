import SwiftUI

// MARK: - EditSpendingDetailView

struct EditSpendingDetailView: View {
    @State var isActive: Bool = false
    @Binding var showEditSpendingDetailView: Bool

    @State var spendingDetails: [SpendingDetail] = [
        SpendingDetail(category: "편의점/마트", description: "", amount: "1,000원", icon: "icon_category_market_on"),
        SpendingDetail(category: "교육", description: "스터디용 메모장", amount: "6,000원", icon: "icon_category_education_on"),
        SpendingDetail(category: "교통", description: "", amount: "3,000원", icon: "icon_category_traffic_on"),
        SpendingDetail(category: "편의점/마트", description: "", amount: "1,000원", icon: "icon_category_market_on"),
        SpendingDetail(category: "교육", description: "스터디용 메모장", amount: "6,000원", icon: "icon_category_education_on"),
        SpendingDetail(category: "교통", description: "", amount: "3,000원", icon: "icon_category_traffic_on"),
        SpendingDetail(category: "교통", description: "", amount: "1,000원", icon: "icon_category_traffic_on"),
        SpendingDetail(category: "교통", description: "", amount: "10,000원", icon: "icon_category_traffic_on"),
        SpendingDetail(category: "교통", description: "", amount: "3,000원", icon: "icon_category_traffic_on")
    ]

    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 40, height: 4)
                    .platformTextColor(color: Color("Gray03"))
                    .padding(.top, 12)

                HStack(spacing: 0) {
                    Button(action: {
                        showEditSpendingDetailView = false
                    }, label: {
                        Image("icon_arrow_back")
                            .scaledToFill()
                            .frame(width: 7 * DynamicSizeFactor.factor(), height: 14 * DynamicSizeFactor.factor())
                            .padding(.vertical, 15)
                            .padding(.horizontal, 18.5)
                    })

                    Spacer()

                    Button(action: {}, label: {
                        Image("icon_chat_delete_line")
                            .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                            .padding(10)
                    })

                    Button(action: {}, label: {
                        Image("icon_navigation_add_black")
                            .scaledToFill()
                            .frame(width: 28 * DynamicSizeFactor.factor(), height: 28 * DynamicSizeFactor.factor())
                            .padding(8)
                    })
                }

                ScrollView {
                    Spacer().frame(height: 7 * DynamicSizeFactor.factor())

                    HStack(spacing: 4 * DynamicSizeFactor.factor()) {
                        Button(action: {
                            toggleAllSelections()
                        }, label: {
                            Image(spendingDetails.allSatisfy { $0.isSelected } ? "icon_checkone_on_small" : "icon_checkone_off_small")
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                        })

                        Text("전체 선택")
                            .font(.B2MediumFont())
                            .platformTextColor(color: Color("Gray05"))
                            .padding(.vertical, 4)
                            .padding(.trailing, 8)

                        Spacer()
                    }
                    .padding(.leading, 14)
                    // EditNoHistorySpendingView() -> 달의 소비내역이 없으면

                    Spacer().frame(height: 20 * DynamicSizeFactor.factor())

                    VStack(spacing: 0) {
                        ForEach(spendingDetails.indices, id: \.self) { index in
                            HStack(spacing: 0) {
                                Button(action: {
                                    spendingDetails[index].isSelected.toggle()
                                }) {
                                    Image(spendingDetails[index].isSelected ? "icon_checkone_on_small" : "icon_checkone_off_small")
                                        .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                                        .aspectRatio(contentMode: .fill)
                                }

                                Image(spendingDetails[index].icon)
                                    .frame(width: 40 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())
                                    .aspectRatio(contentMode: .fill)
                                    .padding(.leading, 4 * DynamicSizeFactor.factor())

                                VStack(alignment: .leading, spacing: 1 * DynamicSizeFactor.factor()) {
                                    Text(spendingDetails[index].category)
                                        .font(.B1SemiboldeFont())
                                        .platformTextColor(color: Color("Gray06"))

                                    if !spendingDetails[index].description.isEmpty {
                                        Text(spendingDetails[index].description)
                                            .font(.B3MediumFont())
                                            .platformTextColor(color: Color("Gray04"))
                                    }
                                }
                                .padding(.leading, 10 * DynamicSizeFactor.factor())

                                Spacer()

                                Text(spendingDetails[index].amount)
                                    .font(.B1SemiboldeFont())
                                    .platformTextColor(color: Color("Gray06"))
                            }
                            .padding(.leading, 14)
                            .padding(.trailing, 20)

                            Spacer().frame(height: 12) // 동적 ui 적용하니 너무 커짐
                        }
                    }
                    .padding(.bottom, 103)
                }

                Spacer() // 바텀시트 높이에 따라 조건문으로 spacer()처리해야 함.
            }
            CustomBottomButton(action: { isActive = true }, label: "완료", isFormValid: .constant(true))
                .offset(y: 217 * DynamicSizeFactor.factor())
                .zIndex(1)
        }
        .setTabBarVisibility(isHidden: true)
        .padding(.leading, 3)
        .padding(.trailing, 5)
    }

    private func toggleAllSelections() {
        let allSelected = spendingDetails.allSatisfy { $0.isSelected }
        spendingDetails.indices.forEach { spendingDetails[$0].isSelected = !allSelected }
    }
}

#Preview {
    EditSpendingDetailView(showEditSpendingDetailView: .constant(true))
}
