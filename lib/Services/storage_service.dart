import 'package:flutter_secure_storage/flutter_secure_storage.dart';

//STORAGE ITEM MODEL
class StorageItem {
  StorageItem(this.key, this.value);

  final String key;
  final String value;
}

class StorageService {
  final _secureStorage = const FlutterSecureStorage();

  //The method responsible for writing data into secure storage:
  Future<void> writeSecureData(StorageItem newItem) async {
    await _secureStorage.write(
        key: newItem.key, value: newItem.value, aOptions: _getAndroidOptions());
  }
  //_getAndroidOptions() is a method of the StorageService class used to set the encryptedSharedPreference property to true
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
  encryptedSharedPreferences: true,
  );



  //readSecureData method to read the secured data concerning the key
  Future<String?> readSecureData(String key) async {
    var readData =
    await _secureStorage.read(key: key, aOptions: _getAndroidOptions());
    return readData;
  }


  //To delete a key-value pair, create the deleteSecureData method
  Future<void> deleteSecureData(StorageItem item) async {
    await _secureStorage.delete(key: item.key, aOptions: _getAndroidOptions());
  }


  //Create a containsKeyInSecureData method responsible for checking whether the storage contains the provided key or not
  Future<bool> containsKeyInSecureData(String key) async {
    var containsKey = await _secureStorage.containsKey(key: key, aOptions: _getAndroidOptions());
    return containsKey;
  }


  //To read all the secured data, create the readAllSecureData method
  Future<List<StorageItem>> readAllSecureData() async {
    var allData = await _secureStorage.readAll(aOptions: _getAndroidOptions());
    List<StorageItem> list =
    allData.entries.map((e) => StorageItem(e.key, e.value)).toList();
    return list;
  }


  //To delete all the secured data, create the deleteAllSecureData method
  Future<void> deleteAllSecureData() async {
    await _secureStorage.deleteAll(aOptions: _getAndroidOptions());
  }

}

