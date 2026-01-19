# Venue & Service Booking Platform – Database Schema

This repository contains the PostgreSQL database design for an end-to-end venue and service booking platform.

## Overview
- Designed a normalized relational schema (30+ tables) covering venues, services, bookings, payments, users, providers, and access control.
- Entity–Relationship (ER) model created to represent complex many-to-many relationships and domain constraints.
- Normalization enforced up to **BCNF** to ensure data consistency and minimize redundancy.

## Contents
- `venue_db.sql` – Schema-only SQL export (DDL) generated using **pgAdmin**
- `er_diagram4.png` – Visualized ER diagram generated via **dbdiagram.io**

## Notes
This repository focuses solely on database design and schema correctness.  
No application-layer logic or sample data is included.
