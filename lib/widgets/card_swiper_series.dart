import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';

class CardSwiperSeries extends StatelessWidget {
  final List<Serie> series;

  const CardSwiperSeries({Key? key, required this.series}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (series.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: size.height * 0.5,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: size.height * 0.4,
      child: Swiper(
        itemCount: series.length,
        layout: SwiperLayout.STACK,
        itemWidth: size.width * 0.6,
        itemHeight: size.height * 0.4,
        itemBuilder: (BuildContext context, int index) {
          final serie = series[index];

          serie.heroId = 'swiper-${serie.id}';

          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details_series', arguments: serie),
            child: Hero(
              tag: serie.heroId!,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/loading.gif'),
                    image: NetworkImage(serie.fullPosterImg),
                    fit: BoxFit.cover,
                  )),
            ),
          );
        },
      ),
    );
  }
}
