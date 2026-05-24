-- ================================================
-- AI BRD Generator — Database Schema
-- Run this once after creating the Railway MySQL DB
-- ================================================

CREATE DATABASE IF NOT EXISTS brd_ai;
USE brd_ai;

CREATE TABLE IF NOT EXISTS communications (
    id          INT PRIMARY KEY AUTO_INCREMENT,
    source_type VARCHAR(50),
    sender_name VARCHAR(100),
    project_name VARCHAR(100),
    content     TEXT,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
