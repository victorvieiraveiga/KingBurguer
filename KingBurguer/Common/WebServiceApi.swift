//
//  WebServiceApi.swift
//  KingBurguer
//
//  Created by Victor Vieira Veiga on 25/07/24.
//

import Foundation

class WebServiceApi {
    
    static let apiKey = "98a491ef-432b-4f7d-85ff-a8bbef04c0df"
    static let baseURL = "https://hades.tiagoaguiar.co/kingburguer"
    
    static let shared = WebServiceApi()
    
    enum Endpoint: String {
        case createUser = "/users"
        case login = "/auth/login"
        case refreshToken = "/auth/refresh-token"
        case feed = "/feed"
        case highlight = "/highlight"
        case productDetail = "/products/%d"
    }
    
    enum Method: String {
        case post
        case put
        case get
        case delete
    }
    
    enum NetworkError {
        case unauthorized
        case badRequest
        case notFound
        case internalError
        case unknown
    }
    
    enum Result {
        case success(Data?)
        case failure(NetworkError, Data?)
    }
    
    private func completeUrl(path: String) -> URLRequest? {
        let endpoint = "\(WebServiceApi.baseURL)\(path)"
        guard let url = URL(string: endpoint) else {
            print("ERROR: URL \(endpoint) malformed!")
            return nil
        }
        return URLRequest(url: url)
    }
    
    // possibilidade de passar uma url dinamico (PURA) /products/123123
    func call(path: String, method: Method, accessToken: String? = nil, completion: @escaping (Result) -> Void) {
        makeRequest(path: path, body: nil, method: method, accessToken: accessToken, completion: completion)
    }
    
    // possibilidade de passar uma url por ENDPOINT + body
    func call<R: Encodable>(path: Endpoint, body: R?, method: Method, accessToken: String? = nil, completion: @escaping (Result) -> Void) {
        makeRequest(path: path.rawValue, body: body, method: method, accessToken: accessToken, completion: completion)
    }
    
    func makeRequest(path: String, body: Encodable?, method: Method, accessToken: String? = nil, completion: @escaping (Result) -> Void) {
        do {
            guard var request = completeUrl(path: path) else { return }

            request.httpMethod = method.rawValue.uppercased()
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "accept")
            request.setValue(WebServiceApi.apiKey, forHTTPHeaderField: "x-secret-key")
            
            if let accessToken = accessToken {
                request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            }
        
            
            if let body = body {
                let jsonRequest = try JSONEncoder().encode(body)
                request.httpBody = jsonRequest
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                // asincrono
                // XPTO-THREAD
                print("Response is \(String(describing: response))")
                print("----------------------------\n\n")
                
                if let error = error {
                    print(error)
                    completion(.failure(.internalError, data))
                    return
                }
                
                if let r = response as? HTTPURLResponse {
                    switch r.statusCode {
                        case 200:
                            completion(.success(data))
                            break
                        case 401:
                            completion(.failure(.unauthorized, data))
                            break
                        case 404:
                            completion(.failure(.notFound, data))
                            break
                        case 400:
                            completion(.failure(.badRequest, data))
                            break
                        case 500:
                            completion(.failure(.internalError, data))
                            break
                        default:
                            completion(.failure(.unknown, data))
                            break
                    }
                }
            }
            
            task.resume()
        } catch {
            print(error)
            return
        }
    }
}
