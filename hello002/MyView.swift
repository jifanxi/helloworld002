import SwiftUI

struct MyView: View {
    var body: some View {
        ZStack {
            // 添加背景图像
            Image("backgroundImage")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            // 其他内容
            VStack {
                Text("欢迎来到主页")
                    .font(.largeTitle)
                    .padding()

                NavigationLink(destination: ProfileView()) {
                    Text("进入个人中心")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                Spacer()
            }
        }
    }
}

struct ProfileView: View {
    var body: some View {
        ZStack {
            // 添加背景图像
            Image("backgroundImage")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            // 其他内容
            VStack {
                Text("个人中心")
                    .font(.largeTitle)
                    .padding()

                // 其他个人中心内容
                Spacer()
            }
        }
    }
}

