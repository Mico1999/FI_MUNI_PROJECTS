import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_catalog/celebrity/model/celebrity.dart';
import 'package:movie_catalog/celebrity/model/role.dart';
import 'package:movie_catalog/celebrity/service/celebrity_service.dart';
import 'package:movie_catalog/common/service/fire_storage.dart';
import 'package:movie_catalog/common/widget/page_template.dart';
import 'package:movie_catalog/common/widget/poster.dart';
import 'package:movie_catalog/genre/model/genre.dart';
import 'package:movie_catalog/genre/service/genre_service.dart';
import 'package:movie_catalog/genre/widget/genre_list_view.dart';
import 'package:movie_catalog/movie/model/movie.dart';
import 'package:movie_catalog/movie/service/movie_service.dart';
import 'package:movie_catalog/movie/widget/celebrity_scroller.dart';
import 'package:movie_catalog/movie/widget/movie_banner_image.dart';
import 'package:diacritic/diacritic.dart';

class MovieEditPage extends StatefulWidget {
  final genreService = GetIt.I.get<GenreService>();
  final movieService = GetIt.I.get<MovieService>();
  final celebrityService = GetIt.I.get<CelebrityService>();
  final storageService = GetIt.I.get<FireStorage>();
  final Movie? movie;
  MovieEditPage({super.key, required this.movie});

  @override
  State<MovieEditPage> createState() => _MovieEditPageState();
}

class _MovieEditPageState extends State<MovieEditPage> {
  final _titleController = TextEditingController();
  final _previewController = TextEditingController();
  final _storylineController = TextEditingController();
  final _imagePicker = ImagePicker();
  Movie? _movie;
  String _bannerPreview = "";
  String _posterPreview = "";
  DateTime _year = DateTime.now();
  final List<int> _genreIndexes = [];

  @override
  void initState() {
    super.initState();
    if (widget.movie != null) {
      initGenres();
      _movie = widget.movie!;
      _titleController.text = _movie!.title;
      _previewController.text = _movie!.preview;
      _storylineController.text = _movie!.storyLine;
      _bannerPreview = _movie!.bannerImage;
      _posterPreview = _movie!.posterImage;
      _year = _movie!.year;
    }
  }

