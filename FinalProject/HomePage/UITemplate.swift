//
//  SwiftUIView.swift
//  FinalProject
//
//  Created by 丁泓哲 on 2021/5/3.
//

import SwiftUI
var title = "選課時間已公告"
var subTitle = "2/10 ~ 2/17 準時開選"

struct SwiftUIView: View {
    var body: some View {
        CardView()
    }
}

//校園公告的浮水字樣
struct CardOverlay: View {
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
                    .font(.system(size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(subTitle)
                    .font(.system(size: 12))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }.padding(28)
        }
        .opacity(0.8)
        .cornerRadius(10.0)
    }
}

//校園公告
struct CardView: View {
    var body: some View {
        VStack {
            Image("cardView2")
                .resizable()
                .overlay(CardOverlay(title: title, subTitle: subTitle),alignment: .bottomLeading)
                .opacity(1) //透明度全滿
                .cornerRadius(10)
                .frame(width: 206, height: 168, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }.padding([.top, .leading],10)
    }
}

//討論版動態
//struct Forum: View {
//    var body: some View {
//        VStack {
//            Image("cardView2")
//                .resizable()
//                .overlay(CardOverlay(),alignment: .bottomLeading)
//                .opacity(1) //透明度
//                .cornerRadius(10)
//                .frame(width: 318, height: 192, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//        }.padding([.top, .leading],10)
//    }
//}

struct ForumData {
    let major : String
    let gender : String
    let subject : String
    let content : String
    let tags : Array<String>  //踩坑：List型態
    let like : Array<Int>
    let timeStamp : String
}

//討論版卡片內容
struct ForumOverlay: View {
    
    var ForumInfo = ForumData (major: "逢甲資工系", gender: "男", subject: "資料結構", content: "第一次小考第一題怎麼算啊？為什麼答案是0?", tags: ["求解題","問卦"], like: [10, 5], timeStamp: "2021/12/01 13:30")
    //    var major = "逢甲資工系"
    //    var gender = "男"
    //    var subject = "資料結構"
    //    var content = "第一次小考第一題怎麼算啊？為什麼答案是0?"
    //    var tags = ["求解題","問卦"]
    //    var like = ["10","5"]
    //    var timeStamp = "2021/12/01 13:30"
    //    var object = ["123":"456"]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("cardView2") // TODO:改成其他圖片
                    .resizable()
                    .scaledToFill()
                    .frame(width: 36, height: 36, alignment: .center)
                    .clipShape(Circle())
                VStack (alignment: .leading){
                    Text(ForumInfo.major + " " + ForumInfo.gender + "同學")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text(ForumInfo.subject)
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                        .foregroundColor(Color.init(hex: "#318E00", alpha: 1.0))
                }
                Spacer()
                Like(object: ForumInfo.like)
            }
            Spacer()
            Text(ForumInfo.content)
                .font(.system(size: 14))
                .foregroundColor(.black)
            Spacer()
            HStack () {
                ForEach(0 ..< ForumInfo.tags.count) { item in
                    Text("#" + ForumInfo.tags[item])
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                        .foregroundColor(Color.init(hex: "#318E00", alpha: 1.0))
                }
                Spacer()
                Text(ForumInfo.timeStamp)
                    .font(.system(size: 12))
                    .fontWeight(.bold)
            }
        }.padding(21)
        //        ZStack {
        //
        //        }
        //        .opacity(0.8)
        //        .cornerRadius(10.0)
    }
}

struct Forumm: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.white)
                .opacity(1) //透明度
                .overlay(ForumOverlay())
            
        }
        .cornerRadius(0)
        .frame(width: 318, height: 192, alignment: .center )
        .shadow(radius: 3)
    }
}

struct Like: View {
    var comment: Int
    var like: Int
    init(object: Array<Int>) {
        self.comment = object[0]
        self.like = object[1]
    }
    var body: some View {
        HStack {
            ZStack {
                Image("comment")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
                Text(String(comment))
                    .foregroundColor(.white)
                    .font(.system(size: 10))
                         .frame(width: 20, height: 13)
                         .background(Color.init(hex: "#96A467", alpha: 1.0))
                         .cornerRadius(100)
                    .offset(x: 9.50, y: -8.0)
                
            }
            .padding(.trailing, 10.0)
            ZStack {
                Image("like")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text(String(like))
                    .foregroundColor(.white)
                    .font(.system(size: 10))
                         .frame(width: 20, height: 13)
                         .background(Color.init(hex: "#F58686", alpha: 1.0))
                         .cornerRadius(100)
                    .offset(x: 10.50, y: -8.0)
            }
            .padding(.leading, 10.0)
        }
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardView()
            //Forum()
            Forumm()
        }
    }
}
