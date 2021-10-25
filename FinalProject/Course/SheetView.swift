//
//  ExperienceDetailView.swift
//  FinalProject
//
//  Created by 丁泓哲 on 2021/6/5.
//   所有的Sheet都放在這裡面了
import SwiftUI

struct CreateUserBody: Encodable {
    let nid: String
    let courseID: Int
    let scoreEasyScore: Int
    let selfRecommScore: Int
    let difficultyScore: Int
    let richnessScore: Int
    let chooseDifficltyScore: Int
    let comment: String
}

struct CreateUserResponse: Decodable {
    let status: Int
    let message: String
}

private var token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwYXlsb2FkIjp7Im5pZCI6IkQwNzQ1ODY3IiwibmFtZSI6IuS4geazk-WTsiIsImRlcHQiOiLos4foqIrlt6XnqIvlrbjns7sifSwiZXhwIjoxNjI0MzkyMDMxLCJpYXQiOjE2MjQzMDU2MzF9.VGJMM-F1ExmXWNR1dyEmqZM8Ka2SWqKbExI_NHxrfGE"
func postJudge(corseID:Int, nid:String, score:[Int], commemt: String) {
    let url = URL(string: "http://gf.ericlion.tw:6060/api/review")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")
    let encoder = JSONEncoder()
    let user = CreateUserBody(nid: "D0745867", courseID: corseID, scoreEasyScore: score[0], selfRecommScore: score[1], difficultyScore: score[2], richnessScore: score[3], chooseDifficltyScore: score[4], comment: commemt)
    let data = try? encoder.encode(user)
    request.httpBody = data
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let data = data {
            do {
                let decoder = JSONDecoder()
                let createUserResponse = try decoder.decode(CreateUserResponse.self, from: data)
                print(createUserResponse)
            } catch  {
                print(error)
            }
        }
    }.resume()
}

struct JudgeSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // For rating score
    // TODO: Using init to connect to API
    var courseTitle: String
    var courseProfess: String
    var courseID: Int
    init(title: String, teacher:String, courseID: Int) {
        self.courseTitle = title
        self.courseProfess = teacher
        self.courseID = courseID
    }
    
    private var ratingTitle: [String] = [
        "給分甜度",
        "課程難易度",
        "私心推薦",
        "內容豐富度",
        "選課難易度"
    ]
    @State var message : String = ""
    
    @State var rating_1 = 0
    @State var rating_2 = 0
    @State var rating_3 = 0
    @State var rating_4 = 0
    @State var rating_5 = 0
    
    @State var rating: [String : Int] = ["給分甜度":0, "課程難易度":0, "私心推薦":0, "內容豐富度":0, "選課難易度":0]
    
    @State var selecton: String = "逢甲男同學"
    let pickerOption: [String] = [
        "逢甲男同學", "施灌腸"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment:.leading) {
                    ZStack (alignment:.leading){
                        Rectangle().frame(width: 315, height: 141, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(Color.init(hex: "#DCDCDC", alpha: 0.475)).cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
                        VStack(alignment: .leading, spacing: 5) {
                            Image("education")
                                .resizable().frame(width: 41, height: 36, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            Text("課程名稱：\(courseTitle)").font(.system(size: 22.0))
                            Text("課程指導老師：\(courseProfess)").font(.system(size: 14.0)).foregroundColor(Color.init(hex: "#292724",alpha: 0.6))
                        }.padding(EdgeInsets(top: 7, leading: 30, bottom: 0, trailing: 0))
                    }.padding()
                    Text("身份").fontWeight(.semibold).font(.system(size: 14.0))
                    
                    Picker(selection: $selecton, label: HStack{
                        Image("cardView2") // TODO:改成其他圖片
                            .resizable()
                            .scaledToFill()
                            .frame(width: 36, height: 36, alignment: .center)
                            .clipShape(Circle())
                        HStack(alignment:.firstTextBaseline) {
                            Text(selecton).foregroundColor(.black).font(.system(size: 20))
                                .minimumScaleFactor(0.4)
                                .id(selecton)
                            //坑：1.minimumScaleFactor可以解決Text變化不夠長...棒 2. 加ID可以解決透明問題
                        }
                        Image(systemName: "chevron.right").resizable().frame(width: 5, height: 12, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(.gray)
                    }
                    , content:{
                        ForEach(pickerOption, id: \.self) {
                            option in HStack {
                                Text(option).tag(option)
                            }
                        }
                    }).pickerStyle(MenuPickerStyle())
                    Divider().frame(width:315).padding(.top,20)
                    Spacer().frame(height:25)
                    VStack (alignment: .leading){
                        Group {
                            Text("給分甜度")
                                .fontWeight(.semibold)
                            StarRatingView(rating: $rating_1).padding(.bottom,10)
                            Text("私心推薦").fontWeight(.semibold)
                            StarRatingView(rating: $rating_2).padding(.bottom,10)
                            Text("課程難易度").fontWeight(.semibold)
                            StarRatingView(rating: $rating_3).padding(.bottom,10)
                            Text("內容豐富度").fontWeight(.semibold)
                            StarRatingView(rating: $rating_4).padding(.bottom,10)
                            Text("選課難易").fontWeight(.semibold)
                            StarRatingView(rating: $rating_5).padding(.bottom,10)
                        }
                        .font(.system(size: 14.0))
                        Divider().frame(width:315).padding([.top,.bottom],10)
                    }
                    Text("心得分享").fontWeight(.semibold).font(.system(size: 14.0))
                    ZStack(alignment: .topLeading) {
                        if message.isEmpty  {
                            Text("和大家分享您上這門課的心得與經驗吧...")
                                .font(.system(size: 18.0))
                                .foregroundColor(Color.primary.opacity(0.25))
                                .padding(EdgeInsets(top: 2, leading: 4, bottom: 0, trailing: 0))
                                .padding(5)
                        }
                        TextEditor(text: $message)
                            .frame(width: 325, height: 200)
                    }.onAppear() {
                        UITextView.appearance().backgroundColor = .clear
                        // clear才能看見Zstack中的提示字
                    }.onDisappear() {
                        UITextView.appearance().backgroundColor = nil
                    }
                    Spacer()
                }
                .navigationBarTitle(Text("課程評分與心得"), displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel").bold().foregroundColor(Color.init(hex: "#4A5F30"))
                },trailing: Button(action: {
                    print("123")
                    postJudge(corseID: courseID, nid: "D0745867", score: [rating_1, rating_2, rating_3, rating_4, rating_5], commemt: message)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done").bold().foregroundColor(Color.init(hex: "#4A5F30"))
                })
            }
        }
    }
}


