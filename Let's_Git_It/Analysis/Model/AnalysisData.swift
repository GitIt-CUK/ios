//
//  AnalysisData.swift
//  Let's_Git_It
//
//  Created by 김정원 on 10/26/23.
//
import SwiftUI
import Foundation
import Charts

struct Product: Identifiable {
    var id: Int
    var profit: Double
    var productCategory: String
}
let data: [Product] = [
    Product(id: 1, profit: 30, productCategory: "C++"),
    Product(id: 2, profit: 40, productCategory: "Swift"),
    Product(id: 3, profit: 15, productCategory: "Java"),
    Product(id: 4, profit: 10, productCategory: "Python"),
    Product(id: 5, profit: 5, productCategory: "Others"),
    // ... 추가적인 데이터를 넣을 수 있습니다.
]
