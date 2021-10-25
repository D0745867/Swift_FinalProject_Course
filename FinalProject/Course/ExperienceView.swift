//
//  Experience.swift
//  FinalProject
//
//  Created by 丁泓哲 on 2021/5/29.
//  ISSUE : Still having some async issue

import SwiftUI

struct Result: Codable {
    var result: [result]
}

struct result : Codable, Hashable{
    var reviewID: Int
    var nid: String
    var userIdentity: String
    var courseID: Int
    var scoreEasyScore: Int
    var selfRecommScore: Int
    var difficultyScore: Int
    var richnessScore: Int
    var chooseDifficltyScore: Int
    var comment: String
}

// 上面的Navigator view
struct TopNavigationBar: View {
    
    var courseCollege: String
    var courseTitle: String
    var body: some View {
        ZStack {
            VStack (alignment: .leading){
                Text("評價心得")
                    .font(.system(size: 34))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 80)
                Spacer().frame(width: 0, height: 7.5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text(courseCollege + " - " + courseTitle)
                    .foregroundColor(.white)
            }.padding(.bottom,30)
            //spcaing :0 用以消除margin
            VStack (alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 0, content: {
                Image(systemName: "line.horizontal.3.decrease.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.init(hex: "0XFFFFFF"))
            }).offset(x: 245, y: -10)
            .frame(width: 24, height: 24, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
}

struct ExperienceCard: View {
    
    func asyncData() {
        userIdentity = data.userIdentity
        scoreEasyScore =  data.scoreEasyScore
        selfRecommScore =  data.selfRecommScore
        difficultyScore =  data.difficultyScore
        richnessScore = data.richnessScore
        chooseDifficltyScore = data.chooseDifficltyScore
        comment = data.comment
        cardSheet.toggle()
    }
    /*Card binding state*/
    @Binding var userIdentity: String
    @Binding var scoreEasyScore: Int
    @Binding var selfRecommScore: Int
    @Binding var difficultyScore: Int
    @Binding var richnessScore: Int
    @Binding var chooseDifficltyScore: Int
    @Binding var comment: String
    @Binding var cardSheet: Bool
    
    let ID: String
    let star: String
    var content: String
    var data: result
    
    init(Data: result, userIdentity: Binding<String>,scoreEasyScore: Binding<Int>    ,selfRecommScore: Binding<Int> ,difficultyScore: Binding<Int>,richnessScore: Binding<Int> ,chooseDifficltyScore: Binding<Int> ,comment: Binding<String>, cardSheet: Binding<Bool> ) {
        self.data = Data
        self.ID = Data.userIdentity
        self.star = String(format: "%.1f", Float(Data.chooseDifficltyScore + Data.scoreEasyScore+Data.selfRecommScore+Data.difficultyScore+Data.richnessScore)/5)
        self.content = Data.comment
        _userIdentity = userIdentity
        _scoreEasyScore = scoreEasyScore
        _selfRecommScore = selfRecommScore
        _difficultyScore = difficultyScore
        _richnessScore = richnessScore
        _chooseDifficltyScore = chooseDifficltyScore
        _comment = comment
        _cardSheet = cardSheet
    }
    //定義API資料結構
    //TODO: 串接API
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white)
                .opacity(1) //透明度
            VStack(alignment:.leading) {
                HStack (spacing:100){
                    HStack {
                        Image("cardView2") // TODO:改成其他圖片
                            .resizable()
                            .scaledToFill()
                            .frame(width: 36, height: 36, alignment: .center)
                            .clipShape(Circle())
                        Text(self.ID).bold().frame(width:95)
                    }
                    HStack (spacing:0) {
                        Image(systemName: "star.circle")
                            .foregroundColor(Color.init(hex: "#FFBB02"))
                        Text("\(self.star)/5")
                    }
                }
                Spacer().frame(height:8)
                Text(self.content)
                    .fontWeight(.regular)
            }.padding(EdgeInsets(top: -35, leading: 20, bottom: 10, trailing: 20))
            
        }
        .cornerRadius(0)
        .frame(width: 350, height: 160, alignment: .center)
        .shadow(color:Color.black.opacity(0.2),radius: 5)
        .padding(.bottom,10)
        .onTapGesture(perform: {
            asyncData()
        })
    }
}

struct ExperienceView: View {
    
    var courseID: Int
    var courseCollege: String
    var courseTitle: String
    
    @State var cardSheet = false
    
    /*Card binding state*/
    @State var userIdentity: String = "default"
    @State var scoreEasyScore: Int = 0
    @State var selfRecommScore: Int = 0
    @State var difficultyScore: Int = 0
    @State var richnessScore: Int = 0
    @State var chooseDifficltyScore: Int = 0
    @State var comment: String = "default"
    
    // TODO:這邊要改Link連結
    private let url = "http://gf.ericlion.tw:6060/api/reviews/course/"
    @State private var comments = [result]()
    
    func fectchData() {
        guard let url = URL(string: url  + String(courseID)) else {
            print("URL is not Valid")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            if let data = data {
                if let decodedResult = try?
                    JSONDecoder().decode(Result.self, from: data) {
                    DispatchQueue.main.async {
                        self.comments = decodedResult.result
                    }
                    return
                }
            }
            print("Error: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    var body: some View {
        VStack (spacing:0){
            ZStack (alignment:.leading){
                Rectangle()
                    .fill(Color.init(hex: "#81986E", alpha: 1.0))
                    .frame(width: 390, height: 200
                    )
                TopNavigationBar(courseCollege: self.courseCollege, courseTitle: self.courseTitle) //評價心得的標題
                    .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 0))
            }
            ZStack {
                Color.init(hex: "#f2f2f7").ignoresSafeArea()
                VStack (alignment: .center, spacing: 20){
                    //放置空白處東西
                    if(comments.isEmpty) {
                        Text("目前尚未有評價喔！")
                    } else {
                        ScrollView() {
                            ForEach(comments, id: \.self) { object in
                                ExperienceCard(Data: object, userIdentity: $userIdentity, scoreEasyScore: $scoreEasyScore, selfRecommScore: $selfRecommScore, difficultyScore: $difficultyScore, richnessScore: $richnessScore, chooseDifficltyScore: $chooseDifficltyScore, comment: $comment, cardSheet: $cardSheet)
                            }
                        }
                    }
                    // TODO: 改成Destination 還有 ForeachData
                    // TODO: 字數限制有Bug, 有空閒時間修理
                    
                }
                .sheet(isPresented: $cardSheet) {
                    DetailSheetView(userIdentity: userIdentity, scoreEasyScore: scoreEasyScore, selfRecommScore: selfRecommScore, difficultyScore: difficultyScore, richnessScore: richnessScore, chooseDifficltyScore: chooseDifficltyScore, comment: comment)
                }
                .padding(.top,15)
            }
            Spacer()
        }.onAppear(perform: fectchData).ignoresSafeArea()
    }
}

struct ExperienceView_Previews: PreviewProvider {
    static var previews: some View {
        ExperienceView(courseID: 100, courseCollege: "通識課", courseTitle: "如何說笑話")
    }
}
