import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isHidden;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.isHidden = false,
  });

  @override
  CustomTextFieldState createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = false;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    // Si isHidden es true, no mostrar el campo de texto
    if (widget.isHidden) {
      return const SizedBox.shrink(); // Devuelve un widget vacío
    }

    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: 8.0), // Espacio vertical entre campos
      decoration: BoxDecoration(
        color: Colors.grey[200], // Color de fondo del contenedor
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: _isObscured,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          labelText: widget.labelText,
          border:
              InputBorder.none, // Sin borde para usar el borde del contenedor
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          prefixIcon: widget.prefixIcon, // Icono al inicio del campo
          suffixIcon: _buildSuffixIcon(), // Construir el ícono de suffix
        ),
      ),
    );
  }

  // Construir el ícono de suffix para alternar entre ocultar y mostrar la contraseña
  Widget _buildSuffixIcon() {
    // Si el campo no está en modo de contraseña, devuelve el suffixIcon directamente
    if (!widget.obscureText) {
      return widget.suffixIcon ?? const SizedBox.shrink();
    }

    return IconButton(
      icon: Icon(_isObscured ? Icons.visibility_off : Icons.visibility),
      onPressed: _toggleObscureText,
    );
  }

  // Función para alternar entre ocultar y mostrar la contraseña
  void _toggleObscureText() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }
}
