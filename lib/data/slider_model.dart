class Slider {
  int? id;
  String? imageurl;
  String? createdat;
  String? title;
  String? description;

  Slider({this.id, this.imageurl, this.createdat,this.title,this.description});

  Slider.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageurl = json['image_url'];
    createdat = json['created_at'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['image_url'] = imageurl;
    data['created_at'] = createdat;
    data['title'] = title;
    data['description'] = description;
    return data;
  }
}

class SliderResponse {
  List<Slider?>? data;
  bool? success;
  int? statuscode;

  SliderResponse({this.data, this.success, this.statuscode});

  SliderResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Slider>[];
      json['data'].forEach((v) {
        data!.add(Slider.fromJson(v));
      });
    }
    success = json['success'];
    statuscode = json['status_code'];
  }


}

class NoticeResponse {
  Slider? data;
  bool? success;
  int? statuscode;

  NoticeResponse({this.data, this.success, this.statuscode});

  NoticeResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Slider?.fromJson(json['data']) : null;
    success = json['success'];
    statuscode = json['status_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['data'] = Slider().toJson();
    data['success'] = success;
    data['status_code'] = statuscode;
    return data;
  }
}

