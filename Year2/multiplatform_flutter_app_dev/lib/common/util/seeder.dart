import 'package:get_it/get_it.dart';
import 'package:movie_catalog/celebrity/model/role.dart';
import 'package:movie_catalog/celebrity/service/celebrity_service.dart';
import 'package:movie_catalog/celebrity/service/celebrity_mock_data.dart';
import 'package:movie_catalog/genre/service/genre_mock_data.dart';
import 'package:movie_catalog/genre/service/genre_service.dart';
import 'package:movie_catalog/movie/service/movie_mock_data.dart';
import 'package:movie_catalog/movie/service/movie_service.dart';
import 'package:movie_catalog/review/service/review_service.dart';
import 'package:movie_catalog/review/service/review_mock_data.dart';
import 'package:movie_catalog/user/service/app_user_mock_data.dart';
import 'package:movie_catalog/user/service/app_user_service.dart';

class Seeder {
  final _movieService = GetIt.I.get<MovieService>();
  final _celebrityService = GetIt.I.get<CelebrityService>();
  final _reviewService = GetIt.I.get<ReviewService>();
  final _appUserService = GetIt.I.get<AppUserService>();
  final _genreService = GetIt.I.get<GenreService>();

  void seed() async {
    final hrebejekId = await _celebrityService.add(hrebejek);
    final jarchovksyId = await _celebrityService.add(jarchovksy);
    final kodetId = await _celebrityService.add(kodet);
    final vasaryovaId = await _celebrityService.add(vasaryova);
    final polivkaId = await _celebrityService.add(polivka);
    final donutilId = await _celebrityService.add(donutil);
    final malirId = await _celebrityService.add(malir);
    final hlasId = await _celebrityService.add(hlas);
    final chytilovaId = await _celebrityService.add(chytilova);
    final havlovaId = await _celebrityService.add(havlova);
    final kronerId = await _celebrityService.add(kroner);
    final sandersId = await _celebrityService.add(sanders);
    final bulisId = await _celebrityService.add(bulis);
    final campbellId = await _celebrityService.add(campbell);
    final purvisId = await _celebrityService.add(purvis);
    final craigId = await _celebrityService.add(craig);
    final greenId = await _celebrityService.add(green);
    final mikkelsenId = await _celebrityService.add(mikkelsen);
    final denchId = await _celebrityService.add(dench);
    final meheuxId = await _celebrityService.add(meheux);
    final arnoldId = await _celebrityService.add(arnold);
    final darabontId = await _celebrityService.add(darabont);
    final kingId = await _celebrityService.add(king);
    final robbinsId = await _celebrityService.add(robbins);
    final freemanId = await _celebrityService.add(freeman);
    final guntonId = await _celebrityService.add(gunton);
    final coppolaId = await _celebrityService.add(coppola);
    final puzzoId = await _celebrityService.add(puzzo);
    final brandoId = await _celebrityService.add(brando);
    final pacinoId = await _celebrityService.add(pacino);
    final caanId = await _celebrityService.add(caan);
    final nolanId = await _celebrityService.add(nolan);
    final nolan2Id = await _celebrityService.add(nolan2);
    final baleId = await _celebrityService.add(bale);
    final ledgerId = await _celebrityService.add(ledger);
    final eckhartId = await _celebrityService.add(eckhart);

    final peliskyId = await _movieService.add(pelisky);
    final dedictviId = await _movieService.add(dedictvi);
    final casinoId = await _movieService.add(casino_royal);
    final shawshankId = await _movieService.add(shawshank);
    final godfatherId = await _movieService.add(godfather);
    final darkKnightId = await _movieService.add(dark_knight);

    final comedyId = await _genreService.add(comedy);
    final dramaId = await _genreService.add(drama);
    final actionId = await _genreService.add(action);
    final familyId = await _genreService.add(family);
    final thrillerId = await _genreService.add(thriller);
    final sciFiId = await _genreService.add(sciFi);

    _movieService.addCelebrity(peliskyId, hrebejekId, role: Role.director);
    _movieService.addCelebrity(peliskyId, jarchovksyId,
        role: Role.scriptwriter);
    _movieService.addCelebrity(peliskyId, malirId, role: Role.cameraman);
    _movieService.addCelebrity(peliskyId, hlasId, role: Role.music);
    _movieService.addCelebrity(peliskyId, kodetId);
    _movieService.addCelebrity(peliskyId, vasaryovaId);
    _movieService.addCelebrity(peliskyId, polivkaId);
    _movieService.addCelebrity(peliskyId, donutilId);

    _movieService.addCelebrity(dedictviId, chytilovaId, role: Role.director);
    _movieService.addCelebrity(dedictviId, polivkaId, role: Role.scriptwriter);
    _movieService.addCelebrity(dedictviId, sandersId, role: Role.cameraman);
    _movieService.addCelebrity(dedictviId, bulisId, role: Role.music);
    _movieService.addCelebrity(dedictviId, havlovaId);
    _movieService.addCelebrity(dedictviId, kronerId);
    _movieService.addCelebrity(dedictviId, polivkaId);
    _movieService.addCelebrity(dedictviId, donutilId);

    _movieService.addCelebrity(casinoId, campbellId, role: Role.director);
    _movieService.addCelebrity(casinoId, purvisId, role: Role.scriptwriter);
    _movieService.addCelebrity(casinoId, meheuxId, role: Role.cameraman);
    _movieService.addCelebrity(casinoId, arnoldId, role: Role.music);
    _movieService.addCelebrity(casinoId, craigId);
    _movieService.addCelebrity(casinoId, greenId);
    _movieService.addCelebrity(casinoId, mikkelsenId);
    _movieService.addCelebrity(casinoId, denchId);

    _movieService.addCelebrity(shawshankId, darabontId, role: Role.director);
    _movieService.addCelebrity(shawshankId, kingId, role: Role.scriptwriter);
    _movieService.addCelebrity(shawshankId, robbinsId);
    _movieService.addCelebrity(shawshankId, freemanId);
    _movieService.addCelebrity(shawshankId, guntonId);

    _movieService.addCelebrity(godfatherId, coppolaId, role: Role.director);
    _movieService.addCelebrity(godfatherId, puzzoId, role: Role.scriptwriter);
    _movieService.addCelebrity(godfatherId, coppolaId, role: Role.scriptwriter);
    _movieService.addCelebrity(godfatherId, brandoId);
    _movieService.addCelebrity(godfatherId, pacinoId);
    _movieService.addCelebrity(godfatherId, caanId);

    _movieService.addCelebrity(darkKnightId, nolanId, role: Role.director);
    _movieService.addCelebrity(darkKnightId, nolan2Id, role: Role.scriptwriter);
    _movieService.addCelebrity(darkKnightId, nolanId, role: Role.scriptwriter);
    _movieService.addCelebrity(darkKnightId, baleId);
    _movieService.addCelebrity(darkKnightId, ledgerId);
    _movieService.addCelebrity(darkKnightId, eckhartId);

    _movieService.addGenreTags(peliskyId, [comedyId, dramaId, familyId]);
    _movieService.addGenreTags(dedictviId, [comedyId, dramaId]);
    _movieService.addGenreTags(casinoId, [actionId, thrillerId]);
    _movieService.addGenreTags(shawshankId, [dramaId, thrillerId]);
    _movieService.addGenreTags(godfatherId, [dramaId, familyId, thrillerId]);
    _movieService.addGenreTags(darkKnightId, [actionId, thrillerId, sciFiId]);

    final marek_pelisky_full_review =
        marek_pelisky_review.copyWith(movieId: peliskyId);
    final marek_dedictvi_full_review =
        marek_dedictvi_review.copyWith(movieId: dedictviId);
    final marek_godfather_full_review =
        marek_godfather_review.copyWith(movieId: godfatherId);
    final marek_darknight_full_review =
        marek_darknight_review.copyWith(movieId: darkKnightId);
    final marek_casino_full_review =
        marek_casino_review.copyWith(movieId: casinoId);
    final marek_shawshank_full_review =
        marek_shawshank_review.copyWith(movieId: shawshankId);

    final petrik_pelisky_full_review =
        petrik_pelisky_review.copyWith(movieId: peliskyId);
    final petrik_dedictvi_full_review =
        petrik_dedictvi_review.copyWith(movieId: dedictviId);
    final petrik_godfather_full_review =
        petrik_godfather_review.copyWith(movieId: godfatherId);
    final petrik_darknight_full_review =
        petrik_darknight_review.copyWith(movieId: darkKnightId);
    final petrik_casino_full_review =
        petrik_casino_review.copyWith(movieId: casinoId);
    final petrik_shawshank_full_review =
        petrik_shawshank_review.copyWith(movieId: shawshankId);

    final admin_casino_full_review =
        admin_casino_review.copyWith(movieId: casinoId);
    final admin_darknight_full_review =
        admin_darknight_review.copyWith(movieId: darkKnightId);

    _reviewService.add(marek_pelisky_full_review);
    _reviewService.add(marek_dedictvi_full_review);
    _reviewService.add(marek_casino_full_review);
    _reviewService.add(marek_darknight_full_review);
    _reviewService.add(marek_godfather_full_review);
    _reviewService.add(marek_shawshank_full_review);
    _reviewService.add(petrik_pelisky_full_review);
    _reviewService.add(petrik_dedictvi_full_review);
    _reviewService.add(petrik_casino_full_review);
    _reviewService.add(petrik_darknight_full_review);
    _reviewService.add(petrik_godfather_full_review);
    _reviewService.add(petrik_shawshank_full_review);
    _reviewService.add(admin_casino_full_review);
    _reviewService.add(admin_darknight_full_review);

    final marek1_full_user = marek1.copyWith(
        favoriteMovies: [peliskyId, godfatherId, shawshankId],
        favoriteCelebrities: [brandoId, polivkaId, donutilId]);

    final marek2_full_user = marek2.copyWith(
        favoriteMovies: [casinoId, godfatherId, dedictviId],
        favoriteCelebrities: [kodetId, polivkaId, donutilId]);

    final petrik1_full_user = petrik1.copyWith(
        favoriteMovies: [peliskyId, shawshankId, dedictviId],
        favoriteCelebrities: [baleId, polivkaId, pacinoId]);

    final petrik2_full_user = petrik2.copyWith(
        favoriteMovies: [peliskyId, shawshankId, dedictviId, darkKnightId],
        favoriteCelebrities: [baleId, polivkaId, donutilId, ledgerId]);

    final admin_full_user = admin.copyWith(favoriteMovies: [
      peliskyId,
      shawshankId,
      dedictviId,
      darkKnightId
    ], favoriteCelebrities: [
      baleId,
      polivkaId,
      brandoId,
      ledgerId,
      donutilId
    ]);

    _appUserService.add(marek1_full_user);
    _appUserService.add(marek2_full_user);
    _appUserService.add(petrik1_full_user);
    _appUserService.add(petrik2_full_user);
    _appUserService.add(admin_full_user);
  }
}
