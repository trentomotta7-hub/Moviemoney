export type ConfirmationEmailInput = {
  to: string;
  name: string;
  offerUrl: string;
  expiresAtMs: number;
};

export type EmailDeliveryStatus = "pending" | "sent" | "failed";

type EmailConfig = {
  apiKey: string;
  from: string;
};

const escapeHtml = (value: string) =>
  value.replace(/[&<>'"]/g, character => {
    const entities: Record<string, string> = {
      "&": "&amp;",
      "<": "&lt;",
      ">": "&gt;",
      "'": "&#39;",
      '"': "&quot;",
    };
    return entities[character] ?? character;
  });

export function buildConfirmationEmailHtml(input: ConfirmationEmailInput) {
  const safeName = escapeHtml(input.name);
  const safeUrl = escapeHtml(input.offerUrl);
  const expiry = new Date(input.expiresAtMs).toLocaleString("pt-BR", {
    dateStyle: "long",
    timeStyle: "short",
    timeZone: "America/Sao_Paulo",
  });

  return `<!doctype html>
  <html lang="pt-BR">
    <body style="margin:0;background:#050505;color:#f7f7f2;font-family:Arial,sans-serif">
      <div style="max-width:620px;margin:0 auto;padding:40px 24px">
        <p style="margin:0 0 12px;color:#ff334f;font-size:12px;font-weight:700;letter-spacing:2px">MOVIE MONEY // ACESSO LIBERADO</p>
        <h1 style="margin:0 0 18px;font-size:32px;line-height:1.1">Seu acesso está pronto, ${safeName}.</h1>
        <p style="color:#b8b8b2;line-height:1.7">Confirmamos seu cadastro para conhecer a máquina de criativos de alta conversão da Movie Money.</p>
        <div style="margin:28px 0;padding:20px;border:1px solid #292929;background:#0d0d0d">
          <strong>Resumo do acesso</strong>
          <p style="margin:10px 0 0;color:#b8b8b2;line-height:1.6">Oferta individual da Movie Money, demonstração do processo e condições reservadas até ${expiry}.</p>
        </div>
        <a href="${safeUrl}" style="display:inline-block;background:#ff334f;color:#050505;text-decoration:none;font-weight:800;padding:16px 24px">ACESSAR MINHA OFERTA</a>
        <p style="margin-top:28px;color:#777;font-size:12px;line-height:1.6">O prazo é vinculado ao seu cadastro e não reinicia ao recarregar a página.</p>
      </div>
    </body>
  </html>`;
}

export async function sendConfirmationEmail(
  input: ConfirmationEmailInput,
  config: EmailConfig = {
    apiKey: process.env.RESEND_API_KEY ?? "",
    from: process.env.EMAIL_FROM ?? "",
  },
): Promise<EmailDeliveryStatus> {
  if (!config.apiKey || !config.from) {
    console.info("[Email] Provedor não configurado; confirmação mantida como pendente.");
    return "pending";
  }

  try {
    const response = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        authorization: `Bearer ${config.apiKey}`,
        "content-type": "application/json",
      },
      body: JSON.stringify({
        from: config.from,
        to: [input.to],
        subject: "Seu acesso à Movie Money está liberado",
        html: buildConfirmationEmailHtml(input),
      }),
    });

    if (!response.ok) {
      console.warn(`[Email] Resend recusou o envio (${response.status}).`);
      return "failed";
    }

    return "sent";
  } catch (error) {
    console.warn("[Email] Falha ao contatar o provedor:", error);
    return "failed";
  }
}
