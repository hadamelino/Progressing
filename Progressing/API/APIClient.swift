//
//  APIClient.swift
//  AcademyLOTracker
//
//  Created by Hada Melino Muhammad on 22/07/22.
//

import Foundation
import RxSwift

extension API {
    
    class Client {
        static let shared = Client()
        static let utilities = Utilities()
        
        var headers = [
            "Accept": "application/json",
            "Notion-Version": "2022-02-22",
            "Authorization": utilities.getApiKey()
        ]
                
        func request<T: Codable>(
            endpoint: Types.Endpoint,
            method: Types.Method,
            expecting: T.Type,
            body: Data = Data()
        ) -> Observable<T> {
            return Observable.create { observer in
                var urlRequest = URLRequest(url: endpoint.url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
                urlRequest.httpMethod = method.rawValue
                
                if !body.isEmpty {
                    urlRequest.httpBody = body
                    self.headers["Content-Type"] = "application/json"
                }
                urlRequest.allHTTPHeaderFields = self.headers
                
                let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                    guard let data = data else {
                        if let error = error {
                            observer.onError(error)
                        }
                        return
                    }
                    do {
                        let result = try JSONDecoder().decode(expecting, from: data)
                        observer.onNext(result)
                    } catch {
                        observer.onError(error)
                    }
                }
                task.resume()
                return Disposables.create{ }
            }
        }
    }
}

