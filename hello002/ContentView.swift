//
//  ContentView.swift
//  hello002
//
//  Created by jishengbao on 2024/7/12.
//

import SwiftUI
import SwiftData


// 定时器逻辑封装在ObservableObject中
class TimerViewModel: ObservableObject {
    @Published var time = 0 // 用于记录时间的变量，使用@Published使其可观察
    @Published var items: [Item] = []
    private let locationService = LocationService()
    @Published var username = ""
    @Published var hisname = ""
    
    private let locationViewModel = LocationViewModel()

    
    init() {
        // 这里可以放置一些初始化代码，但在这个例子中，它是空的
    }
    
    private var timer: Timer?
      
    func startTimer() {
        // 停止之前的定时器（如果有的话）
        stopTimer()
          
        // 创建一个新的定时器，每秒更新一次
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] timer in
            //self?.time += 1 // 更新时间
            //print( self?.time)
            print( Date())
            let ss = Double.random(in: 1...100)
            
            print("timer..Username: \(self?.username)")
            
            let tt = ""
            if let username = self?.username {
                //上报当前用户坐标
                if let location = self?.locationViewModel.location {
                    print("Latitude: \(location.coordinate.latitude)")
                    self?.locationService.createLocation(username: username,
                                                         longitude:location.coordinate.longitude,
                                                         latitude:location.coordinate.latitude) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let todo):
                                //self.todos.append(todo)
                                print("succ")
                            case .failure(let error):
                                print("Error creating todo: \(error)")
                            }
                        }
                    }
                } else {
                    print("Loading location...")
                }
            } else {
                print("username is nil")
            }
            
            if let hisname = self?.hisname {
                print(hisname)  // 输出: ssss
                //获取hisname的位置信息
                if let location = self?.locationViewModel.location {
                    print("Latitude: \(location.coordinate.latitude)")
                    self?.locationService.fetchLoactions(username: hisname,
                                                         longitude:location.coordinate.longitude,
                                                         latitude:location.coordinate.latitude) { 
                        [weak self] result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let todos):
                                print("todoooooo---\(todos)")
                                //self?.items = todos
                            case .failure(let error):
                                print("todoooooo---\(error)")
                                //self?.errorMessage = error.localizedDescription
                            }
                        }
                    }
                } else {
                    print("Loading location...")
                }
            } else {
                print("hisname is nil")
            }
            
            
            
            let newItem = Item(timestamp: Date(), s:ss)
            self?.items.append(newItem)
            if(self?.items.count == 10) {
                self?.items = []
            }
             
            
            
            
            
            
            
             
        }
    }
      
    func stopTimer() {
        // 停止并释放定时器
        timer?.invalidate()
        timer = nil
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
   
    @StateObject private var timerViewModel = TimerViewModel()
    @State private var username: String = ""
    @State private var hisname: String = ""

    

    var body: some View {
        NavigationSplitView {
            
            if timerViewModel.items.isEmpty {
                Text("欢迎您来到山海")
                    .font(.largeTitle)
                    .padding()

                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding()
                
                
                Text("Login")
                    .font(.largeTitle)
                    .padding(.bottom, 40)
                
                TextField("你的名字", text: $username)
                    .padding()
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                
                TextField("他的名字", text: $hisname)
                    .padding()
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)


                Button(action: {
                    //self.login()
                    print("Username: \(username)")
                    timerViewModel.username = username
                    timerViewModel.hisname = hisname
                    
                }) {
                    Text("登录")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(Color.blue)
                        .cornerRadius(15.0)
                }

                Spacer()
    
                Button("探寻他的位置") {
                    timerViewModel.startTimer()
                    //timerViewModel.time = 100
                }
            } else {
                List {
                    ForEach(timerViewModel.items) { item in
                        NavigationLink {
                            Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                        } label: {
                            Text("\(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))&nbsp;&nbsp;&nbsp;&nbsp;相距\(item.s)米")
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
    #if os(macOS)
                .navigationSplitViewColumnWidth(min: 180, ideal: 200)
    #endif
                .toolbar {
    #if os(iOS)
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
    #endif
                    ToolbarItem {
                        Button(action: addItem) {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                }
                .onAppear(){
                    
                    let ss = Double.random(in: 1...100)
                    let newItem = Item(timestamp: Date(), s:ss)
                        modelContext.insert(newItem)
                    
                    let newItem2 = Item(timestamp: Date(),s:100)
                        modelContext.insert(newItem2)
                    
                    timerViewModel.startTimer()
                }
                
            }
            
            
            
           
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let ss = Double.random(in: 1...100)
            let newItem = Item(timestamp: Date(), s:ss)
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
