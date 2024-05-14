
import 'dart:convert';

MusicModel musicModelFromJson(String str) => MusicModel.fromJson(json.decode(str));

String musicModelToJson(MusicModel data) => json.encode(data.toJson());

class MusicModel {
    final int? id;
    final bool? readable;
    final String? title;
    final String? titleShort;
    final String? titleVersion;
    final String? link;
    final int? duration;
    final int? rank;
    final bool? explicitLyrics;
    final int? explicitContentLyrics;
    final int? explicitContentCover;
    final String? preview;
    final List<Contributor>? contributors;
    final String? md5Image;
    final Artist? artist;
    final Album? album;
    final String? type;

    MusicModel({
        this.id,
        this.readable,
        this.title,
        this.titleShort,
        this.titleVersion,
        this.link,
        this.duration,
        this.rank,
        this.explicitLyrics,
        this.explicitContentLyrics,
        this.explicitContentCover,
        this.preview,
        this.contributors,
        this.md5Image,
        this.artist,
        this.album,
        this.type,
    });

    MusicModel copyWith({
        int? id,
        bool? readable,
        String? title,
        String? titleShort,
        String? titleVersion,
        String? link,
        int? duration,
        int? rank,
        bool? explicitLyrics,
        int? explicitContentLyrics,
        int? explicitContentCover,
        String? preview,
        List<Contributor>? contributors,
        String? md5Image,
        Artist? artist,
        Album? album,
        String? type,
    }) => 
        MusicModel(
            id: id ?? this.id,
            readable: readable ?? this.readable,
            title: title ?? this.title,
            titleShort: titleShort ?? this.titleShort,
            titleVersion: titleVersion ?? this.titleVersion,
            link: link ?? this.link,
            duration: duration ?? this.duration,
            rank: rank ?? this.rank,
            explicitLyrics: explicitLyrics ?? this.explicitLyrics,
            explicitContentLyrics: explicitContentLyrics ?? this.explicitContentLyrics,
            explicitContentCover: explicitContentCover ?? this.explicitContentCover,
            preview: preview ?? this.preview,
            contributors: contributors ?? this.contributors,
            md5Image: md5Image ?? this.md5Image,
            artist: artist ?? this.artist,
            album: album ?? this.album,
            type: type ?? this.type,
        );

    factory MusicModel.fromJson(Map<String, dynamic> json) => MusicModel(
        id: json["id"],
        readable: json["readable"],
        title: json["title"],
        titleShort: json["title_short"],
        titleVersion: json["title_version"],
        link: json["link"],
        duration: json["duration"],
        rank: json["rank"],
        explicitLyrics: json["explicit_lyrics"],
        explicitContentLyrics: json["explicit_content_lyrics"],
        explicitContentCover: json["explicit_content_cover"],
        preview: json["preview"],
        contributors: json["contributors"] == null ? [] : List<Contributor>.from(json["contributors"]!.map((x) => Contributor.fromJson(x))),
        md5Image: json["md5_image"],
        artist: json["artist"] == null ? null : Artist.fromJson(json["artist"]),
        album: json["album"] == null ? null : Album.fromJson(json["album"]),
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "readable": readable,
        "title": title,
        "title_short": titleShort,
        "title_version": titleVersion,
        "link": link,
        "duration": duration,
        "rank": rank,
        "explicit_lyrics": explicitLyrics,
        "explicit_content_lyrics": explicitContentLyrics,
        "explicit_content_cover": explicitContentCover,
        "preview": preview,
        "contributors": contributors == null ? [] : List<dynamic>.from(contributors!.map((x) => x.toJson())),
        "md5_image": md5Image,
        "artist": artist?.toJson(),
        "album": album?.toJson(),
        "type": type,
    };
}

class Album {
    final int? id;
    final String? title;
    final String? cover;
    final String? coverSmall;
    final String? coverMedium;
    final String? coverBig;
    final String? coverXl;
    final String? md5Image;
    final String? tracklist;
    final String? type;

    Album({
        this.id,
        this.title,
        this.cover,
        this.coverSmall,
        this.coverMedium,
        this.coverBig,
        this.coverXl,
        this.md5Image,
        this.tracklist,
        this.type,
    });

