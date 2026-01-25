//
//  ContentView.swift
//  TaxCalculator
//
//  Created by Inoda Naomi on 2025/11/28.
//

import SwiftUI

struct ContentView: View {

    @State private var inputText = ""
    @State private var result = 0.0
    @State private var tax8 = 0.0
    @State private var tax10 = 0.0
    @State private var baht = 0.0

    var body: some View {
        VStack(spacing: 20) {

            TextField("ここに文字を入力", text: $inputText)
                .keyboardType(.decimalPad)

            Button("計算") {
                let value = Double(inputText) ?? 0

                result = value
                tax8 = result * 0.08
                tax10 = result * 0.10
                baht = result * 0.24
            }

            Text("価格：\(result)")
            Text("消費税8%：\(tax8)")
            Text("消費税10%：\(tax10)")
            Text("バーツ：\(baht)")
        }
        .padding()
    }
}
