//
//  Item.swift
//  hello002
//
//  Created by jishengbao on 2024/7/12.
//

import Foundation
import SwiftData

struct Location: Decodable, Encodable {
    var username: String
    var longitude: Double
    var latitude: Double
    
    
   
   init(username: String, longitude: Double, latitude: Double) {
       self.username = username
       self.longitude = longitude
       self.latitude = latitude
   }
     
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
  
        // 我们可以选择性地编码属性
        try container.encode(username, forKey: .username)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        // 注意我们没有编码 hiddenProperty
    }
    
    
    // 实现Decodable协议所需的初始化方法
    init(from decoder: Decoder) throws {
        // 使用container(keyedBy:)方法获取一个解码容器，该容器允许我们通过键来访问JSON中的值
        let container = try decoder.container(keyedBy: CodingKeys.self)
  
        // 从JSON中解码每个属性
        username = try container.decode(String.self, forKey: .username)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
    }
  
    // 为了使用container(keyedBy:)方法，我们需要定义一个枚举来作为键的类型
    private enum CodingKeys: String, CodingKey {
        case username, latitude, longitude
    }
}

