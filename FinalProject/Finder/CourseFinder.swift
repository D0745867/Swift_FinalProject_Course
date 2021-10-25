//
//  CourseFinder.swift
//  FinalProject
//
//  Created by 丁泓哲 on 2021/6/21.
//

import SwiftUI

struct CourseFinder: View {
    @State var selectedTab = Tabs.FirstTab
    @State var selected = 0

    var body: some View {
        NavigationView{
            VStack(spacing:0){
                ZStack(alignment: .leading){
                    Rectangle()
                        .fill(Color.init(hex: "#81986E", alpha: 1.0))
                        .frame(width: 390, height: 170
                        )
                    VStack (alignment: .leading){
                        Spacer().frame(height:92)
                        Text("評價心得")
                            .font(.system(size: 34))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                        Spacer().frame(width: 0, height: 7.5, alignment: .center)
                    }.padding(.bottom,30)
                }
                ZStack(alignment: .leading){
                    Rectangle()
                        .fill(Color.init(hex: "#f2f2f7"))
                        .frame(width: 390)
                    VStack(alignment: .leading) {
                        Picker(selection: $selected, label: Text(""), content: {
                            Text("依開課系所查詢").tag(0)
                            Text("依輸入條件查詢").tag(1)
                        }).pickerStyle(SegmentedPickerStyle())
                        .padding(20)
                        if selected == 0 {
                            FirstTabView()
                        } else {
                            SecondTabView()
                        }
                        Spacer()
                    }
                }
                
                Spacer()
            }.ignoresSafeArea()
        }
    }
}
struct FirstTabView : View {
    
    @State var systemSelection: String = "大學部"
    @State var collegeSelection: String = ""
    @State var majorSelection: String = ""
    @State var classSelection: String = ""
    let pickerSystem: [String] = [
        "大學部"
    ]
    
    let pickerCollege: [String] = [
        "資電學院", "商學院", "通識核心課"
    ]
    
    let pickerMajor: [String] = [
        "資訊系", "電機系"
    ]
    
    let pickerMajor_2: [String] = [
        "通識核心"
    ]
    
    let pickerMajor_3: [String] = [
        "會計系", "國貿系"
    ]
    
    let pickerClass_1: [String] = [
        "資訊一甲", "資訊一乙", "資訊一丙"
        , "資訊二甲", "資訊二乙", "資訊二丙", "資訊二丁"
        , "資訊三甲", "資訊三乙", "資訊三丙", "資訊三丁"
        , "資訊四甲", "資訊四乙", "資訊四丙", "資訊四丁"
    ]
    
    let pickerClass_2: [String] = [
        "電機一甲", "電機一乙", "電機二甲", "電機二乙"
        ,"電機二丙", "電機二合", "電機三甲", "電機三乙"
        ,"電機三丙", "電機四甲", "電機四乙", "電機四丙"
        ,"電磁能源學程電機三", "光電工程學程電機三"
        ,"電波工程學程電機三", "電磁能源學程電機四"
        , "光電工程學程電機四","電波工程學程電機四",
    ]
    
    let pickClass_3: [String] = [
        "通識－人文(H)", "通識－自然(N)"
        , "通識－社會(S)", "通識－統合(M)"
    ]
    
    let pickClass_4: [String] = [
        "會計一甲", "會計一乙", "會計一丙"
        ,"會計二甲", "會計二乙", "會計二丙"
        ,"會計三甲", "會計三乙", "會計三丙"
        ,"會計四甲", "會計四乙", "會計四丙"
    ]
    
