
import SwiftUI

// MARK: - SelectCategoryIconView

struct SelectCategoryIconView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: AddSpendingHistoryViewModel
    @ObservedObject var spendingCategoryViewModel: SpendingCategoryViewModel
    @State var selectedCategoryIcon: CategoryIconName = CategoryIconName(baseName: .etc, state: .on)
    let entryPoint: CustomCategoryEntryPoint

    let columns = [
        GridItem(.flexible(), spacing: 32),
        GridItem(.flexible(), spacing: 32),
        GridItem(.flexible(), spacing: 32),
        GridItem(.flexible(), spacing: 32)
    ]

    let icons: [CategoryIconListItem] = [
        CategoryIconListItem(offIcon: CategoryIconName(baseName: CategoryBaseName.food, state: .off), onIcon: CategoryIconName(baseName: CategoryBaseName.food, state: .onMint)),
        CategoryIconListItem(offIcon: CategoryIconName(baseName: CategoryBaseName.traffic, state: .off), onIcon: CategoryIconName(baseName: CategoryBaseName.traffic, state: .onMint)),
        CategoryIconListItem(offIcon: CategoryIconName(baseName: CategoryBaseName.beauty, state: .off), onIcon: CategoryIconName(baseName: CategoryBaseName.beauty, state: .onMint)),
        CategoryIconListItem(offIcon: CategoryIconName(baseName: CategoryBaseName.market, state: .off), onIcon: CategoryIconName(baseName: CategoryBaseName.market, state: .onMint)),
        CategoryIconListItem(offIcon: CategoryIconName(baseName: CategoryBaseName.education, state: .off), onIcon: CategoryIconName(baseName: CategoryBaseName.education, state: .onMint)),
        CategoryIconListItem(offIcon: CategoryIconName(baseName: CategoryBaseName.life, state: .off), onIcon: CategoryIconName(baseName: CategoryBaseName.life, state: .onMint)),
        CategoryIconListItem(offIcon: CategoryIconName(baseName: CategoryBaseName.health, state: .off), onIcon: CategoryIconName(baseName: CategoryBaseName.health, state: .onMint)),
        CategoryIconListItem(offIcon: CategoryIconName(baseName: CategoryBaseName.hobby, state: .off), onIcon: CategoryIconName(baseName: CategoryBaseName.hobby, state: .onMint)),
        CategoryIconListItem(offIcon: CategoryIconName(baseName: CategoryBaseName.travel, state: .off), onIcon: CategoryIconName(baseName: CategoryBaseName.travel, state: .onMint)),
        CategoryIconListItem(offIcon: CategoryIconName(baseName: CategoryBaseName.drink, state: .off), onIcon: CategoryIconName(baseName: CategoryBaseName.drink, state: .onMint)),
        CategoryIconListItem(offIcon: CategoryIconName(baseName: CategoryBaseName.event, state: .off), onIcon: CategoryIconName(baseName: CategoryBaseName.event, state: .onMint)),
        CategoryIconListItem(offIcon: CategoryIconName(baseName: CategoryBaseName.etc, state: .off), onIcon: CategoryIconName(baseName: CategoryBaseName.etc, state: .onMint))
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("아이콘 선택")
                    .font(.H3SemiboldFont())
                    .padding(.leading, 20)
                    .padding(.top, 28)
                Spacer()
            }

            Spacer().frame(height: 24 * DynamicSizeFactor.factor())

            LazyVGrid(columns: columns, spacing: 20 * DynamicSizeFactor.factor()) {
                ForEach(icons) { icon in
                    Image((selectedCategoryIcon.rawValue == icon.onIcon.rawValue ? icon.onIcon : icon.offIcon).rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40 * DynamicSizeFactor.factor(), height: 40 * DynamicSizeFactor.factor())
                        .onTapGesture {
                            selectedCategoryIcon = icon.onIcon
                        }
                }
            }
            .padding(.horizontal, 32)

            Spacer()

            CustomBottomButton(action: {
                if let selectedCategory = SpendingCategoryIconList.fromIcon(selectedCategoryIcon) {
                    if entryPoint == .create {
                        viewModel.selectedCategoryIconTitle = selectedCategory.rawValue
                        viewModel.selectedCategoryIcon = MapCategoryIconUtil.mapToCategoryIcon(selectedCategoryIcon, outputState: .on) // onMint -> on
                    } else { // 수정인 경우
                        spendingCategoryViewModel.selectedCategoryIconTitle = selectedCategory.rawValue
                        spendingCategoryViewModel.selectedCategoryIcon = MapCategoryIconUtil.mapToCategoryIcon(selectedCategoryIcon, outputState: .on) // onMint -> on
                    }
                    isPresented = false
                    Log.debug(selectedCategory.rawValue)
                }
            }, label: "확인", isFormValid: .constant(true))
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            // onMint 아이콘으로 매칭
            if let icon = (entryPoint == .create ? viewModel.selectedCategoryIcon : spendingCategoryViewModel.selectedCategory?.icon) {
                selectedCategoryIcon = MapCategoryIconUtil.mapToCategoryIcon(icon, outputState: .onMint) // on -> onMint
            }
        }
    }
}
