//
//  ContentView.swift
//  ColorViewApp
//
//  Created by Роман Бакаев on 02.06.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var redSliderValue = Double.random(in: 0..<1)
    @State private var greenSliderValue = Double.random(in: 0..<1)
    @State private var blueSliderValue = Double.random(in: 0..<1)
    
    var body: some View {
        ZStack {
            Color(.init(red: redSliderValue, green: greenSliderValue, blue: blueSliderValue, alpha: 0.3))
                .ignoresSafeArea()
            VStack {
                Color(red: redSliderValue, green: greenSliderValue, blue: blueSliderValue)
                    .frame(width: 350, height: 250)
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white, lineWidth: 4))
                VStack {
                    
                    SliderView(value: $redSliderValue, color: .red)
                    SliderView(value: $greenSliderValue, color: .green)
                    SliderView(value: $blueSliderValue, color: .blue)
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct SliderView: View {
    @Binding var value:Double
    var color: Color
    @FocusState private var colorValue: Bool
    @State private var alertPresented = false
    var body: some View {
        HStack {
            Text("\(lround(value * 255))")
            Slider(value: $value,in: 0...1, step: 0.001)
                .tint(color)
            TextField("Enter value", text : Binding<String>(get:{return "\(lround(value * 255))"}, set:{self.value = (Double($0) ?? 0) / 255}))
                .focused($colorValue)
                .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) { self.colorValue = true} }
            
                .frame(width: 45,height: 25)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        
                        Spacer()
                        
                        Button("Done") {
                            checkTextField()
                            colorValue = false
                        }
                        .foregroundColor(color)
                    }
                }
        }
        .alert("Error", isPresented:$alertPresented, actions: {}){
            Text ("Please enter number from 0 to 255")
        }
    }
    
    private func checkTextField() {
        if (value * 255 > 255) {
            alertPresented.toggle()
            value = 0
            
        } else {
            return
        }
    }
}
