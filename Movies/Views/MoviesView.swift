//
//  MoviesView.swift
//  Movies
//
//  Created by Cristian Chertes on 20.03.2023.
//

import SwiftUI
import Combine
import Kingfisher

struct MoviesView: View {
    @ObservedObject var viewModel: MoviesViewModel
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var navigateToMovieDetail: Bool? = false
    @State private var selectedMovie: Movie? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: MovieView(viewModel: MovieViewModel(moviesService: MoviesService(configuration: ServiceConfiguration()), serviceConfiguration: ServiceConfiguration()), movieID: selectedMovie?.id ?? ""), tag: true, selection: $navigateToMovieDetail) {
                }
                GeometryReader { geo in
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 0) {
                            ForEach(viewModel.dataSource) { movie in
                                MovieCellView(movie: movie) {
                                    self.selectedMovie = $0
                                    self.navigateToMovieDetail = true
                                }
                            }
                        }
                        .padding(.top, geo.safeAreaInsets.top)
                    }
                    .edgesIgnoringSafeArea(.all)
                    .background(Color.black)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            Task {
                await viewModel.getMovies()
            }
        }
    }
}

struct MovieCellView: View {
    var movie: MoviesCellViewModel
    var onSelectMovie: (Movie) -> Void
    
    var body: some View {
        Color.black.opacity(0)
            .aspectRatio(4/5, contentMode: .fill)
            .background {
                if let posterPath = movie.posterPath, let url = URL(string: posterPath) {
                    KFImage.url(url)
                        .renderingMode(.original)
                        .resizable()
                        .clipped()
                }
            }
            .onTapGesture {
                onSelectMovie(movie.movie)
            }
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView(viewModel: MoviesViewModel(moviesService: MoviesService(configuration: ServiceConfiguration()),
                                              serviceConfiguration: ServiceConfiguration(),
                                              flowCoordinatorFactory: FlowCoordinatorFactory()))
    }
}
