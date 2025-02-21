//
//  MoviesViewModel.swift
//  MovieApp
//
//  Created by Jigar Oza on 20/02/25.
//

import Foundation
import Combine

class MoviesViewModel {
    @Published private(set) var movies: [Movie] = []
    @Published var loadingCompleted: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    private let httpClient: HTTPClient
    private var searchSubject = CurrentValueSubject<String, Never>("")
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
        setupSearch()
    }
    
    private func setupSearch() {
        searchSubject
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.loadMovies(search: searchText)
            }
            .store(in: &cancellables)
    }
    
    func setSearchText(_ text: String) {
        searchSubject.send(text)
    }
    
    func loadMovies(search: String) {
        httpClient.fetchMovies(searchText: search)
            .sink { [weak self] completion in
                print("fetchMovies completed")
                switch completion {
                case .finished:
                    self?.loadingCompleted = true
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] movies in
                print("Movies fetched successfully: \(movies)")
                self?.movies = movies
            }
            .store(in: &cancellables)
    }
}
