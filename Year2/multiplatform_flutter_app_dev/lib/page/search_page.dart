import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_catalog/celebrity/service/celebrity_service.dart';

import 'package:movie_catalog/common/widget/page_template.dart';
import 'package:movie_catalog/genre/model/genre.dart';
import 'package:movie_catalog/genre/service/genre_service.dart';
import 'package:movie_catalog/genre/widget/genre_list_view.dart';
import 'package:movie_catalog/movie/service/movie_service.dart';
import 'package:movie_catalog/page/widget/combined_stream_builder.dart';

class SearchPage extends StatefulWidget {
  final _movieService = GetIt.I.get<MovieService>();
  final _celebrityService = GetIt.I.get<CelebrityService>();
  final _genreService = GetIt.I.get<GenreService>();
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _inputController = TextEditingController();
  var _isFilter = false;
  final List<int> _genreIndexes = [];
  late bool _showCelebrities = (_genreIndexes.isEmpty);

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: "Search",
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildInput(),
              _buildCancelButton(),
              _buildFilter(),
            ],
          ),
          Expanded(
            child: CombinedStreamBuilder(
                movies: widget._movieService.filteredMovies,
                celebrities: widget._celebrityService.filteredCelebrities,
                showCelebrities: _showCelebrities,
                isSearch: _isFilter),
          ),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, top: 8.0, right: 0.0, bottom: 8.0),
        child: TextField(
            onChanged: (text) {
              widget._movieService.addTitleFilter(text);
              widget._celebrityService.addNameFilter(text);
              _updateCancelButton();
              setState(() {});
            },
            decoration: InputDecoration(
              fillColor: Colors.grey,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
              prefixIcon: const Icon(Icons.search),
            ),
            controller: _inputController),
      ),
    );
  }

  Widget _buildCancelButton() {
    return TextButton(
      onPressed: () {
        _inputController.text = '';
        widget._movieService.addTitleFilter("");
        widget._movieService.addGenreFilter([]);
        widget._celebrityService.addNameFilter("");
        _isFilter = false;
        setState(() {});
      },
      child: Icon(
        Icons.cancel_rounded,
        size: 35,
        color: _isFilter ? Colors.purple : Colors.grey,
      ),
    );
  }

  Widget _buildFilter() {
    return TextButton(
      onPressed: () => showDialog<String>(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, innerSetState) => Dialog(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                      stream: widget._genreService.genres,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Genre>> snapshot) {
                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
                        if (snapshot.hasData) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GenreListView(
                                  genres: snapshot.data!,
                                  innerSetState: innerSetState,
                                  genreIndexes: _genreIndexes),
                              _buildBottomButtons(snapshot.data!, context),
                            ],
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      }),
                ),
              ),
            );
          }),
      child: const Icon(
        Icons.filter_alt,
        size: 35,
      ),
    );
  }

  Widget _buildBottomButtons(List<Genre> genres, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            widget._movieService.addGenreFilter([]);
            _showCelebrities = true;
            _updateCancelButton();
            setState(() {});
            Navigator.pop(context);
          },
          child: const Text(
            'Discard',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            if (_genreIndexes != []) {
              widget._movieService.addGenreFilter(genres
                  .where((g) => _genreIndexes.contains(genres.indexOf(g)))
                  .map((g) => g.id!)
                  .toList());
            }
            _updateCancelButton();
            setState(() {});
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _updateCancelButton() {
    _isFilter = _genreIndexes.isNotEmpty || _inputController.text != "";
  }
}
