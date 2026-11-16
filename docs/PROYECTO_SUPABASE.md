# Configuración de Supabase para CRN PERFORMANCE

Proyecto indicado por el propietario: `geamekbwpocjbopfpowy`.
URL pública del proyecto (derivada del ID, no verificada): `https://geamekbwpocjbopfpowy.supabase.co`.

**Estado:** identificador recibido; no hay conexión real a la base de datos, ni se han ejecutado las migraciones, ni se ha verificado la región, la autenticación o las políticas RLS. La web pública sigue siendo una demo local.

## Siguiente paso del propietario
1. Abrir Supabase → proyecto CRN-PERFORMANCE → SQL Editor.
2. NO ejecutar todavía las migraciones 001/002 sin revisión y pruebas. La migración inicial aún contiene un diseño de portal de clientes, que ya no se quiere, y la segunda requiere validación de claves foráneas y políticas.
3. Abrir Project Settings → API Keys (o la sección equivalente) y localizar la **publishable key** (`sb_publishable_...`). Es una clave destinada al cliente público, pero no da permiso para saltarse RLS.
4. No compartir `service_role`, `sb_secret_...`, contraseñas ni tokens. No pegar secretos en GitHub.

## Próximo trabajo de desarrollo
- Retirar el portal de clientes del esquema y revisar la migración de gastos.
- Crear autenticación exclusiva para el taller, con MFA y RLS comprobadas.
- Añadir almacenamiento privado de fotos, con acceso exclusivo del taller.
- Sustituir localStorage por consultas autenticadas, con pruebas en iPhone y ordenador.
- Integración oficial de WhatsApp Business, cuando el propietario autorice la cuenta de Meta.
