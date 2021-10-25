//
//  CourseResult.swift
//  FinalProject
//
//  Created by 丁泓哲 on 2021/6/21.
//
import SwiftUI


struct courseData_2 : View {
    var systemSelection: String
    var collegeSelection: String
    var majorSelection: String
    var classSelection: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var articles = [CreateUserResponse]()
    //fetch data
    struct CreateUserBody: Encodable {
        let system: String
        let college: String
        let department: String
        let `class`: String
    }

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
    
    func postSearch() {
        let url = URL(string: "http://gf.ericlion.tw:6060/api/search/no1")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        let user = CreateUserBody(system: systemSelection, college: collegeSelection, department: majorSelection, class: classSelection)
        let data = try? encoder.encode(user)
        request.httpBody = data
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                if let decodedResult = try?
                                    JSONDecoder().decode(Result.self, from: data) {
                                    DispatchQueue.main.async {
                                        self.articles = decodedResult.result
                                    }
                                    return
                                }

            }
        }.resume()
    }

    var body: some View {
        VStack {
//            if(articles.isEmpty) {
//                Spacer().frame(height:100)
//                Text("沒有符合的搜尋結果...").padding()
//                Button(action: {
//                        self.presentationMode.wrappedValue.dismiss()}, label: {
//                    Text("點擊返回")
//                })
//            } else{
                List(articles, id: \.courseID) {
                    item in
                    VStack(alignment:.leading) {
                        NavigationLink(
                            destination: /*@START_MENU_TOKEN@*/Text("Destination")/*@END_MENU_TOKEN@*/,
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
            //}
        }.onAppear(perform: {
            print(systemSelection)
            print(collegeSelection)
            print(majorSelection)
            print(classSelection)
            postSearch()
        })
    }
}

struct CourseResult_2: View {

    var systemSelection: String
    var collegeSelection: String
    var majorSelection: String
    var classSelection: String
    
    var body: some View {
            VStack(spacing:0) {
                HStack{
                    ZStack(alignment: .leading){
                        Rectangle()
                            .fill(Color.init(hex: "#81986E", alpha: 1.0))
                            .frame(width: 390, height: 170
                            )
                        VStack (alignment: .leading){
                            Spacer().frame(height:92)
                            Text("搜尋結果")
                                .font(.system(size: 34))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.leading, 20)
                            Spacer().frame(width: 0, height: 7.5, alignment: .center)
                        }.padding(.bottom,30)
                    }
                }
                courseData_2(systemSelection: systemSelection, collegeSelection: collegeSelection, majorSelection: majorSelection, classSelection: classSelection)
                Spacer()
            }.ignoresSafeArea()
    }
}

struct CourseResult_2_Previews: PreviewProvider {
    static var previews: some View {
        CourseResult(codeName: "1333", teacher: "", subject: "")
    }
}