    let pickClass_5: [String] = [
        "國貿一甲", "國貿一乙", "國貿一丙"
        ,"國貿二甲", "國貿二乙", "國貿二丙"
        ,"國貿三甲", "國貿三乙", "國貿三丙"
        ,"國貿四甲", "國貿四乙", "國貿四丙"
        ,"國貿全英班ㄧ","國貿全英班二","國貿全英班三"
        ,"國貿全英班四"
    ]
    let pickerOption: [String] = [
        "逢甲男同學", "施灌腸"
    ]
    var body : some View {
        VStack(spacing:0) {
            Spacer().frame(height:30)
            Group {
                Text("學制").fontWeight(.semibold).font(.system(size: 14.0))
                    Picker(selection: $systemSelection, label: HStack{
                        HStack(alignment:.firstTextBaseline) {
                            Text(systemSelection).foregroundColor(.black).font(.system(size: 20))
                                .minimumScaleFactor(0.4)
                                .id(systemSelection)
                            //坑：1.minimumScaleFactor可以解決Text變化不夠長...棒 2. 加ID可以解決透明問題
                        }
                        Image(systemName: "chevron.right").resizable().frame(width: 5, height: 12, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(.gray)
                    }
                    , content:{
                        ForEach(pickerSystem, id: \.self) {
                            option in HStack {
                                Text(option).tag(option)
                            }
                        }
                    }).pickerStyle(MenuPickerStyle())
                    
                Spacer().frame(height:20)
                Text("學院").fontWeight(.semibold).font(.system(size: 14.0))
                Picker(selection: $collegeSelection, label: HStack{
                    HStack(alignment:.firstTextBaseline) {
                        Text(collegeSelection).foregroundColor(.black).font(.system(size: 20))
                            .minimumScaleFactor(0.4)
                            .id(collegeSelection)
                        //坑：1.minimumScaleFactor可以解決Text變化不夠長...棒 2. 加ID可以解決透明問題
                    }
                    Image(systemName: "chevron.right").resizable().frame(width: 5, height: 12, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(.gray)
                }
                , content:{
                    ForEach(pickerCollege, id: \.self) {
                        option in HStack {
                            Text(option).tag(option)
                        }
                    }
                }).pickerStyle(MenuPickerStyle())
                Spacer().frame(height:20)
                
                Text("系所").fontWeight(.semibold).font(.system(size: 14.0))
                Picker(selection: $majorSelection, label: HStack{
                    HStack(alignment:.firstTextBaseline) {
                        Text(majorSelection).foregroundColor(.black).font(.system(size: 20))
                            .minimumScaleFactor(0.4)
                            .id(majorSelection)
                        //坑：1.minimumScaleFactor可以解決Text變化不夠長...棒 2. 加ID可以解決透明問題
                    }
                    Image(systemName: "chevron.right").resizable().frame(width: 5, height: 12, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(.gray)
                }
                , content:{
                    ForEach(collegeSelection == "資電學院" ? pickerMajor :  collegeSelection == "商學院" ? pickerMajor_3 : pickerMajor_2, id: \.self) {
                        option in HStack {
                            Text(option).tag(option)
                        }
                    }
                })
                .pickerStyle(MenuPickerStyle())
                
                Text("班級").fontWeight(.semibold).font(.system(size: 14.0)).padding(.top, 20)
                Picker(selection: $classSelection, label: HStack{
                    HStack(alignment:.firstTextBaseline) {
                        Text(classSelection).foregroundColor(.black).font(.system(size: 20))
                            .minimumScaleFactor(0.4)
                            .id(classSelection)
                        //坑：1.minimumScaleFactor可以解決Text變化不夠長...棒 2. 加ID可以解決透明問題
                    }
                    Image(systemName: "chevron.right").resizable().frame(width: 5, height: 12, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).foregroundColor(.gray)
                }
                , content:{
                    ForEach(majorSelection == "資訊系" ? pickerClass_1 : majorSelection == "電機系" ? pickerClass_2 : majorSelection == "通識核心" ? pickClass_3 : majorSelection == "會計系" ? pickClass_4 : pickClass_5, id: \.self) {
                        option in HStack {
                            Text(option).tag(option)
                        }
                    }
                }).pickerStyle(MenuPickerStyle())
            }.padding(.leading,-150).padding(.top, 7)
            HStack {
                Button(action: {
                    // Open and close sheet toggle
                }) {
                    NavigationLink(
                        destination: CourseResult_2(systemSelection: systemSelection, collegeSelection: collegeSelection, majorSelection: majorSelection, classSelection: classSelection),
                        label: {
                            HStack {
                                Text("立即搜尋")
                                    .font(.system(size: 14))
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            }
                            .frame(width:156, height: 42)
                            .foregroundColor(Color.init(hex: "#FFFFFF"))
                            .background(Color.init(hex: "#4A5F30"))
                            .cornerRadius(5.5)
                        }).disabled(systemSelection.isEmpty && collegeSelection.isEmpty && majorSelection.isEmpty && classSelection.isEmpty)
                        .navigationTitle("")
                }
                
                Button(action: {
                    systemSelection = ""
                    collegeSelection = ""
                   majorSelection = ""
                     classSelection = ""
                }) {
                    HStack {
                        Text("清除")
                            .font(.system(size: 14))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    .frame(width:156, height: 42)
                    .foregroundColor(Color.init(hex: "#4A5F30"))
                    .background(Color.init(hex: "#E9EACA"))
                    .cornerRadius(5.5)
                }
            }.padding(.top, 60)
            Spacer()
        }.frame(width: 390, height: 478)
        .background(Color.init(.white))
    }
}

struct SecondTabView : View {
    @State private var courseID = ""
    @State private var courseTeacher = ""
    @State private var courseName = ""
    var body : some View {
        ZStack {
            VStack(spacing:0) {
                Text("保留空白，即表示不使用此條件").fontWeight(.regular).opacity(0.5)
                Form {
                        TextField("選課代號..", text: $courseID)
                        TextField("開課教師姓名..", text: $courseTeacher)
                        TextField("科目名稱..", text: $courseName)
                }
                HStack {
                    NavigationLink(
                        destination: CourseResult(codeName: courseID, teacher: courseTeacher, subject: courseName),
                        label: {
                            HStack {
                                Text("立即搜尋")
                                    .font(.system(size: 14))
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            }
                            .frame(width:156, height: 42)
                            .foregroundColor(Color.init(hex: "#FFFFFF"))
                            .background(Color.init(hex: "#4A5F30"))
                            .cornerRadius(5.5)
                        }).disabled(courseID.isEmpty && courseName.isEmpty && courseName.isEmpty)
                        .navigationTitle("")
                    
                    Button(action: {
                        courseID = ""
                        courseName = ""
                        courseTeacher = ""
                    }) {
                        HStack {
                            Text("清除")
                                .font(.system(size: 14))
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        }
                        .frame(width:156, height: 42)
                        .foregroundColor(Color.init(hex: "#4A5F30"))
                        .background(Color.init(hex: "#E9EACA"))
                        .cornerRadius(5.5)
                    }
                }.padding(.top, 60)
            }
        }.frame(width: 390, height: 478)
    }
}

enum Tabs {
    case FirstTab
    case SecondTab
}

struct CourseFinder_Previews: PreviewProvider {
    static var previews: some View {
        CourseFinder()
        FirstTabView()
        SecondTabView()
    }
}