//Parent page: ExperienceViewCard
struct DetailSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    private let content : String = "教學很認真，至少我上課都在笑，雖然考試有點難，對沒幽默感的人來說有點困難。"
    //    @State private var showAlert = false
    var userIdentity: String // 同學姓名依據
    var scoreEasyScore: Int
    var selfRecommScore: Int
    var difficultyScore: Int
    var richnessScore: Int
    var chooseDifficltyScore: Int
    var comment: String
    
    //    @State var _userIdentity: String
    //    @State var _scoreEasyScore: Int
    //    @State var _selfRecommScore: Int
    //    @State var _difficultyScore: Int
    //    @State var _richnessScore: Int
    //    @State var _chooseDifficltyScore: Int
    //    @State var _comment: String
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment:.leading) {
                    Spacer().frame(height:40)
                    HStack {
                        Image("cardView2") // TODO:改成其他圖片
                            .resizable()
                            .scaledToFill()
                            .frame(width: 36, height: 36, alignment: .center)
                            .clipShape(Circle())
                        VStack(alignment:.leading) {
                            Text(userIdentity).bold().font(.system(size: 20))
                            Text("系統不會儲存真實姓名，資料庫已加密")
                                .font(.system(size: 14))
                                .opacity(0.5)
                        }
                    }
                    Divider().frame(width:315).padding(.top,20)
                    ZStack() {
                        HStack(spacing: 15) {
                            VStack(alignment:.leading ,spacing:0) {
                                Image("LargeStar").padding(.leading, 13)
                                
                                Text("\(String(format: "%.1f", Float(scoreEasyScore + selfRecommScore+difficultyScore+richnessScore+chooseDifficltyScore)/5)) / 5")
                                    .font(.system(size: 43)) // TODO: 前面換成分數
                                    .fontWeight(.light)
                                
                            }.padding()
                            StarsTemplate(sweet: scoreEasyScore,hard: difficultyScore,recommend: selfRecommScore,content: richnessScore,select: chooseDifficltyScore)
                                .padding(.top, 38)
                        }
                    }
                    Divider().frame(width:315).padding([.bottom, .top],20)
                    Text("心得").fontWeight(.semibold).font(.system(size: 14.0)).padding(.bottom,7.5)
                    Text(comment).font(.system(size: 18.0)).frame(width: 298, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    Spacer().frame(height:70)
                    HStack(alignment: .center) {
                        Spacer().frame(width:107)
                        Image(systemName: "exclamationmark.bubble.fill").resizable().frame(width: 18, height: 16, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Text("檢舉回報").font(.system(size: 14.0)).fontWeight(.semibold)
                    }.foregroundColor(Color.init(hex: "#555555"))
                    .gesture(TapGesture()
                                .onEnded({
                                    //放置onTap動作
                                }))
                    //                    .alert(isPresented: $showAlert) { () -> Alert in
                    //                            let answer = ["愛", "不愛"].randomElement()!
                    //                            return Alert(title: Text(answer))
                    //                         }
                    
                }
                .padding(.leading,13)
                .navigationBarTitle(Text("詳細心得評價"), displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel").bold().foregroundColor(Color.init(hex: "#4A5F30"))
                },trailing: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done").bold().foregroundColor(Color.init(hex: "#4A5F30"))
                })
            }
        }
    }
}

