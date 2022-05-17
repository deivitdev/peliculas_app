import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';

class SerieSlider extends StatefulWidget {
  final List<Serie> series;
  final String? title;
  final Function onNextPage;

  const SerieSlider({
    Key? key,
    required this.series,
    required this.onNextPage,
    this.title,
  }) : super(key: key);

  @override
  State<SerieSlider> createState() => _SerieSliderState();
}

class _SerieSliderState extends State<SerieSlider> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500) {
        widget.onNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                widget.title!,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.series.length,
              itemBuilder: (_, int index) => _SeriePoster(widget.series[index], '${widget.title}-$index-${widget.series[index].id}'),
            ),
          )
        ],
      ),
    );
  }
}

class _SeriePoster extends StatelessWidget {
  final Serie serie;
  final String heroId;

  const _SeriePoster(this.serie, this.heroId);

  @override
  Widget build(BuildContext context) {
    serie.heroId = heroId;

    return Container(
      width: 130,
      height: 120,
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, 'details_series', arguments: serie),
            child: Hero(
              tag: serie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(serie.fullPosterImg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            serie.name,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
