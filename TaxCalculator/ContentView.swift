struct ExchangeRateResponse: Codable {
let rates: Rates
}

struct Rates: Codable {
let THB: Double
}
//  ContentView.swift
//  TaxCalculator
//
//  Created by Inoda Naomi on 2025/11/28.
//

import SwiftUI


import SwiftUI

struct ContentView: View {

    @State private var inputText = ""
    @State private var result = 0.0
    @State private var exchangeRate = 0.24
    @State private var isYenToBaht = true

    var body: some View {

        VStack(spacing: 20) {

            Text("為替計算アプリ")
                .font(.title)

            Toggle(isOn: $isYenToBaht) {
                Text(isYenToBaht ? "円 → バーツ" : "バーツ → 円")
            }

            TextField("金額を入力", text: $inputText)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)

            Button("計算する") {
                if let value = Double(inputText) {
                    if isYenToBaht {
                        result = value * exchangeRate
                    } else {
                        result = value / exchangeRate
                    }
                }
            }

            Text("結果: \(result, specifier: "%.2f")")
                .font(.title2)

        }
        .padding()
    }
}

#Preview {
    ContentView()
}

