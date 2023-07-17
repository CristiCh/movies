//
//  MoviesView.swift
//  Movies
//
//  Created by Cristian Chertes on 20.03.2023.
//

import SwiftUI
import UIKit
import Combine
import Kingfisher
import FirebaseCrashlytics
import FirebaseAnalytics

struct MoviesView: View {
    
    @StateObject var viewModel: MoviesViewModel
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @State private var navigateToMovieDetail: Bool = false
    @State private var selectedMovie: Movie? = nil
    @StateObject private var minVersionViewModel: MinVersionCheckViewModel = MinVersionCheckViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    GeometryReader { geo in
                        ScrollView {
                            VStack {
                                FavoriteMovieCarousel(dataSource: viewModel.dataSource.count >= 5 ? Array(viewModel.dataSource.prefix(upTo: 5)) : viewModel.dataSource)
                                MovieCarousel(title: "Recommended", dataSource: viewModel.dataSource, loadMore: {
                                    Task {
                                        await viewModel.getMovies()
                                    }
                                })
                                MovieCarousel(title: "Favorites", dataSource: viewModel.favoriteDataSource)
                            }
                        }
                        .edgesIgnoringSafeArea(.all)
                        .background(Color.black)
                        .refreshable {
                            Task {
                                await viewModel.refresh()
                            }
                        }
                    }
                }
                .navigationDestination(for: Movie.self) { movie in
                    MovieView(movieID: movie.id)
                }
                UpgradeModalView(isPresented: minVersionViewModel.shouldUpgrade, minRemoteConfig: minVersionViewModel.remoteConfigMinVersion) { url in
                    minVersionViewModel.goToAppStore(url: url)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            Task {
                await viewModel.getMovies()
            }
            minVersionViewModel.getMinVersion()
        }
    }
}

struct MovieCarousel: View {
    var title: String
    var dataSource: [MoviesCellViewModel]
    var loadMore: () -> Void = {}
    var body: some View {
        if dataSource.count > 0 {
            VStack {
                HStack {
                    Text(title)
                        .foregroundColor(.white)
                        .font(.title)
                    Spacer()
                }
                ScrollView(.horizontal) {
                    LazyHStack(alignment: .bottom) {
                        ForEach(dataSource) { movie in
                            NavigationLink(value: movie.movie) {
                                MovieCellView(movie: movie)
                            }
                        }
                        if dataSource.count > 0 {
                            Text("")
                                .onAppear {
                                    loadMore()
                                }
                        }
                    }.frame(height: 180)
                }
            }
        }
    }
}

struct FavoriteMovieCarousel: View {
    var dataSource: [MoviesCellViewModel]
    var height: CGFloat = 500
    var body: some View {
        GeometryReader { geo in
            TabView {
                ForEach(dataSource) { movie in
                    NavigationLink(value: movie.movie) {
                        MovieCellView(movie: movie)
                            .frame(width: geo.size.width, height: height)
                    }
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .onAppear{
                setupAppearance()
            }
        }
        .frame(height: height)
    }
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .red
        UIPageControl.appearance().pageIndicatorTintColor = .blue
    }
}

struct PageIndicatorView : View {
    var numberOfElements: Int
    var selectedIndex: Int
    var body: some View {
        HStack {
            if numberOfElements > 1 {
                ForEach(1...numberOfElements , id: \.self) { index in
                    Circle()
                        .foregroundColor(selectedIndex + 1 == index ? .red : .white)
                        .frame(width: 18, height: 18)
                }
            }
        }
        .padding(.bottom, 20)
    }
}

struct MovieCellView: View {
    var movie: MoviesCellViewModel
    
    var body: some View {
        Color.black.opacity(0)
            .aspectRatio(4/5, contentMode: .fill)
            .background {
                if let posterPath = movie.posterPath, let url = URL(string: posterPath) {
                    KFImage.url(url)
                        .renderingMode(.original)
                        .resizable()
                        .clipped()
                } else {
                    Image("placeholder1")
                        .renderingMode(.original)
                        .resizable()
                        .clipped()
                }
            }
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView(viewModel: MoviesViewModel(moviesService: MoviesService(configuration: ServiceConfiguration()),
                                              serviceConfiguration: ServiceConfiguration(),
                                              databaseManager: DatabaseManager(configuration: DatabaseConfiguration()),
                                              flowCoordinatorFactory: FlowCoordinatorFactory()))
    }
}
