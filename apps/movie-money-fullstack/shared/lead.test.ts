import { describe, expect, it } from "vitest";
import {
  createOfferExpiry,
  getOfferTiming,
  isValidOfferToken,
  OFFER_DURATION_MS,
} from "./lead";

describe("lead offer rules", () => {
  it("creates an expiry exactly 72 hours after registration", () => {
    const createdAtMs = Date.UTC(2026, 7, 6, 12, 0, 0);
    expect(createOfferExpiry(createdAtMs)).toBe(createdAtMs + OFFER_DURATION_MS);
    expect(OFFER_DURATION_MS).toBe(259_200_000);
  });

  it("derives active and expired countdown states from server timestamps", () => {
    expect(getOfferTiming(10_000, 4_000)).toEqual({ remainingMs: 6_000, expired: false });
    expect(getOfferTiming(10_000, 10_000)).toEqual({ remainingMs: 0, expired: true });
    expect(getOfferTiming(10_000, 12_000)).toEqual({ remainingMs: 0, expired: true });
  });

  it("accepts only 64-character hexadecimal access tokens", () => {
    expect(isValidOfferToken("a".repeat(64))).toBe(true);
    expect(isValidOfferToken("A0".repeat(32))).toBe(true);
    expect(isValidOfferToken("z".repeat(64))).toBe(false);
    expect(isValidOfferToken("a".repeat(63))).toBe(false);
  });
});
