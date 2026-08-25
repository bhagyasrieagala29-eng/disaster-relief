-- ==============================================================================
-- AegisRelief Disaster Command Hub - Supabase Database Schema
-- Run this in your Supabase Project: SQL Editor -> New Query -> Run
-- ==============================================================================

-- 1. Create Incidents Table
CREATE TABLE IF NOT EXISTS public.incidents (
    id TEXT PRIMARY KEY,
    scenario_id TEXT NOT NULL DEFAULT 'flash_flood',
    title TEXT NOT NULL,
    category TEXT NOT NULL CHECK (category IN ('medical', 'rescue', 'hazard', 'supplies')),
    severity TEXT NOT NULL CHECK (severity IN ('critical', 'high', 'medium', 'low')),
    lat DOUBLE PRECISION NOT NULL,
    lng DOUBLE PRECISION NOT NULL,
    address TEXT NOT NULL,
    description TEXT,
    victims INTEGER DEFAULT 1,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'dispatched', 'in_transit', 'rescued', 'resolved')),
    responder TEXT,
    requires_boat BOOLEAN DEFAULT FALSE,
    verified BOOLEAN DEFAULT FALSE,
    urgency_score INTEGER DEFAULT 50,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Create Shelters Table
CREATE TABLE IF NOT EXISTS public.shelters (
    id TEXT PRIMARY KEY,
    scenario_id TEXT NOT NULL DEFAULT 'flash_flood',
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    lat DOUBLE PRECISION NOT NULL,
    lng DOUBLE PRECISION NOT NULL,
    capacity INTEGER NOT NULL DEFAULT 500,
    occupied INTEGER NOT NULL DEFAULT 0,
    status TEXT DEFAULT 'open' CHECK (status IN ('open', 'full', 'closed')),
    features TEXT[] DEFAULT '{}',
    food_stock INTEGER DEFAULT 80,
    water_stock INTEGER DEFAULT 80,
    medical_stock INTEGER DEFAULT 80,
    bedding_stock INTEGER DEFAULT 80,
    contact TEXT,
    supervisor TEXT,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Create SOS Beacons Table
CREATE TABLE IF NOT EXISTS public.sos_beacons (
    id TEXT PRIMARY KEY,
    emergency_type TEXT NOT NULL,
    people_count INTEGER DEFAULT 1,
    address TEXT,
    notes TEXT,
    lat DOUBLE PRECISION NOT NULL,
    lng DOUBLE PRECISION NOT NULL,
    urgency_score INTEGER DEFAULT 80,
    has_infants BOOLEAN DEFAULT FALSE,
    has_elderly BOOLEAN DEFAULT FALSE,
    is_injured BOOLEAN DEFAULT FALSE,
    water_rising BOOLEAN DEFAULT FALSE,
    power_loss BOOLEAN DEFAULT FALSE,
    status TEXT DEFAULT 'DISPATCH_QUEUED',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 4. Create Missing Persons & Safety Registry Table
CREATE TABLE IF NOT EXISTS public.missing_persons (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    age TEXT,
    gender TEXT,
    last_seen_location TEXT,
    last_seen_time TEXT,
    status TEXT DEFAULT 'searching' CHECK (status IN ('searching', 'safe', 'hospitalized', 'reunited')),
    status_label TEXT DEFAULT 'Search in Progress',
    status_class TEXT DEFAULT 'badge-warning',
    description TEXT,
    contact_person TEXT,
    photo TEXT,
    verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 5. Create Volunteer Squads Table
CREATE TABLE IF NOT EXISTS public.volunteer_roles (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    badge TEXT NOT NULL,
    badge_class TEXT NOT NULL,
    icon TEXT NOT NULL,
    needed INTEGER NOT NULL DEFAULT 20,
    joined INTEGER NOT NULL DEFAULT 0,
    location TEXT NOT NULL,
    requirements TEXT,
    urgency TEXT DEFAULT 'High',
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 6. Create Donations & Relief Pledges Table
CREATE TABLE IF NOT EXISTS public.donations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    amount NUMERIC(10, 2) NOT NULL,
    donor_name TEXT DEFAULT 'Anonymous Donor',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ==============================================================================
-- ENABLE REALTIME ON ALL TABLES FOR LIVE WEBSOCKET BROADCASTING
-- ==============================================================================
ALTER PUBLICATION supabase_realtime ADD TABLE public.incidents;
ALTER PUBLICATION supabase_realtime ADD TABLE public.shelters;
ALTER PUBLICATION supabase_realtime ADD TABLE public.sos_beacons;
ALTER PUBLICATION supabase_realtime ADD TABLE public.missing_persons;
ALTER PUBLICATION supabase_realtime ADD TABLE public.volunteer_roles;
ALTER PUBLICATION supabase_realtime ADD TABLE public.donations;

-- ==============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES FOR EMERGENCY DISASTER RELIEF
-- ==============================================================================
ALTER TABLE public.incidents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.shelters ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sos_beacons ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.missing_persons ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.volunteer_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.donations ENABLE ROW LEVEL SECURITY;

-- Allow Public Read Access
CREATE POLICY "Public Read Incidents" ON public.incidents FOR SELECT USING (true);
CREATE POLICY "Public Read Shelters" ON public.shelters FOR SELECT USING (true);
CREATE POLICY "Public Read SOS" ON public.sos_beacons FOR SELECT USING (true);
CREATE POLICY "Public Read Missing Persons" ON public.missing_persons FOR SELECT USING (true);
CREATE POLICY "Public Read Volunteers" ON public.volunteer_roles FOR SELECT USING (true);
CREATE POLICY "Public Read Donations" ON public.donations FOR SELECT USING (true);

-- Allow Public Insert & Update Access for Emergency Field Operators & Citizens
CREATE POLICY "Public Insert Incidents" ON public.incidents FOR INSERT WITH CHECK (true);
CREATE POLICY "Public Update Incidents" ON public.incidents FOR UPDATE USING (true);

CREATE POLICY "Public Update Shelters" ON public.shelters FOR UPDATE USING (true);
CREATE POLICY "Public Insert Shelters" ON public.shelters FOR INSERT WITH CHECK (true);

CREATE POLICY "Public Insert SOS" ON public.sos_beacons FOR INSERT WITH CHECK (true);

CREATE POLICY "Public Insert Missing Persons" ON public.missing_persons FOR INSERT WITH CHECK (true);
CREATE POLICY "Public Update Missing Persons" ON public.missing_persons FOR UPDATE USING (true);

CREATE POLICY "Public Update Volunteers" ON public.volunteer_roles FOR UPDATE USING (true);
CREATE POLICY "Public Insert Volunteers" ON public.volunteer_roles FOR INSERT WITH CHECK (true);

CREATE POLICY "Public Insert Donations" ON public.donations FOR INSERT WITH CHECK (true);

-- ==============================================================================
-- INITIAL DISASTER RELIEF SEED DATA
-- ==============================================================================
INSERT INTO public.shelters (id, name, address, lat, lng, capacity, occupied, status, features, contact, supervisor)
VALUES 
('SHL-101', 'Central Civic Arena Mega-Shelter', '100 Grand Boulevard, Central Heights', 13.0835, 80.2550, 1200, 984, 'open', ARRAY['Backup Generator', 'Medical Bay', 'Pet Friendly', 'Hot Meals'], '+1 (800) 555-0199', 'Commander Sarah Chen'),
('SHL-102', 'Holy Trinity High School Gymnasium', '18 Pine Crest Way, East District', 13.0980, 80.2690, 450, 410, 'open', ARRAY['Hot Meals', 'Infant Care', 'Cots Available'], '+1 (800) 555-0142', 'Officer David Vance'),
('SHL-103', 'South University Fieldhouse', '500 University Park Ave', 13.0580, 80.2480, 800, 310, 'open', ARRAY['Backup Generator', 'Showers', 'Charging Stations'], '+1 (800) 555-0188', 'Elena Rostova')
ON CONFLICT (id) DO NOTHING;

INSERT INTO public.volunteer_roles (id, title, badge, badge_class, icon, needed, joined, location, requirements, urgency)
VALUES 
('VOL-01', 'Swift Water Boat Rescuer', 'Specialized', 'badge-critical', 'fa-life-ring', 15, 9, 'Harbour Station & Delta Sector', 'Certified boat handling, swimming proficiency.', 'Immediate'),
('VOL-02', 'Emergency Triage Paramedic / Nurse', 'Medical', 'badge-info', 'fa-user-md', 30, 24, 'Central Civic Arena & Field Clinics', 'Valid RN/EMT license, trauma care.', 'High'),
('VOL-03', 'Food & Ration Preparation Crew', 'Logistics', 'badge-warning', 'fa-utensils', 50, 41, 'Central Relief Community Kitchen', 'Hygiene adherence, able to stand 4 hours.', 'Medium')
ON CONFLICT (id) DO NOTHING;
