import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layout/cubit/shop_cubit.dart';
import 'package:shop/layout/cubit/shop_states.dart';
import 'package:shop/models/categories_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = ShopCubit.get(context);

        return cubit.categoriesModel != null ? ListView.separated(
          itemBuilder: (context, index) =>
              buildCatItem(cubit.categoriesModel!.data!.data[index]),
          separatorBuilder: (context, index) => const SizedBox(height: 1),
          itemCount: cubit.categoriesModel!.data!.data.length,
        ) : const Center(child: CircularProgressIndicator(),);
      },
    );
  }

  Widget buildCatItem(DataModel dataModel) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              imageUrl: dataModel.image!,
              progressIndicatorBuilder: (context, url, downloadProgress)=> Center(child: CircularProgressIndicator(value: downloadProgress.progress,)),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              height: 80.0,
              width: 80.0,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            dataModel.name!,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
