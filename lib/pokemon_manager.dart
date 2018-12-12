import 'package:flutter/material.dart';

import 'pokemonList.dart';

class PokemonManager extends StatelessWidget {
  final List<Map<String, dynamic>> pokemonList;

  PokemonManager(this.pokemonList);

  @override
  Widget build(BuildContext context) {
    return Column(children: [Expanded(child: PokemonList(pokemonList))]);
  }
}
