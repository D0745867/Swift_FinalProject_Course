//
//  ContentView.swift
//  FinalProject
//
//  Created by 丁泓哲 on 2021/5/2.
//

import SwiftUI

extension Color {
    static let cloloABC = Color(hex: "#FFFFFF", alpha: 0.5)

    init(hex: String, alpha: CGFloat = 1.0) {
        var hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if hex.hasPrefix("#") {
            hex = String(hex.dropFirst())
        }
        assert(hex.count == 3 || hex.count == 6 || hex.count == 8, "Invalid hex code used. hex count is #(3, 6, 8).")
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (r, g, b) = (int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(alpha)
        )
    }
}

struct ImageOverlay: View {
    var body: some View {
        ZStack {
            Text("早安！同學")
                .font(.largeTitle)
                .padding(23.0)
                .foregroundColor(.white)
        }
        .opacity(0.8)
        .cornerRadius(10.0)
        .padding(6)
    }
}

struct Title: View {
    var title: String
    init(_ name: String) {
        self.title = name
    }
    var body: some View{
        Text(title)
            .font(.system(size: 20))
            .fontWeight(.semibold)
            .foregroundColor(Color.init(hex: "#4a5f30", alpha: 1.0))
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 14.0)
            .padding(.leading, 20.0)
    }
}

struct HomePage: View {
    var body: some View {
        VStack{
            Image("homePage")
                .resizable()
                .scaledToFit()
                .overlay(ImageOverlay(),alignment: .bottomLeading)
            Title("校園公告")
            Spacer().frame(height:42)
            ScrollView (.horizontal, showsIndicators: false) {
                 HStack {
                    ForEach(0 ..< 6) {
                        card in CardView()
                    }
                 }
            }.frame(height: 100)
            .padding(.leading, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            Title("討論版動態").padding(EdgeInsets(top: 70, leading: 0, bottom: 20, trailing:0 ))
            Forumm()
            Spacer()
        }.ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomePage()
            HomePage()
            HomePage()
        }
    }
}
