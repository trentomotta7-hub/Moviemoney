import type { Lead } from "../drizzle/schema";

const formulaPrefix = /^[=+\-@\t\r]/;

export function escapeCsvCell(value: string | number | boolean | null | undefined) {
  const raw = value == null ? "" : String(value);
  const safe = formulaPrefix.test(raw) ? `'${raw}` : raw;
  return `"${safe.replaceAll('"', '""')}"`;
}

function isoDate(milliseconds: number | null) {
  return milliseconds == null ? "" : new Date(milliseconds).toISOString();
}

export function leadsToCsv(leads: Lead[], serverNowMs = Date.now()) {
  const header = [
    "id",
    "nome",
    "email",
    "consentimento_lgpd",
    "consentimento_em",
    "oferta_expira_em",
    "status_oferta",
    "status_email",
    "email_enviado_em",
    "cadastrado_em",
  ];

  const rows = leads.map(lead => [
    lead.id,
    lead.name,
    lead.email,
    lead.lgpdConsent ? "sim" : "não",
    isoDate(lead.lgpdConsentedAtMs),
    isoDate(lead.offerExpiresAtMs),
    lead.offerExpiresAtMs > serverNowMs ? "ativa" : "expirada",
    lead.emailStatus,
    isoDate(lead.emailSentAtMs),
    isoDate(lead.createdAtMs),
  ]);

  return [header, ...rows]
    .map(row => row.map(escapeCsvCell).join(","))
    .join("\r\n");
}
