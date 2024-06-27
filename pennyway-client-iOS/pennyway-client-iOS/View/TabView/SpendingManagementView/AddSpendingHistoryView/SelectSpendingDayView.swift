import SwiftUI

struct SelectSpendingDayView: View {
    @Binding var isPresented: Bool
    @Binding var selectedDate: Date

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("날짜")
                    .font(.H3SemiboldFont())
                    .padding(.leading, 20)
                    .padding(.top, 28)
                Spacer()
            }

            Spacer().frame(height: 24 * DynamicSizeFactor.factor())

            DatePicker("", selection: $selectedDate, in: dateRange, displayedComponents: [.date])
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "ko_KR"))
                .frame(height: 114 * DynamicSizeFactor.factor())
                .clipped()

            Spacer()

            CustomBottomButton(action: {
                isPresented = false
            }, label: "확인", isFormValid: .constant(true))
                .padding(.bottom, 34 * DynamicSizeFactor.factor())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }

    private var dateRange: ClosedRange<Date> { // 2000년도부터 현재까지로 제한
        let calendar = Calendar.current
        let startDate = calendar.date(from: DateComponents(year: 2000, month: 1, day: 1))!
        let endDate = Date()
        return startDate ... endDate
    }
}