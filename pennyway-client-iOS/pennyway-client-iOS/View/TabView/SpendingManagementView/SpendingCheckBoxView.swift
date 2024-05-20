
import SwiftUI

struct SpendingCheckBoxView: View {
    /// 총 지출량
    var totalSpent: Int = 500_000
    
    /// 프로그래스 바에 사용될 최대 값
    let targetValue: CGFloat = 500_000
    
    /// 프로그래스 바의 현재 값 (0부터 maxValue까지)
    var progressValue: CGFloat {
        return CGFloat(totalSpent) / targetValue * 100
    }
    
    let baseAttribute: BaseAttribute
    let stringAttribute: StringAttribute
    var formattedTotalSpent: String
    
    var myString: String {
        return "반가워요 붕어빵님! \n이번 달에 총 \(formattedTotalSpent)원 썼어요"
    }
    
    init(totalSpent: Int) {
        self.totalSpent = totalSpent
        baseAttribute = BaseAttribute(font: .H3SemiboldFont(), color: Color("Gray07"))
        formattedTotalSpent = NumberFormatterUtil.formatNumber(totalSpent)
        stringAttribute = StringAttribute(text: "\(formattedTotalSpent)원", font: .H3SemiboldFont(), color: CGFloat(totalSpent) > targetValue ? Color("Red03") : Color("Mint03"))
    }
    
    var body: some View {
        VStack {
            Spacer().frame(height: 18 * DynamicSizeFactor.factor())
            
            HStack {
                myString.toAttributesText(base: baseAttribute, stringAttribute)
                Spacer()
            }
            .frame(height: 44 * DynamicSizeFactor.factor())
            .padding(.leading, 18 * DynamicSizeFactor.factor())

            Spacer().frame(height: 20 * DynamicSizeFactor.factor())

            // 프로그래스 바
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: 244 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                    .platformTextColor(color: Color("Gray01"))
                    
                Rectangle()
                    .frame(width: CGFloat(totalSpent) > targetValue ? 244 * DynamicSizeFactor.factor() : min(progressValue / 100 * 300, 300), height: 24 * DynamicSizeFactor.factor()) // 현재 지출에 따른 프로그래스 바
                    .platformTextColor(color: CGFloat(totalSpent) > targetValue ? Color("Red03") : Color("Mint03"))
            }
            .cornerRadius(15)
            .padding(.horizontal, 18 * DynamicSizeFactor.factor())
            
            Spacer().frame(height: 6 * DynamicSizeFactor.factor())
            
            HStack {
                Text("\(totalSpent)")
                    .font(.B1SemiboldeFont())
                    .platformTextColor(color: CGFloat(totalSpent) > targetValue ? Color("Red03") : Color("Mint03"))
                    .padding(.leading, 4 * DynamicSizeFactor.factor())
                Spacer()
                
                HStack(spacing: 0) {
                    Text("\(Int(targetValue))")
                        .font(.B1SemiboldeFont())
                        .platformTextColor(color: Color("Gray07"))
                    
                    Button(action: {}, label: {
                        Image("icon_arrow_front_small")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
                    })
                }
            }
            .frame(width: 244 * DynamicSizeFactor.factor(), height: 24 * DynamicSizeFactor.factor())
            
            Spacer().frame(height: 16)
        }
        .frame(maxWidth: .infinity, maxHeight: 144 * DynamicSizeFactor.factor())
        .background(Color("White01"))
        .cornerRadius(8)
    }
}