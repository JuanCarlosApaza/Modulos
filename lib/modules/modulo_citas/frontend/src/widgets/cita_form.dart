import 'package:flutter/material.dart';
import 'package:modulos/core/theme/app_colors.dart';
import '../../../backend/src/models/cita_dto.dart';

class CitaForm extends StatefulWidget {
  final CitaDto? existente;
  final Future<void> Function(CitaDto cita) onSubmit;

  const CitaForm({super.key, this.existente, required this.onSubmit});

  @override
  State<CitaForm> createState() => _CitaFormState();
}

class _CitaFormState extends State<CitaForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tituloController;
  late final TextEditingController _descripcionController;
  late final TextEditingController _notasController;
  late DateTime _fechaInicio;
  late DateTime _fechaFin;
  late String _estado;

  bool get _esEdicion => widget.existente != null;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.existente?.titulo ?? '');
    _descripcionController = TextEditingController(text: widget.existente?.descripcion ?? '');
    _notasController = TextEditingController(text: widget.existente?.notas ?? '');
    _fechaInicio = widget.existente?.fechaInicio ?? DateTime.now();
    _fechaFin = widget.existente?.fechaFin ?? DateTime.now().add(const Duration(hours: 1));
    _estado = widget.existente?.estado ?? 'pendiente';
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFechaYHora({
    required DateTime fechaActual,
    required ValueChanged<DateTime> onSeleccionado,
  }) async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: fechaActual,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(primary: AppColors.brandGreen),
          ),
          child: child!,
        );
      },
    );
    if (fecha == null || !mounted) return;

    final hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(fechaActual),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(primary: AppColors.brandGreen),
          ),
          child: child!,
        );
      },
    );
    if (hora == null) return;

    onSeleccionado(DateTime(fecha.year, fecha.month, fecha.day, hora.hour, hora.minute));
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      final cita = CitaDto(
        id: _esEdicion
            ? widget.existente!.id
            : DateTime.now().millisecondsSinceEpoch.toString(),
        clienteId: _esEdicion ? widget.existente!.clienteId : '',
        usuarioId: _esEdicion ? widget.existente!.usuarioId : '',
        titulo: _tituloController.text,
        descripcion: _descripcionController.text.isNotEmpty ? _descripcionController.text : null,
        fechaInicio: _fechaInicio,
        fechaFin: _fechaFin,
        estado: _estado,
        notas: _notasController.text.isNotEmpty ? _notasController.text : null,
        activo: _esEdicion ? widget.existente!.activo : true,
      );
      await widget.onSubmit(cita);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.negativeRed),
        );
      }
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textSecondary),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.brandGreen),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _esEdicion ? 'Editar Cita' : 'Nueva Cita',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _tituloController,
                decoration: _inputDecoration('Título *'),
                validator: (v) => v == null || v.trim().isEmpty ? 'El título es requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descripcionController,
                decoration: _inputDecoration('Descripción'),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  await _seleccionarFechaYHora(
                    fechaActual: _fechaInicio,
                    onSeleccionado: (f) => setState(() => _fechaInicio = f),
                  );
                },
                child: InputDecorator(
                  decoration: _inputDecoration('Fecha Inicio *'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_fechaInicio.day}/${_fechaInicio.month}/${_fechaInicio.year} ${_fechaInicio.hour.toString().padLeft(2, '0')}:${_fechaInicio.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      const Icon(Icons.calendar_today, color: AppColors.textSecondary, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  await _seleccionarFechaYHora(
                    fechaActual: _fechaFin,
                    onSeleccionado: (f) => setState(() => _fechaFin = f),
                  );
                },
                child: InputDecorator(
                  decoration: _inputDecoration('Fecha Fin *'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_fechaFin.day}/${_fechaFin.month}/${_fechaFin.year} ${_fechaFin.hour.toString().padLeft(2, '0')}:${_fechaFin.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(color: AppColors.textPrimary),
                      ),
                      const Icon(Icons.calendar_today, color: AppColors.textSecondary, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _estado,
                decoration: _inputDecoration('Estado'),
                items: const [
                  DropdownMenuItem(value: 'pendiente', child: Text('Pendiente')),
                  DropdownMenuItem(value: 'confirmada', child: Text('Confirmada')),
                  DropdownMenuItem(value: 'completada', child: Text('Completada')),
                  DropdownMenuItem(value: 'cancelada', child: Text('Cancelada')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _estado = v);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notasController,
                decoration: _inputDecoration('Notas'),
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.cardBorder),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Cancelar', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(_esEdicion ? 'Actualizar' : 'Crear'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
