//
//  NASA_Image_SearcherTests.swift
//  NASA Image SearcherTests
//
//  Created by Adam Zuspan on 6/4/23.
//

import XCTest
import Combine
@testable import NASA_Image_Searcher

final class NASA_Image_SearcherTests: XCTestCase {
    
    var viewModel: SearchResultsViewModel!
    var mockNetworkService: MockNetworkService!
    let query = "Buzz"
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        viewModel = SearchResultsViewModel(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    func testGetSearchResultsFor_SuccessfulResponse_FirstPage() async {
        let expectation = XCTestExpectation(description: ExpetationDescriptions.successfulResponseFirstPage.rawValue)
        
        await viewModel.getSearchResultsFor(query: query)
        XCTAssertNotNil(mockNetworkService.mockResponse)
        let observationCollectionOfData = viewModel.$collectionOfData.sink { collectionOfData in
            XCTAssertNotNil(collectionOfData)
            XCTAssertEqual(self.mockNetworkService.mockResponse?.collection, collectionOfData)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
        observationCollectionOfData.cancel()
    }
    
    func testGetSearchResultsFor_FailedResponse_FirstPage() async {
        let expectation = XCTestExpectation(description: ExpetationDescriptions.failedResponseFirstPage.rawValue)
        
        mockNetworkService.shouldReturnSuccess = false
        let observationShowError = viewModel.$showError.sink { showError in
            if showError {
                XCTAssert(showError)
                expectation.fulfill()
            }
        }
        let observationCollectionOfData = viewModel.$collectionOfData.sink { collectionOfData in
            XCTAssertNil(collectionOfData)
            XCTAssertNil(self.mockNetworkService.mockResponse)
            expectation.fulfill()
        }
        await viewModel.getSearchResultsFor(query: query)
        
        wait(for: [expectation], timeout: 3)
        
        observationCollectionOfData.cancel()
        observationShowError.cancel()
    }
    
    func testGetSearchResultsFor_SuccessfulResponse_NextPage() async {
        let expectation = XCTestExpectation(description: ExpetationDescriptions.successfulResponseNextPage.rawValue)
        let expectedCurrentPageNumber = 2
        let expectedMaxNumberOfPages = 5
        
        mockNetworkService.desiredPage = expectedCurrentPageNumber
        
        await viewModel.getSearchResultsFor(query: query)
        await viewModel.loadNextPage(query: query)
        let observationCollectionOfData = viewModel.$collectionOfData.sink { collectionOfData in
            XCTAssertNotNil(collectionOfData)
            XCTAssertNotNil(self.mockNetworkService.mockResponse)
            XCTAssertNotEqual(self.mockNetworkService.mockResponse?.collection, collectionOfData)
            expectation.fulfill()
        }
        
        XCTAssert(viewModel.currentPage == expectedCurrentPageNumber)
        XCTAssert(viewModel.maxNumberOfPages == expectedMaxNumberOfPages)
        
        expectation.fulfill()
        wait(for: [expectation], timeout: 3)
        
        observationCollectionOfData.cancel()
    }
    
    func testGetSearchResultsFor_FailedResponse_NextPage() async {
        let expectation = XCTestExpectation(description: ExpetationDescriptions.failedResponseNextPage.rawValue)
        let expectedMaxNumberOfPages = 5
        let nonValidPageCount = expectedMaxNumberOfPages + 1
        
        await viewModel.getSearchResultsFor(query: query)
        
        for _ in 0...nonValidPageCount {
            await viewModel.loadNextPage(query: query)
        }
        
        XCTAssert(viewModel.currentPage == nonValidPageCount)
        XCTAssert(viewModel.maxNumberOfPages == expectedMaxNumberOfPages)
        
        expectation.fulfill()
        wait(for: [expectation], timeout: 3)
    }
    
    func testImageURLs() async {
        let expectation = XCTestExpectation(description: ExpetationDescriptions.imageURLs.rawValue)
        let expectedImageURL = URL(string:"https://images-assets.nasa.gov/image/ED07-0204-46/ED07-0204-46~thumb.jpg")
    
        await viewModel.getSearchResultsFor(query: query)
        let observationCollectionOfData = viewModel.$collectionOfData.sink { collectionOfData in
            if let mockResponseLinks = self.mockNetworkService.mockResponse?.collection.items.first?.links,
               let viewModelLinks = collectionOfData?.items.first?.links {
                let linkURLs = self.viewModel.imageURLFor(links: mockResponseLinks)
                XCTAssert(expectedImageURL == linkURLs.first)
                XCTAssert(mockResponseLinks == viewModelLinks)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3)
        
        observationCollectionOfData.cancel()
    }
    
    func testRetrieveDataForDetailView() async {
        let expectation = XCTestExpectation(description: ExpetationDescriptions.retrieveDataForDetailView.rawValue)
        let expectedTitle = "Members of the SOFIA infrared observatory support team gather around Apollo 11 astronaut Buzz Aldrin (in red shirt) during Aldrin's tour of NASA Dryden"
        
        let expectedDescription = "Members of the SOFIA infrared observatory support team gather around Apollo 11 astronaut Buzz Aldrin (in red shirt) during Aldrin's tour of NASA Dryden."
        
        let expectedFormattedDate = "Aug 24, 2007, 5:00 PM"
        await viewModel.getSearchResultsFor(query: query)
        let observationCollectionOfData = viewModel.$collectionOfData.sink { value in
            if let data = value?.items.first?.data.first,
               let links = value?.items.first?.links {
                let dataForDetailView = self.viewModel.retrieveDataForDetailView(data: data, links: links)
                XCTAssert(dataForDetailView.title == expectedTitle)
                XCTAssert(dataForDetailView.description == expectedDescription)
                XCTAssert(dataForDetailView.dateCreated == expectedFormattedDate)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 5)
        observationCollectionOfData.cancel()
    }
}

final class MockNetworkService: NetworkService {
    
    var shouldReturnSuccess: Bool = true
    var desiredPage: Int = 1
    var mockResponse: SearchedDataListModel?
    var mockError: Error?
    
    override func makeAPIRequest<T: Decodable>(path: String, queryItems: [URLQueryItem]) async throws -> T {
        if shouldReturnSuccess {
            createMockResponse()
            guard let response = mockResponse as? T else {
                throw NSError(domain: "MockNetworkService", code: 0, userInfo: nil)
            }
            return response
        } else {
            throw mockError ?? NSError(domain: "MockNetworkService", code: 0, userInfo: nil)
        }
    }
    
    private func createMockResponse() {
        let decoder = JSONDecoder()
        
        guard let fileURL = Bundle.main.url(forResource: "BuzzSampleFirstPageJSON", withExtension: "json") else {
            XCTFail("Failed to locate BuzzSampleJSON.json in the bundle.")
            return
        }
        guard let jsonData = try? Data(contentsOf: fileURL) else {
            XCTFail("Failed to load data from data.json.")
            return
        }
        guard let expectedItems = try? decoder.decode(SearchedDataListModel.self, from: jsonData) else {
            XCTFail("Failed to decode JSON data into [Item].")
            return
        }
        mockResponse = expectedItems
    }
}

extension NASA_Image_SearcherTests {
    enum ExpetationDescriptions: String {
        case successfulResponseFirstPage = "First Page Successful from Async Network Call"
        case failedResponseFirstPage = "First Page Failed from Async Network Call"
        case successfulResponseNextPage = "Next Page Successful From Async Network Call"
        case failedResponseNextPage = "Next Page Failed From Async Network Call"
        case imageURLs = "Get Images From Async Network Call"
        case retrieveDataForDetailView = "Get Data For Detail View From Async Network Call"
    }
}


