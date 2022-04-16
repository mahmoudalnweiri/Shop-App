import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop/layout/cubit/shop_cubit.dart';
import 'package:shop/layout/cubit/shop_states.dart';
import 'package:shop/models/categories_model.dart';
import 'package:shop/models/home_model.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ChangeFavoritesSuccessState) {
          if (!state.model.status!) {
            Fluttertoast.showToast(
                msg: state.model.message!, backgroundColor: Colors.red);
          }
        }
      },
      builder: (context, state) {
        var cubit = ShopCubit.get(context);

        return cubit.homeModel != null && cubit.categoriesModel != null
            ? productsBuilder(context, cubit.homeModel!, cubit.categoriesModel!)
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget productsBuilder(BuildContext context, HomeModel homeModel,
      CategoriesModel categoriesModel) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items: homeModel.data!.banners
                .map((e) => Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          image: DecorationImage(
                              image: NetworkImage(e.image!),
                              fit: BoxFit.cover)),
                    ))
                .toList(),
            options: CarouselOptions(
              height: 180.0,
              initialPage: 0,
              enlargeCenterPage: true,
              viewportFraction: 0.8,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(seconds: 1),
              autoPlayCurve: Curves.fastOutSlowIn,
              scrollDirection: Axis.horizontal,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Categories',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) =>
                    buildCategoryItem(categoriesModel.data!.data[index]),
                separatorBuilder: (context, index) =>
                    const SizedBox(width: 8.0),
                itemCount: categoriesModel.data!.data.length,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'New Products',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w800),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: Colors.grey[300],
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 5.0,
                childAspectRatio: 1 / 1.65,
                children:
                    List.generate(homeModel.data!.products.length, (index) {
                  return Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Stack(
                            alignment: AlignmentDirectional.bottomStart,
                            children: [
                              CachedNetworkImage(
                                imageUrl:
                                    homeModel.data!.products[index].image!,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                        child: CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                )),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                height: 200,
                                width: double.infinity,
                              ),
                              if (homeModel.data!.products[index].discount != 0)
                                Container(
                                  color: Colors.red,
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.0),
                                    child: Text(
                                      'discount',
                                      style: TextStyle(
                                          fontSize: 12.0, color: Colors.white),
                                    ),
                                  ),
                                ),
                              Positioned(
                                top: 2.0,
                                right: 2.0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white54,
                                  child: IconButton(
                                    onPressed: () {
                                      ShopCubit.get(context).changeFavorites(
                                          homeModel.data!.products[index].id!);
                                    },
                                    icon: ShopCubit.get(context).favorites[
                                            homeModel.data!.products[index].id]!
                                        ? const Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          )
                                        : const Icon(
                                            Icons.favorite_outline,
                                            color: Colors.black,
                                          ),
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                homeModel.data!.products[index].name!,
                                style: const TextStyle(
                                    height: 1.3, fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${homeModel.data!.products[index].price}\$',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  if (homeModel
                                          .data!.products[index].discount !=
                                      0)
                                    Text(
                                      '${homeModel.data!.products[index].oldPrice}\$',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryItem(DataModel dataModel) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: NetworkImage(dataModel.image!),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          width: 100,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
            ),
            color: Colors.black87,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              dataModel.name!,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ],
    );
  }
}
