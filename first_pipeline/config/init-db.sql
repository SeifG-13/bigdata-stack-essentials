-- Create database for crypto data
CREATE DATABASE crypto_db;

-- Connect to crypto_db
\c crypto_db;

-- Create table for raw crypto data from API
CREATE TABLE IF NOT EXISTS crypto_prices (
    id SERIAL PRIMARY KEY,
    coin_id VARCHAR(50) NOT NULL,
    symbol VARCHAR(20) NOT NULL,
    name VARCHAR(100) NOT NULL,
    current_price DECIMAL(20, 8),
    market_cap BIGINT,
    market_cap_rank INTEGER,
    total_volume BIGINT,
    high_24h DECIMAL(20, 8),
    low_24h DECIMAL(20, 8),
    price_change_24h DECIMAL(20, 8),
    price_change_percentage_24h DECIMAL(10, 4),
    circulating_supply DECIMAL(30, 8),
    total_supply DECIMAL(30, 8),
    last_updated TIMESTAMP,
    extracted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index for faster queries
CREATE INDEX idx_crypto_coin_id ON crypto_prices(coin_id);
CREATE INDEX idx_crypto_extracted_at ON crypto_prices(extracted_at);

-- Grant permissions
GRANT ALL PRIVILEGES ON DATABASE crypto_db TO airflow;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO airflow;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO airflow;