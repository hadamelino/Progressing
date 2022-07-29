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
        
        let headers = [
            "Accept": "application/json",
            "Notion-Version": "2022-02-22",
            "Authorization": "secret_EOlEjtZ4Mkj330icjACrLhGfZcNx0kUQcmQxf8Rc3rI"
        ]
                
        func request<T: Codable>(
            endpoint: Types.Endpoint,
            method: Types.Method,
            expecting: T.Type
        ) -> Observable<T> {
            return Observable.create { observer in

                var urlRequest = URLRequest(url: endpoint.url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
                urlRequest.httpMethod = method.rawValue
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

