import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/Pages/NumberPlateSelector.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';
import 'package:uuid/uuid.dart';

class Services extends StatelessWidget {
  Services({Key key, this.numberPlate}) : super(key: key);
  final String numberPlate;

  List<Map<String, Object>> myList = [
    {
      'price': '250',
      'title': 'Door Cleaning',
      'img_url':
          'https://i.pinimg.com/originals/a7/54/b9/a754b9f831679abce99d732da447bae1.jpg',
      'description': 'full door cleaning and polishing',
    },
    {
      'price': '400',
      'title': 'Full Body Wash',
      'img_url':
          'https://www.columbiatireauto.com/Portals/7/soft-touch-car-wash-pros-cons.PNG',
      'description': 'Full body wash only from outside',
    },
    {
      'price': '300',
      'title': 'Car inside Cleaning',
      'img_url':
          'https://media-cldnry.s-nbcnews.com/image/upload/t_fit-2000w,f_auto,q_auto:best/newscms/2018_13/1275414/clean-car-vacuum-today-170814-tease.jpg',
      'description': 'full body Respray',
    },
    {
      'price': '500',
      'title': 'Car Respray',
      'img_url':
          'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/car-painting-technology-royalty-free-image-467478662-1557523321.jpg',
      'description': 'full body Respray',
    },
    {
      'price': '500',
      'title': 'Car Respray',
      'img_url':
          'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/car-painting-technology-royalty-free-image-467478662-1557523321.jpg',
      'description': 'full body Respray',
    },
    {
      'price': '500',
      'title': 'Car Respray',
      'img_url':
          'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/car-painting-technology-royalty-free-image-467478662-1557523321.jpg',
      'description': 'full body Respray',
    },
    {
      'price': '500',
      'title': 'Car Respray',
      'img_url':
          'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/car-painting-technology-royalty-free-image-467478662-1557523321.jpg',
      'description': 'full body Respray',
    },
    {
      'price': '500',
      'title': 'Car Respray',
      'img_url':
          'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/car-painting-technology-royalty-free-image-467478662-1557523321.jpg',
      'description': 'full body Respray',
    },
  ];

  final List<Widget> fancyCards = [
    FancyCard(
      image: "https://thumbs.dreamstime.com/z/hand-wiping-dirty-glass-cleaning-window-house-car-fabric-concept-cartoon-illustration-vector-eps-219299529.jpg",
      title: "Window Cleaning",
      price: "RS.100",
    ),
    FancyCard(
      image: "https://image.freepik.com/free-vector/car-wash-cartoon-vector_23-2147498053.jpg",
      title: "Full Car Wash",
      price: "RS.400",
    ),
    FancyCard(
      image: "https://lh3.googleusercontent.com/proxy/H7BZ_ljfNrBDWloq5S8zl8oGurKwCFtAXqOZVa9BrEO-xKslO5Sr-LuJym-eNDIOY99dfzTF_nS0lstWTzTvMlnyMKSHuY8",
      title: "Car Vacuum",
      price: "RS.1000",
    ),
    FancyCard(
      image: "https://previews.123rf.com/images/prettyvectors/prettyvectors1605/prettyvectors160500136/56625826-car-painting-vector-flat-cartoon-illustration.jpg",
      title: "Paint Job",
      price: "RS.10000",
    ),
    FancyCard(
      image: "https://previews.123rf.com/images/djvstock/djvstock1712/djvstock171209808/92414820-tire-gauge-measuring-the-tire-pressure-in-colored-design-cartoon-illustration-.jpg",
      title: "Tyre Pressure",
      price: "RS.50",
    ),
    FancyCard(
      image: "https://kiamotors-portqasim.com/wp-content/uploads/2020/02/Wheel-Alignment-and-Balancing-800x577.png",
      title: "Wheel Alignment",
      price: "RS.2000",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return StackedCardCarousel(
      items: fancyCards,
    );
    // return Padding(
    //   padding: const EdgeInsets.all(10.0),
    //   child: GridView.builder(
    //     itemCount: myList.length,
    //     scrollDirection: Axis.vertical,
    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //         crossAxisCount: 2,
    //         crossAxisSpacing: 5.0,
    //         childAspectRatio: 0.7,
    //         mainAxisSpacing: 5.0),
    //     itemBuilder: (BuildContext context, int index) {
    //       return Stack(
    //         children: [
    //           Card(
    //               clipBehavior: Clip.antiAlias,
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(20.0),
    //               ),
    //               child: ClipRRect(
    //                 borderRadius: BorderRadius.circular(20.0),
    //                 child: Image.network(
    //                   myList[index]['img_url'],
    //                   fit: BoxFit.cover,
    //                 ),
    //               )
    //           ),
    //
    //         ],
    //       );
    //     },
    //   ),
    // );
  }
}

class FancyCard extends StatelessWidget {
  const FancyCard({
    Key key,
    this.image,
    this.title,
    this.price
  }) : super(key: key);

  final String image;
  final String title;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey.shade100,
      elevation: 4.0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width/1.3,
            height: MediaQuery.of(context).size.height/2.2,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover
              )
            )
          ),
          Positioned(
            bottom: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width/1.3,
                child: Card(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  elevation: 10.0,
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white),
                      ),
                      Text(
                        price,
                        style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                        child: const Text("BUY NOW",style:
                        TextStyle(color: Colors.black)),
                        onPressed: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context) => NumberPlateSelector(imageUrl: image,title: title,price: price,)));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
