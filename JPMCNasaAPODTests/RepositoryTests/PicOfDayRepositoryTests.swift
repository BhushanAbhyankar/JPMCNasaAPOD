//
//  PicOfDayRepositoryTests.swift
//  JPMCNasaAPODTests
//
//  Created by Bhushan Abhyankar on 12/11/2024.
//

import XCTest
@testable import JPMCNasaAPOD

final class PicOfDayRepositoryTests: XCTestCase {
    
    var repository:PicOfDayRepository!
    var fakeNetworkManager:FakeNetworkManager!
    var cacheManager:MockCacheManager!

    override func setUpWithError() throws {
        fakeNetworkManager = FakeNetworkManager()
        cacheManager = MockCacheManager()
        repository = PicOfDayRepository(manager: fakeNetworkManager, cacheManager: cacheManager)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        repository = nil
        fakeNetworkManager = nil
        cacheManager = nil
    }

    func testGetPictureOfTheDayData_whenExpectingValidOutput_WhenCacheIsNotAvailabel() async throws {
        //when
        fakeNetworkManager.mockPath = "PODValidTest"
        let data = try await repository.getPictureOfTheDayData(for: "2024-11-11")
        
        //then
        XCTAssertNotNil(fakeNetworkManager)
        XCTAssertNotNil(repository)
        XCTAssertNotNil(data)

    }
    func testGetPictureOfTheDayData_whenExpectingValidOutput_WhenCacheIsAvailabel() async throws {
        //when
        fakeNetworkManager.mockPath = "PODValidTest"
        let cachedResponse = PicOfDayResponse.mockPicOfDayResponse()
        let testDate = "2022-11-11"

        cacheManager.cacheData(cachedResponse, key: testDate)
        let data = try await repository.getPictureOfTheDayData(for: testDate)
        XCTAssertEqual(data.title, cachedResponse.title)
        XCTAssertEqual(data.url, cachedResponse.url)
        XCTAssertEqual(data.explanation,cachedResponse.explanation)
        XCTAssertEqual(data.mediaType,cachedResponse.mediaType)
        XCTAssertEqual(data.serviceVersion,cachedResponse.serviceVersion)
        XCTAssertEqual(data.url,cachedResponse.url)
        XCTAssertEqual(data.hdurl,cachedResponse.hdurl)
        XCTAssertEqual(data.copyright,cachedResponse.copyright)

        //then
        XCTAssertNotNil(fakeNetworkManager)
        XCTAssertNotNil(repository)
        XCTAssertNotNil(data)

    }

    func testGetPictureOfTheDayData_whenExpectingInValidOutput() async throws {
        //when
        fakeNetworkManager.mockPath = "PODInValidTest"
        do{
            let _ = try await repository.getPictureOfTheDayData(for: "2024-11-11")
        }catch{
            //then
            XCTAssertNotNil(fakeNetworkManager)
            XCTAssertNotNil(repository)
            XCTAssertNotNil(error)
        }
    }
    
    func testGetPictureOfTheDayData_whenExpectingNoData() async throws {
        //when
        fakeNetworkManager.mockPath = "PODTestNoData"
        do{
            let _ = try await repository.getPictureOfTheDayData(for: "2024-11-11")
        }catch{
            //then
            XCTAssertNotNil(fakeNetworkManager)
            XCTAssertNotNil(repository)
            XCTAssertNotNil(error)
        }
    }
    
    func testLoadImage_CachedImageDataAvailable() async throws {
        // Given
        let imageURL = "https://test.com/image.jpg"
        let testImageData = "Some dummy Test data".data(using: .utf8)
        cacheManager.cacheImageData(testImageData!, for: imageURL)
        
        // When
        let result = try await repository.loadImage(for: imageURL)
        
        // Then
        XCTAssertEqual(result, testImageData)
    }
    
    func testLoadImage_NetworkFetchesImageDataAndCachesIt() async throws {
        // Given
        let imageURL = "https://test.com/image.jpg"
        let testImageData = "Some dummy Test data".data(using: .utf8)
        fakeNetworkManager.setimageData(data: testImageData!)
        
        // When
        let result = try await repository.loadImage(for: imageURL)
        
        // Then
        XCTAssertEqual(result, testImageData)
        
    }
    
    func testLoadImage_InvalidURLThrowsError() async {
        // Given
        let invalidURL = "invalid-url"
        let testImageData = "Some dummy Test data".data(using: .utf8)
        fakeNetworkManager.setimageData(data: testImageData!)

        // When & Then
        do{
            let _ = try await repository.loadImage(for: invalidURL)
        }catch{
            XCTAssertEqual(error as? NetworkError, NetworkError.invalidURL)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
