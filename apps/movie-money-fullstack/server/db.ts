import { randomBytes } from "node:crypto";
import { desc, eq } from "drizzle-orm";
import { drizzle } from "drizzle-orm/mysql2";
import { InsertUser, Lead, leads, users } from "../drizzle/schema";
import { createOfferExpiry } from "../shared/lead";
import { ENV } from './_core/env';

let _db: ReturnType<typeof drizzle> | null = null;

// Lazily create the drizzle instance so local tooling can run without a DB.
export async function getDb() {
  if (!_db && process.env.DATABASE_URL) {
    try {
      _db = drizzle(process.env.DATABASE_URL);
    } catch (error) {
      console.warn("[Database] Failed to connect:", error);
      _db = null;
    }
  }
  return _db;
}

export async function upsertUser(user: InsertUser): Promise<void> {
  if (!user.openId) {
    throw new Error("User openId is required for upsert");
  }

  const db = await getDb();
  if (!db) {
    console.warn("[Database] Cannot upsert user: database not available");
    return;
  }

  try {
    const values: InsertUser = {
      openId: user.openId,
    };
    const updateSet: Record<string, unknown> = {};

    const textFields = ["name", "email", "loginMethod"] as const;
    type TextField = (typeof textFields)[number];

    const assignNullable = (field: TextField) => {
      const value = user[field];
      if (value === undefined) return;
      const normalized = value ?? null;
      values[field] = normalized;
      updateSet[field] = normalized;
    };

    textFields.forEach(assignNullable);

    if (user.lastSignedIn !== undefined) {
      values.lastSignedIn = user.lastSignedIn;
      updateSet.lastSignedIn = user.lastSignedIn;
    }
    if (user.role !== undefined) {
      values.role = user.role;
      updateSet.role = user.role;
    } else if (user.openId === ENV.ownerOpenId) {
      values.role = 'admin';
      updateSet.role = 'admin';
    }

    if (!values.lastSignedIn) {
      values.lastSignedIn = new Date();
    }

    if (Object.keys(updateSet).length === 0) {
      updateSet.lastSignedIn = new Date();
    }

    await db.insert(users).values(values).onDuplicateKeyUpdate({
      set: updateSet,
    });
  } catch (error) {
    console.error("[Database] Failed to upsert user:", error);
    throw error;
  }
}

export async function getUserByOpenId(openId: string) {
  const db = await getDb();
  if (!db) {
    console.warn("[Database] Cannot get user: database not available");
    return undefined;
  }

  const result = await db.select().from(users).where(eq(users.openId, openId)).limit(1);

  return result.length > 0 ? result[0] : undefined;
}

export async function createOrReuseLead(input: {
  name: string;
  email: string;
}): Promise<{ lead: Lead; created: boolean }> {
  const db = await getDb();
  if (!db) throw new Error("Banco de dados indisponível.");

  const now = Date.now();
  const email = input.email.trim().toLowerCase();
  const name = input.name.trim().replace(/\s+/g, " ");
  const existing = await db.select().from(leads).where(eq(leads.email, email)).limit(1);

  if (existing[0]) {
    await db
      .update(leads)
      .set({ name, lgpdConsent: true, lgpdConsentedAtMs: now, updatedAtMs: now })
      .where(eq(leads.id, existing[0].id));
    return {
      lead: {
        ...existing[0],
        name,
        lgpdConsent: true,
        lgpdConsentedAtMs: now,
        updatedAtMs: now,
      },
      created: false,
    };
  }

  const values = {
    name,
    email,
    lgpdConsent: true,
    lgpdConsentedAtMs: now,
    accessToken: randomBytes(32).toString("hex"),
    offerExpiresAtMs: createOfferExpiry(now),
    emailStatus: "pending" as const,
    createdAtMs: now,
    updatedAtMs: now,
  };

  try {
    await db.insert(leads).values(values);
  } catch (error) {
    const raced = await db.select().from(leads).where(eq(leads.email, email)).limit(1);
    if (raced[0]) return { lead: raced[0], created: false };
    throw error;
  }

  const inserted = await db.select().from(leads).where(eq(leads.email, email)).limit(1);
  if (!inserted[0]) throw new Error("Não foi possível recuperar o lead cadastrado.");
  return { lead: inserted[0], created: true };
}

export async function updateLeadEmailStatus(
  id: number,
  status: "pending" | "sent" | "failed",
) {
  const db = await getDb();
  if (!db) throw new Error("Banco de dados indisponível.");
  const now = Date.now();
  await db
    .update(leads)
    .set({
      emailStatus: status,
      emailSentAtMs: status === "sent" ? now : null,
      updatedAtMs: now,
    })
    .where(eq(leads.id, id));
}

export async function getLeadByAccessToken(accessToken: string) {
  const db = await getDb();
  if (!db) throw new Error("Banco de dados indisponível.");
  const result = await db
    .select()
    .from(leads)
    .where(eq(leads.accessToken, accessToken))
    .limit(1);
  return result[0];
}

export async function listAllLeads() {
  const db = await getDb();
  if (!db) throw new Error("Banco de dados indisponível.");
  return db.select().from(leads).orderBy(desc(leads.createdAtMs));
}
