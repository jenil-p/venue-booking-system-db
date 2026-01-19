-- Adminer 5.4.1 PostgreSQL 18.1 dump

DROP TYPE IF EXISTS "VenueStatus";;
CREATE TYPE "VenueStatus" AS ENUM ('ACTIVE', 'UNDER_MAINTENANCE', 'PENDING', 'BLOCKED', 'DELETED', 'DRAFT');

DROP TYPE IF EXISTS "PriceUnit";;
CREATE TYPE "PriceUnit" AS ENUM ('HOURLY', 'DAILY');

DROP TYPE IF EXISTS "BookingStatus";;
CREATE TYPE "BookingStatus" AS ENUM ('CART', 'PENDING_PAYMENT', 'CONFIRMED', 'CANCELLED', 'COMPLETED', 'REFUNDED');

DROP TYPE IF EXISTS "PaymentMethod";;
CREATE TYPE "PaymentMethod" AS ENUM ('UPI', 'CREDIT_CARD', 'CASH', 'BANK_CHEQUE');

DROP TYPE IF EXISTS "PaymentStatus";;
CREATE TYPE "PaymentStatus" AS ENUM ('SUCCESS', 'PENDING', 'FAILED', 'CANCELLED');

DROP TYPE IF EXISTS "ServiceStatus";;
CREATE TYPE "ServiceStatus" AS ENUM ('ACTIVE', 'TEMPORARILY_UNAVAILABLE', 'PENDING', 'BLOCKED', 'DELETED', 'DRAFT');

DROP TYPE IF EXISTS "ProviderStatus";;
CREATE TYPE "ProviderStatus" AS ENUM ('DRAFT', 'PENDING', 'APPROVED', 'REJECTED', 'DELETED');

CREATE SEQUENCE "ActionLog_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 148 CACHE 1;

