import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/layout/cubit/shop_cubit.dart';
import 'package:shop/layout/cubit/shop_states.dart';
import 'package:shop/models/favorites_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return state is! GetFavoritesLoadingState && ShopCubit.get(context).favoritesModel != null
            ? ListView.separated(
                itemCount:
                    ShopCubit.get(context).favoritesModel!.data!.data!.length,
                itemBuilder: (context, index) => buildFavItem(context,
                    ShopCubit.get(context).favoritesModel!.data!.data![index]),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 1,
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  Widget buildFavItem(BuildContext context, FavoritesData model) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        height: 120.0,
        width: double.infinity,
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CachedNetworkImage(
                    imageUrl: model.product!.image!,
                    progressIndicatorBuilder: (context, url, downloadProgress)=> Center(child: CircularProgressIndicator(value: downloadProgress.progress,)),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    height: 120,
                    width: 120,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.product!.name!,
                        style: const TextStyle(
                            fontSize: 18,
                            height: 1.3,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            '${model.product!.price}\$',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          if (model.product!.discount != 0)
                            Text(
                              '${model.product!.oldPrice}\$',
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
            CircleAvatar(
              backgroundColor: Colors.white54,
              child: IconButton(
                onPressed: () {
                  ShopCubit.get(context).changeFavorites(model.product!.id!);
                },
                icon: ShopCubit.get(context).favorites[model.product!.id]!
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_outline,
                        color: Colors.black87,
                      ),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
