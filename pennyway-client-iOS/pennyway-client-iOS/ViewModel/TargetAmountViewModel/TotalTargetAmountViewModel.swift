

import SwiftUI

// MARK: - TotalTargetAmountViewModel

class TotalTargetAmountViewModel: ObservableObject {
    @Published var targetAmounts: [TargetAmount] = [] // 내림차순 데이터
    @Published var sortTargetAmounts: [TargetAmount] = [] // 오름차순 정렬
    @Published var currentData: TargetAmount = TargetAmount(year: 0, month: 0, targetAmountDetail: AmountDetail(id: -1, amount: -1, isRead: false), totalSpending: 0, diffAmount: 0) // 당월 데이터

    func getTotalTargetAmountApi(completion: @escaping (Bool) -> Void) {
        let getTotalTargetAmountRequestDto = GetTotalTargetAmountRequestDto(date: Date.getBasicformattedDate(from: Date()))

        TargetAmountAlamofire.shared.getTotalTargetAmount(getTotalTargetAmountRequestDto) { result in
            switch result {
            case let .success(data):
                if let responseData = data {
                    do {
                        let response = try JSONDecoder().decode(GetTotalTargetAmountResponseDto.self, from: responseData)

                        self.targetAmounts = response.data.targetAmounts
                        self.sortTargetAmounts = self.targetAmounts.sorted(by: { $0.month < $1.month })
                        if let firstTargetAmount = self.targetAmounts.first {
                            self.currentData = firstTargetAmount
                        }
                        if let jsonString = String(data: responseData, encoding: .utf8) {
                            Log.debug("목표 금액 및 총 사용 금액 리스트 조회 완료 \(jsonString)")
                        }

                        completion(true)
                    } catch {
                        Log.fault("Error decoding JSON: \(error)")
                        completion(false)
                    }
                }
            case let .failure(error):
                if let statusSpecificError = error as? StatusSpecificError {
                    Log.info("StatusSpecificError occurred: \(statusSpecificError)")
                } else {
                    Log.error("Network request failed: \(error)")
                }
                completion(false)
            }
        }
    }
}