CREATE TABLE "public"."ActionLog" (
    "id" integer DEFAULT nextval('"ActionLog_id_seq"') NOT NULL,
    "userId" integer NOT NULL,
    "tableId" integer NOT NULL,
    "operationId" integer NOT NULL,
    "operationObjectID" integer,
    "operationDate" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT "ActionLog_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);


CREATE SEQUENCE "Address_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 39 CACHE 1;

CREATE TABLE "public"."Address" (
    "id" integer DEFAULT nextval('"Address_id_seq"') NOT NULL,
    "location" text NOT NULL,
    "postalcode" integer NOT NULL,
    "latitude" double precision NOT NULL,
    "longitude" double precision NOT NULL,
    "cityId" integer NOT NULL,
    CONSTRAINT "Address_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);


CREATE SEQUENCE "AppTable_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 20 CACHE 1;

CREATE TABLE "public"."AppTable" (
    "id" integer DEFAULT nextval('"AppTable_id_seq"') NOT NULL,
    "tablename" text NOT NULL,
    "displayname" text NOT NULL,
    CONSTRAINT "AppTable_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX "AppTable_tablename_key" ON public."AppTable" USING btree (tablename);

CREATE UNIQUE INDEX "AppTable_displayname_key" ON public."AppTable" USING btree (displayname);


CREATE SEQUENCE "Booking_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."Booking" (
    "id" integer DEFAULT nextval('"Booking_id_seq"') NOT NULL,
    "userId" integer NOT NULL,
    "venueId" integer NOT NULL,
    "bookingStatus" "BookingStatus" DEFAULT PENDING_PAYMENT NOT NULL,
    "startTime" timestamp(3) NOT NULL,
    "endTime" timestamp(3) NOT NULL,
    "numberOfGuestsExpected" integer,
    "totalCost" numeric(10,2) NOT NULL,
    "createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) NOT NULL,
    CONSTRAINT "Booking_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);


CREATE SEQUENCE "BookingService_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."BookingService" (
    "id" integer DEFAULT nextval('"BookingService_id_seq"') NOT NULL,
    "bookingId" integer NOT NULL,
    "serviceId" integer NOT NULL,
    "priceAtBooking" numeric(10,2) NOT NULL,
    CONSTRAINT "BookingService_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX "BookingService_bookingId_serviceId_key" ON public."BookingService" USING btree ("bookingId", "serviceId");


CREATE SEQUENCE "City_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 33 CACHE 1;

CREATE TABLE "public"."City" (
    "id" integer DEFAULT nextval('"City_id_seq"') NOT NULL,
    "name" text NOT NULL,
    "stateId" integer NOT NULL,
    CONSTRAINT "City_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX "City_name_key" ON public."City" USING btree (name);

CREATE UNIQUE INDEX "City_name_stateId_key" ON public."City" USING btree (name, "stateId");


CREATE SEQUENCE "Country_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 5 CACHE 1;

CREATE TABLE "public"."Country" (
    "id" integer DEFAULT nextval('"Country_id_seq"') NOT NULL,
    "name" text NOT NULL,
    CONSTRAINT "Country_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX "Country_name_key" ON public."Country" USING btree (name);


CREATE SEQUENCE "Feature_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 14 CACHE 1;

CREATE TABLE "public"."Feature" (
    "id" integer DEFAULT nextval('"Feature_id_seq"') NOT NULL,
    "name" text NOT NULL,
    "icon" text NOT NULL,
    CONSTRAINT "Feature_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX "Feature_name_key" ON public."Feature" USING btree (name);


CREATE SEQUENCE "MenuLink_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."MenuLink" (
    "id" integer DEFAULT nextval('"MenuLink_id_seq"') NOT NULL,
    "displayname" text NOT NULL,
    "url" text NOT NULL,
    "icon" text,
    "tableId" integer NOT NULL,
    "parentId" integer,
    CONSTRAINT "MenuLink_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX "MenuLink_displayname_key" ON public."MenuLink" USING btree (displayname);


CREATE SEQUENCE "Operation_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 9 CACHE 1;

CREATE TABLE "public"."Operation" (
    "id" integer DEFAULT nextval('"Operation_id_seq"') NOT NULL,
    "operationname" text NOT NULL,
    CONSTRAINT "Operation_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX "Operation_operationname_key" ON public."Operation" USING btree (operationname);


CREATE SEQUENCE "Payment_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."Payment" (
    "id" integer DEFAULT nextval('"Payment_id_seq"') NOT NULL,
    "bookingId" integer NOT NULL,
    "transactionId" text NOT NULL,
    "amount" numeric(10,2) NOT NULL,
    "paymentMethod" "PaymentMethod" DEFAULT CREDIT_CARD NOT NULL,
    "status" "PaymentStatus" DEFAULT PENDING NOT NULL,
    "createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) NOT NULL,
    CONSTRAINT "Payment_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX "Payment_bookingId_key" ON public."Payment" USING btree ("bookingId");

CREATE UNIQUE INDEX "Payment_transactionId_key" ON public."Payment" USING btree ("transactionId");


CREATE SEQUENCE "ProviderProfile_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 12 CACHE 1;

CREATE TABLE "public"."ProviderProfile" (
    "id" integer DEFAULT nextval('"ProviderProfile_id_seq"') NOT NULL,
    "userId" integer NOT NULL,
    "legalname" text NOT NULL,
    "contact1" text NOT NULL,
    "contact2" text,
    "dateOfBirth" timestamp(3) NOT NULL,
    "idProof" text NOT NULL,
    "photo" text NOT NULL,
    "addressId" integer NOT NULL,
    "status" "ProviderStatus" DEFAULT DRAFT NOT NULL,
    CONSTRAINT "ProviderProfile_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX "ProviderProfile_userId_key" ON public."ProviderProfile" USING btree ("userId");


CREATE SEQUENCE "Role_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 7 CACHE 1;

CREATE TABLE "public"."Role" (
    "id" integer DEFAULT nextval('"Role_id_seq"') NOT NULL,
    "rolename" text NOT NULL,
    CONSTRAINT "Role_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX "Role_rolename_key" ON public."Role" USING btree (rolename);


CREATE SEQUENCE "RolePermission_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 61 CACHE 1;

CREATE TABLE "public"."RolePermission" (
    "id" integer DEFAULT nextval('"RolePermission_id_seq"') NOT NULL,
    "roleId" integer NOT NULL,
    "tableId" integer NOT NULL,
    "operationId" integer NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    CONSTRAINT "RolePermission_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX "RolePermission_roleId_tableId_operationId_key" ON public."RolePermission" USING btree ("roleId", "tableId", "operationId");


CREATE SEQUENCE "Service_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 16 CACHE 1;

CREATE TABLE "public"."Service" (
    "id" integer DEFAULT nextval('"Service_id_seq"') NOT NULL,
    "name" text NOT NULL,
    "description" text NOT NULL,
    "basePrice" numeric(10,2) NOT NULL,
    "categoryId" integer NOT NULL,
    "providerId" integer NOT NULL,
    "cityId" integer NOT NULL,
    "status" "ServiceStatus" DEFAULT PENDING NOT NULL,
    "rating" numeric(3,2) DEFAULT '0.0' NOT NULL,
    CONSTRAINT "Service_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);


CREATE SEQUENCE "ServiceCategory_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 13 CACHE 1;

CREATE TABLE "public"."ServiceCategory" (
    "id" integer DEFAULT nextval('"ServiceCategory_id_seq"') NOT NULL,
    "name" text NOT NULL,
    CONSTRAINT "ServiceCategory_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX "ServiceCategory_name_key" ON public."ServiceCategory" USING btree (name);


CREATE SEQUENCE "ServiceReview_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 61 CACHE 1;

CREATE TABLE "public"."ServiceReview" (
    "id" integer DEFAULT nextval('"ServiceReview_id_seq"') NOT NULL,
    "rating" integer NOT NULL,
    "comment" text,
    "serviceId" integer NOT NULL,
    "userId" integer NOT NULL,
    "createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) NOT NULL,
    CONSTRAINT "ServiceReview_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX "ServiceReview_userId_serviceId_key" ON public."ServiceReview" USING btree ("userId", "serviceId");


CREATE SEQUENCE "ServiceStatistic_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."ServiceStatistic" (
    "id" integer DEFAULT nextval('"ServiceStatistic_id_seq"') NOT NULL,
    "statDate" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "views" integer,
    "inquiries" integer,
    "bookings" integer,
    "revenue" numeric(10,2),
    "serviceId" integer NOT NULL,
    CONSTRAINT "ServiceStatistic_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);


CREATE SEQUENCE "State_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 29 CACHE 1;

CREATE TABLE "public"."State" (
    "id" integer DEFAULT nextval('"State_id_seq"') NOT NULL,
    "name" text NOT NULL,
    "countryId" integer NOT NULL,
    CONSTRAINT "State_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX "State_name_key" ON public."State" USING btree (name);

CREATE UNIQUE INDEX "State_name_countryId_key" ON public."State" USING btree (name, "countryId");


CREATE SEQUENCE "TypeOfVenue_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 12 CACHE 1;

CREATE TABLE "public"."TypeOfVenue" (
    "id" integer DEFAULT nextval('"TypeOfVenue_id_seq"') NOT NULL,
    "name" text NOT NULL,
    "icon" text NOT NULL,
    CONSTRAINT "TypeOfVenue_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);


CREATE SEQUENCE "User_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 41 CACHE 1;

CREATE TABLE "public"."User" (
    "id" integer DEFAULT nextval('"User_id_seq"') NOT NULL,
    "fullname" text NOT NULL,
    "contactnumber" text NOT NULL,
    "email" text,
    "isverified" boolean DEFAULT false NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX "User_contactnumber_key" ON public."User" USING btree (contactnumber);

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


CREATE SEQUENCE "UserRole_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 16 CACHE 1;

CREATE TABLE "public"."UserRole" (
    "id" integer DEFAULT nextval('"UserRole_id_seq"') NOT NULL,
    "userId" integer NOT NULL,
    "roleId" integer NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    CONSTRAINT "UserRole_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX "UserRole_userId_roleId_key" ON public."UserRole" USING btree ("userId", "roleId");


CREATE SEQUENCE "Venue_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 15 CACHE 1;

CREATE TABLE "public"."Venue" (
    "id" integer DEFAULT nextval('"Venue_id_seq"') NOT NULL,
    "venuename" text NOT NULL,
    "description" text NOT NULL,
    "capacity" integer NOT NULL,
    "contactemail" text NOT NULL,
    "contactnumber1" text NOT NULL,
    "contactnumber2" text,
    "status" "VenueStatus" DEFAULT DRAFT NOT NULL,
    "addressId" integer NOT NULL,
    "providerId" integer NOT NULL,
    "rating" numeric(3,2) DEFAULT '0' NOT NULL,
    CONSTRAINT "Venue_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);


CREATE SEQUENCE "VenueFeature_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 77 CACHE 1;

CREATE TABLE "public"."VenueFeature" (
    "id" integer DEFAULT nextval('"VenueFeature_id_seq"') NOT NULL,
    "venueId" integer NOT NULL,
    "featureId" integer NOT NULL,
    CONSTRAINT "VenueFeature_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX "VenueFeature_venueId_featureId_key" ON public."VenueFeature" USING btree ("venueId", "featureId");


CREATE SEQUENCE "VenuePhoto_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 61 CACHE 1;

CREATE TABLE "public"."VenuePhoto" (
    "id" integer DEFAULT nextval('"VenuePhoto_id_seq"') NOT NULL,
    "image" text NOT NULL,
    "description" text,
    "order" integer NOT NULL,
    "venueId" integer NOT NULL,
    CONSTRAINT "VenuePhoto_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX "VenuePhoto_venueId_order_key" ON public."VenuePhoto" USING btree ("venueId", "order");


CREATE SEQUENCE "VenuePricingRule_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 25 CACHE 1;

CREATE TABLE "public"."VenuePricingRule" (
    "id" integer DEFAULT nextval('"VenuePricingRule_id_seq"') NOT NULL,
    "venueId" integer NOT NULL,
    "unit" "PriceUnit" NOT NULL,
    "price" numeric(10,2) NOT NULL,
    "startTime" timestamp(3),
    "endTime" timestamp(3),
    CONSTRAINT "VenuePricingRule_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);


CREATE SEQUENCE "VenueReview_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 73 CACHE 1;

CREATE TABLE "public"."VenueReview" (
    "id" integer DEFAULT nextval('"VenueReview_id_seq"') NOT NULL,
    "rating" integer NOT NULL,
    "comment" text,
    "venueId" integer NOT NULL,
    "userId" integer NOT NULL,
    "createdAt" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) NOT NULL,
    CONSTRAINT "VenueReview_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);


CREATE SEQUENCE "VenueStatistic_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."VenueStatistic" (
    "id" integer DEFAULT nextval('"VenueStatistic_id_seq"') NOT NULL,
    "statDate" timestamp(3) DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "pageViews" integer,
    "bookingrequests" integer,
    "confirmedbookings" integer,
    "revenue" numeric(10,2),
    "venueId" integer NOT NULL,
    CONSTRAINT "VenueStatistic_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);


CREATE SEQUENCE "VenueType_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 START 15 CACHE 1;

CREATE TABLE "public"."VenueType" (
    "id" integer DEFAULT nextval('"VenueType_id_seq"') NOT NULL,
    "venueId" integer NOT NULL,
    "typeId" integer NOT NULL,
    CONSTRAINT "VenueType_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX "VenueType_venueId_typeId_key" ON public."VenueType" USING btree ("venueId", "typeId");


CREATE SEQUENCE "Wishlist_id_seq" INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."Wishlist" (
    "id" integer DEFAULT nextval('"Wishlist_id_seq"') NOT NULL,
    "userId" integer NOT NULL,
    "venueId" integer NOT NULL,
    CONSTRAINT "Wishlist_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);

CREATE UNIQUE INDEX "Wishlist_userId_venueId_key" ON public."Wishlist" USING btree ("userId", "venueId");


CREATE TABLE "public"."_prisma_migrations" (
    "id" character varying(36) NOT NULL,
    "checksum" character varying(64) NOT NULL,
    "finished_at" timestamptz,
    "migration_name" character varying(255) NOT NULL,
    "logs" text,
    "rolled_back_at" timestamptz,
    "started_at" timestamptz DEFAULT now() NOT NULL,
    "applied_steps_count" integer DEFAULT '0' NOT NULL,
    CONSTRAINT "_prisma_migrations_pkey" PRIMARY KEY ("id")
)
WITH (oids = false);


ALTER TABLE ONLY "public"."ActionLog" ADD CONSTRAINT "ActionLog_operationId_fkey" FOREIGN KEY ("operationId") REFERENCES "Operation"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;
ALTER TABLE ONLY "public"."ActionLog" ADD CONSTRAINT "ActionLog_tableId_fkey" FOREIGN KEY ("tableId") REFERENCES "AppTable"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;
ALTER TABLE ONLY "public"."ActionLog" ADD CONSTRAINT "ActionLog_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;

ALTER TABLE ONLY "public"."Address" ADD CONSTRAINT "Address_cityId_fkey" FOREIGN KEY ("cityId") REFERENCES "City"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;

ALTER TABLE ONLY "public"."Booking" ADD CONSTRAINT "Booking_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;
ALTER TABLE ONLY "public"."Booking" ADD CONSTRAINT "Booking_venueId_fkey" FOREIGN KEY ("venueId") REFERENCES "Venue"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;

ALTER TABLE ONLY "public"."BookingService" ADD CONSTRAINT "BookingService_bookingId_fkey" FOREIGN KEY ("bookingId") REFERENCES "Booking"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;
ALTER TABLE ONLY "public"."BookingService" ADD CONSTRAINT "BookingService_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "Service"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;

ALTER TABLE ONLY "public"."City" ADD CONSTRAINT "City_stateId_fkey" FOREIGN KEY ("stateId") REFERENCES "State"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;

ALTER TABLE ONLY "public"."MenuLink" ADD CONSTRAINT "MenuLink_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "MenuLink"(id) ON UPDATE CASCADE ON DELETE SET NULL NOT DEFERRABLE;
ALTER TABLE ONLY "public"."MenuLink" ADD CONSTRAINT "MenuLink_tableId_fkey" FOREIGN KEY ("tableId") REFERENCES "AppTable"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;

ALTER TABLE ONLY "public"."Payment" ADD CONSTRAINT "Payment_bookingId_fkey" FOREIGN KEY ("bookingId") REFERENCES "Booking"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;

ALTER TABLE ONLY "public"."ProviderProfile" ADD CONSTRAINT "ProviderProfile_addressId_fkey" FOREIGN KEY ("addressId") REFERENCES "Address"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;
ALTER TABLE ONLY "public"."ProviderProfile" ADD CONSTRAINT "ProviderProfile_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;

ALTER TABLE ONLY "public"."RolePermission" ADD CONSTRAINT "RolePermission_operationId_fkey" FOREIGN KEY ("operationId") REFERENCES "Operation"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;
ALTER TABLE ONLY "public"."RolePermission" ADD CONSTRAINT "RolePermission_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "Role"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;
ALTER TABLE ONLY "public"."RolePermission" ADD CONSTRAINT "RolePermission_tableId_fkey" FOREIGN KEY ("tableId") REFERENCES "AppTable"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;

ALTER TABLE ONLY "public"."Service" ADD CONSTRAINT "Service_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "ServiceCategory"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;
ALTER TABLE ONLY "public"."Service" ADD CONSTRAINT "Service_cityId_fkey" FOREIGN KEY ("cityId") REFERENCES "City"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;
ALTER TABLE ONLY "public"."Service" ADD CONSTRAINT "Service_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "ProviderProfile"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;

ALTER TABLE ONLY "public"."ServiceReview" ADD CONSTRAINT "ServiceReview_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "Service"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;
ALTER TABLE ONLY "public"."ServiceReview" ADD CONSTRAINT "ServiceReview_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;

ALTER TABLE ONLY "public"."ServiceStatistic" ADD CONSTRAINT "ServiceStatistic_serviceId_fkey" FOREIGN KEY ("serviceId") REFERENCES "Service"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;

ALTER TABLE ONLY "public"."State" ADD CONSTRAINT "State_countryId_fkey" FOREIGN KEY ("countryId") REFERENCES "Country"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;

ALTER TABLE ONLY "public"."UserRole" ADD CONSTRAINT "UserRole_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "Role"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;
ALTER TABLE ONLY "public"."UserRole" ADD CONSTRAINT "UserRole_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;

ALTER TABLE ONLY "public"."Venue" ADD CONSTRAINT "Venue_addressId_fkey" FOREIGN KEY ("addressId") REFERENCES "Address"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;
ALTER TABLE ONLY "public"."Venue" ADD CONSTRAINT "Venue_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "ProviderProfile"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;

ALTER TABLE ONLY "public"."VenueFeature" ADD CONSTRAINT "VenueFeature_featureId_fkey" FOREIGN KEY ("featureId") REFERENCES "Feature"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;
ALTER TABLE ONLY "public"."VenueFeature" ADD CONSTRAINT "VenueFeature_venueId_fkey" FOREIGN KEY ("venueId") REFERENCES "Venue"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;

ALTER TABLE ONLY "public"."VenuePhoto" ADD CONSTRAINT "VenuePhoto_venueId_fkey" FOREIGN KEY ("venueId") REFERENCES "Venue"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;

ALTER TABLE ONLY "public"."VenuePricingRule" ADD CONSTRAINT "VenuePricingRule_venueId_fkey" FOREIGN KEY ("venueId") REFERENCES "Venue"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;

ALTER TABLE ONLY "public"."VenueReview" ADD CONSTRAINT "VenueReview_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;
ALTER TABLE ONLY "public"."VenueReview" ADD CONSTRAINT "VenueReview_venueId_fkey" FOREIGN KEY ("venueId") REFERENCES "Venue"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;

ALTER TABLE ONLY "public"."VenueStatistic" ADD CONSTRAINT "VenueStatistic_venueId_fkey" FOREIGN KEY ("venueId") REFERENCES "Venue"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;

ALTER TABLE ONLY "public"."VenueType" ADD CONSTRAINT "VenueType_typeId_fkey" FOREIGN KEY ("typeId") REFERENCES "TypeOfVenue"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;
ALTER TABLE ONLY "public"."VenueType" ADD CONSTRAINT "VenueType_venueId_fkey" FOREIGN KEY ("venueId") REFERENCES "Venue"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;

ALTER TABLE ONLY "public"."Wishlist" ADD CONSTRAINT "Wishlist_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;
ALTER TABLE ONLY "public"."Wishlist" ADD CONSTRAINT "Wishlist_venueId_fkey" FOREIGN KEY ("venueId") REFERENCES "Venue"(id) ON UPDATE CASCADE ON DELETE RESTRICT NOT DEFERRABLE;

-- 2026-01-19 06:06:59 UTC
