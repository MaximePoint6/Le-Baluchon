//
//  URLSessionFake.swift
//  Le BaluchonTests
//
//  Created by Maxime Point on 09/12/2022.
//

import Foundation

class URLSessionFake: URLSession {
    
    var data: Data?
    var response: URLResponse?
    var error: Error?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    override func dataTask(with url: URL,
                           completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        if let task = super.dataTask(with: url, completionHandler: completionHandler) as? URLSessionDataTaskFake {
            task.completionHandler = completionHandler
            task.data = data
            task.urlResponse = response
            task.responseError = error
            return task
        }
        return super.dataTask(with: url, completionHandler: completionHandler)
    }
    
    override func dataTask(with request: URLRequest,
                           completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        if let task = super.dataTask(with: request, completionHandler: completionHandler) as? URLSessionDataTaskFake {
            task.completionHandler = completionHandler
            task.data = data
            task.urlResponse = response
            task.responseError = error
            return task
        }
        return super.dataTask(with: request, completionHandler: completionHandler)
    }
    
}


class URLSessionDataTaskFake: URLSessionDataTask {
    
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    var data: Data?
    var urlResponse: URLResponse?
    var responseError: Error?
    
    override func resume() {
        completionHandler?(data, urlResponse, responseError)
    }
    
    override func cancel() {}
    
}