

import SwiftUI

struct CustomInputView: View {
    @Binding var inputText: String
    @State var titleText: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 13) {
        
            Text(titleText!)
                .padding(.horizontal, 20)
                .font(.pretendard(.regular, size: 12))
                .platformTextColor(color: Color("Gray04"))
            
            HStack(spacing: 11) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("Gray01"))
                        .frame(height: 46)
                    
                    TextField("", text: $inputText)
                        .padding(.leading, 13)
                        .font(.pretendard(.medium, size: 14))
                        
                }
            }
            .padding(.horizontal, 20)
        }
    }
}