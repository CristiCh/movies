//
//  MoviesViewModel.swift
//  MVPExample
//
//  Created by Cristian Chertes on 02.12.2022.
//  Copyright © 2022 Cristian Chertes. All rights reserved.
//

import UIKit
import Combine

protocol MoviesViewModelProtocol {
    func getMovies() async
    func refreshPopularMovies() async
    func goToMovie(movieID: String, navigationController: UINavigationController?)
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    var dataSource: [MoviesCellViewModel] { get }
    var goToMovie: PassthroughSubject<Void, Never> { get }
    var lastDownloadedPage: Int { get set }
}

class MoviesViewModel: MoviesViewModelProtocol, ObservableObject {
    private let moviesService: MoviesServiceProtocol
    private let serviceConfig: ServiceConfigurationProtocol
    private let databaseManager: DatabaseManager
    private let flowCoordinatorFactory: FlowCoordinatorFactory
    @Published var dataSource: [MoviesCellViewModel] = []
    var isLoading = CurrentValueSubject<Bool, Never>(false)
    var goToMovie = PassthroughSubject<Void, Never>()
    var lastDownloadedPage = 0
    
    init(moviesService: MoviesServiceProtocol, serviceConfiguration: ServiceConfigurationProtocol, databaseManager: DatabaseManager, flowCoordinatorFactory: FlowCoordinatorFactory) {
        self.moviesService = moviesService
        self.serviceConfig = serviceConfiguration
        self.databaseManager = databaseManager
        self.flowCoordinatorFactory = flowCoordinatorFactory
    }
    
    func getMovies() async {
        if isLoading.value == true {
            return
        }
        
        isLoading.send(true)
        lastDownloadedPage += 1
        let movies = await moviesService.fetchPopularMovies(page: lastDownloadedPage)

        if let result = try? movies.result.get() {
            let moviesDB = result.results.compactMap { apiMovie in
                MovieDB.transform(movie:apiMovie, configuration:serviceConfig)
            }
            DispatchQueue.main.async {
                var cells = [MoviesCellViewModel]()
                self.databaseManager.save(objects: moviesDB)
                let movieVM: [MoviesCellViewModel] = self.databaseManager.get(type: MovieDB.self)?.compactMap({ movieDB in
                    Movie.transform(movie: movieDB.freeze())
                }).compactMap({ movie in
                    MoviesCellViewModel(movie: movie)
                }) ?? []
                cells.append(contentsOf: movieVM)
                self.dataSource.append(contentsOf: cells)
            }
        } else {
            dataSource.append(contentsOf: [])
            lastDownloadedPage -= 1
        }
        isLoading.send(false)
    }
    
    func refreshPopularMovies() async {
        dataSource = []
        lastDownloadedPage = 0
        await getMovies()
    }
    
    func goToMovie(movieID: String, navigationController: UINavigationController?) {
        guard let navController = navigationController else { return }
        flowCoordinatorFactory.create(type: .movieDetail(movieID: movieID, navigationController:navController)).start()
    }
}
