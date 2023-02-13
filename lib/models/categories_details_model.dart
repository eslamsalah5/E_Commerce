class CategoryDetailModel {
  dynamic status;
  Data? data;

  CategoryDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = Data.fromJson(json['data']);
  }
}

class Data {
  int? currentPage;
  List<ProductData>? productData;

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    productData = [];
    json['data'].forEach((element) {
      productData!.add(ProductData.fromJson(element));
    });
  }
}

class ProductData {
  int? id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  String? image;
  String? name;
  String? description;
  List<String>? images;
  dynamic inFavorites;
  dynamic inCart;

  ProductData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    images = json['images'].cast<String>();
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }
}