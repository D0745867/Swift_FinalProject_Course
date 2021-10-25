//
//  SwiftUIView.swift
//  FinalProject
//
//  Created by 丁泓哲 on 2021/5/19.
//  

import SwiftUI

// 星星模板
struct StarsTemplate: View {
    
    var score = [
        1: 0,
        2: 0,
        3: 0,
        4: 0,
        5: 0
    ]
    
    let title = [
        "給分甜度",
        "課程難易度",
        "私心推薦",
        "內容豐富度",
        "選課難易度"
    ]
    //    let sweet: Int  //給分甜度
    //    let hard: Int   //課程難易度
    //    let recommend: Int //私心推薦
    //    let content: Int //內容豐富度
    //    let select: Int //選課難易度
    
    init(sweet:Int, hard:Int, recommend:Int, content:Int, select: Int) {
        self.score[1] = sweet
        self.score[2] = hard
        self.score[3] = recommend
        self.score[4] = content
        self.score[5] = select
    }
    var body: some View {
        VStack(alignment: .leading) {
            // 讓Array的內容按照順序
            ForEach(Array(score.keys).sorted(by: <), id: \.self) { key in
                VStack(alignment: .leading) {
                    Text(title[key - 1])
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.system(size: 14))
                    HStack {
                        ForEach(0 ..< 5) { item in
                            Image(systemName: item<(score[key]!) ?"star.fill" :"star")
                                .foregroundColor(Color.init(hex: "#FFBB02"))
                        }
                    }
                }
                .padding(.bottom, 12)
            }
        }
    }
}

struct StarRatingView: View {
    @Binding var rating: Int
    var label = ""
    var maximumRating = 5
    
    var offImage = Image(systemName: "star")
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View{
        HStack {
            if label.isEmpty == false {
                Text(label)
            }
            
            ForEach(1..<maximumRating + 1) {
                number in self.image(for: number).resizable().frame(width: 32, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(number > self.rating ? self.offColor : self.onColor).padding(.leading,10).onTapGesture {
                    self.rating = number
                }
            }
        }
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage
        } else {
            return onImage
        }
    }
}

//  用來提供Button的簡化
struct ButtonTemplate: View {
    
    @Binding var showSheet: Bool
    var icon: String?
    let title: String
    let width: CGFloat
    let height : CGFloat
    let fontColor: String
    let backingColor: String
    
    init(showSheet:Binding<Bool>, icon:String, title:String, wid: CGFloat, height: CGFloat, fColor: String, bColor: String) {
        self._showSheet = showSheet
        self.icon = icon
        self.title = title
        self.width = wid
        self.height = height
        self.fontColor = fColor
        self.backingColor = bColor
    }
    
    init(showSheet:Binding<Bool>, title:String, wid: CGFloat, height: CGFloat, fColor: String, bColor: String) {
        self._showSheet = showSheet
        self.title = title
        self.width = wid
        self.height = height
        self.fontColor = fColor
        self.backingColor = bColor
    }
    
    var body: some View {
        Button(action: {
            // Open and close sheet toggle
            showSheet.toggle()
        }) {
            HStack {
                if icon != nil {
                    Image(systemName: self.icon!)
                        .foregroundColor(Color.init(hex: fontColor))
                }
                Text(title)
                    .font(.system(size: 14))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            }
            .frame(width:width, height: height)
            .foregroundColor(Color.init(hex: fontColor))
            .background(Color.init(hex: backingColor))
            .cornerRadius(5.5)
        }
    }
}

// 上面那一欄
struct ScoreBoard: View {
    @State var flag: Int = 1
    var courseIndex: Int
    var courseName: String
    var courseTeacher: String
    struct Result: Codable, Hashable {
        var status: Int
        var scoreEasyScore: Float
        var selfRecommScore: Float
        var difficultyScore: Float
        var richnessScore: Float
        var chooseDifficltyScore: Float
        var totalAVG: Float
    }
    private let url = "http://gf.ericlion.tw:6060/api/review/course/"
    @State private var infos = [Result]()
     func fectchData() {
        guard let url = URL(string: url + String(courseIndex)) else {
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
                        self.infos = [decodedResult]
                        print(self.infos)
                    }
                    return
                }
            }
            print("Error: \(error?.localizedDescription ?? "Unknown error")")
            self.flag = 0
        }.resume()
    }
    @State var scoreSheet = false
    @State var expSheet = false
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white)
                .opacity(1) //透明度
            HStack {
                VStack(alignment:.leading ,spacing:0) {
                    Text("綜合評價")
                        .fontWeight(.bold)
                        .foregroundColor(Color.init(hex: "#4A5F30"))
                        .padding(.bottom,10)
                    Image("LargeStar").padding(.leading, 13)
                    
                    HStack() {
                        ForEach(infos, id: \.self) { object in
                            Text("\(infos[0].totalAVG, specifier: "%.1f") / 5")
                                .font(.system(size: 43)) // TODO: 前面換成分數
                                .fontWeight(.light)
                        }
                    }
                    ButtonTemplate(showSheet: $scoreSheet, title: "給予評分", wid: 120, height: 34, fColor: "#FFFFFF", bColor: "#4A5F30").padding(.top, 20)
                        .sheet(isPresented: $scoreSheet, onDismiss: fectchData) {
                            JudgeSheetView(title: courseName, teacher: courseTeacher, courseID: courseIndex)
                        }
                    
                    //TODO: 查看心得頁面更改
//                    ButtonTemplate(showSheet: $expSheet, title: "查看心得", wid: 120, height: 34, fColor: "#4A5F30", bColor: "#DCDDA6").padding(.top, 13)
                    NavigationLink(
                        destination: ExperienceView(courseID: courseIndex, courseCollege: courseName, courseTitle: courseTeacher),
                        label: {
                            HStack {
                                Text("查看心得")
                                    .font(.system(size: 14))
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            }
                            .frame(width:120, height: 34)
                            .foregroundColor(Color.init(hex: "4A5F30"))
                            .background(Color.init(hex: "DCDDA6"))
                            .cornerRadius(5.5)
                        }).navigationTitle("").padding(.top,10)
                }
                .padding(EdgeInsets(top: 25.0, leading: 50.0, bottom: 0, trailing: 28.5))
                
                HStack() {
                    ForEach(infos, id: \.self) { object in
                        if(flag != 0) {
                            StarsTemplate(sweet: Int(infos[0].richnessScore),hard: Int(infos[0].scoreEasyScore),recommend: Int(infos[0].selfRecommScore),content: Int(infos[0].richnessScore),select: Int(infos[0].chooseDifficltyScore))
                                .padding(.top, 38)
                        }
                    }
                    if(flag == 0) {
                        Text("目前尚未有評價")
                    }
                }
            }.onAppear(perform: {
                fectchData()
            })
            
        }
        .cornerRadius(0)
        .frame(width: nil, height: 334, alignment: .center )
    }
}

