# CRN PERFORMANCE — Estado real de entrega (16-11-2026)

## Disponible en GitHub Pages (DEMO, no producción)
- Panel responsive rojo/negro con indicadores de taller, entregas, progreso y accesos rápidos.
- Clientes, vehículos, órdenes de reparación, estados, fechas, notas e historial local.
- Búsqueda de reparaciones por matrícula, descripción y estado.
- Presupuestos en categorías Repuestos, Chapa y Pintura; tarifas configuradas, IVA, impresión PDF.
- Borradores de factura desde presupuesto o manualmente, serie F, número y fecha introducidos manualmente, aviso de números duplicados locales.
- Agenda con día/hora manual, impresión de resguardo de depósito y orden de trabajo.
- Copias JSON de prueba; compartir con iCloud Drive si lo permite el dispositivo.

## NO implementado ni conectado
- Servidor, base de datos real, sincronización entre dispositivos y cuentas autenticadas.
- Portal privado del cliente, fotos publicadas selectivamente, firmas electrónicas y avisos automáticos.
- Facturas fiscales definitivas y controles normativos SIF aplicables, rectificativas, inmutabilidad y secuencia global atómica.
- Backups automáticos, política RGPD aplicada y despliegue auditado.

## Dependencia externa necesaria
El propietario debe crear/autorizar un proyecto privado Supabase (región UE), configurar cuenta/MFA y conceder acceso a través de los mecanismos oficiales. No pegar claves secretas en el chat ni en GitHub Pages. Ejecutar migraciones solo después de revisión y pruebas de seguridad.

## Validación previa a datos reales
1. Probar el HTML en Safari iPhone y ordenador, incluida impresión, navegación, copias y restauración.
2. Revisar RLS, integridad multi-taller, permisos y ausencia de claves privadas en el frontend.
3. Probar autenticación, almacenamiento privado y restauración de copias.
4. Validar requisitos legales de facturación y protección de datos con profesional competente.

## Advertencia
Los cambios guardados en GitHub no implican verificación funcional en dispositivos ni puesta en producción.
