class CategoriesModel {
  bool? status;
  CategoriesDataModel? data;

  CategoriesModel.formJson(Map<String, dynamic> json){
    status = json['status'];
    data = CategoriesDataModel.fromJson(json['data']);
  }
}

class CategoriesDataModel {
  int? currentPage;
  List<DataModel> data = [];

  CategoriesDataModel.fromJson(Map<String, dynamic> json){
    currentPage = json['current_page'];

    for(var element in json['data']){
      data.add(DataModel.fromJson(element));
    }
  }
}

class DataModel {
  int? id;
  String? name;
  String? image;

  DataModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}