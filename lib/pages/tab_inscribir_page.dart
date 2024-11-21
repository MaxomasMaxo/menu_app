import 'package:flutter/material.dart';

class TabInscribirPage extends StatelessWidget {
  const TabInscribirPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario de Inscripción'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo para el tipo de menú
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Tipo de Menú',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un tipo de menú';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16), // Espacio entre campos
              
              // Campo para la fecha
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                ),
                readOnly: true, // Para que el usuario no escriba directamente
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (selectedDate != null) {
                    // Aquí podrías actualizar el estado si usas StatefulWidget
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor selecciona una fecha';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16), // Espacio entre campos

              // Botón de envío
              ElevatedButton(
                onPressed: () {
                  // Lógica para enviar el formulario
                  // Aquí puedes validar el formulario y enviar la información
                },
                child: Text('Inscribir'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
