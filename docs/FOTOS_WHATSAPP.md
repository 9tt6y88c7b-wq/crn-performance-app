# CRN PERFORMANCE — Fotografías y WhatsApp (diseño aprobado)

## Decisión funcional
- NO habrá portal ni cuentas de clientes.
- Solo el taller inicia sesión en la aplicación privada.
- Fotos por reparación: antes / durante / después. El taller decide qué enviar al cliente por WhatsApp.
- Presupuestos, facturas y fotografías se comparten por WhatsApp, con revisión humana.
- Para recibir y responder mensajes desde el panel se requiere integración oficial WhatsApp Business Platform (Meta Cloud API o proveedor autorizado), webhooks protegidos y consentimiento/plantillas cuando corresponda.
- La demo actual solo abre enlaces wa.me; no lee conversaciones ni envía mensajes automáticamente.

## Implementación actual (v2.2)
- Galería de imágenes de prueba por reparación, con subida, vista previa, descarga y eliminación.
- Persistencia local mediante IndexedDB en el navegador actual, no en servidor.
- No se incluyen imágenes en la exportación JSON de la demo. Borrar datos del sitio puede borrar las fotos.
- No usar fotografías reales de clientes hasta activar servidor, autenticación, almacenamiento privado y RGPD.

## Producción pendiente
1. Crear proyecto privado Supabase UE y activar acceso autenticado con MFA.
2. Storage privado, metadatos por reparación, políticas de acceso y enlaces firmados de corta duración.
3. Procesar imágenes con límites, validación de MIME real, cuotas, eliminación y conservación.
4. WhatsApp Business Platform: alta/autorización de cuenta, número elegible, permisos, webhook verificado, cola de envíos, registro de mensajes, plantillas y cumplimiento de ventanas de conversación.
5. Adjuntar documentos desde backend autenticado, no publicar archivos en GitHub Pages.
6. Probar restauración, control de costes, iPhone/ordenador y seguridad antes de usar datos reales.

## Nota
La integración de Outlook y WhatsApp a ChatGPT es distinta de conectarlos a esta aplicación propia. Nunca guardar secretos de Microsoft/Meta/Supabase en el HTML público.
