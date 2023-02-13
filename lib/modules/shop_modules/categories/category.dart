import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop2/modules/shop_modules/categories/categories%20details/categories_details_screen.dart';
import '../../../main/cubit.dart';
import '../../../main/state.dart';
import '../../../models/category_model.dart';
import '../../../shared/components/components.dart';


class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => catList(
              MainCubit.get(context).categoriesModel!.data!.data[index], context,),
          separatorBuilder: (context, index) => myDivider(),
          itemCount: MainCubit.get(context).categoriesModel!.data!.data.length,
        );
      },
    );
  }
  
  Widget catList(DataModel model, context) => InkWell(
    onTap: () {
      MainCubit.get(context).getCategoryDetailsData(model.id!);
      navigateTo(context, CategoriesDetailsScreen());
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.deepPurple, width: 2),
              image: DecorationImage(
                image: NetworkImage(
                  model.image!,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          Text(
            model.name!.toUpperCase(),
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_forward_ios,
            ),
          ),
        ],
      ),
    ),
  );
}
