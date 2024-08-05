//
//  MockURLSessionProtocol.swift
//  SimpleMovieApp
//
//  Created by Tow Ching Shen on 04/08/2024.
//

import Foundation

class MockURLSessionProtocol: URLProtocol {
    static var loadingHandler: (() -> (HTTPURLResponse, Data?, Error?))?
    
    override class func canInit(
        with request: URLRequest
    ) -> Bool {
        return true
    }
    
    override class func canonicalRequest(
        for request: URLRequest
    ) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLSessionProtocol.loadingHandler else {
            fatalError("Loading handler is not set.")
        }
        
        let (response, data, error) = handler()
        
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        
        if let data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}
