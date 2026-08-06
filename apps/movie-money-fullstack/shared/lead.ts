export const OFFER_DURATION_MS = 72 * 60 * 60 * 1000;

const ACCESS_TOKEN_PATTERN = /^[a-f0-9]{64}$/i;

export function createOfferExpiry(createdAtMs: number) {
  return createdAtMs + OFFER_DURATION_MS;
}

export function isValidOfferToken(accessToken: string) {
  return ACCESS_TOKEN_PATTERN.test(accessToken);
}

export function getOfferTiming(offerExpiresAtMs: number, serverNowMs: number) {
  const remainingMs = Math.max(0, offerExpiresAtMs - serverNowMs);
  return {
    remainingMs,
    expired: remainingMs === 0,
  };
}
