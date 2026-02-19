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
struct ExchangeResponse: Codable {
    let rates: [String: Double]
}
struct ContentView: View {
    
    @State private var inputText = ""
    @State private var result = 0.0
    @State private var exchangeRate = 0.24
    @State private var isYenToBaht = true
    @State private var taxIncluded = 0.0
    @State private var timeResult = ""
    @State private var secondInput = ""
    @State private var isLoading = false
    @State private var errorMessage = ""
    func fetchExchangeRate() {
        isLoading = true //
        errorMessage = ""
        
        guard let url = URL(string: "https://api.exchangerate-api.com/v4/latest/JPY") else {
            errorMessage = "URLが無効です"
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            DispatchQueue.main.async {
                isLoading = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = "通信エラー: \(error.localizedDescription)"
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "データが取得できませんでした"
                }
                return
            }
            
            if let decoded = try? JSONDecoder().decode(ExchangeResponse.self, from: data),
               let thbRate = decoded.rates["THB"] {
                
                DispatchQueue.main.async {
                    exchangeRate = thbRate
                }
                
            } else {
                DispatchQueue.main.async {
                    errorMessage = "データ解析に失敗しました"
                }
            }
            
        }.resume()
    }
    var body: some View {
        
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Tax Calculator")
            }
            
            ProgressView("読み込み中...")
        }
        if !errorMessage.isEmpty {
            Text(errorMessage)
                .foregroundColor(.red)
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()
        }
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
                Button("計算する") {
                    // 既存処理
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                
            }
            
        }
        Button("最新レート取得") {
            fetchExchangeRate()
        }
        TextField("2つ目の数字", text: $secondInput)
            .keyboardType(.decimalPad)
            .textFieldStyle(.roundedBorder)
            .onAppear {
                fetchExchangeRate()
                
            }
        
        HStack {
            Button("+") {
                if let v1 = Double(inputText), let v2 = Double(secondInput) {
                    result = v1 + v2
                }
            }
            
            Button("−") {
                if let v1 = Double(inputText), let v2 = Double(secondInput) {
                    result = v1 - v2
                }
            }
            
            Button("×") {
                if let v1 = Double(inputText), let v2 = Double(secondInput) {
                    result = v1 * v2
                }
            }
            
            Button("÷") {
                if let v1 = Double(inputText), let v2 = Double(secondInput), v2 != 0 {
                    result = v1 / v2
                }
            }
        }
        
        Text("結果: \(result, specifier: "%.2f")")
            .font(.title2)
    }
                    .padding()
                    .onAppear {
                        fetchExchangeRate()
                    
            }
        }
        #Preview {
            ContentView()
        }
    
