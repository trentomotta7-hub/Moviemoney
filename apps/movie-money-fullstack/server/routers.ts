import { COOKIE_NAME } from "@shared/const";
import { getOfferTiming } from "@shared/lead";
import { TRPCError } from "@trpc/server";
import { z } from "zod";
import {
  createOrReuseLead,
  getLeadByAccessToken,
  listAllLeads,
  updateLeadEmailStatus,
} from "./db";
import { getSessionCookieOptions } from "./_core/cookies";
import { notifyOwner } from "./_core/notification";
import { systemRouter } from "./_core/systemRouter";
import { adminProcedure, publicProcedure, router } from "./_core/trpc";
import { leadsToCsv } from "./csv";
import { sendConfirmationEmail } from "./email";

const requestOrigin = (req: { protocol: string; get(name: string): string | undefined }) => {
  const host = req.get("host");
  if (!host) throw new TRPCError({ code: "INTERNAL_SERVER_ERROR", message: "Host indisponível." });
  return `${req.protocol}://${host}`;
};

export const appRouter = router({
    // if you need to use socket.io, read and register route in server/_core/index.ts, all api should start with '/api/' so that the gateway can route correctly
  system: systemRouter,
  auth: router({
    me: publicProcedure.query(opts => opts.ctx.user),
    logout: publicProcedure.mutation(({ ctx }) => {
      const cookieOptions = getSessionCookieOptions(ctx.req);
      ctx.res.clearCookie(COOKIE_NAME, { ...cookieOptions, maxAge: -1 });
      return {
        success: true,
      } as const;
    }),
  }),
  leads: router({
    capture: publicProcedure
      .input(
        z.object({
          name: z.string().trim().min(2).max(160),
          email: z.string().trim().email().max(320),
          lgpdConsent: z.literal(true),
        }),
      )
      .mutation(async ({ input, ctx }) => {
        const { lead, created } = await createOrReuseLead(input);
        const offerUrl = `${requestOrigin(ctx.req)}/oferta/${lead.accessToken}`;

        if (created || lead.emailStatus !== "sent") {
          const emailStatus = await sendConfirmationEmail({
            to: lead.email,
            name: lead.name,
            offerUrl,
            expiresAtMs: lead.offerExpiresAtMs,
          });
          await updateLeadEmailStatus(lead.id, emailStatus);
        }

        if (created) {
          await notifyOwner({
            title: "Novo lead — Movie Money",
            content: `Nome: ${lead.name}\nE-mail: ${lead.email}\nCadastro: ${new Date(
              lead.createdAtMs,
            ).toISOString()}`,
          }).catch(error => console.warn("[Lead] Falha ao notificar proprietário:", error));
        }

        return {
          accessToken: lead.accessToken,
          offerExpiresAtMs: lead.offerExpiresAtMs,
          serverNowMs: Date.now(),
          created,
        };
      }),
    offer: publicProcedure
      .input(z.object({ accessToken: z.string().length(64) }))
      .query(async ({ input }) => {
        const lead = await getLeadByAccessToken(input.accessToken);
        if (!lead) throw new TRPCError({ code: "NOT_FOUND", message: "Oferta não encontrada." });
        const serverNowMs = Date.now();
        const timing = getOfferTiming(lead.offerExpiresAtMs, serverNowMs);
        return {
          name: lead.name,
          offerExpiresAtMs: lead.offerExpiresAtMs,
          serverNowMs,
          expired: timing.expired,
        };
      }),
  }),
  admin: router({
    leads: adminProcedure.query(async () => {
      const serverNowMs = Date.now();
      const rows = await listAllLeads();
      const items = rows.map(lead => {
        const timing = getOfferTiming(lead.offerExpiresAtMs, serverNowMs);
        return {
          id: lead.id,
          name: lead.name,
          email: lead.email,
          lgpdConsent: lead.lgpdConsent,
          lgpdConsentedAtMs: lead.lgpdConsentedAtMs,
          offerExpiresAtMs: lead.offerExpiresAtMs,
          expired: timing.expired,
          remainingMs: timing.remainingMs,
          emailStatus: lead.emailStatus,
          emailSentAtMs: lead.emailSentAtMs,
          createdAtMs: lead.createdAtMs,
        };
      });

      return {
        serverNowMs,
        summary: {
          total: items.length,
          active: items.filter(item => !item.expired).length,
          expired: items.filter(item => item.expired).length,
          emailSent: items.filter(item => item.emailStatus === "sent").length,
        },
        items,
      };
    }),
    leadsCsv: adminProcedure.query(async () => {
      const rows = await listAllLeads();
      return {
        fileName: `movie-money-leads-${new Date().toISOString().slice(0, 10)}.csv`,
        content: `\uFEFF${leadsToCsv(rows)}`,
      };
    }),
  }),
});

export type AppRouter = typeof appRouter;
