import 'dart:convert';

List<Recipe> recipeFromJson(String str) => List<Recipe>.from(json.decode(str).map((x) => Recipe.fromJson(x)));

List<Recipe> recipeFromJson2(String str) => List<Recipe>.from(json.decode(str).map((x) => Recipe.fromJson2(x)));

String recipeToJson(List<Recipe> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Recipe {
    Recipe({
        this.id,
        this.createdAtTime,
        this.createdbyuser,
        required this.description,
        this.imagesList,
        required this.ingredients,
        required this.name,
        required this.shortdesc,
        this.v,
    });

    String? id;
    DateTime? createdAtTime;
    String? createdbyuser;
    String description;
    List<ImagesList>? imagesList;
    List<String> ingredients;
    String name;
    String shortdesc;
    int? v;

    factory Recipe.fromJson2(Map<String, dynamic> json) => Recipe(
        id: json["recipe"]["_id"],
        createdAtTime: DateTime.parse(json["recipe"]["createdAtTime"]),
        createdbyuser: json["recipe"]["createdbyuser"],
        description: json["recipe"]["description"],
        imagesList: List<ImagesList>.from(json["recipe"]["imagesList"].map((x) => ImagesList.fromJson(x))),
        ingredients: List<String>.from(json["recipe"]["ingredients"].map((x) => x)),
        name: json["recipe"]["name"],
        shortdesc: json["recipe"]["shortdesc"],
        v: json["recipe"]["__v"],
    );

    factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json["_id"],
        createdAtTime: DateTime.parse(json["createdAtTime"]),
        createdbyuser: json["createdbyuser"],
        description: json["description"],
        imagesList: List<ImagesList>.from(json["imagesList"].map((x) => ImagesList.fromJson(x))),
        ingredients: List<String>.from(json["ingredients"].map((x) => x)),
        name: json["name"],
        shortdesc: json["shortdesc"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "createdAtTime": createdAtTime!.toIso8601String(),
        "createdbyuser": createdbyuser,
        "description": description,
        "imagesList": List<dynamic>.from(imagesList!.map((x) => x.toJson())),
        "ingredients": List<dynamic>.from(ingredients.map((x) => x)),
        "name": name,
        "shortdesc": shortdesc,
        "__v": v,
    };
}

class ImagesList {
    ImagesList({
        this.uid,
        this.lastModified,
        this.lastModifiedDate,
        this.name,
        this.size,
        this.type,
        this.percent,
        this.originFileObj,
        this.error,
        this.response,
        this.status,
        this.thumbUrl,
    });

    String? uid;
    int? lastModified;
    DateTime? lastModifiedDate;
    String? name;
    int? size;
    String? type;
    int? percent;
    OriginFileObj? originFileObj;
    Error? error;
    String? response;
    String? status;
    String? thumbUrl;

    factory ImagesList.fromJson(Map<String, dynamic> json) => ImagesList(
        uid: json["uid"],
        lastModified: json["lastModified"],
        lastModifiedDate: DateTime.parse(json["lastModifiedDate"]),
        name: json["name"],
        size: json["size"],
        type: json["type"],
        percent: json["percent"],
        originFileObj: OriginFileObj.fromJson(json["originFileObj"]),
        error: Error.fromJson(json["error"]),
        response: json["response"],
        status: json["status"],
        thumbUrl: json["thumbUrl"],
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "lastModified": lastModified,
        "lastModifiedDate": lastModifiedDate!.toIso8601String(),
        "name": name,
        "size": size,
        "type": type,
        "percent": percent,
        "originFileObj": originFileObj!.toJson(),
        "error": error!.toJson(),
        "response": response,
        "status": status,
        "thumbUrl": thumbUrl,
    };
}

class Error {
    Error({
        this.status,
        this.method,
        this.url,
    });

    int? status;
    String? method;
    String? url;

    factory Error.fromJson(Map<String, dynamic> json) => Error(
        status: json["status"],
        method: json["method"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "method": method,
        "url": url,
    };
}

class OriginFileObj {
    OriginFileObj({
        this.uid,
    });

    String? uid;

    factory OriginFileObj.fromJson(Map<String, dynamic> json) => OriginFileObj(
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
    };
}
