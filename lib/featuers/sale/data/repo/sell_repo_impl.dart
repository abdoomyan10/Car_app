import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repo/sell_repo.dart';
import '../datasource/sell_datasourcef.dart';

@Injectable(as: SellCarRepository)
class SellCarRepositoryImpl implements SellCarRepository {
  final SellCarRemoteDataSource remoteDataSource;

  SellCarRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<String>> uploadImages(List<XFile> imageFiles, String carId) async {
    List<String> imageUrls = [];
    final result = await Future.wait(
      imageFiles.map((e) async => await remoteDataSource.uploadImage(e)),
    );
    imageUrls.addAll(result);
    return imageUrls;
  }

  @override
  Future<void> submitCarListing({
    required String carModel,
    required int year,
    required double price,
    required String phone,
    required String carType,
    required String transmission,
    required String description,
    required String city,
    required List<String> imageUrls,
  }) async {
    print(imageUrls);
    return await remoteDataSource.submitCarListing(
      carModel: carModel,
      year: year,
      price: price,
      phone: phone,
      carType: carType,
      transmission: transmission,
      description: description,
      city: city,
      imageUrls: imageUrls,
    );
  }
}
