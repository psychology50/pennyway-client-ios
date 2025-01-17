

import SwiftUI

class AddSpendingHistoryViewModel: ObservableObject {
    /// 카테고리 선택
    @Published var selectedCategory: SpendingCategoryData? = nil
    @Published var isCategoryListViewPresented: Bool = false

    /// 카테고리 생성
    @Published var selectedCategoryIconTitle: String = "OTHER"
    @Published var selectedCategoryIcon: CategoryIconName = CategoryIconName(baseName: .etc, state: .on)
    @Published var categoryName: String = ""

    @Published var navigateToAddCategory = false // 추가하기 버튼 누른 경우
    @Published var isSelectAddCategoryViewPresented: Bool = false

    /// 날짜 선택
    @Published var isSelectDayViewPresented: Bool = false
    @Published var selectedDate: Date = Date()
    @Published var clickDate: Date?

    /// 가격, 소비처, 메모 text
    @Published var amountSpentText: String = ""
    @Published var consumerText: String = ""
    @Published var memoText: String = ""

    /// 총 카테고리 리스트
    @Published var spendingCategories: [SpendingCategoryData] = []

    /// 시스템 카테고리 리스트
    @Published var systemCategories: [SpendingCategoryData] = []

    /// 사용자 정의 카테고리 리스트
    @Published var customCategories: [SpendingCategoryData] = []

    @Published var isFormValid = false // 지출내역 추가 valid

    init(selectedDate: Date = Date()) {
        self.selectedDate = selectedDate
    }

    func validateForm() {
        isFormValid = (selectedCategory != nil && !amountSpentText.isEmpty)
    }

    func getSpendingCustomCategoryListApi() {
        SpendingCategoryAlamofire.shared.getSpendingCustomCategoryList { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(getSpendingCustomCategoryListResponseDto.self, from: responseData)

                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("사용자 정의 카테고리 조회 완료 \(jsonString)")
                        }
                        self.systemCategories = SpendingCategoryIconList.allCases
                            .filter { $0 != .other && $0 != .plus }
                            .map { $0.details }

                        let otherCategory = SpendingCategoryIconList.plus.details
                        self.customCategories = response.data.spendingCategories.compactMap { self.convertToSpendingCategoryData(from: $0) }
                        self.spendingCategories = self.systemCategories + self.customCategories + [otherCategory]
                    } catch {
                        Log.fault("Error decoding JSON: \(error)")
                    }
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
            }
        }
    }

    func editSpendingHistoryApi(spendingId: Int, completion: @escaping (Bool) -> Void) {
        let amount = Int(amountSpentText.replacingOccurrences(of: ",", with: "")) ?? 0
        let spendAt = Date.getBasicformattedDate(from: clickDate ?? selectedDate)
        var categoryId = -1

        if selectedCategory?.isCustom == false { // isCustom false 인 경우 -> 정의된 카테고리
            if let icon = selectedCategory?.icon {
                let categoryIconName = CategoryIconName(baseName: icon.baseName, state: icon.state)
                if let category = SpendingCategoryIconList.fromIcon(categoryIconName) {
                    selectedCategoryIconTitle = category.rawValue
                    categoryId = -1
                }
            }
        } else { // 사용자 정의 카테고리
            selectedCategoryIconTitle = "CUSTOM"
            categoryId = selectedCategory?.id ?? 0
        }

        Log.debug(selectedCategory?.icon)

        let addSpendingHistoryRequestDto = AddSpendingHistoryRequestDto(amount: amount, categoryId: categoryId, icon: selectedCategoryIconTitle, spendAt: spendAt, accountName: consumerText, memo: memoText)

        SpendingAlamofire.shared.editSpendingHistory(spendingId: spendingId, addSpendingHistoryRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(AddSpendingHistoryResponseDto.self, from: responseData)

                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("지출 내역 수정 완료 \(jsonString)")
                        }
                        completion(true)
                    } catch {
                        Log.fault("Error decoding JSON: \(error)")
                        completion(false)
                    }
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                } else {
                    Log.error("Network request faile: \(error)")
                }
            }
        }
    }

    func convertToSpendingCategoryData(from spendingCategory: SpendingCategory) -> SpendingCategoryData? {
        guard let iconList = SpendingCategoryIconList(rawValue: spendingCategory.icon) else {
            return nil
        }
        return SpendingCategoryData(id: spendingCategory.id, isCustom: spendingCategory.isCustom, name: spendingCategory.name, icon: iconList.details.icon)
    }

    func addSpendingCustomCategoryApi(completion: @escaping (Bool) -> Void) {
        let addSpendingCustomCategoryRequestDto = AddSpendingCustomCategoryRequestDto(name: categoryName, icon: selectedCategoryIconTitle)

        SpendingCategoryAlamofire.shared.addSpendingCustomCategory(addSpendingCustomCategoryRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(AddSpendingCustomCategoryResponseDto.self, from: responseData)

                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("카테고리 생성 완료 \(jsonString)")
                        }

                        self.selectedCategory =
                            SpendingCategoryData(
                                id: response.data.spendingCategory.id,
                                isCustom: true,
                                name: self.categoryName,
                                icon: self.selectedCategoryIcon
                            )
                        completion(true)
                    } catch {
                        Log.fault("Error decoding JSON: \(error)")
                        completion(false)
                    }
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
                completion(false)
            }
        }
    }

    func addSpendingHistoryApi(completion: @escaping (Bool) -> Void) {
        let amount = Int(amountSpentText.replacingOccurrences(of: ",", with: "")) ?? 0
        let spendAt = Date.getBasicformattedDate(from: clickDate ?? selectedDate)

        Log.debug("clickDate: \(String(describing: clickDate)), selectedDate: \(selectedDate), spendAt: \(spendAt)")

        let categoryDetails = getCategoryDetails()
        selectedCategoryIconTitle = categoryDetails.categoryIconTitle
        let categoryId = categoryDetails.categoryId

        let addSpendingHistoryRequestDto = AddSpendingHistoryRequestDto(amount: amount, categoryId: categoryId, icon: selectedCategoryIconTitle, spendAt: spendAt, accountName: consumerText, memo: memoText)

        SpendingAlamofire.shared.addSpendingHistory(addSpendingHistoryRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        _ = try JSONDecoder().decode(AddSpendingHistoryResponseDto.self, from: responseData)

                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("지출내역 추가 완료 \(jsonString)")
                        }
                        completion(true)
                    } catch {
                        Log.fault("Error decoding JSON: \(error)")
                        completion(false)
                    }
                }
            case let .failure(error):
                if let StatusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(StatusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
                completion(false)
            }
        }
    }

    func getCategoryDetails() -> (categoryIconTitle: String, categoryId: Int) {
        var categoryIconTitle = ""
        var categoryId = -1

        if selectedCategory?.isCustom == false { // isCustom false 인 경우 -> 정의된 카테고리
            if let icon = selectedCategory?.icon {
                let categoryIconName = CategoryIconName(baseName: icon.baseName, state: icon.state)
                if let category = SpendingCategoryIconList.fromIcon(categoryIconName) {
                    categoryIconTitle = category.rawValue
                    categoryId = -1
                }
            }
        } else { // 사용자 정의 카테고리
            categoryIconTitle = "CUSTOM"
            categoryId = selectedCategory?.id ?? 0
        }

        return (categoryIconTitle, categoryId)
    }
}
