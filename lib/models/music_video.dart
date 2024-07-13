class MusicModel {
  int resultCount;
  List<MusicVideo> musics;

  MusicModel({
    required this.resultCount,
    required this.musics,
  });

  factory MusicModel.fromJson(Map<String, dynamic> json) {
    var resultsList = json['results'] as List<dynamic>;
    List<MusicVideo> musics = resultsList.map((e) => MusicVideo.fromJson(e)).toList();

    return MusicModel(
      resultCount: json['resultCount'] ?? 0,
      musics: musics,
    );
  }
}

class MusicVideo {
  final String wrapperType;
  final String kind;
  final int artistId;
  final int collectionId;
  final int trackId;
  final String artistName;
  final String collectionName;
  final String trackName;
  final String collectionCensoredName;
  final String trackCensoredName;
  final String artistViewUrl;
  final String collectionViewUrl;
  final String trackViewUrl;
  final String previewUrl;
  final String artworkUrl30;
  final String artworkUrl60;
  final double collectionPrice;
  final double trackPrice;
  final String releaseDate;
  final String collectionExplicitness;
  final String trackExplicitness;
  final int discCount;
  final int discNumber;
  final int trackCount;
  final int trackNumber;
  final int trackTimeMillis;
  final String country;
  final String currency;
  final String primaryGenreName;

  MusicVideo({
    required this.wrapperType,
    required this.kind,
    required this.artistId,
    required this.collectionId,
    required this.trackId,
    required this.artistName,
    required this.collectionName,
    required this.trackName,
    required this.collectionCensoredName,
    required this.trackCensoredName,
    required this.artistViewUrl,
    required this.collectionViewUrl,
    required this.trackViewUrl,
    required this.previewUrl,
    required this.artworkUrl30,
    required this.artworkUrl60,
    required this.collectionPrice,
    required this.trackPrice,
    required this.releaseDate,
    required this.collectionExplicitness,
    required this.trackExplicitness,
    required this.discCount,
    required this.discNumber,
    required this.trackCount,
    required this.trackNumber,
    required this.trackTimeMillis,
    required this.country,
    required this.currency,
    required this.primaryGenreName,
  });

  factory MusicVideo.fromJson(Map<String, dynamic> json) {
    return MusicVideo(
      wrapperType: handleStringType(json['wrapperType']),
      kind: handleStringType(json['kind']),
      artistId: json['artistId'] as int? ?? 0,
      collectionId: json['collectionId'] as int? ?? 0,
      trackId: json['trackId'] as int? ?? 0,
      artistName: handleStringType(json['artistName']),
      collectionName: handleStringType(json['collectionName']),
      trackName: handleStringType(json['trackName']),
      collectionCensoredName: handleStringType(json['collectionCensoredName']),
      trackCensoredName: handleStringType(json['trackCensoredName']),
      artistViewUrl: handleStringType(json['artistViewUrl']),
      collectionViewUrl: handleStringType(json['collectionViewUrl']),
      trackViewUrl: handleStringType(json['trackViewUrl']),
      previewUrl: handleStringType(json['previewUrl']),
      artworkUrl30: handleStringType(json['artworkUrl30']),
      artworkUrl60: handleStringType(json['artworkUrl60']),
      collectionPrice: (json['collectionPrice'] as num?)?.toDouble() ?? 0.0,
      trackPrice: (json['trackPrice'] as num?)?.toDouble() ?? 0.0,
      releaseDate: handleStringType(json['releaseDate']),
      collectionExplicitness: handleStringType(json['collectionExplicitness']),
      trackExplicitness: handleStringType(json['trackExplicitness']),
      discCount: json['discCount'] as int? ?? 0,
      discNumber: json['discNumber'] as int? ?? 0,
      trackCount: json['trackCount'] as int? ?? 0,
      trackNumber: json['trackNumber'] as int? ?? 0,
      trackTimeMillis: json['trackTimeMillis'] as int? ?? 0,
      country: handleStringType(json['country']),
      currency: handleStringType(json['currency']),
      primaryGenreName: handleStringType(json['primaryGenreName']),
    );
  }
}

String handleStringType(dynamic data) {
  if (data == null) {
    return '';
  }
  if (data is String) {
    return data;
  } else {
    return data.toString();
  }
}
