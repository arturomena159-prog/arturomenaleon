import { readFileSync } from 'node:fs';
import { AwsClient } from 'aws4fetch';

const [, , localPath, remoteKey] = process.argv;
if (!localPath || !remoteKey) {
  console.error('Uso: node upload-to-r2.mjs <archivo-local> <clave-remota>');
  process.exit(1);
}

const { R2_ACCESS_KEY_ID, R2_SECRET_ACCESS_KEY, R2_ENDPOINT, R2_BUCKET } = process.env;
if (!R2_ACCESS_KEY_ID || !R2_SECRET_ACCESS_KEY || !R2_ENDPOINT || !R2_BUCKET) {
  console.error('Faltan variables de entorno R2_ACCESS_KEY_ID / R2_SECRET_ACCESS_KEY / R2_ENDPOINT / R2_BUCKET');
  process.exit(1);
}

const client = new AwsClient({
  accessKeyId: R2_ACCESS_KEY_ID,
  secretAccessKey: R2_SECRET_ACCESS_KEY,
  service: 's3',
  region: 'auto',
});

let data;
try {
  data = readFileSync(localPath);
} catch (err) {
  console.error(`No se pudo leer el archivo local: ${localPath}`);
  process.exit(1);
}

const url = `${R2_ENDPOINT}/${R2_BUCKET}/${remoteKey}`;

const res = await client.fetch(url, {
  method: 'PUT',
  body: data,
});

if (!res.ok) {
  console.error(`Error subiendo archivo: HTTP ${res.status} — ${await res.text()}`);
  process.exit(1);
}

console.log('OK');
