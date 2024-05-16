import 'package:get_it/get_it.dart';
import 'package:movie_catalog/celebrity/service/celebrity_mock_data.dart';
import 'package:movie_catalog/common/service/fire_storage.dart';
import 'package:movie_catalog/movie/service/movie_mock_data.dart';

class ImageSeeder {
  final _storageService = GetIt.I.get<FireStorage>();
  void seed() {
    _storageService.uploadImage(pelisky.bannerImage);
    _storageService.uploadImage(pelisky.posterImage);
    _storageService.uploadImage(casino_royal.bannerImage);
    _storageService.uploadImage(casino_royal.posterImage);
    _storageService.uploadImage(dedictvi.bannerImage);
    _storageService.uploadImage(dedictvi.posterImage);
    _storageService.uploadImage(shawshank.bannerImage);
    _storageService.uploadImage(shawshank.posterImage);
    _storageService.uploadImage(dark_knight.bannerImage);
    _storageService.uploadImage(dark_knight.posterImage);
    _storageService.uploadImage(godfather.bannerImage);
    _storageService.uploadImage(godfather.posterImage);

    _storageService.uploadImage(hrebejek.avatar);
    _storageService.uploadImage(jarchovksy.avatar);
    _storageService.uploadImage(kodet.avatar);
    _storageService.uploadImage(vasaryova.avatar);
    _storageService.uploadImage(polivka.avatar);
    _storageService.uploadImage(donutil.avatar);
    _storageService.uploadImage(malir.avatar);
    _storageService.uploadImage(hlas.avatar);
    _storageService.uploadImage(chytilova.avatar);
    _storageService.uploadImage(havlova.avatar);
    _storageService.uploadImage(kroner.avatar);
    _storageService.uploadImage(sanders.avatar);
    _storageService.uploadImage(bulis.avatar);
    _storageService.uploadImage(campbell.avatar);
    _storageService.uploadImage(purvis.avatar);
    _storageService.uploadImage(craig.avatar);
    _storageService.uploadImage(green.avatar);
    _storageService.uploadImage(mikkelsen.avatar);
    _storageService.uploadImage(dench.avatar);
    _storageService.uploadImage(meheux.avatar);
    _storageService.uploadImage(arnold.avatar);
    _storageService.uploadImage(darabont.avatar);
    _storageService.uploadImage(king.avatar);
    _storageService.uploadImage(robbins.avatar);
    _storageService.uploadImage(freeman.avatar);
    _storageService.uploadImage(gunton.avatar);
    _storageService.uploadImage(coppola.avatar);
    _storageService.uploadImage(puzzo.avatar);
    _storageService.uploadImage(brando.avatar);
    _storageService.uploadImage(pacino.avatar);
    _storageService.uploadImage(caan.avatar);
    _storageService.uploadImage(nolan.avatar);
    _storageService.uploadImage(nolan2.avatar);
    _storageService.uploadImage(bale.avatar);
    _storageService.uploadImage(ledger.avatar);
    _storageService.uploadImage(eckhart.avatar);
  }
}
