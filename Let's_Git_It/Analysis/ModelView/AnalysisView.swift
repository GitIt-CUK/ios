import SwiftUI
import Charts

//struct AnalysisView: View {
//    var body: some View {
//        VStack {
//            Text("사용 언어 비율")
//                .font(Font.custom("NanumSquareNeoOTF-Bd", size: 30))
//
//            Chart {
//                ForEach(LanguageData.example, id: \.language) { data in
//                    PieMark(
//                        center: .center,
//                        startAngle: .degrees(0),
//                        endAngle: .degrees(data.percentage * 360 / 100)
//                    )
//                    .foregroundStyle(by: .value("Language", data.language))
//                }
//            }
//            .frame(height: 300)
//        }
//        .background(Color(hex: 0x1E1F24))
//    }
//}
//
//struct LanguageData {
//    let language: String
//    let percentage: Double
//
//    static let example = [
//        LanguageData(language: "C", percentage: 40),
//        LanguageData(language: "Java", percentage: 20),
//        LanguageData(language: "Swift", percentage: 10),
//        LanguageData(language: "Python", percentage: 30)
//    ]
//}
//
//
//struct BarChart_Previews: PreviewProvider {
//    static var previews: some View {
//        AnalysisView()
//            //.preferredColorScheme(.white) // 미리보기에서 다크 모드로 설정
//    }
//}
//extension Color {
//    init(hex: UInt) {
//        let red = Double((hex & 0xFF0000) >> 16) / 255.0
//        let green = Double((hex & 0x00FF00) >> 8) / 255.0
//        let blue = Double(hex & 0x0000FF) / 255.0
//        self.init(red: red, green: green, blue: blue)
//    }
//}

import SwiftUI

struct AnalysisView: View {
    let data = LanguageData.example
    let colors = [Color.red, Color.green, Color.blue, Color.yellow]

    var body: some View {
        ZStack {
            // 전체 배경색 설정
            Color(hex: 0x1E1F24)
                .edgesIgnoringSafeArea(.all)

            VStack {
                // 타이틀 텍스트 추가
                Text("사용 언어 분석")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top, -100) // 상단에 패딩 추가

                PieChartView(data: data, colors: colors)
                    .frame(height: 300)
                    .padding() // 차트 주변에 패딩 추가

                // 각 언어와 퍼센테이지를 표시하는 뷰에 패딩 추가
                HStack {
                    ForEach(0..<data.count, id: \.self) { index in
                        HStack {
                            Rectangle()
                                .fill(colors[index])
                                .frame(width: 20, height: 20)
                            Text("\(data[index].language) \(Int(data[index].percentage))%")
                                .foregroundColor(.white)
                        }
                    }
                } // 하단에 패딩 추가
            }
        }
    }
}


struct LegendView: View {
    var data: [LanguageData]
    var colors: [Color]

    var body: some View {
        HStack {
            ForEach(0..<data.count, id: \.self) { index in
                HStack {
                    Rectangle()
                        .fill(colors[index % colors.count])
                        .frame(width: 20, height: 20)
                    Text(data[index].language)
                        .foregroundColor(.primary)
                }
            }
            .background(Color(hex: 0x1E1F24))
        }
    }
}
struct LanguageData {
    let language: String
    let percentage: Double

    static let example = [
        LanguageData(language: "C", percentage: 10),
        LanguageData(language: "Java", percentage: 10),
        LanguageData(language: "Swift", percentage: 70),
        LanguageData(language: "Python", percentage: 10)
    ]
}

struct PieChartView: View {
    var data: [LanguageData]
    var colors: [Color]

    var body: some View {
        GeometryReader { geometry in
            self.makePie(geometry: geometry)
        }
    }

    func makePie(geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let height = geometry.size.height
        let radius = min(width, height) / 2
        let center = CGPoint(x: width / 2, y: height / 2)

        var startAngle = -90.0
        var endAngle = 0.0

        return ZStack {
            ForEach(0..<data.count, id: \.self) { index in
                Path { path in
                    path.move(to: center)
                    endAngle = startAngle + (360 * data[index].percentage / 100)
                    
                    path.addArc(center: center, radius: radius, startAngle: Angle(degrees: startAngle), endAngle: Angle(degrees: endAngle), clockwise: false)
                    startAngle = endAngle
                }
                .fill(self.colors[index % self.colors.count])
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView()
        
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
