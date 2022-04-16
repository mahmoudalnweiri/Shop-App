import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/models/search_model.dart';
import 'package:shop/modules/search/cubit/search_cubit.dart';
import 'package:shop/modules/search/cubit/search_states.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  var formKey = GlobalKey<FormState>();
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchCubit, SearchStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.black,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
          ),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.search),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: Colors.black12,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextFormField(
                              controller: searchController,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Please enter key word to search';
                                }
                                return null;
                              },
                              onChanged: (text) {
                                if(!RegExp(r'^[ ]*$').hasMatch(text)){
                                  SearchCubit.get(context).search(text: text);
                                }else{
                                  SearchCubit.get(context).clearListSearch();
                                }
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search',
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  if (state is SearchLoadingState)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  if (state is SearchSuccessState)
                    Expanded(
                      child: ListView.separated(
                        itemCount: SearchCubit.get(context)
                            .searchModel!
                            .data!
                            .data!
                            .length,
                        itemBuilder: (context, index) => buildSearchItem(
                            context,
                            SearchCubit.get(context)
                                .searchModel!
                                .data!
                                .data![index]),
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 1,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildSearchItem(BuildContext context, Product model) {
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
                    imageUrl: model.image!,
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
                        model.name!,
                        style: const TextStyle(
                            fontSize: 18,
                            height: 1.3,
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                      const Spacer(),
                      Text(
                        '${model.price}\$',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