// 最下面那一欄
struct ScoreBoardFunc: View {
    @State var scoreSheet = false
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white)
                .opacity(1) //透明度
            VStack {
                ButtonTemplate(showSheet: $scoreSheet, icon:"square.and.arrow.up.fill", title: "分享課程", wid: 271, height: 47, fColor: "#FFFFFF", bColor: "#96A467").padding(.top, 20)
                
                HStack {
                    ButtonTemplate(showSheet: $scoreSheet, icon:"square.and.arrow.up.fill", title: "課業討論版", wid: 127, height: 51, fColor: "#4A5F30", bColor: "#DCDDA6").padding(.top, 20)
                    Spacer().frame(width:18)
                    ButtonTemplate(showSheet: $scoreSheet, icon:"square.and.arrow.up.fill", title: "筆記分享", wid: 127, height: 51, fColor: "#4A5F30", bColor: "#DCDDA6").padding(.top, 20)
                }
            }
        }
        .frame(width: nil, height: 234, alignment: .center )
    }
}

struct CourseView: View {
    
    //CourseIndex需要從上ㄧ層傳來
    var courseIndex: Int
    struct Result: Codable {
        var result: [result]
    }
    struct result : Codable, Hashable{
        var courseID: Int
        var year: Int
        var semester: Int
        var system: String
        var college: String
        var department: String
        var `class`: String
        var codeName: String
        var teacher: String
        var subject: String
    }
    
    private let url = "http://gf.ericlion.tw:6060/api/course/"
    @State private var infos = [result]()
    func fectchData() {
        guard let url = URL(string: url + String(courseIndex)) else {
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
                        self.infos = decodedResult.result
                    }
                    return
                }
            }
            print("Error: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    func printf() {
        print("INFOS: \(infos)")
    }
    var body: some View {
            ZStack {
                Color.init(hex: "#f2f2f7")
                VStack (alignment: .center, spacing: 20){
                    ZStack (alignment:.leading){
                        Rectangle()
                            .fill(Color.init(hex: "#81986E", alpha: 1.0))
                            .frame(width: 390, height: 230
                            )
                        //Text(infos[0].subject)
                        HStack() {
                            ForEach(infos, id: \.self) { object in
                                CourseContent(college: infos[0].college, course: infos[0].class, year: infos[0].year, teacher: infos[0].teacher)
                                    .padding(EdgeInsets(top: 45, leading: 25, bottom: 0, trailing: 0))
                            }
                        }
                    }
                    HStack() {
                        ForEach(infos, id: \.self) { object in
                            ScoreBoard(courseIndex: courseIndex, courseName: infos[0].subject, courseTeacher: infos[0].teacher)
                        }
                    }
                    ScoreBoardFunc()
                    Spacer()
                }.ignoresSafeArea()
                .offset(x: 0, y: 30)
            }
        .accentColor( .white)
        .onAppear(perform: fectchData)
    }
}


// 上面的Navigator view
struct CourseContent: View {
    var college: String
    var course: String
    var year: Int
    var teacher: String
    
    var body: some View {
        ZStack {
            VStack (alignment: .leading){
                Text(college).foregroundColor(.white)
                Text(course)
                    .font(.system(size: 34))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("\(year) 年")
                    .foregroundColor(.white)
                Text(teacher + "老師")
                    .foregroundColor(.white)
            }
            //spcaing :0 用以消除margin
            VStack (alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 0, content: {
                Image("informIcon")
                Text("課程大綱")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
            }).offset(x: 230, y: 27.5)
        }
    }
}



struct CourseView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            //呼叫CourseView必須傳入資料
            CourseView(courseIndex: 10)
            StarRatingView(rating: .constant(4))
            JudgeSheetView(title: "123", teacher: "!23", courseID: 1)
        }
    }
}
