//
//  MoviesViewModelTests.swift
//  MovieAppTests
//
//  Created by Jigar Oza on 21/02/25.
//

import XCTest
import Combine
@testable import MovieApp

class MoviesViewModelTests: XCTestCase {
    var viewModel: MoviesViewModel!
    var mockHTTPClient: MockHTTPClient!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        mockHTTPClient = MockHTTPClient()
        viewModel = MoviesViewModel(httpClient: mockHTTPClient)
    }

    override func tearDown() {
        viewModel = nil
        mockHTTPClient = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testFetchMovies() {
        // Given
        let mockMovies = [Movie(title: "Inception", year: "2010"), Movie(title: "Interstellar", year: "2014")]
        mockHTTPClient.mockMovies = mockMovies

        // When
        let expectation = XCTestExpectation(description: "Movies fetched successfully")
        viewModel.$movies
            .dropFirst()
            .sink { movies in
                // Then
                XCTAssertEqual(movies.count, 2)
                XCTAssertEqual(movies.first?.title, "Inception")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.setSearchText("Christopher Nolan")
        wait(for: [expectation], timeout: 2)
    }
}

class MockHTTPClient: HTTPClient {
    var mockMovies: [Movie] = []
    var shouldFail = false

    override func fetchMovies(searchText: String) -> AnyPublisher<[Movie], Error> {
        if shouldFail {
            return Fail(error: NetwrorkError.decodingFailed).eraseToAnyPublisher()
        } else {
            return Just(mockMovies)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
