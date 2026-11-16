# CRN PERFORMANCE — Plan de puesta en producción

Estado: arquitectura propuesta; NO desplegada. La aplicación pública de GitHub Pages es una demostración local, no apta para datos reales de clientes.

## Decisión de almacenamiento
- Base de datos privada gestionada (propuesta: Supabase PostgreSQL en región UE) con autenticación y políticas RLS por usuario/empresa.
- Almacenamiento privado de fotografías y documentos con URLs firmadas de corta duración.
- iCloud Drive para copias cifradas de seguridad, exportadas manualmente desde el iPhone. iCloud Drive NO es la base de datos compartida de la aplicación.
- No colocar claves de administrador, contraseñas, tokens de servicio ni datos reales en GitHub Pages.

## Modelo inicial
- workshops(id, legal_name, nif, contact)
- staff(id, workshop_id, auth_user_id, role)
- customers(id, workshop_id, name, contact, tax_details)
- vehicles(id, workshop_id, customer_id, plate, vin, model)
- repair_orders(id, workshop_id, vehicle_id, status, estimated_delivery, created_at)
- repair_events(id, workshop_id, repair_order_id, actor_id, event_type, content, created_at)
- quotes(id, workshop_id, repair_order_id, revision, status, issued_at)
- quote_lines(id, quote_id, category, description, qty, unit_price, vat_rate)
- invoice_drafts(id, workshop_id, customer_id, source_quote_id, created_at)
- invoices(id, workshop_id, series, sequential_number, issued_at, customer_snapshot, totals, immutable_payload)
- invoice_lines(id, invoice_id, description, qty, unit_price, vat_rate)
- appointments(id, workshop_id, date, time, customer_id, reason, status)
- media(id, workshop_id, repair_order_id, storage_key, stage, published_to_customer, created_at)
- portal_tokens(id, workshop_id, repair_order_id, token_hash, expires_at, revoked_at)

## Controles necesarios
1. Autenticación del propietario, MFA y sesión protegida.
2. Políticas RLS y separación de datos por taller, permisos mínimos, auditoría.
3. Copias automáticas, pruebas de restauración, política de conservación y cifrado.
4. Portal de cliente con enlace privado de alta entropía, caducidad, revocación y control explícito de publicación.
5. RGPD: información, encargados de tratamiento, derechos, conservación y contratos.
6. Facturación española: serie única configurada, numeración correlativa al emitir (no al guardar borrador), facturas rectificativas y requisitos de software de facturación/VERI*FACTU según normativa aplicable; revisión profesional antes de activar emisión.
7. Migración de datos locales SOLO tras consentimiento y revisión; no importar datos de clientes a una demo pública.
8. Pruebas en iPhone y ordenador, copias, restauración, roles y seguridad antes del uso real.

## Próxima acción externa
Crear un proyecto de base de datos privado en un proveedor elegido por el propietario. Se necesita su autorización y configuración segura de credenciales; no se ha creado ningún proyecto externo ni base de datos en esta fase.
