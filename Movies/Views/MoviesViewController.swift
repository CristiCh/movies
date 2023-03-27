//
//  MoviesViewController.swift
//  MVPExample
//
//  Created by Cristian Chertes on 24.11.2022.
//  Copyright © 2022 Cristis. All rights reserved.
//

//import UIKit
//import Combine
//
//class MoviesViewController: UIViewController {
//    @IBOutlet private var collectionView: UICollectionView!
//    @IBOutlet private var activityIndiacator: UIActivityIndicatorView!
//    private let refreshControl = UIRefreshControl()
//    var viewModel: MoviesViewModelProtocol!
//    private var datasource: UICollectionViewDiffableDataSource<MoviesSection.SectionIdentifier, BaseMovieCellViewModel>!
//    private var cancellables = Set<AnyCancellable>()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        configureCollectionView()
//        setupViewModel()
//        setupDataSource()
//        getPopularMovies()
//    }
//
//    @objc func refresh(_ sender: AnyObject) {
//        Task {
//            await viewModel.refreshPopularMovies()
//        }
//        refreshControl.endRefreshing()
//    }
//}
//
//extension MoviesViewController {
//    func getPopularMovies() {
//        Task {
//            await viewModel.getMovies()
//        }
//    }
//
//    func setupViewModel() {
//        viewModel = MoviesViewModel(moviesService: MoviesService(configuration: ServiceConfiguration()), serviceConfiguration: ServiceConfiguration(), flowCoordinatorFactory: FlowCoordinatorFactory())
//    }
//
//    func configureCollectionView() {
//        MovieCollectionCell.register(to: collectionView)
//        collectionView.delegate = self
//        collectionView.collectionViewLayout = generateLayout()
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
//        collectionView.addSubview(refreshControl)
//    }
//
//    func setupDataSource() {
//        datasource = MoviesViewModelDataSource(collectionView: collectionView)
//        bindViewModel()
//    }
//
//    func updateDatasource(movies: [MoviesCellViewModel]) {
//        var snapshot = NSDiffableDataSourceSnapshot<MoviesSection.SectionIdentifier, BaseMovieCellViewModel>()
//        snapshot.appendSections([MoviesSection.SectionIdentifier.main])
//        snapshot.appendItems(movies, toSection: MoviesSection.SectionIdentifier.main)
//        datasource.apply(snapshot, animatingDifferences: false)
//    }
//
//    func bindViewModel() {
//        viewModel.isLoading
//            .receive(on: DispatchQueue.main)
//            .dropFirst()
//            .sink { [unowned self] isLoading in
//                if isLoading {
//                    self.activityIndiacator.startAnimating()
//                    self.activityIndiacator.hidesWhenStopped = true
//                } else {
//                    self.activityIndiacator.stopAnimating()
//                }
//            }
//            .store(in: &cancellables)
//
//        viewModel.dataSource
//            .receive(on: DispatchQueue.main)
//            .dropFirst()
//            .sink { [unowned self] moviesVM in
//                self.updateDatasource(movies: moviesVM)
//            }
//            .store(in: &cancellables)
//    }
//
//    func generateLayout() -> UICollectionViewLayout {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
//        let fullPhotoItem = NSCollectionLayoutItem(layoutSize: itemSize)
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.8))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: fullPhotoItem, count: 2)
//        let section = NSCollectionLayoutSection(group: group)
//        let layout = UICollectionViewCompositionalLayout(section: section)
//
//        return layout
//    }
//}
//
//extension MoviesViewController: UICollectionViewDelegate {
//    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let movieID = viewModel.dataSource.value[indexPath.row].movie.id
//        viewModel.goToMovie(movieID: movieID, navigationController: navigationController)
//    }
//
//    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.row == viewModel.dataSource.value.count - 2 {
//            getPopularMovies()
//        }
//    }
//}
