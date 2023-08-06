import 'package:flutter/material.dart';

class ExplorerHeader extends StatelessWidget {
  final String text;
  final VoidCallback? onBackButtonPressed;

  ExplorerHeader({required this.text, this.onBackButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Occupe toute la largeur du composant parent
      height: 50.0, // Hauteur du widget (peut être ajustée selon vos besoins)
      color: Colors.blue, // Couleur du fond du widget (peut être modifiée)
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBackButtonPressed,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize:
                  20.0, // Taille du texte (peut être ajustée selon vos besoins)
              fontWeight: FontWeight.bold,
              color: Colors.white, // Couleur du texte (peut être modifiée)
            ),
          ),
          const SizedBox(), // Espace vide au milieu pour que le texte reste au milieu
        ],
      ),
    );
  }
}
