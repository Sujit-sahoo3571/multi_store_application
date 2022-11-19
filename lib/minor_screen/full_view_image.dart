import 'package:flutter/material.dart';
import 'package:multi_store_application/widgets/appbar_widgets.dart';

class FullScreenView extends StatefulWidget {
  final List imageList;
  const FullScreenView({super.key, required this.imageList});

  @override
  State<FullScreenView> createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<FullScreenView> {
  final PageController _controller = PageController();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const AppbarTitle(subCategoryName: "Image Preview"),
        elevation: 0.0,
        leading: const AppBarBackButton(),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Center(
            child: Text(
              '${index + 1} / ${widget.imageList.length}',
              style: const TextStyle(
                  fontSize: 24.0, fontFamily: 'Poppins', letterSpacing: 5.0),
            ),
          ),
          SizedBox(
            height: size.height * 0.5,
            child: PageView(
              onPageChanged: (value) {
                setState(() {
                  index = value;
                });
              },
              controller: _controller,
              children: listOfImages(),
            ),
          ),
          SizedBox(
            height: size.height * 0.2,
            child: imageView(),
          ),
        ]),
      ),
    );
  }

  Widget imageView() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.imageList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _controller.jumpToPage(index);
            },
            child: Container(
              width: 120.0,
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.yellow, width: 2.0),
                  borderRadius: BorderRadius.circular(20.0)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18.0),
                child: Image.network(
                  widget.imageList[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        });
  }

  List<Widget> listOfImages() {
    return List.generate(widget.imageList.length, (index) {
      return InteractiveViewer(
          transformationController: TransformationController(),
          child: Image.network(widget.imageList[index].toString()));
    });
  }
}
