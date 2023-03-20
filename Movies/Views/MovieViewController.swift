////
////  MovieViewController.swift
////  Movies
////
////  Created by Cristian Chertes on 26.12.2022.
////
//
//import UIKit
//import Combine
//import Kingfisher
//
//class MovieViewController: UIViewController {
//    @IBOutlet private var movieImageView: UIImageView!
//    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
//    @IBOutlet private var descriptionLabel: UILabel!
//    var viewModel: MovieViewModelProtocol!
//    private var cancellables = Set<AnyCancellable>()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        configureAppearance()
//    }
//
//    func loadMovieData(movieID: String) {
//        bindViewModel()
//        viewModel.loadMovieData(movieID: movieID)
//    }
//
//    private func configureAppearance() {
//        activityIndicator.hidesWhenStopped = true
//    }
//
//    @IBAction func closePressed(_ sender: Any) {
//        dismiss(animated: true)
//    }
//
//    private func bindViewModel() {
//        viewModel.movie
//            .receive(on: DispatchQueue.main)
//            .dropFirst()
//            .sink { [weak self] movie in
//                guard let strongSelf = self else {
//                    return
//                }
//                if let movie = movie {
//                    strongSelf.configureUI(movie: movie)
//                }
//            }
//            .store(in: &cancellables)
//
//        viewModel.isLoading
//            .receive(on: DispatchQueue.main)
//            .dropFirst()
//            .sink { [unowned self] isLoading in
//                if isLoading {
//                    self.activityIndicator.startAnimating()
//                } else {
//                    self.activityIndicator.stopAnimating()
//                }
//            }
//            .store(in: &cancellables)
//    }
//
//    private func configureUI(movie: Movie) {
//        if let movieImageString = movie.posterPath, let movieImageURL = URL(string: movieImageString)  {
//            movieImageView.kf.setImage(with: Source.network(ImageResource(downloadURL: movieImageURL))) { [weak self] result in
//            }
//        }
//        descriptionLabel.text = movie.overView
//    }
//}
