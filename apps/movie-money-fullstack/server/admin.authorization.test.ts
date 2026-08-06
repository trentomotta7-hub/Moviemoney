import type { TrpcContext } from "./_core/context";
import { describe, expect, it } from "vitest";
import { appRouter } from "./routers";

function contextFor(role: "user" | "admin" | null): TrpcContext {
  return {
    user: role
      ? {
          id: 1,
          openId: "test-user",
          name: "Test User",
          email: "test@example.com",
          loginMethod: "test",
          role,
          createdAt: new Date(),
          updatedAt: new Date(),
          lastSignedIn: new Date(),
        }
      : null,
    req: { protocol: "https", headers: {} } as TrpcContext["req"],
    res: {} as TrpcContext["res"],
  };
}

describe("admin authorization", () => {
  it.each([null, "user"] as const)("blocks role %s from lead data", async role => {
    const caller = appRouter.createCaller(contextFor(role));
    await expect(caller.admin.leads()).rejects.toMatchObject({ code: "FORBIDDEN" });
    await expect(caller.admin.leadsCsv()).rejects.toMatchObject({ code: "FORBIDDEN" });
  });
});
