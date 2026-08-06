import type { Lead } from "../drizzle/schema";
import { describe, expect, it } from "vitest";
import { escapeCsvCell, leadsToCsv } from "./csv";

const lead: Lead = {
  id: 7,
  name: '=HYPERLINK("https://unsafe.example")',
  email: "pessoa@example.com",
  lgpdConsent: true,
  lgpdConsentedAtMs: 1_000,
  accessToken: "a".repeat(64),
  offerExpiresAtMs: 10_000,
  emailStatus: "sent",
  emailSentAtMs: 2_000,
  createdAtMs: 1_000,
  updatedAtMs: 2_000,
};

describe("lead CSV export", () => {
  it("escapes quotes and neutralizes spreadsheet formulas", () => {
    expect(escapeCsvCell('=SUM(1,2)')).toBe('"\'=SUM(1,2)"');
    expect(escapeCsvCell('Nome "Teste"')).toBe('"Nome ""Teste"""');
  });

  it("exports consent, delivery and server-derived offer status", () => {
    const activeCsv = leadsToCsv([lead], 9_000);
    expect(activeCsv).toContain('"status_oferta"');
    expect(activeCsv).toContain('"ativa"');
    expect(activeCsv).toContain('"sim"');
    expect(activeCsv).toContain('"sent"');
    expect(activeCsv).toContain('"\'=HYPERLINK(""https://unsafe.example"")"');

    expect(leadsToCsv([lead], 10_000)).toContain('"expirada"');
  });
});
