import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../main/cubit.dart';
import '../../../../main/state.dart';
import '../../../../shared/components/components.dart';
import '../../home/product_details.dart';
class CategoriesDetailsScreen extends StatelessWidget {
   CategoriesDetailsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {
        if (state is ChangeFavoritesSuccessStates) {
          if (state.model.status!) {
            showToast(
              text: state.model.message!,
              state: ToastStates.success,
            );
          } else {
            showToast(
              text: state.model.message!,
              state: ToastStates.error,
            );
          }
        }
      },
      builder: (context, state) {
        return BlocConsumer<MainCubit, MainStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              body: ConditionalBuilder(
                condition: state is! CategoryDetailsLoadingStates,
                builder: (context) => ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => buildListProduct(
                      MainCubit.get(context)
                          .categoryDetailModel
                          ?.data!.productData![index],
                      context),
                  separatorBuilder: (context, index) => myDivider(),
                  itemCount:
                  MainCubit.get(context).categoryDetailModel!.data!.productData!.length,
                ),
                fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
              ),
            );
          },
        );
      },
    );
  }

   Widget buildListProduct(
       model,
       context, {
         isOldPrice = true,
       }) =>
       InkWell(
         onTap:() {
           MainCubit.get(context).getProductData(model.id!);
           navigateTo(context, ProductDetailsScreen());
         },
         child: Padding(
           padding: const EdgeInsets.all(20.0),
           child: SizedBox(
             height: 446.0,
             child:  Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Stack(children: [
                   Image(
                     image: NetworkImage('${model.image}'),
                     height: 240,
                     width: double.infinity,
                   ),
                   Positioned(
                     top: 10,
                     right: 0,
                     child: IconButton(
                       onPressed: () {
                         MainCubit.get(context).changeFavorites(model.id!);
                       },
                       icon: Icon(
                         MainCubit.get(context).favorites[model.id]
                             ? Icons.favorite
                             : Icons.favorite_border,
                         color: MainCubit.get(context).favorites[model.id]
                             ? Colors.red
                             : Colors.grey,
                         size: 35,
                       ),
                     ),
                   ),
                   if (model.discount != 0)
                     Positioned.fill(
                       child: Align(
                         alignment: const Alignment(1, -1),
                         child: ClipRect(
                           child: Banner(
                             message: 'OFFERS',
                             textStyle: const TextStyle(
                               fontFamily: 'Roboto',
                               fontWeight: FontWeight.bold,
                               fontSize: 12,
                               letterSpacing: 0.5,
                             ),
                             location: BannerLocation.topStart,
                             color: Colors.red,
                             child: Container(
                               height: 100.0,
                             ),
                           ),
                         ),
                       ),
                     ),
                 ]),
                 const SizedBox(height: 10),
                 Text(
                   '${model.name}',
                   maxLines: 3,
                   overflow: TextOverflow.ellipsis,
                 ),
                 Padding(
                   padding: const EdgeInsets.symmetric(vertical: 10),
                   child: Text(
                     '${model.description}',
                     maxLines: 5,
                     overflow: TextOverflow.ellipsis,
                   ),
                 ),
                 const SizedBox(
                   height: 5,
                 ),
                 Row(
                   crossAxisAlignment: CrossAxisAlignment.end,
                   children: [
                     Text(
                       '${model.price} LE',
                       style: const TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 20,
                       ),
                     ),
                     const SizedBox(
                       width: 10,
                     ),
                     if (model.discount != 0)
                       Text(
                         '${model.oldPrice} LE',
                         style: const TextStyle(
                             fontSize: 12,
                             decoration: TextDecoration.lineThrough,
                             color: Colors.grey),
                       ),
                     const Spacer(),
                     Text(
                       '${model.discount} % OFF',
                       style: const TextStyle(color: Colors.red, fontSize: 11),
                     )
                   ],
                 )
               ],
             ),
           ),
         ),
       );
}
