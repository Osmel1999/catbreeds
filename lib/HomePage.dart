import 'dart:async';

import 'package:catbreeds/InfoPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/api_catbreeds.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late API api;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      api.fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    api = Provider.of<API>(context);
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: media.height,
          width: media.width,
          alignment: Alignment.center,
          child: const Text('CatBreeds'),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: media.width * 0.01),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Buscador
            Expanded(
                flex: 1,
                child: Search(
                  api: api,
                )),
            Expanded(
              flex: 9,
              child: Container(
                child: (api.data!.isNotEmpty)
                    ? Contenido(
                        lista: (api.busqueda.isNotEmpty)
                            ? api.busqueda
                            : api.data!,
                      )
                    : (api.data!.isEmpty)
                        ? Center(
                            child: SizedBox(
                                height: media.height * 0.02,
                                width: media.height * 0.02,
                                child:
                                    const CircularProgressIndicator.adaptive()),
                          )
                        : const ErrorLoad(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Search extends StatelessWidget {
  final API api;
  const Search({super.key, required this.api});

  @override
  Widget build(BuildContext context) {
    Timer? debounce;
    var media = MediaQuery.of(context).size;

    void onSearchChanged(String query, API api) async {
  
      if (debounce?.isActive ?? false) {
        debounce!.cancel();
      }
      debounce = Timer(const Duration(seconds: 1), () async {
        // Iniciamos busqueda
        api.searcCat(query);
      });
    }

    return Padding(
      padding: EdgeInsets.only(bottom: media.height * 0.01),
      child: Card(
        color: Colors.white,
        child: SizedBox(
          width: media.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 8,
                child: TextFormField(
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(color: Colors.transparent)),
                      filled: true,
                      fillColor: Colors.transparent,
                      hintText: 'Search cat',
                    ),
                    textCapitalization: TextCapitalization.words,
                    onChanged: (text) {
                      onSearchChanged(text, api);
                    }),
              ),
              const Expanded(flex: 1, child: Icon(Icons.search_rounded)),
            ],
          ),
        ),
      ),
    );
  }

}


class Contenido extends StatelessWidget {
  final List lista;
  const Contenido({super.key, required this.lista});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return ListView.builder(
        itemCount: lista.length,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => InfoPage(
                  name: lista[i]['name'],
                  image:
                      "https://cdn2.thecatapi.com/images/${lista[i]['reference_image_id']}.jpg",
                  texto: lista[i]['description'],
                ),
              ),
            ),
            child: Card(
              color: Colors.white,
              child: SizedBox(
                height: media.height * 0.5,
                width: media.width * 0.9,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: media.width * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(lista[i]['name']),
                            const Text('Mas...')
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 6,
                        child: ImageWithLoadingIndicator(
                            imageUrl:
                                "https://cdn2.thecatapi.com/images/${lista[i]['reference_image_id']}.jpg")),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: media.width * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(lista[i]['origin']),
                            Text(getQuality(lista[i]['temperament']))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class ImageWithLoadingIndicator extends StatelessWidget {
  final String imageUrl;

  const ImageWithLoadingIndicator({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/loading.gif',
      image: imageUrl,
      fadeInDuration: const Duration(milliseconds: 500),
      fadeInCurve: Curves.easeIn,
      imageErrorBuilder: (context, error, stackTrace) {
        return const Center(child: Text('Error al cargar la imagen'));
      },
    );
  }
}

class ErrorLoad extends StatelessWidget {
  const ErrorLoad({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Imagen de erro
        Expanded(
            flex: 2,
            child: Image.asset(
              'assets/sad.png',
              scale: 4,
            )),
        // Texto error
        const Expanded(
            flex: 1, child: Text('Lo sentimos, se presento un error')),
      ],
    );
  }
}
