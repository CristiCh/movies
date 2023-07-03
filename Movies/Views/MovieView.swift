//
//  MovieView.swift
//  Movies
//
//  Created by Cristian Chertes on 13.03.2023.
//

import SwiftUI
import Kingfisher

struct MovieView: View {
    @StateObject var viewModel: MovieViewModel = MovieViewModel(moviesService: MoviesService(configuration: ServiceConfiguration()), serviceConfiguration: ServiceConfiguration(), databaseManager: DatabaseManager(configuration: DatabaseConfiguration()))
    var movieID: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { geo in
                if let posterPath = viewModel.movie?.posterPath, let url = URL(string: posterPath) {
                    KFImage.url(url)
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                } else {
                    Image("placeholder1")
                        .renderingMode(.original)
                        .resizable()
                        .clipped()
                }
            }
            Color.black
                .opacity(0.7)
            VStack {
                Spacer()
                Text(viewModel.movie?.title ?? "")
                    .font(.largeTitle)
                Text(viewModel.movie?.overView ?? "")
                    .padding(.top, 8)
                    .padding(.horizontal)
                    .font(.headline)
                if viewModel.dataSource.count > 0 {
                    ScrollView(.horizontal) {
                        LazyHStack(alignment: .bottom) {
                            ForEach(viewModel.dataSource) { movie in
                                NavigationLink(value: movie.movie) {
                                    MovieCellView(movie: movie)
                                }
                            }
                        }.frame(height: 180)
                    }
                }
            }
            .foregroundColor(.white)
            .padding()
            .padding(.bottom, 32)
            HStack {
                BackButtonView()
                Spacer()
                FavoriteButtonView(isFavorite: viewModel.isFavorite) {
                    if viewModel.isFavorite {
                        viewModel.deleteFavorite(movieID: viewModel.movie?.id)
                    } else {
                        viewModel.saveFavorite(movie: viewModel.movie)
                    }
                }
            }
            .padding(.top, 50)
            .padding(.horizontal, 24)
        }
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.loadMovieData(movieID: movieID)
        }
    }
}

struct MovieView_Previews: PreviewProvider {
    static var previews: some View {
        MovieView(viewModel: MovieViewModel(moviesService: MoviesService(configuration: ServiceConfiguration()), serviceConfiguration: ServiceConfiguration(), databaseManager: DatabaseManager(configuration: DatabaseConfiguration())), movieID: "123")
    }
}
