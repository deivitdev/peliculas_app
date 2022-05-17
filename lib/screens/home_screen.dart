import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/providers/series_provider.dart';
import 'package:peliculas_app/widgets/widgets.dart';
import 'package:peliculas_app/search/search_delegate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    final seriesProvider = Provider.of<SeriesProvider>(context);

    return ChangeNotifierProvider(
      create: (_) => _NavigationModel(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Movies and Series'),
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () => showSearch(context: context, delegate: MovieSearchDelegate()),
                icon: const Icon(Icons.search_outlined),
              )
            ],
          ),
          body: _PageView(moviesProvider: moviesProvider, seriesProvider: seriesProvider),
          bottomNavigationBar: const _BottomNavigationBar(),
        ),
      ),
    );
  }
}

class _PageView extends StatelessWidget {
  const _PageView({
    Key? key,
    required this.moviesProvider,
    required this.seriesProvider,
  }) : super(key: key);

  final MoviesProvider moviesProvider;
  final SeriesProvider seriesProvider;

  @override
  Widget build(BuildContext context) {
    final navegationModel = Provider.of<_NavigationModel>(context);
    return PageView(
      controller: navegationModel.pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Películas en cartelera', style: TextStyle(fontSize: 24)),
                ),
                CardSwiper(movies: moviesProvider.onDisplayMovies),
              ],
            ),
            MovieSlider(
              movies: moviesProvider.popularMovies,
              title: 'Populares',
              onNextPage: () => moviesProvider.getPopularMovies(),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Series al aire', style: TextStyle(fontSize: 24)),
            ),
            CardSwiperSeries(series: seriesProvider.onDisplaySeries),
            SerieSlider(
              series: seriesProvider.popularSeries,
              title: 'Populares',
              onNextPage: () => seriesProvider.getPopularSeries(),
            )
          ],
        ),
      ],
    );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationModel = Provider.of<_NavigationModel>(context);
    return BottomNavigationBar(
      currentIndex: navigationModel.page,
      onTap: (i) => navigationModel.page = i,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Películas'),
        BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'Series'),
      ],
    );
  }
}

class _NavigationModel with ChangeNotifier {
  int _page = 0;
  final PageController _pageController = PageController();

  get page => _page;

  set page(value) {
    _page = value;
    _pageController.animateToPage(value, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    notifyListeners();
  }

  PageController get pageController => _pageController;
}
