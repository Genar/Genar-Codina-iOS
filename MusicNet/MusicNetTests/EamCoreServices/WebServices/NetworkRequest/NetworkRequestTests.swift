//
//  NetworkRequestTest.swift
//  MusicNetTests
//
//  Created by Genaro Codina Reverter on 6/3/21.
//

import XCTest
@testable import MusicNet

class NetworkRequestTests: XCTestCase {
    
    var requestService: RequestServiceProtocol? // SUT
    
    var mockUrlSession: URLSessionMock?

    override func setUpWithError() throws {
        
        requestService = RequestService()
        mockUrlSession = URLSessionMock()
    }

    override func tearDownWithError() throws {
        
        mockUrlSession = nil
        requestService = nil
    }
    
    func testSetAccessToken() {
        
        let tokenEntity = TokenEntity(accessToken: "123456", expiresIn: 3600, tokenType: "Bearer")
        requestService?.setAccessToken(token: tokenEntity)
        
        let httpHeader = requestService?.sessionConfig.httpAdditionalHeaders?["Authorization"] as? String
        
        XCTAssertEqual(requestService?.tokenEntity?.accessToken, tokenEntity.accessToken)
        XCTAssertEqual(requestService?.tokenEntity?.expiresIn, tokenEntity.expiresIn)
        XCTAssertEqual(requestService?.tokenEntity?.tokenType, tokenEntity.tokenType)
        XCTAssertEqual("Bearer 123456", httpHeader)
    }
    
    func testRequest() {
        
        // Create data and tell the session to always return it
        //let mockUrlSession = URLSessionMock()
        requestService?.defaultSession = mockUrlSession!
        let dummyEntity = DummyModel(name: "hi")
        let data = try! JSONEncoder().encode(dummyEntity)
        mockUrlSession!.data = data

        // Create a URL
        let url = URL(fileURLWithPath: "dummyurl")

        // Perform the request and verify the result
        _ = requestService!.request(url) { (result: Result<DummyModel>) in
            switch result {
            case .success(let data):
                XCTAssertEqual("hi", data.name)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testRequestFail() {
        
        // Create data and tell the session to always return it
        //let mockUrlSession = URLSessionMock()
        requestService?.defaultSession = mockUrlSession!
        let dummyEntity = DummyModelNotCodable(name: "hi")
        let data = encode(value: dummyEntity)
        mockUrlSession!.data = data as Data

        // Create a URL
        let url = URL(fileURLWithPath: "dummyurl")

        // Perform the request and verify the result
        _ = requestService!.request(url) { (result: Result<DummyModel>) in
            switch result {
            case .success( _):
                XCTFail("Must not success")
            case .failure( _):
                XCTAssertTrue(true)
            }
        }
    }
}

func encode<T>( value: T) -> NSData {
    
    return withUnsafePointer(to:value) { p in
        NSData(bytes: p, length: MemoryLayout.size(ofValue:value))
    }
}

func decode<T>(data: NSData) -> T {
    
    let capacity = MemoryLayout.size(ofValue:T.self)
    let pointer = UnsafeMutablePointer<T>.allocate(capacity: capacity)
    data.getBytes(pointer, length: capacity)
    return pointer.move()
}
