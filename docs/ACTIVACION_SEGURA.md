# Checklist de activación — CRN PERFORMANCE

## Estado actual
La web de GitHub Pages sigue siendo una DEMOSTRACIÓN. Guarda datos en localStorage, no dispone de cuentas de usuario, ni servidor privado, ni sincronización. Los botones de WhatsApp abren mensajes prellenados: no realizan envíos automáticos.

## Implementado en el repositorio
- Demo de clientes, vehículos, reparaciones, presupuestos, borradores de factura y agenda.
- Exportación y restauración manual de datos de prueba; compartir archivo con iCloud Drive mediante el menú del iPhone si el navegador lo permite.
- Modelo SQL inicial para una base de datos PostgreSQL/Supabase con autenticación y RLS, SIN EJECUTAR.

## Bloqueadores para datos reales
1. Crear proyecto privado de Supabase en región de la UE, verificar el encargado de tratamiento y el contrato de tratamiento de datos.
2. Crear identidad del propietario, activar MFA, asignar taller y comprobar políticas RLS.
3. Reforzar integridad entre taller y relaciones (cliente-vehículo-reparación-presupuesto); pruebas automáticas de acceso cruzado y roles.
4. Crear backend de funciones protegidas para operaciones sensibles. Nunca publicar clave service_role en HTML.
5. Migrar frontend a sesiones autenticadas y consultas seguras. No conservar datos reales en localStorage.
6. Crear almacenamiento privado de imágenes y documentos; permisos por reparación y publicación selectiva.
7. Implementar portal de cliente mediante token aleatorio seguro, solo hash en base de datos, caducidad, revocación, límites de solicitudes y backend que solo exponga datos publicados.
8. Diseñar facturación española con asesoría: serie única, numeración correlativa y atómica al emitir, inmutabilidad, rectificativas, datos fiscales obligatorios y normativa de sistemas informáticos de facturación/VERI*FACTU aplicable. La demo solo genera borradores sin validez fiscal.
9. RGPD: información al cliente, plazos de conservación, solicitudes de derechos, registro de accesos, contratos con proveedores y política de copias.
10. Copias automáticas cifradas, restauración probada, controles de costes y monitorización.
11. Validación funcional en iPhone y ordenador antes de operar.

## Decisión sobre iCloud
iCloud Drive puede guardar COPIAS exportadas manualmente; no sirve como base de datos multiusuario transaccional para esta aplicación web. No se ha conectado iCloud a ningún backend. Las copias de la demo pueden contener información sensible si el usuario la introduce, por eso NO se deben introducir datos reales.

## Próximo paso que requiere intervención del propietario
Crear o autorizar una cuenta/proyecto privado de Supabase. El proyecto no se ha creado; no hay credenciales ni conexiones reales. Tras ello, ejecutar y probar migraciones y construir el acceso autenticado.
