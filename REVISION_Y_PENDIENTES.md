# CRN PERFORMANCE — Estado de entrega y validación (16/11/2026)

## Implementado en privado.html
- Acceso autenticado mediante Supabase Auth y comprobación de pertenencia al taller.
- Clientes: alta, consulta, edición de nombre, teléfono y datos fiscales.
- Vehículos: alta, consulta y edición de matrícula/modelo.
- Reparaciones: alta, consulta, edición, fecha prevista y cambio de estado.
- Fotos: carga y visualización desde almacenamiento privado y eliminación.
- Presupuestos: líneas por Repuestos, Chapa y Pintura, edición/eliminación, cálculo con IVA, impresión de borrador.
- Facturas: borradores manuales o desde presupuesto, snapshot fiscal, fecha de operación, impresión y eliminación de borradores.
- Agenda: alta y marcado de citas realizadas.
- WhatsApp: apertura manual de enlace wa.me; NO API ni IA integrada.

## Bloqueos antes de uso con datos reales
1. Validar operaciones completas de alta/edición/eliminación desde una cuenta real y con el esquema efectivamente instalado.
2. Probar RLS con otro usuario y otro taller, incluyendo acceso a fotos y referencias cruzadas.
3. Diseñar e implementar numeración fiscal atómica en servidor, bloqueo de documentos emitidos, rectificativas, registro y conservación, y verificar los requisitos españoles aplicables antes de emitir facturas.
4. Incorporar copia de seguridad/restauración verificadas para datos y archivos, plan de incidentes y política RGPD.
5. Pruebas de Safari iPhone, Chrome escritorio, impresión PDF, errores de red, límites de carga y accesibilidad.
6. Confirmar comportamiento de GitHub Pages y HTTPS en el enlace publicado; no confundir commit con despliegue verificado.
7. Integración WhatsApp/IA opcional posterior, siempre con aprobación humana.

## Pruebas automáticas hechas
- Comprobación de sintaxis de JavaScript de privado.html.
- Verificación de IDs HTML únicos y referencias de IDs del script.
- No se han ejecutado pruebas end-to-end autenticadas ni pruebas legales/fiscales.

**No utilizar la app para emitir facturas oficiales ni gestionar datos reales hasta cerrar los bloqueos.**