  Future<void> initGenres() async {
    final genres = await widget.genreService.genres.first;
    final current = await widget.movieService.movieGenres(_movie!.id!).first;
    _genreIndexes.addAll(current.map((g) => genres.indexOf(g)));
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: (_movie == null) ? "Create Movie" : _movie!.title,
      child: SingleChildScrollView(
        child: Column(
          children: [
            MovieBannerImage(imageUrl: _bannerPreview),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Poster(posterUrl: _posterPreview, height: 230.0),
            ),
            _buildSaveButton(),
            _buildTextField("Title", _titleController),
            _buildGenreSelector(),
            _buildYearPicker(),
            _buildImagePicker("Banner photo", Icons.photo),
            _buildImagePicker("Poster photo", Icons.photo_album_outlined),
            _buildCelebrityScroller("Director:", Role.director),
            _buildCelebrityScroller("Scriptwriter:", Role.scriptwriter),
            _buildCelebrityScroller("Cameraman:", Role.cameraman),
            _buildCelebrityScroller("Music:", Role.music),
            _buildCelebrityScroller("Actors:", Role.actor),
            _buildTextField("Preview", _previewController),
            _buildTextField("Storyline", _storylineController),
          ],
        ),
      ),
    );
  }

  Widget _buildCelebrityScroller(String text, Role role) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpandablePanel(
        collapsed: Container(),
        header: Row(
          children: [
            ExpandableIcon(
              theme: const ExpandableThemeData(
                expandIcon: Icons.arrow_right,
                collapseIcon: Icons.arrow_drop_down,
                iconColor: Colors.white,
                iconSize: 28.0,
                iconPadding: EdgeInsets.only(right: 5),
                hasIcon: false,
              ),
            ),
            Expanded(
              child: Text(
                text,
              ),
            ),
          ],
        ),
        expanded: Column(
          children: [
            _buildCelebrityPicker(text),
            (_movie != null)
                ? StreamBuilder(
                    stream: widget.movieService
                        .movieCelebrities(_movie!.id!, role: role),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Celebrity>> snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }
                      if (snapshot.hasData) {
                        return CelebrityScroller(
                          celebrities: snapshot.data!,
                          isInMovieDetail: false,
                          movieIdInEditMode: _movie!.id,
                          roleInEditMode: role,
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$hint:"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLines: null,
              decoration: InputDecoration(hintText: hint),
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
        onPressed: () async {
          if (_movie == null) {
            final movie = Movie(
                title: _titleController.text,
                year: _year,
                preview: _previewController.text,
                storyLine: _storylineController.text,
                genreIds: null,
                bannerImage: _bannerPreview,
                posterImage: _posterPreview,
                celebrityIdsWithRole: null,
                id: null);
            final id = await widget.movieService.add(movie);
            await _updateGenre(id);
          } else {
            await widget.movieService.updateStringFields(
                _movie!.id!,
                _titleController.text,
                _previewController.text,
                _storylineController.text,
                _bannerPreview,
                _posterPreview);
            await _updateGenre(_movie!.id!);
            await widget.movieService.updateYear(_movie!.id!, _year);
          }

          if (context.mounted) {
            Navigator.pushReplacementNamed(context, "/");
          }
        },
        icon: const Icon(
          Icons.save,
          size: 35,
        ),
        label: const Text("Save"));
  }

  Future<void> _updateGenre(String movieId) async {
    final genres = await widget.genreService.genres.first;
    final genreIds = genres.indexed
        .where((e) => _genreIndexes.contains(e.$1))
        .map((e) => e.$2.id!)
        .toList();
    await widget.movieService.updateGenres(movieId, genreIds);
  }

  Widget _buildGenreSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Text("Genres"),
          TextButton(
            onPressed: () => showDialog<String>(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, innerSetState) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StreamBuilder(
                            stream: widget.genreService.genres,
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
                                    TextButton(
                                      onPressed: () async {
                                        setState(() {});
                                        if (context.mounted) {
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text('Save'),
                                    ),
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
              Icons.more_horiz,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearPicker() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Text("Year"),
          TextButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Select Year"),
                content: SizedBox(
                  width: 300,
                  height: 300,
                  child: YearPicker(
                    firstDate: DateTime(DateTime.now().year - 100, 1),
                    lastDate: DateTime(DateTime.now().year + 100, 1),
                    selectedDate:
                        (_movie == null) ? DateTime.now() : _movie!.year,
                    onChanged: (DateTime dateTime) async {
                      _year = dateTime;
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ),
            ),
            child: const Icon(
              Icons.calendar_month,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePicker(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(text),
          TextButton(
            onPressed: () async {
              final image =
                  await _imagePicker.pickImage(source: ImageSource.gallery);
              if (image == null) return;
              widget.storageService.uploadImageFile(image);
              if (text == "Banner photo") {
                _bannerPreview = image.name;
              } else {
                _posterPreview = image.name;
              }

              setState(() {});
            },
            child: Icon(
              icon,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCelebrityPicker(String text) {
    return Row(
      children: [
        Expanded(
          child: StreamBuilder(
              stream: widget.celebrityService.celebrities,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Celebrity>> snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                }
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Autocomplete<Celebrity>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<Celebrity>.empty();
                        }
                        return snapshot.data!.where((c) =>
                            ("${removeDiacritics(c.firstName.toLowerCase())} ${removeDiacritics(c.lastName.toLowerCase())}")
                                .contains(removeDiacritics(
                                    textEditingValue.text.toLowerCase())));
                      },
                      onSelected: (c) async {
                        await _updateOnSelected(text, c);
                        setState(() {});
                        setState(() {});
                      },
                      displayStringForOption: (c) =>
                          "${c.firstName} ${c.lastName}",
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ],
    );
  }

  Future<void> _updateOnSelected(String text, Celebrity celebrity) async {
    if (_movie == null) {
      final movie = Movie(
          title: _titleController.text,
          year: _year,
          preview: _previewController.text,
          storyLine: _storylineController.text,
          genreIds: null,
          bannerImage: _bannerPreview,
          posterImage: _posterPreview,
          celebrityIdsWithRole: null,
          id: null);
      final id = await widget.movieService.add(movie);
      _movie = await widget.movieService.get(id).first;
    }
    if (text == "Director:") {
      widget.movieService
          .addCelebrity(_movie!.id!, celebrity.id!, role: Role.director);
    } else if (text == "Scriptwriter:") {
      widget.movieService
          .addCelebrity(_movie!.id!, celebrity.id!, role: Role.scriptwriter);
    } else if (text == "Cameraman:") {
      widget.movieService
          .addCelebrity(_movie!.id!, celebrity.id!, role: Role.cameraman);
    } else if (text == "Music:") {
      widget.movieService
          .addCelebrity(_movie!.id!, celebrity.id!, role: Role.music);
    } else {
      widget.movieService
          .addCelebrity(_movie!.id!, celebrity.id!, role: Role.actor);
    }
  }
}
