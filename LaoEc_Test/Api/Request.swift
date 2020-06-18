//
//  CommonRequest.swift
//  LaoEc_Test
//
//  Created by Chinh on 10/14/19.
//  Copyright © 2019 Chinh. All rights reserved.
//

import Foundation

struct URLToRequest {
    var string: String
    var urlImage : URL
    var urlProductLimit : URL
    static var urlProduct  = URL(string: "https://laosec-dev.grooo.xyz/api/product")!
    static var urlCategory = URL(string: "https://laosec-dev.grooo.xyz/api/category")!
    static var urlBanner = URL(string: "https://laosec-dev.grooo.xyz/api/banner")!
    static var urlOptionProduct = URL(string: "https://laosec-dev.grooo.xyz/api/product?limit=6")!
    
    init(string:String) {
        self.string = string
        self.urlProductLimit = URL(string: "https://laosec-dev.grooo.xyz/api/product?limit=\(string)")!
        self.urlImage = URL(string: "https://laosec-dev.grooo.xyz/files/\(string)")!
    }
    
}

//LOGIN
enum APIError: Error {
    case responseProblem
    case decodingProblem
    case otherProblem
    case encodingProblem
}

struct LoginRequest {
    let resourceURL : URL
        init(){
        self.resourceURL = URL(string: "https://laosec-dev.grooo.xyz/api/member/auth/login")!
    }
    
    func sendData(_ dataToBeSent: AuthLogin, completion: @escaping(Result<GetLogin, APIError>)->Void){
        do {
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            if var urlComponents = URLComponents(url: resourceURL, resolvingAgainstBaseURL: false) {
                   urlComponents.queryItems = [URLQueryItem]()
                var queryItem = URLQueryItem(name: "phone", value: "\(dataToBeSent.phone)")
                       urlComponents.queryItems?.append(queryItem)
                queryItem = URLQueryItem(name: "password", value: "\(dataToBeSent.password)")
                       urlComponents.queryItems?.append(queryItem)
                   urlRequest.url = urlComponents.url
               }
               
            let dataTask = URLSession.shared.dataTask(with: urlRequest) {data,response, _ in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
                    let jsonData = data else {
                    completion(.failure(.responseProblem))
                    return
                }

                
                do {
                    _ = String(bytes: jsonData, encoding: .utf8)
                    let sentData = try JSONDecoder().decode(GetLogin.self, from: jsonData)
                    completion(.success(sentData))
                }catch {
                    print(error)
                    completion(.failure(.decodingProblem))
                }
                
            }
            dataTask.resume()
        } catch {
            completion(.failure(.encodingProblem))
        }
    }
}

public func getData<T: Codable>(url: URL, completion:@escaping (T)->()) {
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        if error != nil {
            print(error as Any)
            return
        }
        guard let data = data else { return }
        do {
            let data = try JSONDecoder().decode(T.self, from: data)
            DispatchQueue.main.async {
                completion(data)
            }
        } catch let err {
            print("decode error: ", err)
        }
    }.resume()
}