    Album copyWith({
        int? id,
        String? title,
        String? cover,
        String? coverSmall,
        String? coverMedium,
        String? coverBig,
        String? coverXl,
        String? md5Image,
        String? tracklist,
        String? type,
    }) => 
        Album(
            id: id ?? this.id,
            title: title ?? this.title,
            cover: cover ?? this.cover,
            coverSmall: coverSmall ?? this.coverSmall,
            coverMedium: coverMedium ?? this.coverMedium,
            coverBig: coverBig ?? this.coverBig,
            coverXl: coverXl ?? this.coverXl,
            md5Image: md5Image ?? this.md5Image,
            tracklist: tracklist ?? this.tracklist,
            type: type ?? this.type,
        );

    factory Album.fromJson(Map<String, dynamic> json) => Album(
        id: json["id"],
        title: json["title"],
        cover: json["cover"],
        coverSmall: json["cover_small"],
        coverMedium: json["cover_medium"],
        coverBig: json["cover_big"],
        coverXl: json["cover_xl"],
        md5Image: json["md5_image"],
        tracklist: json["tracklist"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "cover": cover,
        "cover_small": coverSmall,
        "cover_medium": coverMedium,
        "cover_big": coverBig,
        "cover_xl": coverXl,
        "md5_image": md5Image,
        "tracklist": tracklist,
        "type": type,
    };
}

class Artist {
    final int? id;
    final String? name;
    final String? tracklist;
    final String? type;

    Artist({
        this.id,
        this.name,
        this.tracklist,
        this.type,
    });

    Artist copyWith({
        int? id,
        String? name,
        String? tracklist,
        String? type,
    }) => 
        Artist(
            id: id ?? this.id,
            name: name ?? this.name,
            tracklist: tracklist ?? this.tracklist,
            type: type ?? this.type,
        );

    factory Artist.fromJson(Map<String, dynamic> json) => Artist(
        id: json["id"],
        name: json["name"],
        tracklist: json["tracklist"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tracklist": tracklist,
        "type": type,
    };
}

class Contributor {
    final int? id;
    final String? name;
    final String? link;
    final String? share;
    final String? picture;
    final String? pictureSmall;
    final String? pictureMedium;
    final String? pictureBig;
    final String? pictureXl;
    final bool? radio;
    final String? tracklist;
    final String? type;
    final String? role;

    Contributor({
        this.id,
        this.name,
        this.link,
        this.share,
        this.picture,
        this.pictureSmall,
        this.pictureMedium,
        this.pictureBig,
        this.pictureXl,
        this.radio,
        this.tracklist,
        this.type,
        this.role,
    });

    Contributor copyWith({
        int? id,
        String? name,
        String? link,
        String? share,
        String? picture,
        String? pictureSmall,
        String? pictureMedium,
        String? pictureBig,
        String? pictureXl,
        bool? radio,
        String? tracklist,
        String? type,
        String? role,
    }) => 
        Contributor(
            id: id ?? this.id,
            name: name ?? this.name,
            link: link ?? this.link,
            share: share ?? this.share,
            picture: picture ?? this.picture,
            pictureSmall: pictureSmall ?? this.pictureSmall,
            pictureMedium: pictureMedium ?? this.pictureMedium,
            pictureBig: pictureBig ?? this.pictureBig,
            pictureXl: pictureXl ?? this.pictureXl,
            radio: radio ?? this.radio,
            tracklist: tracklist ?? this.tracklist,
            type: type ?? this.type,
            role: role ?? this.role,
        );

    factory Contributor.fromJson(Map<String, dynamic> json) => Contributor(
        id: json["id"],
        name: json["name"],
        link: json["link"],
        share: json["share"],
        picture: json["picture"],
        pictureSmall: json["picture_small"],
        pictureMedium: json["picture_medium"],
        pictureBig: json["picture_big"],
        pictureXl: json["picture_xl"],
        radio: json["radio"],
        tracklist: json["tracklist"],
        type: json["type"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "link": link,
        "share": share,
        "picture": picture,
        "picture_small": pictureSmall,
        "picture_medium": pictureMedium,
        "picture_big": pictureBig,
        "picture_xl": pictureXl,
        "radio": radio,
        "tracklist": tracklist,
        "type": type,
        "role": role,
    };
}
