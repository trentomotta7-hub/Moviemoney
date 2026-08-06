CREATE TABLE `leads` (
	`id` int AUTO_INCREMENT NOT NULL,
	`name` varchar(160) NOT NULL,
	`email` varchar(320) NOT NULL,
	`lgpdConsent` boolean NOT NULL,
	`lgpdConsentedAtMs` bigint NOT NULL,
	`accessToken` varchar(96) NOT NULL,
	`offerExpiresAtMs` bigint NOT NULL,
	`emailStatus` enum('pending','sent','failed') NOT NULL DEFAULT 'pending',
	`emailSentAtMs` bigint,
	`createdAtMs` bigint NOT NULL,
	`updatedAtMs` bigint NOT NULL,
	CONSTRAINT `leads_id` PRIMARY KEY(`id`),
	CONSTRAINT `leads_email_unique` UNIQUE(`email`),
	CONSTRAINT `leads_accessToken_unique` UNIQUE(`accessToken`)
);
