import { describe, expect, it } from "vitest";
import { buildConfirmationEmailHtml, sendConfirmationEmail } from "./email";

describe("confirmation email", () => {
  it("mantém o envio pendente quando o provedor ainda não foi configurado", async () => {
    const status = await sendConfirmationEmail(
      {
        to: "lead@example.com",
        name: "Lead Teste",
        offerUrl: "https://example.com/oferta/token",
        expiresAtMs: Date.UTC(2026, 7, 8, 12),
      },
      { apiKey: "", from: "" },
    );

    expect(status).toBe("pending");
  });

  it("escapa conteúdo dinâmico no HTML", () => {
    const html = buildConfirmationEmailHtml({
      to: "lead@example.com",
      name: "<script>alert('x')</script>",
      offerUrl: "https://example.com/oferta/token?a=1&b=2",
      expiresAtMs: Date.UTC(2026, 7, 8, 12),
    });

    expect(html).not.toContain("<script>");
    expect(html).toContain("&lt;script&gt;");
    expect(html).toContain("a=1&amp;b=2");
  });
});
