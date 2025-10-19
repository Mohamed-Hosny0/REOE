/*
  # Create leads table for LEADUX Real Estate Offer Estimator

  1. New Tables
    - `leads`
      - `id` (uuid, primary key) - Unique identifier for each lead
      - `full_name` (text) - Lead's full name
      - `email` (text) - Lead's email address
      - `phone` (text) - Lead's phone number
      - `investor_type` (text) - Type of investor (wholesaler, cash buyer, etc.)
      - `property_address` (text) - Property address analyzed
      - `property_data` (jsonb) - Complete property analysis data
      - `created_at` (timestamptz) - Timestamp when lead was captured
  
  2. Security
    - Enable RLS on `leads` table
    - Add policy for public insert (lead capture is public)
    - Add policy for authenticated admin read access only
  
  3. Indexes
    - Add index on email for quick lookups
    - Add index on created_at for sorting
*/

CREATE TABLE IF NOT EXISTS leads (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name text NOT NULL,
  email text NOT NULL,
  phone text NOT NULL,
  investor_type text NOT NULL,
  property_address text NOT NULL,
  property_data jsonb DEFAULT '{}'::jsonb,
  created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE leads ENABLE ROW LEVEL SECURITY;

-- Allow anyone to insert leads (public lead capture)
CREATE POLICY "Allow public lead submissions"
  ON leads
  FOR INSERT
  TO anon
  WITH CHECK (true);

-- Only authenticated users can view leads (admin access)
CREATE POLICY "Authenticated users can view all leads"
  ON leads
  FOR SELECT
  TO authenticated
  USING (true);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_leads_email ON leads(email);
CREATE INDEX IF NOT EXISTS idx_leads_created_at ON leads(created_at DESC);