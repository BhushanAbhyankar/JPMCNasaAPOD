//
//  PicOfDayViewModelTests.swift
//  JPMCNasaAPODTests
//
//  Created by Bhushan Abhyankar on 12/11/2024.
//

import XCTest
@testable import JPMCNasaAPOD

final class PicOfDayViewModelTests: XCTestCase {
    var viewModel : PicOfDayViewModel!
    var mockRepository: MockPicOfDayRepository!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        //Given
        mockRepository = MockPicOfDayRepository()
        viewModel = PicOfDayViewModel(repository: mockRepository)
    }
    

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        mockRepository = nil
    }

    func testgetPictureOfTheDay_WhenExpecting_CorrectData() async throws {
      
        //given
        mockRepository.setPicOfDayResponse(picOfDayResponse: PicOfDayResponse.mockPicOfDayResponse())
        let testImageData = "Some dummy Test data".data(using: .utf8)
        mockRepository.setimageData(data: testImageData!)
        //when
        await viewModel.getPictureOfTheDay(for:"2024-11-11")
        
        //then
        XCTAssertNotNil(viewModel)
        
        switch viewModel.viewState{
        case .loading:
            break
        case .loaded(let data):
            XCTAssertEqual(data.title,"The Unusual Tails of Comet Tsuchinshan-Atlas")
            XCTAssertEqual(data.date,"2024-11-11")
            XCTAssertEqual(data.explanation,"What created an unusual dark streak in Comet Tsuchinshan-Atlas's tail? Some images of the bright comet during mid-October not only caught its impressively long tail and its thin anti-tail, but a rather unexpected feature: a dark streak in the long tail. The reason for the dark streak is currently unclear and a topic of some debate.  Possible reasons include a plume of dark dust, different parts of the bright tail being unusually superposed, and a shadow of a dense part of the coma on smaller dust particles. The streak is visible in the featured image taken on October 14 from Texas, USA. To help future analyses, if you have taken a good image of the comet that clearly shows this dark streak, please send it in to APOD. Comet Tsuchinshan–ATLAS has now faded considerably and is returning to the outer Solar System.   Gallery: Comet Tsuchinshan-ATLAS in 2024")
            XCTAssertEqual(data.mediaType,"image")
            XCTAssertEqual(data.serviceVersion,"v1")
            XCTAssertEqual(data.url,"https://apod.nasa.gov/apod/image/2411/CometDarkTail_Falls_960.jpg")
            XCTAssertEqual(data.hdurl,"https://apod.nasa.gov/apod/image/2411/CometDarkTail_Falls_5122.jpg")
            XCTAssertEqual(data.copyright,"\nBray Falls\n")
            XCTAssertNotNil(viewModel.dayImageData)

        case .error(_):
            break
        }

    }

    
    func testgetPictureOfTheDay_WhenExpecting_DecodingError() async throws {
      
        //given
        mockRepository.setPicOfDayResponse(picOfDayResponse: PicOfDayResponse.mockPicOfDayResponse())
        mockRepository.setError(error: NetworkError.decodingError)

        //when
        await viewModel.getPictureOfTheDay(for:"2024-11-11")
        
        //then
        XCTAssertNotNil(viewModel)
        
        switch viewModel.viewState{
        case .loading:
            break
        case .loaded(_):
            break
        case .error(let error):
            XCTAssertEqual(error as! NetworkError,NetworkError.decodingError)
            XCTAssertEqual(error.localizedDescription,"Failed to parse API Resonse")
            XCTAssertNil(viewModel.dayImageData)
            break
        }
    }
    
    func testgetPictureOfTheDay_WhenDateIsWrongExpecting_InvalidURLError() async throws {
      
        //given
        mockRepository.setPicOfDayResponse(picOfDayResponse: PicOfDayResponse.mockPicOfDayResponse())
        mockRepository.setError(error: NetworkError.invalidURL)

        //when
        await viewModel.getPictureOfTheDay(for:"wrong URL")
        
        //then
        XCTAssertNotNil(viewModel)
        
        switch viewModel.viewState{
        case .loading:
            break
        case .loaded(_):
            break
        case .error(let error):
            XCTAssertEqual(error as! NetworkError,NetworkError.invalidURL)
            XCTAssertEqual(error.localizedDescription,"API EndPoint URL is Invalid")
            XCTAssertNil(viewModel.dayImageData)
            break
        }
    }
    
    func testgetPictureOfTheDay_WhenDateIsCorrectExpecting_InvalidResponseError() async throws {
      
        //given
        mockRepository.setPicOfDayResponse(picOfDayResponse: PicOfDayResponse.mockPicOfDayResponse())
        mockRepository.setError(error: NetworkError.invalidResponse)

        //when
        await viewModel.getPictureOfTheDay(for:"2024-11-11")
        
        //then
        XCTAssertNotNil(viewModel)
        
        switch viewModel.viewState{
        case .loading:
            break
        case .loaded(_):
            break
        case .error(let error):
            XCTAssertEqual(error as! NetworkError,NetworkError.invalidResponse)
            XCTAssertEqual(error.localizedDescription,"Got Invalid response code from API Endpoint,No data available for this date")
            XCTAssertNil(viewModel.dayImageData)
            break
        }
    }
    
    func testgetPictureOfTheDay_WhenDateIsCorrectExpecting_InvalidImage() async throws {
      
        //given
        mockRepository.setPicOfDayResponse(picOfDayResponse: PicOfDayResponse.mockPicOfDayResponse())
        mockRepository.setError(error: NetworkError.invalidURLComponents)

        //when
        await viewModel.getPictureOfTheDay(for:"2024-11-11")
        
        //then
        XCTAssertNotNil(viewModel)
        
        switch viewModel.viewState{
        case .loading:
            break
        case .loaded(_):
            break
        case .error(let error):
            XCTAssertEqual(error as! NetworkError,NetworkError.invalidURLComponents)
            XCTAssertEqual(error.localizedDescription,"InCorect URL parameters")
            XCTAssertNil(viewModel.dayImageData)
            break
        }
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