struct ProclamationSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    
    //
    struct content : Hashable{
        let title: String
        let content: String
    }
    var article : [content] = [content(title: "如何選課?", content: "這是一首簡單的小情歌，唱著人們心腸的曲折，我想我很快樂，當有你的溫熱，腳邊的空氣轉了，這是一首簡單的小情歌，唱著我們心頭的白鴿。我想我很適合。當一個歌頌者，青春在風中飄著。你知道 就算大雨讓整座城市顛倒 我會給你懷抱 受不了 看見你背影來到，寫下我、度秒如年難捱的離騷 就算整個世界被寂寞綁票。我也不會奔跑、逃不了、最後誰也都蒼老、寫下我，時間和琴聲交錯的城堡"), content(title: "我該注意什麼？", content: "這是一首簡單的小情歌，唱著人們心腸的曲折，我想我很快樂，當有你的溫熱，腳邊的空氣轉了，這是一首簡單的小情歌，唱著我們心頭的白鴿。我想我很適合。當一個歌頌者，青春在風中飄著。你知道 就算大雨讓整座城市顛倒 我會給你懷抱 受不了 看見你背影來到，寫下我、度秒如年難捱的離騷 就算整個世界被寂寞綁票。我也不會奔跑、逃不了、最後誰也都蒼老、寫下我，時間和琴聲交錯的城堡")]
    
    let lyrics = ["你從不知道", "我因為你而煎熬", "心碎過的每一分每一秒"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment:.leading) {
                    VStack {
                        Image("cardView2")
                            .resizable()
                            .overlay(TitleOverlay(title: title, subTitle: subTitle),alignment: .bottomLeading)
                            .opacity(1) //透明度全滿
                            .scaledToFit() //讓照片可以依照父元件調整
                        ForEach(article, id: \.self) { object in
                            ContextTemplate(title: object.title, context: object.content).padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
                        }
                    }
                }
                .navigationBarTitle(Text("詳細心得評價"), displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel").bold().foregroundColor(Color.init(hex: "#4A5F30"))
                },trailing: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Done").bold().foregroundColor(Color.init(hex: "#4A5F30"))
                })
            }
        }
    }
}

//校園公告的浮水字樣
struct TitleOverlay: View {
    
    var title = "選課時間已公告"
    var subTitle = "2/10 ~ 2/17 準時開選"
    init(title:String, subTitle: String) {
        self.title = title
        self.subTitle = subTitle
    }
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 30))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text(subTitle)
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }.padding(28)
        }
        .opacity(0.8)
        .cornerRadius(10.0)
    }
}

struct ContextTemplate: View {
    var title : String = "Hello!Title"
    var context: String = "Content..."
    
    init(title:String, context: String) {
        self.title = title
        self.context = context
    }
    
    var body: some View{
        VStack(alignment: .leading) {
            Text(title).font(.system(size: 25.0)).fontWeight(.thin)
            VStack {
                Rectangle()
                    .foregroundColor(Color.init(hex: "#4A5F30"))
                    .frame(width: 65, height: 4)
                    .cornerRadius(/*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/)
            }.fixedSize()
            Text(context).font(.system(size: 14.0)).fontWeight(.light).lineSpacing(/*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/).fixedSize(horizontal: false, vertical: true)
            //採坑：fixedSize可以防止文字被切掉
        }
    }
}

struct ExperienceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProclamationSheetView()
        //        DetailSheetView()
        JudgeSheetView(title: "123", teacher: "123", courseID: 1 )
    }
}
