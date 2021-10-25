//
//  FavoriteView.swift
//  FinalProject
//
//  Created by 丁泓哲 on 2021/6/22.
//

import SwiftUI

struct FavoriteData : View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var articles = [CreateUserResponse]()
    //fetch data

    struct Result: Decodable {
        var result: [CreateUserResponse]
    }
    
    struct CreateUserResponse: Decodable, Hashable {
        let courseID: Int
        let year: Int
        let department: String
        let teacher: String
        let subject: String
    }
    private var token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXlsb2FkIjp7Im5pZCI6IkQwNzQ1ODY3IiwibmFtZSI6IuS4geazk-WTsiIsImRlcHQiOiLos4foqIrlt6XnqIvlrbjns7sifSwiZXhwIjoxNjI0MzkyMDMxLCJpYXQiOjE2MjQzMDU2MzF9.VGJMM-F1ExmXWNR1dyEmqZM8Ka2SWqKbExI_NHxrfGE"
    private let url = "http://gf.ericlion.tw:6060/api/userLike/course"
     func fectchData() {
        guard let url = URL(string: url) else {
            print("URL is not Valid")
            return
        }
        var request = URLRequest(url: url)
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let data = data {
                if let decodedResult = try?
                    JSONDecoder().decode(Result.self, from: data) {
                    DispatchQueue.main.async {
                        self.articles = decodedResult.result
                        print(self.articles)
                    }
                    return
                }
            }
            print("Error: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }

    var body: some View {

            VStack {
                if(articles.isEmpty) {
                    Spacer().frame(height:100)
                    Text("沒有符合的搜尋結果...").padding()
                    Button(action: {self.presentationMode.wrappedValue.dismiss()}, label: {
                        Text("點擊返回")
                    })
                } else{
                    List(articles, id: \.courseID) {
                        item in
                        VStack(alignment:.leading) {
                            NavigationLink(
                                destination: CourseView(courseIndex: item.courseID),
                                label: {
                                    VStack(alignment:.leading){
                                        HStack{
                                            Text(item.subject).fontWeight(.semibold).font(.system(size: 16.0))
                                            Spacer()
                                            Text("\(item.year)" + "學年").fontWeight(.regular).font(.system(size: 13.0))
                                        }
                                        Text("\(item.department) - \(item.teacher)").fontWeight(.regular).font(.system(size: 13.0)).opacity(0.45)
                                    }
                                }).navigationTitle("") //To fix disappear back button
                        }
                    }.listStyle(GroupedListStyle()).navigationBarHidden(true)
                }
            }.onAppear(perform: {
                fectchData()
        })
        }
}

struct FavoritePost : View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var articles = [CreateUserResponse]()
    //fetch data

    struct Result: Decodable {
        var result: [CreateUserResponse]
    }
    
    struct CreateUserResponse: Decodable, Hashable {
        let courseID: Int
        let year: Int
        let department: String
        let teacher: String
        let subject: String
    }
    private var token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXlsb2FkIjp7Im5pZCI6IkQwNzQ1ODY3IiwibmFtZSI6IuS4geazk-WTsiIsImRlcHQiOiLos4foqIrlt6XnqIvlrbjns7sifSwiZXhwIjoxNjI0MzkyMDMxLCJpYXQiOjE2MjQzMDU2MzF9.VGJMM-F1ExmXWNR1dyEmqZM8Ka2SWqKbExI_NHxrfGE"
    private let url = "http://gf.ericlion.tw:6060/api/userLike/course"
     func fectchData() {
        guard let url = URL(string: url) else {
            print("URL is not Valid")
            return
        }
        var request = URLRequest(url: url)
        request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let data = data {
                if let decodedResult = try?
                    JSONDecoder().decode(Result.self, from: data) {
                    DispatchQueue.main.async {
                        self.articles = decodedResult.result
                        print(self.articles)
                    }
                    return
                }
            }
            print("Error: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }

    var body: some View {

            VStack {
                if(articles.isEmpty) {
                    Spacer().frame(height:100)
                    Text("沒有符合的搜尋結果...").padding()
                    Button(action: {self.presentationMode.wrappedValue.dismiss()}, label: {
                        Text("點擊返回")
                    })
                } else{
                    List(articles, id: \.courseID) {
                        item in
                        VStack(alignment:.leading) {
                            NavigationLink(
                                destination: CourseView(courseIndex: item.courseID),
                                label: {
                                    VStack(alignment:.leading){
                                        HStack{
                                            Text(item.subject).fontWeight(.semibold).font(.system(size: 16.0))
                                            Spacer()
                                            Text("\(item.year)" + "學年").fontWeight(.regular).font(.system(size: 13.0))
                                        }
                                        Text("\(item.department) - \(item.teacher)").fontWeight(.regular).font(.system(size: 13.0)).opacity(0.45)
                                    }
                                }).navigationTitle("") //To fix disappear back button
                        }
                    }.listStyle(GroupedListStyle()).navigationBarHidden(true)
                }
            }.onAppear(perform: {
                fectchData()
        })
        }
}



struct FavoriteView: View {
    @State var selectedTab = Tabs.FirstTab
    @State var selected = 0

    var body: some View {
        NavigationView {
            VStack(spacing:0) {
                    HStack{
                        ZStack(alignment: .leading){
                            Rectangle()
                                .fill(Color.init(hex: "#81986E", alpha: 1.0))
                                .frame(width: 390, height: 170
                                )
                            VStack (alignment: .leading){
                                Spacer().frame(height:92)
                                Text("我的最愛")
                                    .font(.system(size: 34))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.leading, 20)
                                Spacer().frame(width: 0, height: 7.5, alignment: .center)
                            }.padding(.bottom,30)
                        }
                    }
                    Picker(selection: $selected, label: Text(""), content: {
                        Text("課程").tag(0)
                        Text("討論版貼文").tag(1)
                    }).pickerStyle(SegmentedPickerStyle()).padding()
                    if (selected == 0) {
                        FavoriteData()
                    } else {
                        SecondTabView()
                    }
                    
            }.ignoresSafeArea()
        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}
