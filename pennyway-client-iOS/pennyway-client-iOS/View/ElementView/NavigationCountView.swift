

import SwiftUI

struct NavigationCountView: View {
    @Binding var selectedText: Int?

    var body: some View {
        HStack(spacing: 8 * DynamicSizeFactor.factor()) {
            LazyHGrid(rows: [GridItem(.flexible())]) {
                Text("1")
                    .padding(6)
                    .background(selectedText ?? 0 >= 1 ? Color("Gray06") : Color("Gray03"))
                    .platformTextColor(color: selectedText ?? 0 >= 1 ? Color("White01") : Color("Gray04"))
                    .clipShape(Circle())
                    .font(.B2MediumFont())

                Text("2")
                    .padding(6)
                    .background(selectedText ?? 0 >= 2 ? Color("Gray06") : Color("Gray03"))
                    .platformTextColor(color: selectedText ?? 0 >= 2 ? Color("White01") : Color("Gray04"))
                    .clipShape(Circle())
                    .font(.B2MediumFont())

                Text("3")
                    .padding(6)
                    .background(selectedText ?? 0 >= 3 ? Color("Gray06") : Color("Gray03"))
                    .platformTextColor(color: selectedText ?? 0 >= 3 ? Color("White01") : Color("Gray04"))
                    .clipShape(Circle())
                    .font(.B2MediumFont())
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(height: 18)
    }
}
