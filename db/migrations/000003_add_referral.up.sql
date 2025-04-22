ALTER TABLE customer DROP CONSTRAINT IF EXISTS customer_telegram_id_unique;

ALTER TABLE customer ADD CONSTRAINT customer_telegram_id_unique UNIQUE (telegram_id);


CREATE TABLE IF NOT EXISTS referral (
                          id             BIGSERIAL PRIMARY KEY,
                          referrer_id    BIGINT NOT NULL REFERENCES customer(telegram_id),
                          referee_id     BIGINT NOT NULL REFERENCES customer(telegram_id),
                          used_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
                          bonus_granted  BOOLEAN    NOT NULL DEFAULT FALSE
);

CREATE INDEX IF NOT EXISTS idx_referral_referrer_id ON referral USING hash (referrer_id);
CREATE INDEX IF NOT EXISTS idx_referral_referee_id  ON referral USING hash (referee_id);


