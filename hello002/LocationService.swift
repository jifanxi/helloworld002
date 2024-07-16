//
//  LocationService.swift
//  hello002
//
//  Created by jishengbao on 2024/7/14.
//

import Foundation


class LocationService {
    private let baseURL = URL(string: "http://localhost:8085")!
    
    func fetchLoactions(username: String, longitude: Double, latitude: Double,completion: @escaping (Result<[Location], Error>) -> Void) {
        let url = baseURL.appendingPathComponent("/locations")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let user: [String: Any] =  ["username": username, "longitude": longitude, "latitude": latitude]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: user, options: []) else { return }
        
        request.httpBody = httpBody
        
        print("page====----") // 打印请求信息
        print("Request URL: \(request.url?.absoluteString ?? "")")
        print("HTTP Method: \(request.httpMethod ?? "")")
        print("HTTP Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("HTTP Body: \(bodyString)")
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            
            guard let data = data, error == nil else {
                // 处理错误或没有数据的情况
                print(error ?? "No data")
                return
            }
            do {
                let todos = try JSONDecoder().decode([Location].self, from: data)
                
                    print("page________: \(todos)")
                completion(.success(todos))
            } catch {
                completion(.failure(error))
            }
            
            /*
            guard let data = data else {
                completion(.failure(NSError(domain: "dataNilError", code: -10001, userInfo: nil)))
                return
            }
            do {
                let todos = try JSONDecoder().decode([Location].self, from: data)
                completion(.success(todos))
            } catch {
                completion(.failure(error))
            }*/
        }.resume()
    }
    
    func createLocation(username: String, longitude: Double, latitude: Double, completion: @escaping (Result<Location, Error>) -> Void) {
        let url = baseURL.appendingPathComponent("/location")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //let newTodo = Location(username: "", longitude: 1, latitude: 2)
        //request.httpBody = try? JSONEncoder().encode(newTodo)
        
        let user: [String: Any] =  ["username": username, "longitude": longitude, "latitude": latitude]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: user, options: []) else { return }
        
        request.httpBody = httpBody
        
        print("----") // 打印请求信息
        print("Request URL: \(request.url?.absoluteString ?? "")")
        print("HTTP Method: \(request.httpMethod ?? "")")
        print("HTTP Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("HTTP Body: \(bodyString)")
        }
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data, error == nil else {
                // 处理错误或没有数据的情况
                print(error ?? "No data")
                return
            }
          
            // 尝试将 data 转换为 JSON 对象
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print(json) // 假设 json 是一个字典，这里可以进一步处
                if let json = json, let code = json["code"] as? Int {
                    print("坐标上报执行成功Code: \(code)")
                } else {
                    print("坐标上报执行失败Code key is missing or its value is not an Int")
                }
            } catch let parsingError {
                print("坐标上报结果解析失败Parsing error: \(parsingError)")
            }
        }.resume()
    }
    
   
}
