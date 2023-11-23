import SwiftUI
import Charts

struct AnalysisView: View {
    @Environment(\.colorScheme) var colorScheme // 환경의 colorScheme을 가져옴
    
    var body: some View {
    
        VStack {
            HStack {
                Text("사용 언어 비율")
                   // .font(.title2)
                    .font(Font.custom("NanumSquareNeoOTF-Bd", size: 30))
            }
            HStack{
                Spacer()
                GeometryReader { geometry in
                    Chart(data) { // Get the Production values.
                        BarMark(
                            x: .value("Profit", $0.profit)
                        )
                        .foregroundStyle(by: .value("Product Category", $0.productCategory))
                    }
                    
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.13)
                    .preferredColorScheme(colorScheme) // 다크 모드 설정
                    .background(.brown)

                }
                Spacer()
                    
            }
            
        }
        .background(Color(hex: 0x1E1F24))

        
    }
}

struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView()
            //.preferredColorScheme(.white) // 미리보기에서 다크 모드로 설정
    }
}
extension Color {
    init(hex: UInt) {
        let red = Double((hex & 0xFF0000) >> 16) / 255.0
        let green = Double((hex & 0x00FF00) >> 8) / 255.0
        let blue = Double(hex & 0x0000FF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}
