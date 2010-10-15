-- MySQL dump 10.11
--
-- Host: localhost    Database: mw_calendar
-- ------------------------------------------------------
-- Server version	5.0.77-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `bedework`
--


CREATE DATABASE /*!32312 IF NOT EXISTS*/ bedework /*!40100 DEFAULT CHARACTER SET latin1 */;

USE bedework;

--
-- Table structure for table `bw_adminGroupMembers`
--

DROP TABLE IF EXISTS `bw_adminGroupMembers`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_adminGroupMembers` (
  `bw_groupid` int(11) NOT NULL,
  `memberid` int(11) NOT NULL,
  `member_is_group` char(1) NOT NULL,
  PRIMARY KEY  (`bw_groupid`,`memberid`,`member_is_group`),
  KEY `bw_agm_ag_fk` (`bw_groupid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_adminGroups`
--

DROP TABLE IF EXISTS `bw_adminGroups`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_adminGroups` (
  `bw_groupid` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `account` text default NULL,
  `description` text default NULL,
  `groupOwner` int(11) NOT NULL,
  `ownerid` int(11) NOT NULL,
  PRIMARY KEY  (`bw_groupid`),
  KEY `bw_ag_users_fk1` (`groupOwner`),
  KEY `bw_ag_users_fk2` (`ownerid`)
) ENGINE=ndbcluster AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_alarm_attendees`
--

DROP TABLE IF EXISTS `bw_alarm_attendees`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_alarm_attendees` (
  `alarmid` int(11) NOT NULL,
  `attendeeid` int(11) NOT NULL,
  PRIMARY KEY  (`alarmid`,`attendeeid`),
  KEY `bw_aa_alarm_fk` (`alarmid`),
  KEY `bw_aa_att_fk` (`attendeeid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_alarmdescriptions`
--

DROP TABLE IF EXISTS `bw_alarmdescriptions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_alarmdescriptions` (
  `bw_alarmid` int(11) NOT NULL,
  `bw_strid` int(11) NOT NULL,
  PRIMARY KEY  (`bw_alarmid`,`bw_strid`),
  UNIQUE KEY `bw_strid` (`bw_strid`),
  KEY `bw_ad_str_fk` (`bw_strid`),
  KEY `bw_ad_alarm_fk` (`bw_alarmid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_alarms`
--

DROP TABLE IF EXISTS `bw_alarms`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_alarms` (
  `alarmid` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `alarm_type` int(11) default NULL,
  `ownerid` int(11) NOT NULL,
  `publick` char(1) NOT NULL,
  `trigger_rfctime` varchar(16) default NULL,
  `trigger_start` char(1) NOT NULL,
  `duration` varchar(100) default NULL,
  `repetitions` int(11) default NULL,
  `attach` text default NULL,
  `trigger_time` varchar(16) default NULL,
  `previous_trigger` varchar(16) default NULL,
  `repeat_count` int(11) default NULL,
  `expired` char(1) NOT NULL,
  PRIMARY KEY  (`alarmid`),
  KEY `bwidx_alarms_user` (`ownerid`),
  KEY `bw_alarms_users_fk` (`ownerid`)
) ENGINE=ndbcluster AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_alarmsummaries`
--

DROP TABLE IF EXISTS `bw_alarmsummaries`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_alarmsummaries` (
  `bw_alarmid` int(11) NOT NULL,
  `bw_strid` int(11) NOT NULL,
  PRIMARY KEY  (`bw_alarmid`,`bw_strid`),
  UNIQUE KEY `bw_strid` (`bw_strid`),
  KEY `bw_as_str_fk` (`bw_strid`),
  KEY `bw_as_alarm_fk` (`bw_alarmid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_attachments`
--

DROP TABLE IF EXISTS `bw_attachments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_attachments` (
  `bwid` int(11) NOT NULL auto_increment,
  `bw_fmttype` varchar(20) default NULL,
  `bw_valuetype` varchar(20) default NULL,
  `bw_encoding` text default NULL,
  `bw_uri` text default NULL,
  `bw_value` text,
  PRIMARY KEY  (`bwid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_attendees`
--

DROP TABLE IF EXISTS `bw_attendees`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_attendees` (
  `attendeeid` int(11) NOT NULL auto_increment,
  `cn` text default NULL,
  `cutype` text default NULL,
  `delegated_from` text default NULL,
  `delegated_to` text default NULL,
  `dir` text default NULL,
  `lang` varchar(100) default NULL,
  `member` text default NULL,
  `rsvp` char(1) default NULL,
  `role` varchar(200) default NULL,
  `partstat` varchar(100) default NULL,
  `sent_by` text default NULL,
  `attendee_uri` text default NULL,
  `rfcsequence` int(11) default NULL,
  `dtstamp` varchar(16) default NULL,
  PRIMARY KEY  (`attendeeid`)
) ENGINE=ndbcluster AUTO_INCREMENT=4011 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_auth`
--

DROP TABLE IF EXISTS `bw_auth`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_auth` (
  `userid` int(11) NOT NULL,
  `bwseq` int(11) NOT NULL,
  `usertype` int(11) default NULL,
  PRIMARY KEY  (`userid`),
  KEY `bw_auth_user_fk` (`userid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_authprefCalendars`
--

DROP TABLE IF EXISTS `bw_authprefCalendars`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_authprefCalendars` (
  `userid` int(11) NOT NULL,
  `calendarid` int(11) NOT NULL,
  PRIMARY KEY  (`userid`,`calendarid`),
  KEY `bw_apcat_cal_fk1` (`calendarid`),
  KEY `bw_apcal_ap_fk1` (`userid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_authprefCategories`
--

DROP TABLE IF EXISTS `bw_authprefCategories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_authprefCategories` (
  `userid` int(11) NOT NULL,
  `categoryid` int(11) NOT NULL,
  PRIMARY KEY  (`userid`,`categoryid`),
  KEY `bw_apcat_cat_fk1` (`categoryid`),
  KEY `bw_apcat_ap_fk1` (`userid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_authprefContacts`
--

DROP TABLE IF EXISTS `bw_authprefContacts`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_authprefContacts` (
  `userid` int(11) NOT NULL,
  `contactid` int(11) NOT NULL,
  PRIMARY KEY  (`userid`,`contactid`),
  KEY `bw_apcon_con_fk1` (`contactid`),
  KEY `bw_apcon_ap_fk1` (`userid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_authprefLocations`
--

DROP TABLE IF EXISTS `bw_authprefLocations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_authprefLocations` (
  `userid` int(11) NOT NULL,
  `locationid` int(11) NOT NULL,
  PRIMARY KEY  (`userid`,`locationid`),
  KEY `bw_aploc_loc_fk1` (`locationid`),
  KEY `bw_aploc_ap_fk1` (`userid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_authprefs`
--

DROP TABLE IF EXISTS `bw_authprefs`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_authprefs` (
  `userid` int(11) NOT NULL,
  `bwseq` int(11) NOT NULL,
  `autoaddCategories` char(1) NOT NULL,
  `autoaddLocations` char(1) NOT NULL,
  `autoaddContacts` char(1) NOT NULL,
  `autoaddCalendars` char(1) NOT NULL,
  PRIMARY KEY  (`userid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_calendar_categories`
--

DROP TABLE IF EXISTS `bw_calendar_categories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_calendar_categories` (
  `calendarid` int(11) NOT NULL,
  `categoryid` int(11) NOT NULL,
  PRIMARY KEY  (`calendarid`,`categoryid`),
  KEY `bw_cal_cat_fk` (`categoryid`),
  KEY `bw_calcat_cid_fk` (`calendarid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_calendar_properties`
--

DROP TABLE IF EXISTS `bw_calendar_properties`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_calendar_properties` (
  `bwid` int(11) NOT NULL,
  `bw_name` varchar(200) default NULL,
  `bw_value` text,
  KEY `bw_calprp_pid_fk` (`bwid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_calendars`
--

DROP TABLE IF EXISTS `bw_calendars`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_calendars` (
  `id` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `creatorid` int(11) NOT NULL,
  `ownerid` int(11) NOT NULL,
  `bwaccess` text default NULL,
  `publick` char(1) NOT NULL,
  `calname` varchar(100) NOT NULL,
  `bwpath` varchar(1500) NOT NULL,
  `summary` text default NULL,
  `description` text default NULL,
  `mail_list_id` varchar(200) default NULL,
  `calendar_collection` char(1) NOT NULL,
  `parent` int(11) default NULL,
  `caltype` int(11) NOT NULL,
  `bw_lastmod` varchar(16) NOT NULL,
  `bwsequence` int(11) default NULL,
  `bw_created` varchar(16) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `bwidx_cal_calendar` (`parent`),
  KEY `bwidx_cal_owner` (`ownerid`),
  KEY `bwidx_calpath` (`bwpath`(333)),
  KEY `bwidx_cal_creator` (`creatorid`),
  KEY `bw_cal_user_fk1` (`creatorid`),
  KEY `bw_cal_user_fk2` (`ownerid`),
  KEY `bw_cal_cal_fk` (`parent`)
) ENGINE=ndbcluster AUTO_INCREMENT=2399 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_calsuites`
--

DROP TABLE IF EXISTS `bw_calsuites`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_calsuites` (
  `csid` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `creatorid` int(11) NOT NULL,
  `ownerid` int(11) NOT NULL,
  `bwaccess` text default NULL,
  `publick` char(1) NOT NULL,
  `csname` varchar(255) NOT NULL,
  `groupid` int(11) NOT NULL,
  `csrootcal` int(11) NOT NULL,
  PRIMARY KEY  (`csid`),
  UNIQUE KEY `csname` (`csname`),
  KEY `bwidx_calsuite_group` (`groupid`),
  KEY `bwidx_calsuite_owner` (`ownerid`),
  KEY `bwidx_calsuite_creator` (`creatorid`),
  KEY `bw_cs_user_fk1` (`creatorid`),
  KEY `bw_cs_ag_fk` (`groupid`),
  KEY `bw_cs_cal_fk` (`csrootcal`),
  KEY `bw_cs_user_fk2` (`ownerid`)
) ENGINE=ndbcluster AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_categories`
--

DROP TABLE IF EXISTS `bw_categories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_categories` (
  `categoryid` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `creatorid` int(11) NOT NULL,
  `ownerid` int(11) NOT NULL,
  `bwaccess` text default NULL,
  `publick` char(1) NOT NULL,
  `bw_catwdid` int(11) NOT NULL,
  `bw_catdescid` int(11) default NULL,
  PRIMARY KEY  (`categoryid`),
  UNIQUE KEY `bw_catwdid` (`bw_catwdid`),
  UNIQUE KEY `bw_catdescid` (`bw_catdescid`),
  KEY `bwidx_cat_creator` (`creatorid`),
  KEY `bwidx_cat_owner` (`ownerid`),
  KEY `bw_cat_user_fk1` (`creatorid`),
  KEY `bw_cat_wd_fk` (`bw_catwdid`),
  KEY `bw_cat_user_fk2` (`ownerid`),
  KEY `bw_cat_desc_fk` (`bw_catdescid`)
) ENGINE=ndbcluster AUTO_INCREMENT=73 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_contacts`
--

DROP TABLE IF EXISTS `bw_contacts`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_contacts` (
  `entityid` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `creatorid` int(11) NOT NULL,
  `ownerid` int(11) NOT NULL,
  `bwaccess` text default NULL,
  `publick` char(1) NOT NULL,
  `bw_uid` varchar(50) NOT NULL,
  `bw_connameid` int(11) NOT NULL,
  `bw_phone` varchar(255) default NULL,
  `bw_email` varchar(255) default NULL,
  `bw_link` text default NULL,
  PRIMARY KEY  (`entityid`),
  UNIQUE KEY `bw_connameid` (`bw_connameid`),
  KEY `bwidx_contact_owner` (`ownerid`),
  KEY `bwidx_contact_creator` (`creatorid`),
  KEY `bw_con_user_fk1` (`creatorid`),
  KEY `bw_con_name_fk` (`bw_connameid`),
  KEY `bw_con_user_fk2` (`ownerid`)
) ENGINE=ndbcluster AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_entity_alarms`
--

DROP TABLE IF EXISTS `bw_entity_alarms`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_entity_alarms` (
  `eventid` int(11) NOT NULL,
  `alarmid` int(11) NOT NULL,
  PRIMARY KEY  (`eventid`,`alarmid`),
  KEY `bw_event_alarm_fk` (`alarmid`),
  KEY `bw_eventalm_eid_fk` (`eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_entity_attachments`
--

DROP TABLE IF EXISTS `bw_entity_attachments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_entity_attachments` (
  `eventid` int(11) NOT NULL,
  `attachid` int(11) NOT NULL,
  PRIMARY KEY  (`eventid`,`attachid`),
  KEY `bw_event_attach_fk` (`attachid`),
  KEY `bw_eventattach_eid_fk` (`eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_event_annotations`
--

DROP TABLE IF EXISTS `bw_event_annotations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_event_annotations` (
  `eventid` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `bw_entity_type` int(11) default NULL,
  `creatorid` int(11) default NULL,
  `ownerid` int(11) default NULL,
  `bwaccess` text default NULL,
  `publick` char(1) default NULL,
  `start_date_type` char(1) default NULL,
  `start_tzid` text default NULL,
  `start_dtval` varchar(16) default NULL,
  `start_date` varchar(16) default NULL,
  `bw_start_floating` char(1) default NULL,
  `end_date_type` char(1) default NULL,
  `end_tzid` text default NULL,
  `end_dtval` varchar(16) default NULL,
  `end_date` varchar(16) default NULL,
  `bw_end_floating` char(1) default NULL,
  `duration` text default NULL,
  `end_type` char(1) default NULL,
  `bw_nostart` char(1) default NULL,
  `bw_deleted` char(1) default NULL,
  `bw_class` text default NULL,
  `bw_link` text default NULL,
  `bw_geolatitude` decimal(19,2) default NULL,
  `bw_geolongitude` decimal(19,2) default NULL,
  `status` text default NULL,
  `cost` text default NULL,
  `calendarid` int(11) default NULL,
  `bw_dtstamp` varchar(16) default NULL,
  `bw_lastmod` varchar(16) default NULL,
  `bw_created` varchar(16) default NULL,
  `priority` int(11) default NULL,
  `locationid` int(11) default NULL,
  `eventname` text default NULL,
  `bw_uid` text default NULL,
  `rfcsequence` int(11) default NULL,
  `transparency` varchar(100) default NULL,
  `percent_complete` int(11) default NULL,
  `completed` varchar(16) default NULL,
  `recurring` char(1) default NULL,
  `recurrence_id` varchar(16) default NULL,
  `latest_date` varchar(255) default NULL,
  `expanded` char(1) default NULL,
  `schedule_method` int(11) default NULL,
  `originator` text default NULL,
  `organizerid` int(11) default NULL,
  `bw_reltype` varchar(100) default NULL,
  `bw_reltoval` text default NULL,
  `schedule_state` int(11) default NULL,
  `targetid` int(11) default NULL,
  `masterid` int(11) default NULL,
  `bw_override` char(1) NOT NULL,
  `bw_alarms_empty` char(1) default NULL,
  `bw_attendees_empty` char(1) default NULL,
  `bw_categories_empty` char(1) default NULL,
  `bw_comments_empty` char(1) default NULL,
  `bw_contacts_empty` char(1) default NULL,
  `bw_descriptions_empty` char(1) default NULL,
  `bw_exdates_empty` char(1) default NULL,
  `bw_exrules_empty` char(1) default NULL,
  `bw_rdates_empty` char(1) default NULL,
  `bw_recipients_empty` char(1) default NULL,
  `bw_request_statuses_empty` char(1) default NULL,
  `bw_resources_empty` char(1) default NULL,
  `bw_rrules_empty` char(1) default NULL,
  `bw_summaries_empty` char(1) default NULL,
  `bw_xproperties_empty` char(1) default NULL,
  PRIMARY KEY  (`eventid`),
  UNIQUE KEY `organizerid` (`organizerid`),
  KEY `bwidx_eann_start` (`start_date`),
  KEY `bwidx_eann_start_floating` (`bw_start_floating`),
  KEY `bwidx_eann_latest_date` (`latest_date`),
  KEY `bwidx_eann_calendar` (`calendarid`),
  KEY `bwidx_eann_location` (`locationid`),
  KEY `bwidx_eann_expanded` (`expanded`),
  KEY `bwidx_eann_end_floating` (`bw_end_floating`),
  KEY `sidx_eann_owner` (`ownerid`),
  KEY `bwidx_eann_creator` (`creatorid`),
  KEY `bwidx_eann_recurring` (`recurring`),
  KEY `bwidx_eann_deleted` (`bw_deleted`),
  KEY `bwidx_eann_end` (`end_date`),
  KEY `bw_eann_loc_fk` (`locationid`),
  KEY `bw_eann_users_fk1` (`creatorid`),
  KEY `bw_eann_tgt_fk` (`targetid`),
  KEY `bw_eann_org_fk` (`organizerid`),
  KEY `bw_eann_cal_fk` (`calendarid`),
  KEY `bw_eann_mstr_fk` (`masterid`),
  KEY `bw_eann_users_fk2` (`ownerid`)
) ENGINE=ndbcluster AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_event_attendees`
--

DROP TABLE IF EXISTS `bw_event_attendees`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_event_attendees` (
  `eventid` int(11) NOT NULL,
  `attendeeid` int(11) NOT NULL,
  PRIMARY KEY  (`eventid`,`attendeeid`),
  KEY `bw_event_att_fk` (`attendeeid`),
  KEY `bw_eventatt_eid_fk` (`eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_event_availuids`
--

DROP TABLE IF EXISTS `bw_event_availuids`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_event_availuids` (
  `eventid` int(11) NOT NULL,
  `avluid` varchar(255) NOT NULL,
  PRIMARY KEY  (`eventid`,`avluid`),
  KEY `bw_event_avluid_fk` (`eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_event_categories`
--

DROP TABLE IF EXISTS `bw_event_categories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_event_categories` (
  `eventid` int(11) NOT NULL,
  `categoryid` int(11) NOT NULL,
  PRIMARY KEY  (`eventid`,`categoryid`),
  KEY `bw_event_cat_fk` (`categoryid`),
  KEY `bw_eventcat_eid_fk` (`eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_event_comments`
--

DROP TABLE IF EXISTS `bw_event_comments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_event_comments` (
  `bw_eventid` int(11) NOT NULL,
  `bw_strid` int(11) NOT NULL,
  PRIMARY KEY  (`bw_eventid`,`bw_strid`),
  UNIQUE KEY `bw_strid` (`bw_strid`),
  KEY `bw_event_com_fk` (`bw_strid`),
  KEY `bw_eventcom_eid_fk` (`bw_eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_event_contacts`
--

DROP TABLE IF EXISTS `bw_event_contacts`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_event_contacts` (
  `eventid` int(11) NOT NULL,
  `contactid` int(11) NOT NULL,
  PRIMARY KEY  (`eventid`,`contactid`),
  KEY `bw_eventcon_eid_fk` (`eventid`),
  KEY `bw_event_con_fk` (`contactid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_event_descriptions`
--

DROP TABLE IF EXISTS `bw_event_descriptions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_event_descriptions` (
  `bw_eventid` int(11) NOT NULL,
  `bw_strid` int(11) NOT NULL,
  PRIMARY KEY  (`bw_eventid`,`bw_strid`),
  UNIQUE KEY `bw_strid` (`bw_strid`),
  KEY `bw_event_desc_fk` (`bw_strid`),
  KEY `bw_eventdesc_eid_fk` (`bw_eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_event_exdates`
--

DROP TABLE IF EXISTS `bw_event_exdates`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_event_exdates` (
  `eventid` int(11) NOT NULL,
  `ex_date_type` char(1) NOT NULL,
  `ex_tzid` varchar(255) default NULL,
  `ex_dtval` varchar(16) NOT NULL,
  `ex_date` varchar(16) NOT NULL,
  PRIMARY KEY  (`eventid`,`ex_date_type`,`ex_dtval`,`ex_date`),
  KEY `bwidx_event_exdate` (`ex_date`),
  KEY `bw_event_edate_fk` (`eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_event_exrules`
--

DROP TABLE IF EXISTS `bw_event_exrules`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_event_exrules` (
  `eventid` int(11) NOT NULL,
  `exrule` varchar(255) NOT NULL,
  PRIMARY KEY  (`eventid`,`exrule`),
  KEY `bw_event_erule_fk` (`eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_event_rdates`
--

DROP TABLE IF EXISTS `bw_event_rdates`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_event_rdates` (
  `eventid` int(11) NOT NULL,
  `r_date_type` char(1) NOT NULL,
  `r_tzid` varchar(255) default NULL,
  `r_dtval` varchar(16) NOT NULL,
  `r_date` varchar(16) NOT NULL,
  PRIMARY KEY  (`eventid`,`r_date_type`,`r_dtval`,`r_date`),
  KEY `bwidx_event_rdate` (`r_date`),
  KEY `bw_event_rdate_fk` (`eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_event_recipients`
--

DROP TABLE IF EXISTS `bw_event_recipients`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_event_recipients` (
  `eventid` int(11) NOT NULL,
  `recipient` varchar(255) NOT NULL,
  PRIMARY KEY  (`eventid`,`recipient`),
  KEY `bw_event_recip_fk` (`eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_event_resources`
--

DROP TABLE IF EXISTS `bw_event_resources`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_event_resources` (
  `bw_eventid` int(11) NOT NULL,
  `bw_strid` int(11) NOT NULL,
  PRIMARY KEY  (`bw_eventid`,`bw_strid`),
  UNIQUE KEY `bw_strid` (`bw_strid`),
  KEY `bw_event_res_fk` (`bw_strid`),
  KEY `bw_eventres_eid_fk` (`bw_eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_event_rrules`
--

DROP TABLE IF EXISTS `bw_event_rrules`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_event_rrules` (
  `eventid` int(11) NOT NULL,
  `rrule` varchar(255) NOT NULL,
  PRIMARY KEY  (`eventid`,`rrule`),
  KEY `bw_event_rrule_fk` (`eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_event_summaries`
--

DROP TABLE IF EXISTS `bw_event_summaries`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_event_summaries` (
  `bw_eventid` int(11) NOT NULL,
  `bw_strid` int(11) NOT NULL,
  PRIMARY KEY  (`bw_eventid`,`bw_strid`),
  UNIQUE KEY `bw_strid` (`bw_strid`),
  KEY `bw_event_sum_fk` (`bw_strid`),
  KEY `bw_eventsum_eid_fk` (`bw_eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_event_xprops`
--

DROP TABLE IF EXISTS `bw_event_xprops`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_event_xprops` (
  `bw_eventid` int(11) NOT NULL,
  `bw_name` varchar(100) default NULL,
  `bw_pars` varchar(200) default NULL,
  `bw_value` text,
  `bwxp_position` int(11) NOT NULL,
  PRIMARY KEY  (`bw_eventid`,`bwxp_position`),
  KEY `bw_eventxp_eid_fk` (`bw_eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_eventann_alarms`
--

DROP TABLE IF EXISTS `bw_eventann_alarms`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_eventann_alarms` (
  `eventid` int(11) NOT NULL,
  `alarmid` int(11) NOT NULL,
  PRIMARY KEY  (`eventid`,`alarmid`),
  KEY `bw_eann_alarm_fk` (`alarmid`),
  KEY `bw_eannalm_eid_fk` (`eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_eventann_attendees`
--

DROP TABLE IF EXISTS `bw_eventann_attendees`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_eventann_attendees` (
  `eventid` int(11) NOT NULL,
  `attendeeid` int(11) NOT NULL,
  PRIMARY KEY  (`eventid`,`attendeeid`),
  KEY `bw_eann_att_fk` (`attendeeid`),
  KEY `bw_eannatt_eid_fk` (`eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_eventann_categories`
--

DROP TABLE IF EXISTS `bw_eventann_categories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_eventann_categories` (
  `eventid` int(11) NOT NULL,
  `categoryid` int(11) NOT NULL,
  PRIMARY KEY  (`eventid`,`categoryid`),
  KEY `bw_eann_cat_fk` (`categoryid`),
  KEY `bw_eanncat_eid_fk` (`eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_eventann_comments`
--

DROP TABLE IF EXISTS `bw_eventann_comments`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_eventann_comments` (
  `bw_eventid` int(11) NOT NULL,
  `bw_strid` int(11) NOT NULL,
  PRIMARY KEY  (`bw_eventid`,`bw_strid`),
  UNIQUE KEY `bw_strid` (`bw_strid`),
  KEY `bw_eann_com_fk` (`bw_strid`),
  KEY `bw_eanncom_eid_fk` (`bw_eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_eventann_contacts`
--

DROP TABLE IF EXISTS `bw_eventann_contacts`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_eventann_contacts` (
  `eventid` int(11) NOT NULL,
  `contactid` int(11) NOT NULL,
  PRIMARY KEY  (`eventid`,`contactid`),
  KEY `bw_eanncon_eid_fk` (`eventid`),
  KEY `bw_eann_con_fk` (`contactid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_eventann_descriptions`
--

DROP TABLE IF EXISTS `bw_eventann_descriptions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_eventann_descriptions` (
  `bw_eventid` int(11) NOT NULL,
  `bw_strid` int(11) NOT NULL,
  PRIMARY KEY  (`bw_eventid`,`bw_strid`),
  UNIQUE KEY `bw_strid` (`bw_strid`),
  KEY `bw_eann_desc_fk` (`bw_strid`),
  KEY `bw_eanndesc_eid_fk` (`bw_eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_eventann_exdates`
--

DROP TABLE IF EXISTS `bw_eventann_exdates`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_eventann_exdates` (
  `eventid` int(11) NOT NULL,
  `ex_date_type` char(1) NOT NULL,
  `ex_tzid` varchar(255) default NULL,
  `ex_dtval` varchar(16) NOT NULL,
  `ex_date` varchar(16) NOT NULL,
  PRIMARY KEY  (`eventid`,`ex_date_type`,`ex_dtval`,`ex_date`),
  KEY `bwidx_eann_exdate` (`ex_date`),
  KEY `bw_eann_edate_fk` (`eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_eventann_exrules`
--

DROP TABLE IF EXISTS `bw_eventann_exrules`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_eventann_exrules` (
  `eventid` int(11) NOT NULL,
  `exrule` varchar(255) NOT NULL,
  PRIMARY KEY  (`eventid`,`exrule`),
  KEY `bw_eann_erule_fk` (`eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_eventann_rdates`
--

DROP TABLE IF EXISTS `bw_eventann_rdates`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_eventann_rdates` (
  `eventid` int(11) NOT NULL,
  `r_date_type` char(1) NOT NULL,
  `r_tzid` varchar(255) default NULL,
  `r_dtval` varchar(16) NOT NULL,
  `r_date` varchar(16) NOT NULL,
  PRIMARY KEY  (`eventid`,`r_date_type`,`r_dtval`,`r_date`),
  KEY `bwidx_eann_rdate` (`r_date`),
  KEY `bw_eann_rdate_fk` (`eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_eventann_recipients`
--

DROP TABLE IF EXISTS `bw_eventann_recipients`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_eventann_recipients` (
  `eventid` int(11) NOT NULL,
  `recipient` varchar(255) NOT NULL,
  PRIMARY KEY  (`eventid`,`recipient`),
  KEY `bw_eann_recip_fk` (`eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_eventann_resources`
--

DROP TABLE IF EXISTS `bw_eventann_resources`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_eventann_resources` (
  `bw_eventid` int(11) NOT NULL,
  `bw_strid` int(11) NOT NULL,
  PRIMARY KEY  (`bw_eventid`,`bw_strid`),
  UNIQUE KEY `bw_strid` (`bw_strid`),
  KEY `bw_eann_res_fk` (`bw_strid`),
  KEY `bw_eannres_eid_fk` (`bw_eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_eventann_rrules`
--

DROP TABLE IF EXISTS `bw_eventann_rrules`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_eventann_rrules` (
  `eventid` int(11) NOT NULL,
  `rrule` varchar(255) default NULL,
  KEY `bw_eann_rrule_fk` (`eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_eventann_rstatus`
--

DROP TABLE IF EXISTS `bw_eventann_rstatus`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_eventann_rstatus` (
  `eventid` int(11) NOT NULL,
  `bw_rscode` varchar(100) default NULL,
  `bw_rsdescid` int(11) default NULL,
  `bw_rsdata` varchar(250) default NULL,
  UNIQUE KEY `bw_rsdescid` (`bw_rsdescid`),
  KEY `bw_eannrst_eid_fk` (`eventid`),
  KEY `bw_eann_rst_fk` (`bw_rsdescid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_eventann_summaries`
--

DROP TABLE IF EXISTS `bw_eventann_summaries`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_eventann_summaries` (
  `bw_eventid` int(11) NOT NULL,
  `bw_strid` int(11) NOT NULL,
  PRIMARY KEY  (`bw_eventid`,`bw_strid`),
  UNIQUE KEY `bw_strid` (`bw_strid`),
  KEY `bw_eann_sum_fk` (`bw_strid`),
  KEY `bw_eannsum_eid_fk` (`bw_eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_eventann_xprops`
--

DROP TABLE IF EXISTS `bw_eventann_xprops`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_eventann_xprops` (
  `bw_eventannid` int(11) NOT NULL,
  `bw_name` varchar(100) default NULL,
  `bw_pars` varchar(200) default NULL,
  `bw_value` text,
  `bwxp_position` int(11) NOT NULL,
  PRIMARY KEY  (`bw_eventannid`,`bwxp_position`),
  KEY `bw_eventannxp_eid_fk` (`bw_eventannid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_events`
--

DROP TABLE IF EXISTS `bw_events`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_events` (
  `eventid` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `bw_entity_type` int(11) default NULL,
  `creatorid` int(11) NOT NULL,
  `ownerid` int(11) NOT NULL,
  `bwaccess` text default NULL,
  `publick` char(1) NOT NULL,
  `start_date_type` char(1) default NULL,
  `start_tzid` text default NULL,
  `start_dtval` varchar(16) default NULL,
  `start_date` varchar(16) default NULL,
  `bw_start_floating` char(1) default NULL,
  `end_date_type` char(1) default NULL,
  `end_tzid` text default NULL,
  `end_dtval` varchar(16) default NULL,
  `end_date` varchar(16) default NULL,
  `bw_end_floating` char(1) default NULL,
  `duration` text default NULL,
  `end_type` char(1) NOT NULL,
  `bw_nostart` char(1) NOT NULL,
  `bw_deleted` char(1) NOT NULL,
  `bw_class` varchar(250) default NULL,
  `bw_link` text default NULL,
  `bw_geolatitude` decimal(19,2) default NULL,
  `bw_geolongitude` decimal(19,2) default NULL,
  `status` varchar(255) default NULL,
  `cost` text default NULL,
  `calendarid` int(11) NOT NULL,
  `bw_dtstamp` varchar(16) default NULL,
  `bw_lastmod` varchar(16) NOT NULL,
  `bw_created` varchar(16) NOT NULL,
  `priority` int(11) default NULL,
  `locationid` int(11) default NULL,
  `eventname` text default NULL,
  `bw_uid` text default NULL,
  `rfcsequence` int(11) default NULL,
  `transparency` varchar(100) default NULL,
  `percent_complete` int(11) default NULL,
  `completed` varchar(16) default NULL,
  `recurring` char(1) NOT NULL,
  `recurrence_id` varchar(16) default NULL,
  `latest_date` varchar(255) default NULL,
  `expanded` char(1) default NULL,
  `schedule_method` int(11) default NULL,
  `originator` text default NULL,
  `organizerid` int(11) default NULL,
  `bw_reltype` varchar(100) default NULL,
  `bw_reltoval` text default NULL,
  `schedule_state` int(11) default NULL,
  `busy_type` int(11) default NULL,
  PRIMARY KEY  (`eventid`),
  UNIQUE KEY `organizerid` (`organizerid`),
  KEY `bwidx_event_start` (`start_date`),
  KEY `bwidx_event_end_floating` (`bw_end_floating`),
  KEY `bwidx_event_latest_date` (`latest_date`),
  KEY `bwidx_event_location` (`locationid`),
  KEY `bwidx_event_calendar` (`calendarid`),
  KEY `bwidx_event_deleted` (`bw_deleted`),
  KEY `bwidx_event_recurring` (`recurring`),
  KEY `bwidx_event_end` (`end_date`),
  KEY `sidx_event_owner` (`ownerid`),
  KEY `bwidx_event_start_floating` (`bw_start_floating`),
  KEY `bwidx_event_creator` (`creatorid`),
  KEY `bwidx_event_expanded` (`expanded`),
  KEY `bw_event_loc_fk` (`locationid`),
  KEY `bw_event_users_fk1` (`creatorid`),
  KEY `bw_event_org_fk` (`organizerid`),
  KEY `bw_event_cal_fk` (`calendarid`),
  KEY `bw_event_users_fk2` (`ownerid`)
) ENGINE=ndbcluster AUTO_INCREMENT=74837 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_fbcomp`
--

DROP TABLE IF EXISTS `bw_fbcomp`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_fbcomp` (
  `bwid` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `bwtype` int(11) default NULL,
  `bwvalue` text default NULL,
  `eventid` int(11) default NULL,
  `fbcomp_position` int(11) default NULL,
  PRIMARY KEY  (`bwid`),
  KEY `bw_eventfbc_eid_fk` (`eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_filter_descriptions`
--

DROP TABLE IF EXISTS `bw_filter_descriptions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_filter_descriptions` (
  `bw_eventid` int(11) NOT NULL,
  `bw_strid` int(11) NOT NULL,
  PRIMARY KEY  (`bw_eventid`,`bw_strid`),
  UNIQUE KEY `bw_strid` (`bw_strid`),
  KEY `bw_fktr_desc_fk` (`bw_strid`),
  KEY `bw_fltrdesc_eid_fk` (`bw_eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_filter_display_names`
--

DROP TABLE IF EXISTS `bw_filter_display_names`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_filter_display_names` (
  `bw_eventid` int(11) NOT NULL,
  `bw_strid` int(11) NOT NULL,
  PRIMARY KEY  (`bw_eventid`,`bw_strid`),
  UNIQUE KEY `bw_strid` (`bw_strid`),
  KEY `bw_fltrdname_fk` (`bw_strid`),
  KEY `bw_fltrdname_eid_fk` (`bw_eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_filters`
--

DROP TABLE IF EXISTS `bw_filters`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_filters` (
  `filterid` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `ownerid` int(11) NOT NULL,
  `publick` char(1) NOT NULL,
  `filtername` varchar(200) default NULL,
  `bwdefinition` text,
  PRIMARY KEY  (`filterid`),
  KEY `bwidx_filter_owner` (`ownerid`),
  KEY `bw_flt_user_fk` (`ownerid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_group_Members`
--

DROP TABLE IF EXISTS `bw_group_Members`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_group_Members` (
  `groupid` int(11) NOT NULL,
  `memberid` int(11) NOT NULL,
  `member_is_group` char(1) NOT NULL,
  PRIMARY KEY  (`groupid`,`memberid`,`member_is_group`),
  KEY `bw_grp_grp_fk` (`groupid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_groups`
--

DROP TABLE IF EXISTS `bw_groups`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_groups` (
  `bw_group_id` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `bw_account` varchar(200) NOT NULL,
  PRIMARY KEY  (`bw_group_id`),
  UNIQUE KEY `bw_account` (`bw_account`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_hostinfo`
--

DROP TABLE IF EXISTS `bw_hostinfo`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_hostinfo` (
  `bwid` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `bwhostname` varchar(255) NOT NULL,
  `bwport` int(11) default NULL,
  `bwsecure` char(1) NOT NULL,
  `bwsvcs` varchar(255) NOT NULL,
  `bwcaldav_url` varchar(255) default NULL,
  `bwcaldav_principal` varchar(255) default NULL,
  `bwcaldav_cred` varchar(255) default NULL,
  `bwrt_url` varchar(255) default NULL,
  `bwrt_principal` varchar(255) default NULL,
  `bwrt_cred` varchar(255) default NULL,
  `bwfb_url` varchar(255) default NULL,
  PRIMARY KEY  (`bwid`),
  UNIQUE KEY `bwhostname` (`bwhostname`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_locations`
--

DROP TABLE IF EXISTS `bw_locations`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_locations` (
  `entityid` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `creatorid` int(11) NOT NULL,
  `ownerid` int(11) NOT NULL,
  `bwaccess` text default NULL,
  `publick` char(1) NOT NULL,
  `bw_uid` varchar(50) NOT NULL,
  `bw_locaddrid` int(11) NOT NULL,
  `bw_locsubaddrid` int(11) default NULL,
  `bw_link` text default NULL,
  `bw_venueid` int(11) default NULL,
  PRIMARY KEY  (`entityid`),
  UNIQUE KEY `bw_locaddrid` (`bw_locaddrid`),
  UNIQUE KEY `bw_locsubaddrid` (`bw_locsubaddrid`),
  UNIQUE KEY `bw_venueid` (`bw_venueid`),
  KEY `bwidx_loc_owner` (`ownerid`),
  KEY `bwidx_loc_creator` (`creatorid`),
  KEY `bw_loc_user_fk1` (`creatorid`),
  KEY `bw_loc_venue_fk` (`bw_venueid`),
  KEY `bw_loc_sadd_fk` (`bw_locsubaddrid`),
  KEY `bw_loc_addr_fk` (`bw_locaddrid`),
  KEY `bw_loc_user_fk2` (`ownerid`)
) ENGINE=ndbcluster AUTO_INCREMENT=1135 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_longstrings`
--

DROP TABLE IF EXISTS `bw_longstrings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_longstrings` (
  `bw_id` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `bw_lang` varchar(100) default NULL,
  `bw_value` text,
  PRIMARY KEY  (`bw_id`)
) ENGINE=ndbcluster AUTO_INCREMENT=64335 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_organizers`
--

DROP TABLE IF EXISTS `bw_organizers`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_organizers` (
  `alarmid` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `cn` text default NULL,
  `dir` text default NULL,
  `language` varchar(100) default NULL,
  `sent_by` text default NULL,
  `organizer_uri` text default NULL,
  `bw_dtstamp` varchar(16) default NULL,
  PRIMARY KEY  (`alarmid`)
) ENGINE=ndbcluster AUTO_INCREMENT=60303 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_preferences`
--

DROP TABLE IF EXISTS `bw_preferences`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_preferences` (
  `prefid` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `ownerid` int(11) NOT NULL,
  `email` varchar(255) default NULL,
  `bw_default_calendar` text default NULL,
  `skin_name` varchar(255) default NULL,
  `skin_style` varchar(255) default NULL,
  `preferred_view` varchar(255) default NULL,
  `preferred_view_period` varchar(255) default NULL,
  `bw_page_size` int(11) default NULL,
  `workdays` varchar(255) default NULL,
  `workday_start` int(11) default NULL,
  `workday_end` int(11) default NULL,
  `preferred_endtype` varchar(255) default NULL,
  `bwuser_mode` int(11) default NULL,
  `bw_hour24` char(1) NOT NULL,
  `bw_sched_autoresp` char(1) NOT NULL default 'T',
  `bw_sched_autocancelaction` int(11) default NULL,
  `bw_sched_double_book` char(1) NOT NULL default 'T',
  `bw_sched_autoproc_resp` int(11) default '2',
  PRIMARY KEY  (`prefid`),
  UNIQUE KEY `ownerid` (`ownerid`),
  KEY `bw_prf_user_fk` (`ownerid`)
) ENGINE=ndbcluster AUTO_INCREMENT=589 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_recurrences`
--

DROP TABLE IF EXISTS `bw_recurrences`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_recurrences` (
  `recurrence_id` varchar(16) NOT NULL,
  `masterid` int(11) NOT NULL,
  `bwseq` int(11) NOT NULL,
  `start_date_type` char(1) NOT NULL,
  `start_tzid` varchar(255) default NULL,
  `start_dtval` varchar(16) NOT NULL,
  `start_date` varchar(16) NOT NULL,
  `bw_rstart_floating` char(1) default NULL,
  `end_date_type` char(1) default NULL,
  `end_tzid` varchar(255) default NULL,
  `end_dtval` varchar(255) default NULL,
  `end_date` varchar(255) default NULL,
  `bw_rend_floating` char(1) default NULL,
  `overrideid` int(11) default NULL,
  PRIMARY KEY  (`recurrence_id`,`masterid`),
  KEY `bwidx_rstart_floating` (`bw_rstart_floating`),
  KEY `bwidx_rend_floating` (`bw_rend_floating`),
  KEY `bwidx_recur_start` (`start_date`),
  KEY `bwidx_recur_end` (`end_date`),
  KEY `bw_ri_ov_fk` (`overrideid`),
  KEY `bw_ri_mstr_fk` (`masterid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_rstatus`
--

DROP TABLE IF EXISTS `bw_rstatus`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_rstatus` (
  `eventid` int(11) NOT NULL,
  `bw_rscode` varchar(100) default NULL,
  `bw_rsdescid` int(11) default NULL,
  `bw_rsdata` varchar(250) default NULL,
  UNIQUE KEY `bw_rsdescid` (`bw_rsdescid`),
  KEY `bw_eventrst_eid_fk` (`eventid`),
  KEY `bw_event_rst_fk` (`bw_rsdescid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_settings`
--

DROP TABLE IF EXISTS `bw_settings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_settings` (
  `id` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `bwname` varchar(200) default NULL,
  `tzid` varchar(255) default NULL,
  `systemid` varchar(255) default NULL,
  `publicCalendarRoot` varchar(100) default NULL,
  `userCalendarRoot` varchar(100) default NULL,
  `userDefaultCalendar` varchar(100) default NULL,
  `defaultTrashCalendar` varchar(100) default NULL,
  `userInbox` varchar(100) default NULL,
  `userOutbox` varchar(100) default NULL,
  `deletedCalendar` varchar(100) default NULL,
  `busyCalendar` varchar(100) default NULL,
  `defaultUserViewName` varchar(100) default NULL,
  `default_user_hour24` char(1) default NULL,
  `public_user` varchar(100) default NULL,
  `http_connections_per_user` int(11) default NULL,
  `http_connections_per_host` int(11) default NULL,
  `http_connections` int(11) default NULL,
  `maxPublicDescriptionLength` int(11) default NULL,
  `maxUserDescriptionLength` int(11) default NULL,
  `maxUserEntitySize` int(11) default NULL,
  `defaultUserQuota` bigint(20) default NULL,
  `bwmax_instances` int(11) default NULL,
  `bwmax_years` int(11) default NULL,
  `userauth_class` varchar(200) default NULL,
  `mailer_class` varchar(200) default NULL,
  `admingroups_class` varchar(200) default NULL,
  `usergroups_class` varchar(200) default NULL,
  `directory_browsing_disallowed` char(1) default NULL,
  `bwindex_root` text default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=ndbcluster AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_strings`
--

DROP TABLE IF EXISTS `bw_strings`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_strings` (
  `bw_id` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `bw_lang` varchar(100) default NULL,
  `bw_value` text default NULL,
  PRIMARY KEY  (`bw_id`)
) ENGINE=ndbcluster AUTO_INCREMENT=75993 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_subscriptions`
--

DROP TABLE IF EXISTS `bw_subscriptions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_subscriptions` (
  `subscriptionid` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `subscrname` varchar(100) NOT NULL,
  `ownerid` int(11) NOT NULL,
  `bw_uri` text NOT NULL,
  `affects_free_busy` char(1) NOT NULL,
  `ignore_transparency` char(1) NOT NULL,
  `display` char(1) NOT NULL,
  `bwsubstyle` varchar(100) default NULL,
  `internal_Subscription` char(1) NOT NULL,
  `email_notifications` char(1) NOT NULL,
  `calendar_deleted` char(1) NOT NULL,
  `unremoveable` char(1) NOT NULL,
  PRIMARY KEY  (`subscriptionid`),
  KEY `bwidx_sub_owner` (`ownerid`),
  KEY `bw_sub_user_fk` (`ownerid`)
) ENGINE=ndbcluster AUTO_INCREMENT=619 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_synchdata`
--

DROP TABLE IF EXISTS `bw_synchdata`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_synchdata` (
  `userid` int(11) NOT NULL,
  `eventid` int(11) NOT NULL,
  `bwseq` int(11) NOT NULL,
  `eventData` text,
  PRIMARY KEY  (`userid`,`eventid`),
  KEY `bw_syd_user_fk` (`userid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_synchinfo`
--

DROP TABLE IF EXISTS `bw_synchinfo`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_synchinfo` (
  `userid` int(11) NOT NULL,
  `deviceid` varchar(255) NOT NULL,
  `bwseq` int(11) NOT NULL,
  `calendarid` int(11) default NULL,
  `lastsynch` varchar(255) default NULL,
  PRIMARY KEY  (`userid`,`deviceid`),
  KEY `bw_syi_user_fk` (`userid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_synchstate`
--

DROP TABLE IF EXISTS `bw_synchstate`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_synchstate` (
  `userid` int(11) NOT NULL,
  `deviceid` varchar(255) NOT NULL,
  `eventid` int(11) NOT NULL,
  `bwseq` int(11) NOT NULL,
  `guid` varchar(255) default NULL,
  `state` int(11) default NULL,
  PRIMARY KEY  (`userid`,`deviceid`,`eventid`),
  KEY `bw_sys_event_fk` (`eventid`),
  KEY `bw_sys_user_fk` (`userid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_timezones`
--

DROP TABLE IF EXISTS `bw_timezones`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_timezones` (
  `id` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `tzid` varchar(255) NOT NULL,
  `ownerid` int(11) NOT NULL,
  `publick` char(1) NOT NULL,
  `vtimezone` text,
  `jtzid` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `tzid` (`tzid`,`ownerid`),
  KEY `bwidx_tz_tzid` (`tzid`),
  KEY `bwidx_tz_owner` (`ownerid`),
  KEY `bw_tz_user_fk` (`ownerid`)
) ENGINE=ndbcluster AUTO_INCREMENT=594 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_user_properties`
--

DROP TABLE IF EXISTS `bw_user_properties`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_user_properties` (
  `bwid` int(11) NOT NULL,
  `bw_name` varchar(200) default NULL,
  `bw_value` text,
  KEY `bw_prprp_pid_fk` (`bwid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_user_subscriptions`
--

DROP TABLE IF EXISTS `bw_user_subscriptions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_user_subscriptions` (
  `prefid` int(11) NOT NULL,
  `elt` int(11) NOT NULL,
  PRIMARY KEY  (`prefid`,`elt`),
  KEY `bw_pr_sub_fk` (`elt`),
  KEY `bw_prsub_pid_fk` (`prefid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_user_views`
--

DROP TABLE IF EXISTS `bw_user_views`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_user_views` (
  `prefid` int(11) NOT NULL,
  `elt` int(11) NOT NULL,
  PRIMARY KEY  (`prefid`,`elt`),
  KEY `bw_pr_view_fk` (`elt`),
  KEY `bw_prview_pid_fk` (`prefid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_userinfo`
--

DROP TABLE IF EXISTS `bw_userinfo`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_userinfo` (
  `userid` int(11) NOT NULL,
  `bwseq` int(11) NOT NULL,
  `lastname` varchar(255) default NULL,
  `firstname` varchar(255) default NULL,
  `phone` varchar(255) default NULL,
  `email` varchar(255) default NULL,
  `department` varchar(255) default NULL,
  PRIMARY KEY  (`userid`),
  KEY `bw_ui_user_fk` (`userid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_userinfo_properties`
--

DROP TABLE IF EXISTS `bw_userinfo_properties`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_userinfo_properties` (
  `user_info` int(11) NOT NULL,
  `propname` varchar(255) NOT NULL,
  `val` varchar(255) default NULL,
  PRIMARY KEY  (`user_info`,`propname`),
  KEY `bw_ui_pid_fk` (`user_info`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_users`
--

DROP TABLE IF EXISTS `bw_users`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_users` (
  `userid` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `bw_account` varchar(200) NOT NULL,
  `instance_owner` char(1) NOT NULL,
  `bw_created` datetime default NULL,
  `bw_last_logon` datetime default NULL,
  `bw_last_access` datetime default NULL,
  `bw_last_modify` datetime default NULL,
  `bw_category_access` text default NULL,
  `bw_contact_access` text default NULL,
  `bw_location_access` text default NULL,
  `bw_quota` bigint(20) default NULL,
  PRIMARY KEY  (`userid`),
  UNIQUE KEY `bw_account` (`bw_account`),
  KEY `bwidx_user_instance_owner` (`instance_owner`)
) ENGINE=ndbcluster AUTO_INCREMENT=571 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_venue_categories`
--

DROP TABLE IF EXISTS `bw_venue_categories`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_venue_categories` (
  `entityid` int(11) NOT NULL,
  `categoryid` int(11) NOT NULL,
  PRIMARY KEY  (`entityid`,`categoryid`),
  KEY `bw_venuecat_eid_fk` (`entityid`),
  KEY `bw_venue_cat_fk` (`categoryid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_venue_descriptions`
--

DROP TABLE IF EXISTS `bw_venue_descriptions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_venue_descriptions` (
  `bw_venueid` int(11) NOT NULL,
  `bw_strid` int(11) NOT NULL,
  PRIMARY KEY  (`bw_venueid`,`bw_strid`),
  UNIQUE KEY `bw_strid` (`bw_strid`),
  KEY `bw_venuedesc_eid_fk` (`bw_venueid`),
  KEY `bw_venue_desc_fk` (`bw_strid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_venue_loctypes`
--

DROP TABLE IF EXISTS `bw_venue_loctypes`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_venue_loctypes` (
  `eventid` int(11) NOT NULL,
  `loctype` varchar(255) NOT NULL,
  PRIMARY KEY  (`eventid`,`loctype`),
  KEY `bw_venue_loctype_fk` (`eventid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_venue_urls`
--

DROP TABLE IF EXISTS `bw_venue_urls`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_venue_urls` (
  `bw_url_id` int(11) NOT NULL,
  `bw_urltype` varchar(100) NOT NULL,
  `bw_urlval` varchar(200) NOT NULL,
  PRIMARY KEY  (`bw_url_id`,`bw_urltype`,`bw_urlval`),
  KEY `FKBD3A16DEBA56D6BA` (`bw_url_id`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_venues`
--

DROP TABLE IF EXISTS `bw_venues`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_venues` (
  `entityid` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `creatorid` int(11) NOT NULL,
  `ownerid` int(11) NOT NULL,
  `bwaccess` text default NULL,
  `publick` char(1) NOT NULL,
  `bwcountry` text default NULL,
  `bwextaddrs` text default NULL,
  `bw_geolatitude` decimal(19,2) default NULL,
  `bw_geolongitude` decimal(19,2) default NULL,
  `bwlocality` text default NULL,
  `bwname` text default NULL,
  `bwpostalcode` text default NULL,
  `bwregion` text default NULL,
  `bw_reltype` varchar(100) default NULL,
  `bw_reltoval` text default NULL,
  `bwstreetAddress` text default NULL,
  `bwtel` varchar(50) default NULL,
  `bwtzidy` text default NULL,
  `bw_uid` varchar(50) NOT NULL,
  PRIMARY KEY  (`entityid`),
  KEY `bwidx_venue_owner` (`ownerid`),
  KEY `bwidx_venue_creator` (`creatorid`),
  KEY `bw_venue_user_fk1` (`creatorid`),
  KEY `bw_venue_user_fk2` (`ownerid`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_view_subscriptions`
--

DROP TABLE IF EXISTS `bw_view_subscriptions`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_view_subscriptions` (
  `viewid` int(11) NOT NULL,
  `elt` int(11) NOT NULL,
  PRIMARY KEY  (`viewid`,`elt`),
  KEY `bw_tzsub_vid_fk` (`viewid`),
  KEY `bw_tz_sub_fk` (`elt`)
) ENGINE=ndbcluster DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `bw_views`
--

DROP TABLE IF EXISTS `bw_views`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `bw_views` (
  `viewid` int(11) NOT NULL auto_increment,
  `bwseq` int(11) NOT NULL,
  `viewname` varchar(100) NOT NULL,
  `ownerid` int(11) NOT NULL,
  PRIMARY KEY  (`viewid`),
  KEY `bwidx_view_owner` (`ownerid`),
  KEY `bw_view_user_fk` (`ownerid`)
) ENGINE=ndbcluster AUTO_INCREMENT=605 DEFAULT CHARSET=utf8;
SET character_set_client = @saved_cs_client;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-05-11 14:51:28

/* Data with various timezones in Outlook format */
/* Analizzo: AUS Central Standard Time che sara' Australia/Darwin (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'AUS Central Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Australia/Darwin\r\nX-LIC-LOCATION:Australia/Darwin\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+084320\r\nTZOFFSETTO:+0900\r\nTZNAME:CST\r\nDTSTART:18950201T000000\r\nRDATE:18950201T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0900\r\nTZOFFSETTO:+0930\r\nTZNAME:CST\r\nDTSTART:18990501T000000\r\nRDATE:18990501T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0930\r\nTZOFFSETTO:+1030\r\nTZNAME:CST\r\nDTSTART:19170101T000100\r\nRDATE:19170101T000100\r\nRDATE:19420101T020000\r\nRDATE:19420927T020000\r\nRDATE:19431003T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1030\r\nTZOFFSETTO:+0930\r\nTZNAME:CST\r\nDTSTART:19170325T020000\r\nRDATE:19170325T020000\r\nRDATE:19420329T020000\r\nRDATE:19430328T020000\r\nRDATE:19440326T020000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: AUS Eastern Standard Time che sara' Australia/Sydney (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'AUS Eastern Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Australia/Sydney\r\nX-LIC-LOCATION:Australia/Sydney\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+1000\r\nTZOFFSETTO:+1100\r\nTZNAME:EST\r\nDTSTART:20011028T020000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1000\r\nTZOFFSETTO:+1000\r\nTZNAME:EST\r\nDTSTART:20070325T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+100452\r\nTZOFFSETTO:+1000\r\nTZNAME:EST\r\nDTSTART:18950201T000000\r\nRDATE:18950201T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+1000\r\nTZOFFSETTO:+1100\r\nTZNAME:EST\r\nDTSTART:19170101T000100\r\nRDATE:19170101T000100\r\nRDATE:19420101T020000\r\nRDATE:19420927T020000\r\nRDATE:19431003T020000\r\nRDATE:19711031T020000\r\nRDATE:19721029T020000\r\nRDATE:19731028T020000\r\nRDATE:19741027T020000\r\nRDATE:19751026T020000\r\nRDATE:19761031T020000\r\nRDATE:19771030T020000\r\nRDATE:19781029T020000\r\nRDATE:19791028T020000\r\nRDATE:19801026T020000\r\nRDATE:19811025T020000\r\nRDATE:19821031T020000\r\nRDATE:19831030T020000\r\nRDATE:19841028T020000\r\nRDATE:19851027T020000\r\nRDATE:19861019T020000\r\nRDATE:19871025T020000\r\nRDATE:19881030T020000\r\nRDATE:19891029T020000\r\nRDATE:19901028T020000\r\nRDATE:19911027T020000\r\nRDATE:19921025T020000\r\nRDATE:19931031T020000\r\nRDATE:19941030T020000\r\nRDATE:19951029T020000\r\nRDATE:19961027T020000\r\nRDATE:19971026T020000\r\nRDATE:19981025T020000\r\nRDATE:19991031T020000\r\nRDATE:20000827T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1100\r\nTZOFFSETTO:+1000\r\nTZNAME:EST\r\nDTSTART:19170325T020000\r\nRDATE:19170325T020000\r\nRDATE:19420329T020000\r\nRDATE:19430328T020000\r\nRDATE:19440326T020000\r\nRDATE:19720227T030000\r\nRDATE:19730304T030000\r\nRDATE:19740303T030000\r\nRDATE:19750302T030000\r\nRDATE:19760307T030000\r\nRDATE:19770306T030000\r\nRDATE:19780305T030000\r\nRDATE:19790304T030000\r\nRDATE:19800302T030000\r\nRDATE:19810301T030000\r\nRDATE:19820404T030000\r\nRDATE:19830306T030000\r\nRDATE:19840304T030000\r\nRDATE:19850303T030000\r\nRDATE:19860316T030000\r\nRDATE:19870315T030000\r\nRDATE:19880320T030000\r\nRDATE:19890319T030000\r\nRDATE:19900304T030000\r\nRDATE:19910303T030000\r\nRDATE:19920301T030000\r\nRDATE:19930307T030000\r\nRDATE:19940306T030000\r\nRDATE:19950305T030000\r\nRDATE:19960331T030000\r\nRDATE:19970330T030000\r\nRDATE:19980329T030000\r\nRDATE:19990328T030000\r\nRDATE:20000326T030000\r\nRDATE:20010325T030000\r\nRDATE:20020331T030000\r\nRDATE:20030330T030000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1000\r\nTZOFFSETTO:+1000\r\nTZNAME:EST\r\nDTSTART:19710101T000000\r\nRDATE:19710101T000000\r\nRDATE:20040328T030000\r\nRDATE:20050327T030000\r\nRDATE:20060402T030000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Afghanistan Standard Time che sara' Asia/Kabul (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Afghanistan Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Kabul\r\nX-LIC-LOCATION:Asia/Kabul\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+043648\r\nTZOFFSETTO:+0400\r\nTZNAME:AFT\r\nDTSTART:18900101T000000\r\nRDATE:18900101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0430\r\nTZNAME:AFT\r\nDTSTART:19450101T000000\r\nRDATE:19450101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Alaskan Standard Time che sara' America/Anchorage (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Alaskan Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/Anchorage\r\nX-LIC-LOCATION:America/Anchorage\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0900\r\nTZOFFSETTO:-0800\r\nTZNAME:AKDT\r\nDTSTART:20070311T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=2SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0800\r\nTZOFFSETTO:-0900\r\nTZNAME:AKST\r\nDTSTART:20071104T020000\r\nRRULE:FREQ=YEARLY;BYMONTH=11;BYDAY=1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+140024\r\nTZOFFSETTO:-095936\r\nTZNAME:LMT\r\nDTSTART:18671018T000000\r\nRDATE:18671018T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-095936\r\nTZOFFSETTO:-1000\r\nTZNAME:CAT\r\nDTSTART:19000820T120000\r\nRDATE:19000820T120000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-1000\r\nTZOFFSETTO:-1000\r\nTZNAME:CAT\r\nDTSTART:19420101T000000\r\nRDATE:19420101T000000\r\nRDATE:19460101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-1000\r\nTZOFFSETTO:-0900\r\nTZNAME:CAWT\r\nDTSTART:19420209T030000\r\nRDATE:19420209T030000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0900\r\nTZOFFSETTO:-0900\r\nTZNAME:CAPT\r\nDTSTART:19450814T140000\r\nRDATE:19450814T140000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0900\r\nTZOFFSETTO:-1000\r\nTZNAME:CAT\r\nDTSTART:19450930T020000\r\nRDATE:19450930T020000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-1000\r\nTZOFFSETTO:-1000\r\nTZNAME:AHST\r\nDTSTART:19670401T000000\r\nRDATE:19670401T000000\r\nRDATE:19690101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-1000\r\nTZOFFSETTO:-0900\r\nTZNAME:AHDT\r\nDTSTART:19690427T030000\r\nRDATE:19690427T030000\r\nRDATE:19700426T030000\r\nRDATE:19710425T030000\r\nRDATE:19720430T030000\r\nRDATE:19730429T030000\r\nRDATE:19740106T030000\r\nRDATE:19750223T030000\r\nRDATE:19760425T030000\r\nRDATE:19770424T030000\r\nRDATE:19780430T030000\r\nRDATE:19790429T030000\r\nRDATE:19800427T030000\r\nRDATE:19810426T030000\r\nRDATE:19820425T030000\r\nRDATE:19830424T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0900\r\nTZOFFSETTO:-1000\r\nTZNAME:AHST\r\nDTSTART:19691026T020000\r\nRDATE:19691026T020000\r\nRDATE:19701025T020000\r\nRDATE:19711031T020000\r\nRDATE:19721029T020000\r\nRDATE:19731028T020000\r\nRDATE:19741027T020000\r\nRDATE:19751026T020000\r\nRDATE:19761031T020000\r\nRDATE:19771030T020000\r\nRDATE:19781029T020000\r\nRDATE:19791028T020000\r\nRDATE:19801026T020000\r\nRDATE:19811025T020000\r\nRDATE:19821031T020000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0900\r\nTZOFFSETTO:-0900\r\nTZNAME:YST\r\nDTSTART:19831030T020000\r\nRDATE:19831030T020000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0900\r\nTZOFFSETTO:-0900\r\nTZNAME:AKST\r\nDTSTART:19831130T000000\r\nRDATE:19831130T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0900\r\nTZOFFSETTO:-0800\r\nTZNAME:AKDT\r\nDTSTART:19840429T030000\r\nRDATE:19840429T030000\r\nRDATE:19850428T030000\r\nRDATE:19860427T030000\r\nRDATE:19870405T030000\r\nRDATE:19880403T030000\r\nRDATE:19890402T030000\r\nRDATE:19900401T030000\r\nRDATE:19910407T030000\r\nRDATE:19920405T030000\r\nRDATE:19930404T030000\r\nRDATE:19940403T030000\r\nRDATE:19950402T030000\r\nRDATE:19960407T030000\r\nRDATE:19970406T030000\r\nRDATE:19980405T030000\r\nRDATE:19990404T030000\r\nRDATE:20000402T030000\r\nRDATE:20010401T030000\r\nRDATE:20020407T030000\r\nRDATE:20030406T030000\r\nRDATE:20040404T030000\r\nRDATE:20050403T030000\r\nRDATE:20060402T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0800\r\nTZOFFSETTO:-0900\r\nTZNAME:AKST\r\nDTSTART:19841028T020000\r\nRDATE:19841028T020000\r\nRDATE:19851027T020000\r\nRDATE:19861026T020000\r\nRDATE:19871025T020000\r\nRDATE:19881030T020000\r\nRDATE:19891029T020000\r\nRDATE:19901028T020000\r\nRDATE:19911027T020000\r\nRDATE:19921025T020000\r\nRDATE:19931031T020000\r\nRDATE:19941030T020000\r\nRDATE:19951029T020000\r\nRDATE:19961027T020000\r\nRDATE:19971026T020000\r\nRDATE:19981025T020000\r\nRDATE:19991031T020000\r\nRDATE:20001029T020000\r\nRDATE:20011028T020000\r\nRDATE:20021027T020000\r\nRDATE:20031026T020000\r\nRDATE:20041031T020000\r\nRDATE:20051030T020000\r\nRDATE:20061029T020000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Arab Standard Time che sara' Asia/Riyadh (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Arab Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Riyadh\r\nX-LIC-LOCATION:Asia/Riyadh\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+030652\r\nTZOFFSETTO:+0300\r\nTZNAME:AST\r\nDTSTART:19500101T000000\r\nRDATE:19500101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Arabian Standard Time che sara' Asia/Dubai (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Arabian Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Dubai\r\nX-LIC-LOCATION:Asia/Dubai\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+034112\r\nTZOFFSETTO:+0400\r\nTZNAME:GST\r\nDTSTART:19200101T000000\r\nRDATE:19200101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Arabic Standard Time che sara' Asia/Baghdad (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Arabic Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Baghdad\r\nX-LIC-LOCATION:Asia/Baghdad\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0400\r\nTZNAME:ADT\r\nDTSTART:19910401T030000\r\nRRULE:FREQ=YEARLY\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0300\r\nTZNAME:AST\r\nDTSTART:19911001T040000\r\nRRULE:FREQ=YEARLY\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+025740\r\nTZOFFSETTO:+025736\r\nTZNAME:BMT\r\nDTSTART:18900101T000000\r\nRDATE:18900101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+025736\r\nTZOFFSETTO:+0300\r\nTZNAME:AST\r\nDTSTART:19180101T000000\r\nRDATE:19180101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0400\r\nTZNAME:ADT\r\nDTSTART:19820501T000000\r\nRDATE:19820501T000000\r\nRDATE:19830331T000000\r\nRDATE:19840401T000000\r\nRDATE:19850401T000000\r\nRDATE:19860330T010000\r\nRDATE:19870329T010000\r\nRDATE:19880327T010000\r\nRDATE:19890326T010000\r\nRDATE:19900325T010000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0300\r\nTZNAME:AST\r\nDTSTART:19821001T000000\r\nRDATE:19821001T000000\r\nRDATE:19831001T000000\r\nRDATE:19841001T000000\r\nRDATE:19850929T020000\r\nRDATE:19860928T020000\r\nRDATE:19870927T020000\r\nRDATE:19880925T020000\r\nRDATE:19890924T020000\r\nRDATE:19900930T020000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Argentina Standard Time che sara' America/Buenos_Aires (0) NON TROVATO OK */
INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Argentina Standard Time',1,'T',NULL,NULL);

/* Analizzo: Armenian Standard Time che sara' Asia/Yerevan (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Armenian Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Yerevan\r\nX-LIC-LOCATION:Asia/Yerevan\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0500\r\nTZNAME:AMST\r\nDTSTART:19970330T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0500\r\nTZOFFSETTO:+0400\r\nTZNAME:AMT\r\nDTSTART:19971026T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0258\r\nTZOFFSETTO:+0300\r\nTZNAME:YERT\r\nDTSTART:19240502T000000\r\nRDATE:19240502T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0400\r\nTZNAME:YERT\r\nDTSTART:19570301T000000\r\nRDATE:19570301T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0500\r\nTZNAME:YERST\r\nDTSTART:19810401T000000\r\nRDATE:19810401T000000\r\nRDATE:19820401T000000\r\nRDATE:19830401T000000\r\nRDATE:19840401T000000\r\nRDATE:19850331T030000\r\nRDATE:19860330T030000\r\nRDATE:19870329T030000\r\nRDATE:19880327T030000\r\nRDATE:19890326T030000\r\nRDATE:19900325T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0500\r\nTZOFFSETTO:+0400\r\nTZNAME:YERT\r\nDTSTART:19811001T000000\r\nRDATE:19811001T000000\r\nRDATE:19821001T000000\r\nRDATE:19831001T000000\r\nRDATE:19840930T030000\r\nRDATE:19850929T030000\r\nRDATE:19860928T030000\r\nRDATE:19870927T030000\r\nRDATE:19880925T030000\r\nRDATE:19890924T030000\r\nRDATE:19900930T030000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0400\r\nTZNAME:YERST\r\nDTSTART:19910331T030000\r\nRDATE:19910331T030000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0400\r\nTZNAME:AMST\r\nDTSTART:19910923T000000\r\nRDATE:19910923T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0300\r\nTZNAME:AMT\r\nDTSTART:19910929T030000\r\nRDATE:19910929T030000\r\nRDATE:19920926T230000\r\nRDATE:19930926T030000\r\nRDATE:19940925T030000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0400\r\nTZNAME:AMST\r\nDTSTART:19920328T230000\r\nRDATE:19920328T230000\r\nRDATE:19930328T030000\r\nRDATE:19940327T030000\r\nRDATE:19950326T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0400\r\nTZNAME:AMT\r\nDTSTART:19950924T030000\r\nRDATE:19950924T030000\r\nRDATE:19970101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Atlantic Standard Time che sara' America/Halifax (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Atlantic Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/Halifax\r\nX-LIC-LOCATION:America/Halifax\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0400\r\nTZOFFSETTO:-0300\r\nTZNAME:ADT\r\nDTSTART:20070311T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=2SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0300\r\nTZOFFSETTO:-0400\r\nTZNAME:AST\r\nDTSTART:20071104T020000\r\nRRULE:FREQ=YEARLY;BYMONTH=11;BYDAY=1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-041424\r\nTZOFFSETTO:-0400\r\nTZNAME:AST\r\nDTSTART:19020615T000000\r\nRDATE:19020615T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0400\r\nTZOFFSETTO:-0300\r\nTZNAME:ADT\r\nDTSTART:19160401T000000\r\nRDATE:19160401T000000\r\nRDATE:19180414T020000\r\nRDATE:19200509T000000\r\nRDATE:19210506T000000\r\nRDATE:19220430T000000\r\nRDATE:19230506T000000\r\nRDATE:19240504T000000\r\nRDATE:19250503T000000\r\nRDATE:19260516T000000\r\nRDATE:19270501T000000\r\nRDATE:19280513T000000\r\nRDATE:19290512T000000\r\nRDATE:19300511T000000\r\nRDATE:19310510T000000\r\nRDATE:19320501T000000\r\nRDATE:19330430T000000\r\nRDATE:19340520T000000\r\nRDATE:19350602T000000\r\nRDATE:19360601T000000\r\nRDATE:19370502T000000\r\nRDATE:19380501T000000\r\nRDATE:19390528T000000\r\nRDATE:19400505T000000\r\nRDATE:19410504T000000\r\nRDATE:19460428T030000\r\nRDATE:19470427T030000\r\nRDATE:19480425T030000\r\nRDATE:19490424T030000\r\nRDATE:19510429T030000\r\nRDATE:19520427T030000\r\nRDATE:19530426T030000\r\nRDATE:19540425T030000\r\nRDATE:19560429T030000\r\nRDATE:19570428T030000\r\nRDATE:19580427T030000\r\nRDATE:19590426T030000\r\nRDATE:19620429T030000\r\nRDATE:19630428T030000\r\nRDATE:19640426T030000\r\nRDATE:19650425T030000\r\nRDATE:19660424T030000\r\nRDATE:19670430T030000\r\nRDATE:19680428T030000\r\nRDATE:19690427T030000\r\nRDATE:19700426T030000\r\nRDATE:19710425T030000\r\nRDATE:19720430T030000\r\nRDATE:19730429T030000\r\nRDATE:19740428T020000\r\nRDATE:19750427T020000\r\nRDATE:19760425T030000\r\nRDATE:19770424T030000\r\nRDATE:19780430T030000\r\nRDATE:19790429T030000\r\nRDATE:19800427T030000\r\nRDATE:19810426T030000\r\nRDATE:19820425T030000\r\nRDATE:19830424T030000\r\nRDATE:19840429T030000\r\nRDATE:19850428T030000\r\nRDATE:19860427T030000\r\nRDATE:19870405T030000\r\nRDATE:19880403T030000\r\nRDATE:19890402T030000\r\nRDATE:19900401T030000\r\nRDATE:19910407T030000\r\nRDATE:19920405T030000\r\nRDATE:19930404T030000\r\nRDATE:19940403T030000\r\nRDATE:19950402T030000\r\nRDATE:19960407T030000\r\nRDATE:19970406T030000\r\nRDATE:19980405T030000\r\nRDATE:19990404T030000\r\nRDATE:20000402T030000\r\nRDATE:20010401T030000\r\nRDATE:20020407T030000\r\nRDATE:20030406T030000\r\nRDATE:20040404T030000\r\nRDATE:20050403T030000\r\nRDATE:20060402T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0300\r\nTZOFFSETTO:-0400\r\nTZNAME:AST\r\nDTSTART:19161001T000000\r\nRDATE:19161001T000000\r\nRDATE:19181031T020000\r\nRDATE:19200829T000000\r\nRDATE:19210905T000000\r\nRDATE:19220905T000000\r\nRDATE:19230904T000000\r\nRDATE:19240915T000000\r\nRDATE:19250928T000000\r\nRDATE:19260913T000000\r\nRDATE:19270926T000000\r\nRDATE:19280909T000000\r\nRDATE:19290903T000000\r\nRDATE:19300915T000000\r\nRDATE:19310928T000000\r\nRDATE:19320926T000000\r\nRDATE:19331002T000000\r\nRDATE:19340916T000000\r\nRDATE:19350930T000000\r\nRDATE:19360914T000000\r\nRDATE:19370927T000000\r\nRDATE:19380926T000000\r\nRDATE:19390925T000000\r\nRDATE:19400930T000000\r\nRDATE:19410929T000000\r\nRDATE:19450930T020000\r\nRDATE:19460929T020000\r\nRDATE:19470928T020000\r\nRDATE:19480926T020000\r\nRDATE:19490925T020000\r\nRDATE:19510930T020000\r\nRDATE:19520928T020000\r\nRDATE:19530927T020000\r\nRDATE:19540926T020000\r\nRDATE:19560930T020000\r\nRDATE:19570929T020000\r\nRDATE:19580928T020000\r\nRDATE:19590927T020000\r\nRDATE:19621028T020000\r\nRDATE:19631027T020000\r\nRDATE:19641025T020000\r\nRDATE:19651031T020000\r\nRDATE:19661030T020000\r\nRDATE:19671029T020000\r\nRDATE:19681027T020000\r\nRDATE:19691026T020000\r\nRDATE:19701025T020000\r\nRDATE:19711031T020000\r\nRDATE:19721029T020000\r\nRDATE:19731028T020000\r\nRDATE:19741027T020000\r\nRDATE:19751026T020000\r\nRDATE:19761031T020000\r\nRDATE:19771030T020000\r\nRDATE:19781029T020000\r\nRDATE:19791028T020000\r\nRDATE:19801026T020000\r\nRDATE:19811025T020000\r\nRDATE:19821031T020000\r\nRDATE:19831030T020000\r\nRDATE:19841028T020000\r\nRDATE:19851027T020000\r\nRDATE:19861026T020000\r\nRDATE:19871025T020000\r\nRDATE:19881030T020000\r\nRDATE:19891029T020000\r\nRDATE:19901028T020000\r\nRDATE:19911027T020000\r\nRDATE:19921025T020000\r\nRDATE:19931031T020000\r\nRDATE:19941030T020000\r\nRDATE:19951029T020000\r\nRDATE:19961027T020000\r\nRDATE:19971026T020000\r\nRDATE:19981025T020000\r\nRDATE:19991031T020000\r\nRDATE:20001029T020000\r\nRDATE:20011028T020000\r\nRDATE:20021027T020000\r\nRDATE:20031026T020000\r\nRDATE:20041031T020000\r\nRDATE:20051030T020000\r\nRDATE:20061029T020000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0400\r\nTZOFFSETTO:-0400\r\nTZNAME:AST\r\nDTSTART:19180101T000000\r\nRDATE:19180101T000000\r\nRDATE:19190101T000000\r\nRDATE:19460101T000000\r\nRDATE:19740101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0400\r\nTZOFFSETTO:-0300\r\nTZNAME:AWT\r\nDTSTART:19420209T030000\r\nRDATE:19420209T030000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0300\r\nTZOFFSETTO:-0300\r\nTZNAME:APT\r\nDTSTART:19450814T200000\r\nRDATE:19450814T200000\r\nEND:DAYLIGHT\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Azerbaijan Standard Time che sara' Asia/Baku (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Azerbaijan Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Baku\r\nX-LIC-LOCATION:Asia/Baku\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0500\r\nTZNAME:AZST\r\nDTSTART:19970330T040000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0500\r\nTZOFFSETTO:+0400\r\nTZNAME:AZT\r\nDTSTART:19971026T050000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+031924\r\nTZOFFSETTO:+0300\r\nTZNAME:BAKT\r\nDTSTART:19240502T000000\r\nRDATE:19240502T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0400\r\nTZNAME:BAKT\r\nDTSTART:19570301T000000\r\nRDATE:19570301T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0500\r\nTZNAME:BAKST\r\nDTSTART:19810401T000000\r\nRDATE:19810401T000000\r\nRDATE:19820401T000000\r\nRDATE:19830401T000000\r\nRDATE:19840401T000000\r\nRDATE:19850331T030000\r\nRDATE:19860330T030000\r\nRDATE:19870329T030000\r\nRDATE:19880327T030000\r\nRDATE:19890326T030000\r\nRDATE:19900325T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0500\r\nTZOFFSETTO:+0400\r\nTZNAME:BAKT\r\nDTSTART:19811001T000000\r\nRDATE:19811001T000000\r\nRDATE:19821001T000000\r\nRDATE:19831001T000000\r\nRDATE:19840930T030000\r\nRDATE:19850929T030000\r\nRDATE:19860928T030000\r\nRDATE:19870927T030000\r\nRDATE:19880925T030000\r\nRDATE:19890924T030000\r\nRDATE:19900930T030000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0400\r\nTZNAME:BAKST\r\nDTSTART:19910331T030000\r\nRDATE:19910331T030000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0400\r\nTZNAME:AZST\r\nDTSTART:19910830T000000\r\nRDATE:19910830T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0300\r\nTZNAME:AZT\r\nDTSTART:19910929T030000\r\nRDATE:19910929T030000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0400\r\nTZNAME:AZST\r\nDTSTART:19920328T230000\r\nRDATE:19920328T230000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0400\r\nTZNAME:AZT\r\nDTSTART:19920926T230000\r\nRDATE:19920926T230000\r\nRDATE:19960101T000000\r\nRDATE:19970101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0500\r\nTZNAME:AZST\r\nDTSTART:19960331T050000\r\nRDATE:19960331T050000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0500\r\nTZOFFSETTO:+0400\r\nTZNAME:AZT\r\nDTSTART:19961027T060000\r\nRDATE:19961027T060000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Azores Standard Time che sara' Atlantic/Azores (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Azores Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Atlantic/Azores\r\nX-LIC-LOCATION:Atlantic/Azores\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0100\r\nTZOFFSETTO:+0000\r\nTZNAME:AZOST\r\nDTSTART:19940327T000000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0000\r\nTZOFFSETTO:-0100\r\nTZNAME:AZOT\r\nDTSTART:19961027T010000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-014240\r\nTZOFFSETTO:-015432\r\nTZNAME:HMT\r\nDTSTART:18840101T000000\r\nRDATE:18840101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-015432\r\nTZOFFSETTO:-0200\r\nTZNAME:AZOT\r\nDTSTART:19110524T000000\r\nRDATE:19110524T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0200\r\nTZOFFSETTO:-0100\r\nTZNAME:AZOST\r\nDTSTART:19160617T230000\r\nRDATE:19160617T230000\r\nRDATE:19170228T230000\r\nRDATE:19180301T230000\r\nRDATE:19190228T230000\r\nRDATE:19200229T230000\r\nRDATE:19210228T230000\r\nRDATE:19240416T230000\r\nRDATE:19260417T230000\r\nRDATE:19270409T230000\r\nRDATE:19280414T230000\r\nRDATE:19290420T230000\r\nRDATE:19310418T230000\r\nRDATE:19320402T230000\r\nRDATE:19340407T230000\r\nRDATE:19350330T230000\r\nRDATE:19360418T230000\r\nRDATE:19370403T230000\r\nRDATE:19380326T230000\r\nRDATE:19390415T230000\r\nRDATE:19400224T230000\r\nRDATE:19410405T230000\r\nRDATE:19420314T230000\r\nRDATE:19430313T230000\r\nRDATE:19440311T230000\r\nRDATE:19450310T230000\r\nRDATE:19460406T230000\r\nRDATE:19470406T020000\r\nRDATE:19480404T020000\r\nRDATE:19490403T020000\r\nRDATE:19510401T020000\r\nRDATE:19520406T020000\r\nRDATE:19530405T020000\r\nRDATE:19540404T020000\r\nRDATE:19550403T020000\r\nRDATE:19560401T020000\r\nRDATE:19570407T020000\r\nRDATE:19580406T020000\r\nRDATE:19590405T020000\r\nRDATE:19600403T020000\r\nRDATE:19610402T020000\r\nRDATE:19620401T020000\r\nRDATE:19630407T020000\r\nRDATE:19640405T020000\r\nRDATE:19650404T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0100\r\nTZOFFSETTO:-0200\r\nTZNAME:AZOT\r\nDTSTART:19161101T010000\r\nRDATE:19161101T010000\r\nRDATE:19171015T000000\r\nRDATE:19181015T000000\r\nRDATE:19191015T000000\r\nRDATE:19201015T000000\r\nRDATE:19211015T000000\r\nRDATE:19241015T000000\r\nRDATE:19261003T000000\r\nRDATE:19271002T000000\r\nRDATE:19281007T000000\r\nRDATE:19291006T000000\r\nRDATE:19311004T000000\r\nRDATE:19321002T000000\r\nRDATE:19341007T000000\r\nRDATE:19351006T000000\r\nRDATE:19361004T000000\r\nRDATE:19371003T000000\r\nRDATE:19381002T000000\r\nRDATE:19391119T000000\r\nRDATE:19401006T000000\r\nRDATE:19411006T000000\r\nRDATE:19421025T000000\r\nRDATE:19431031T000000\r\nRDATE:19441029T000000\r\nRDATE:19451028T000000\r\nRDATE:19461006T000000\r\nRDATE:19471005T030000\r\nRDATE:19481003T030000\r\nRDATE:19491002T030000\r\nRDATE:19511007T030000\r\nRDATE:19521005T030000\r\nRDATE:19531004T030000\r\nRDATE:19541003T030000\r\nRDATE:19551002T030000\r\nRDATE:19561007T030000\r\nRDATE:19571006T030000\r\nRDATE:19581005T030000\r\nRDATE:19591004T030000\r\nRDATE:19601002T030000\r\nRDATE:19611001T030000\r\nRDATE:19621007T030000\r\nRDATE:19631006T030000\r\nRDATE:19641004T030000\r\nRDATE:19651003T030000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0100\r\nTZOFFSETTO:+0000\r\nTZNAME:AZOMT\r\nDTSTART:19420425T230000\r\nRDATE:19420425T230000\r\nRDATE:19430417T230000\r\nRDATE:19440422T230000\r\nRDATE:19450421T230000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0000\r\nTZOFFSETTO:-0100\r\nTZNAME:AZOST\r\nDTSTART:19420816T000000\r\nRDATE:19420816T000000\r\nRDATE:19430829T000000\r\nRDATE:19440827T000000\r\nRDATE:19450826T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0200\r\nTZOFFSETTO:-0100\r\nTZNAME:AZOT\r\nDTSTART:19660403T020000\r\nRDATE:19660403T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0100\r\nTZOFFSETTO:+0000\r\nTZNAME:AZOST\r\nDTSTART:19770327T000000\r\nRDATE:19770327T000000\r\nRDATE:19780402T000000\r\nRDATE:19790401T000000\r\nRDATE:19800330T000000\r\nRDATE:19810329T010000\r\nRDATE:19820328T010000\r\nRDATE:19830327T030000\r\nRDATE:19840325T010000\r\nRDATE:19850331T010000\r\nRDATE:19860330T010000\r\nRDATE:19870329T010000\r\nRDATE:19880327T010000\r\nRDATE:19890326T010000\r\nRDATE:19900325T010000\r\nRDATE:19910331T010000\r\nRDATE:19920329T010000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0000\r\nTZOFFSETTO:-0100\r\nTZNAME:AZOT\r\nDTSTART:19770925T010000\r\nRDATE:19770925T010000\r\nRDATE:19781001T010000\r\nRDATE:19790930T020000\r\nRDATE:19800928T020000\r\nRDATE:19810927T020000\r\nRDATE:19820926T020000\r\nRDATE:19830925T020000\r\nRDATE:19840930T020000\r\nRDATE:19850929T020000\r\nRDATE:19860928T020000\r\nRDATE:19870927T020000\r\nRDATE:19880925T020000\r\nRDATE:19890924T020000\r\nRDATE:19900930T020000\r\nRDATE:19910929T020000\r\nRDATE:19930926T010000\r\nRDATE:19940925T010000\r\nRDATE:19950924T010000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0000\r\nTZOFFSETTO:+0000\r\nTZNAME:WET\r\nDTSTART:19920927T020000\r\nRDATE:19920927T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0000\r\nTZOFFSETTO:+0000\r\nTZNAME:AZOST\r\nDTSTART:19930328T010000\r\nRDATE:19930328T010000\r\nEND:DAYLIGHT\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Canada Central Standard Time che sara' America/Regina (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Canada Central Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/Regina\r\nX-LIC-LOCATION:America/Regina\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-065836\r\nTZOFFSETTO:-0700\r\nTZNAME:MST\r\nDTSTART:19050901T000000\r\nRDATE:19050901T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0600\r\nTZNAME:MDT\r\nDTSTART:19180414T020000\r\nRDATE:19180414T020000\r\nRDATE:19300504T000000\r\nRDATE:19310503T000000\r\nRDATE:19320501T000000\r\nRDATE:19330507T000000\r\nRDATE:19340506T000000\r\nRDATE:19370411T000000\r\nRDATE:19380410T000000\r\nRDATE:19390409T000000\r\nRDATE:19400414T000000\r\nRDATE:19410413T000000\r\nRDATE:19460414T020000\r\nRDATE:19470427T030000\r\nRDATE:19480425T030000\r\nRDATE:19490424T030000\r\nRDATE:19500430T030000\r\nRDATE:19510429T030000\r\nRDATE:19520427T030000\r\nRDATE:19530426T030000\r\nRDATE:19540425T030000\r\nRDATE:19550424T030000\r\nRDATE:19560429T030000\r\nRDATE:19570428T030000\r\nRDATE:19590426T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0700\r\nTZNAME:MST\r\nDTSTART:19181031T020000\r\nRDATE:19181031T020000\r\nRDATE:19301005T000000\r\nRDATE:19311004T000000\r\nRDATE:19321002T000000\r\nRDATE:19331001T000000\r\nRDATE:19341007T000000\r\nRDATE:19371010T000000\r\nRDATE:19381002T000000\r\nRDATE:19391008T000000\r\nRDATE:19401013T000000\r\nRDATE:19411012T000000\r\nRDATE:19450930T020000\r\nRDATE:19461013T020000\r\nRDATE:19470928T020000\r\nRDATE:19480926T020000\r\nRDATE:19490925T020000\r\nRDATE:19500924T020000\r\nRDATE:19510930T020000\r\nRDATE:19520928T020000\r\nRDATE:19530927T020000\r\nRDATE:19540926T020000\r\nRDATE:19550925T020000\r\nRDATE:19560930T020000\r\nRDATE:19570929T020000\r\nRDATE:19591025T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0600\r\nTZNAME:MWT\r\nDTSTART:19420209T030000\r\nRDATE:19420209T030000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0600\r\nTZNAME:MPT\r\nDTSTART:19450814T170000\r\nRDATE:19450814T170000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0600\r\nTZNAME:CST\r\nDTSTART:19600424T030000\r\nRDATE:19600424T030000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Cape Verde Standard Time che sara' Atlantic/Cape_Verde (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Cape Verde Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Atlantic/Cape_Verde\r\nX-LIC-LOCATION:Atlantic/Cape_Verde\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-013404\r\nTZOFFSETTO:-0200\r\nTZNAME:CVT\r\nDTSTART:19070101T000000\r\nRDATE:19070101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0200\r\nTZOFFSETTO:-0100\r\nTZNAME:CVST\r\nDTSTART:19420901T000000\r\nRDATE:19420901T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0100\r\nTZOFFSETTO:-0200\r\nTZNAME:CVT\r\nDTSTART:19451015T000000\r\nRDATE:19451015T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0200\r\nTZOFFSETTO:-0100\r\nTZNAME:CVT\r\nDTSTART:19751125T020000\r\nRDATE:19751125T020000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Caucasus Standard Time che sara' Asia/Yerevan (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Caucasus Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Yerevan\r\nX-LIC-LOCATION:Asia/Yerevan\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0500\r\nTZNAME:AMST\r\nDTSTART:19970330T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0500\r\nTZOFFSETTO:+0400\r\nTZNAME:AMT\r\nDTSTART:19971026T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0258\r\nTZOFFSETTO:+0300\r\nTZNAME:YERT\r\nDTSTART:19240502T000000\r\nRDATE:19240502T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0400\r\nTZNAME:YERT\r\nDTSTART:19570301T000000\r\nRDATE:19570301T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0500\r\nTZNAME:YERST\r\nDTSTART:19810401T000000\r\nRDATE:19810401T000000\r\nRDATE:19820401T000000\r\nRDATE:19830401T000000\r\nRDATE:19840401T000000\r\nRDATE:19850331T030000\r\nRDATE:19860330T030000\r\nRDATE:19870329T030000\r\nRDATE:19880327T030000\r\nRDATE:19890326T030000\r\nRDATE:19900325T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0500\r\nTZOFFSETTO:+0400\r\nTZNAME:YERT\r\nDTSTART:19811001T000000\r\nRDATE:19811001T000000\r\nRDATE:19821001T000000\r\nRDATE:19831001T000000\r\nRDATE:19840930T030000\r\nRDATE:19850929T030000\r\nRDATE:19860928T030000\r\nRDATE:19870927T030000\r\nRDATE:19880925T030000\r\nRDATE:19890924T030000\r\nRDATE:19900930T030000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0400\r\nTZNAME:YERST\r\nDTSTART:19910331T030000\r\nRDATE:19910331T030000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0400\r\nTZNAME:AMST\r\nDTSTART:19910923T000000\r\nRDATE:19910923T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0300\r\nTZNAME:AMT\r\nDTSTART:19910929T030000\r\nRDATE:19910929T030000\r\nRDATE:19920926T230000\r\nRDATE:19930926T030000\r\nRDATE:19940925T030000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0400\r\nTZNAME:AMST\r\nDTSTART:19920328T230000\r\nRDATE:19920328T230000\r\nRDATE:19930328T030000\r\nRDATE:19940327T030000\r\nRDATE:19950326T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0400\r\nTZNAME:AMT\r\nDTSTART:19950924T030000\r\nRDATE:19950924T030000\r\nRDATE:19970101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Cen. Australia Standard Time che sara' Australia/Adelaide (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Cen. Australia Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Australia/Adelaide\r\nX-LIC-LOCATION:Australia/Adelaide\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0930\r\nTZOFFSETTO:+1030\r\nTZNAME:CST\r\nDTSTART:19871025T020000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0930\r\nTZOFFSETTO:+0930\r\nTZNAME:CST\r\nDTSTART:20070325T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+091420\r\nTZOFFSETTO:+0900\r\nTZNAME:CST\r\nDTSTART:18950201T000000\r\nRDATE:18950201T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0900\r\nTZOFFSETTO:+0930\r\nTZNAME:CST\r\nDTSTART:18990501T000000\r\nRDATE:18990501T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0930\r\nTZOFFSETTO:+1030\r\nTZNAME:CST\r\nDTSTART:19170101T000100\r\nRDATE:19170101T000100\r\nRDATE:19420101T020000\r\nRDATE:19420927T020000\r\nRDATE:19431003T020000\r\nRDATE:19711031T020000\r\nRDATE:19721029T020000\r\nRDATE:19731028T020000\r\nRDATE:19741027T020000\r\nRDATE:19751026T020000\r\nRDATE:19761031T020000\r\nRDATE:19771030T020000\r\nRDATE:19781029T020000\r\nRDATE:19791028T020000\r\nRDATE:19801026T020000\r\nRDATE:19811025T020000\r\nRDATE:19821031T020000\r\nRDATE:19831030T020000\r\nRDATE:19841028T020000\r\nRDATE:19851027T020000\r\nRDATE:19861019T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1030\r\nTZOFFSETTO:+0930\r\nTZNAME:CST\r\nDTSTART:19170325T020000\r\nRDATE:19170325T020000\r\nRDATE:19420329T020000\r\nRDATE:19430328T020000\r\nRDATE:19440326T020000\r\nRDATE:19720227T030000\r\nRDATE:19730304T030000\r\nRDATE:19740303T030000\r\nRDATE:19750302T030000\r\nRDATE:19760307T030000\r\nRDATE:19770306T030000\r\nRDATE:19780305T030000\r\nRDATE:19790304T030000\r\nRDATE:19800302T030000\r\nRDATE:19810301T030000\r\nRDATE:19820307T030000\r\nRDATE:19830306T030000\r\nRDATE:19840304T030000\r\nRDATE:19850303T030000\r\nRDATE:19860316T030000\r\nRDATE:19870315T030000\r\nRDATE:19880320T030000\r\nRDATE:19890319T030000\r\nRDATE:19900318T030000\r\nRDATE:19910303T030000\r\nRDATE:19920322T030000\r\nRDATE:19930307T030000\r\nRDATE:19940320T030000\r\nRDATE:19950326T030000\r\nRDATE:19960331T030000\r\nRDATE:19970330T030000\r\nRDATE:19980329T030000\r\nRDATE:19990328T030000\r\nRDATE:20000326T030000\r\nRDATE:20010325T030000\r\nRDATE:20020331T030000\r\nRDATE:20030330T030000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0930\r\nTZOFFSETTO:+0930\r\nTZNAME:CST\r\nDTSTART:19710101T000000\r\nRDATE:19710101T000000\r\nRDATE:20040328T030000\r\nRDATE:20050327T030000\r\nRDATE:20060402T030000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Central America Standard Time che sara' America/Guatemala (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Central America Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/Guatemala\r\nX-LIC-LOCATION:America/Guatemala\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-060204\r\nTZOFFSETTO:-0600\r\nTZNAME:CST\r\nDTSTART:19181005T000000\r\nRDATE:19181005T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0500\r\nTZNAME:CDT\r\nDTSTART:19731125T000000\r\nRDATE:19731125T000000\r\nRDATE:19830521T000000\r\nRDATE:19910323T000000\r\nRDATE:20060430T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0500\r\nTZOFFSETTO:-0600\r\nTZNAME:CST\r\nDTSTART:19740224T000000\r\nRDATE:19740224T000000\r\nRDATE:19830922T000000\r\nRDATE:19910907T000000\r\nRDATE:20061001T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Central Asia Standard Time che sara' Asia/Dhaka (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Central Asia Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Dhaka\r\nX-LIC-LOCATION:Asia/Dhaka\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+060140\r\nTZOFFSETTO:+055320\r\nTZNAME:HMT\r\nDTSTART:18900101T000000\r\nRDATE:18900101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+055320\r\nTZOFFSETTO:+0630\r\nTZNAME:BURT\r\nDTSTART:19411001T000000\r\nRDATE:19411001T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0630\r\nTZOFFSETTO:+0530\r\nTZNAME:IST\r\nDTSTART:19420515T000000\r\nRDATE:19420515T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0530\r\nTZOFFSETTO:+0630\r\nTZNAME:BURT\r\nDTSTART:19420901T000000\r\nRDATE:19420901T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0630\r\nTZOFFSETTO:+0600\r\nTZNAME:DACT\r\nDTSTART:19510930T000000\r\nRDATE:19510930T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0600\r\nTZOFFSETTO:+0600\r\nTZNAME:BDT\r\nDTSTART:19710326T000000\r\nRDATE:19710326T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Central Brazilian Standard Time che sara' America/Manaus (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Central Brazilian Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/Manaus\r\nX-LIC-LOCATION:America/Manaus\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-040004\r\nTZOFFSETTO:-0400\r\nTZNAME:AMT\r\nDTSTART:19140101T000000\r\nRDATE:19140101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0400\r\nTZOFFSETTO:-0300\r\nTZNAME:AMST\r\nDTSTART:19311003T110000\r\nRDATE:19311003T110000\r\nRDATE:19321003T000000\r\nRDATE:19491201T000000\r\nRDATE:19501201T000000\r\nRDATE:19511201T000000\r\nRDATE:19521201T000000\r\nRDATE:19631209T000000\r\nRDATE:19650131T000000\r\nRDATE:19651201T000000\r\nRDATE:19661101T000000\r\nRDATE:19671101T000000\r\nRDATE:19851102T000000\r\nRDATE:19861025T000000\r\nRDATE:19871025T000000\r\nRDATE:19931017T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0300\r\nTZOFFSETTO:-0400\r\nTZNAME:AMT\r\nDTSTART:19320401T000000\r\nRDATE:19320401T000000\r\nRDATE:19330401T000000\r\nRDATE:19500416T010000\r\nRDATE:19510401T000000\r\nRDATE:19520401T000000\r\nRDATE:19530301T000000\r\nRDATE:19640301T000000\r\nRDATE:19650331T000000\r\nRDATE:19660301T000000\r\nRDATE:19670301T000000\r\nRDATE:19680301T000000\r\nRDATE:19860315T000000\r\nRDATE:19870214T000000\r\nRDATE:19880207T000000\r\nRDATE:19940220T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0400\r\nTZOFFSETTO:-0400\r\nTZNAME:AMT\r\nDTSTART:19880912T000000\r\nRDATE:19880912T000000\r\nRDATE:19930928T000000\r\nRDATE:19940922T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Central Europe Standard Time che sara' Europe/Budapest (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Central Europe Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Europe/Budapest\r\nX-LIC-LOCATION:Europe/Budapest\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0200\r\nTZNAME:CEST\r\nDTSTART:19810329T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0100\r\nTZNAME:CET\r\nDTSTART:19961027T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+011620\r\nTZOFFSETTO:+0100\r\nTZNAME:CET\r\nDTSTART:18901001T000000\r\nRDATE:18901001T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0200\r\nTZNAME:CEST\r\nDTSTART:19160430T230000\r\nRDATE:19160430T230000\r\nRDATE:19170416T020000\r\nRDATE:19180401T030000\r\nRDATE:19190415T030000\r\nRDATE:19200405T030000\r\nRDATE:19410406T020000\r\nRDATE:19430329T030000\r\nRDATE:19440403T030000\r\nRDATE:19450501T230000\r\nRDATE:19460331T020000\r\nRDATE:19470406T020000\r\nRDATE:19480404T020000\r\nRDATE:19490410T020000\r\nRDATE:19500417T020000\r\nRDATE:19540523T000000\r\nRDATE:19550523T000000\r\nRDATE:19560603T000000\r\nRDATE:19570602T010000\r\nRDATE:19800406T010000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0100\r\nTZNAME:CET\r\nDTSTART:19161001T010000\r\nRDATE:19161001T010000\r\nRDATE:19170917T030000\r\nRDATE:19180929T030000\r\nRDATE:19190915T030000\r\nRDATE:19200930T030000\r\nRDATE:19421102T030000\r\nRDATE:19431004T030000\r\nRDATE:19441002T030000\r\nRDATE:19451103T000000\r\nRDATE:19461006T030000\r\nRDATE:19471005T030000\r\nRDATE:19481003T030000\r\nRDATE:19491002T030000\r\nRDATE:19501023T030000\r\nRDATE:19541003T000000\r\nRDATE:19551003T000000\r\nRDATE:19560930T000000\r\nRDATE:19570929T030000\r\nRDATE:19800928T030000\r\nRDATE:19810927T030000\r\nRDATE:19820926T030000\r\nRDATE:19830925T030000\r\nRDATE:19840930T030000\r\nRDATE:19850929T030000\r\nRDATE:19860928T030000\r\nRDATE:19870927T030000\r\nRDATE:19880925T030000\r\nRDATE:19890924T030000\r\nRDATE:19900930T030000\r\nRDATE:19910929T030000\r\nRDATE:19920927T030000\r\nRDATE:19930926T030000\r\nRDATE:19940925T030000\r\nRDATE:19950924T030000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0100\r\nTZNAME:CET\r\nDTSTART:19180101T000000\r\nRDATE:19180101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Central European Standard Time che sara' Europe/Warsaw (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Central European Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Europe/Warsaw\r\nX-LIC-LOCATION:Europe/Warsaw\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0200\r\nTZNAME:CEST\r\nDTSTART:19880327T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0100\r\nTZNAME:CET\r\nDTSTART:19961027T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0124\r\nTZOFFSETTO:+0124\r\nTZNAME:WMT\r\nDTSTART:18800101T000000\r\nRDATE:18800101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0124\r\nTZOFFSETTO:+0100\r\nTZNAME:CET\r\nDTSTART:19150805T000000\r\nRDATE:19150805T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0200\r\nTZNAME:CEST\r\nDTSTART:19160430T230000\r\nRDATE:19160430T230000\r\nRDATE:19170416T020000\r\nRDATE:19180415T020000\r\nRDATE:19400623T020000\r\nRDATE:19430329T030000\r\nRDATE:19440403T030000\r\nRDATE:19450429T000000\r\nRDATE:19460414T000000\r\nRDATE:19470504T020000\r\nRDATE:19480418T020000\r\nRDATE:19490410T020000\r\nRDATE:19570602T010000\r\nRDATE:19580330T010000\r\nRDATE:19590531T010000\r\nRDATE:19600403T010000\r\nRDATE:19610528T010000\r\nRDATE:19620527T010000\r\nRDATE:19630526T010000\r\nRDATE:19640531T010000\r\nRDATE:19770403T010000\r\nRDATE:19780402T010000\r\nRDATE:19790401T010000\r\nRDATE:19800406T010000\r\nRDATE:19810329T010000\r\nRDATE:19820328T010000\r\nRDATE:19830327T010000\r\nRDATE:19840325T010000\r\nRDATE:19850331T010000\r\nRDATE:19860330T010000\r\nRDATE:19870329T010000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0100\r\nTZNAME:CET\r\nDTSTART:19161001T010000\r\nRDATE:19161001T010000\r\nRDATE:19170917T030000\r\nRDATE:19220601T000000\r\nRDATE:19421102T030000\r\nRDATE:19431004T030000\r\nRDATE:19441004T020000\r\nRDATE:19451101T000000\r\nRDATE:19461007T030000\r\nRDATE:19471005T030000\r\nRDATE:19481003T030000\r\nRDATE:19491002T030000\r\nRDATE:19570929T020000\r\nRDATE:19580928T020000\r\nRDATE:19591004T020000\r\nRDATE:19601002T020000\r\nRDATE:19611001T020000\r\nRDATE:19620930T020000\r\nRDATE:19630929T020000\r\nRDATE:19640927T020000\r\nRDATE:19770925T020000\r\nRDATE:19781001T020000\r\nRDATE:19790930T020000\r\nRDATE:19800928T020000\r\nRDATE:19810927T020000\r\nRDATE:19820926T020000\r\nRDATE:19830925T020000\r\nRDATE:19840930T020000\r\nRDATE:19850929T020000\r\nRDATE:19860928T020000\r\nRDATE:19870927T020000\r\nRDATE:19880925T030000\r\nRDATE:19890924T030000\r\nRDATE:19900930T030000\r\nRDATE:19910929T030000\r\nRDATE:19920927T030000\r\nRDATE:19930926T030000\r\nRDATE:19940925T030000\r\nRDATE:19950924T030000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:19180916T030000\r\nRDATE:19180916T030000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0300\r\nTZNAME:EEST\r\nDTSTART:19190415T020000\r\nRDATE:19190415T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:19190916T030000\r\nRDATE:19190916T030000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0200\r\nTZNAME:CEST\r\nDTSTART:19441001T000000\r\nRDATE:19441001T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0100\r\nTZNAME:CET\r\nDTSTART:19770101T000000\r\nRDATE:19770101T000000\r\nRDATE:19880101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Central Pacific Standard Time che sara' Pacific/Guadalcanal (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Central Pacific Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Pacific/Guadalcanal\r\nX-LIC-LOCATION:Pacific/Guadalcanal\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+103948\r\nTZOFFSETTO:+1100\r\nTZNAME:SBT\r\nDTSTART:19121001T000000\r\nRDATE:19121001T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Central Standard Time che sara' America/Chicago (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Central Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/Chicago\r\nX-LIC-LOCATION:America/Chicago\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0500\r\nTZNAME:CDT\r\nDTSTART:20070311T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=2SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0500\r\nTZOFFSETTO:-0600\r\nTZNAME:CST\r\nDTSTART:20071104T020000\r\nRRULE:FREQ=YEARLY;BYMONTH=11;BYDAY=1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-055036\r\nTZOFFSETTO:-0600\r\nTZNAME:CST\r\nDTSTART:18831118T120924\r\nRDATE:18831118T120924\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0500\r\nTZNAME:CDT\r\nDTSTART:19180331T030000\r\nRDATE:19180331T030000\r\nRDATE:19190330T030000\r\nRDATE:19200613T020000\r\nRDATE:19210327T020000\r\nRDATE:19220430T030000\r\nRDATE:19230429T030000\r\nRDATE:19240427T030000\r\nRDATE:19250426T030000\r\nRDATE:19260425T030000\r\nRDATE:19270424T030000\r\nRDATE:19280429T030000\r\nRDATE:19290428T030000\r\nRDATE:19300427T030000\r\nRDATE:19310426T030000\r\nRDATE:19320424T030000\r\nRDATE:19330430T030000\r\nRDATE:19340429T030000\r\nRDATE:19350428T030000\r\nRDATE:19370425T030000\r\nRDATE:19380424T030000\r\nRDATE:19390430T030000\r\nRDATE:19400428T030000\r\nRDATE:19410427T030000\r\nRDATE:19460428T030000\r\nRDATE:19470427T030000\r\nRDATE:19480425T030000\r\nRDATE:19490424T030000\r\nRDATE:19500430T030000\r\nRDATE:19510429T030000\r\nRDATE:19520427T030000\r\nRDATE:19530426T030000\r\nRDATE:19540425T030000\r\nRDATE:19550424T030000\r\nRDATE:19560429T030000\r\nRDATE:19570428T030000\r\nRDATE:19580427T030000\r\nRDATE:19590426T030000\r\nRDATE:19600424T030000\r\nRDATE:19610430T030000\r\nRDATE:19620429T030000\r\nRDATE:19630428T030000\r\nRDATE:19640426T030000\r\nRDATE:19650425T030000\r\nRDATE:19660424T030000\r\nRDATE:19670430T030000\r\nRDATE:19680428T030000\r\nRDATE:19690427T030000\r\nRDATE:19700426T030000\r\nRDATE:19710425T030000\r\nRDATE:19720430T030000\r\nRDATE:19730429T030000\r\nRDATE:19740106T030000\r\nRDATE:19750223T030000\r\nRDATE:19760425T030000\r\nRDATE:19770424T030000\r\nRDATE:19780430T030000\r\nRDATE:19790429T030000\r\nRDATE:19800427T030000\r\nRDATE:19810426T030000\r\nRDATE:19820425T030000\r\nRDATE:19830424T030000\r\nRDATE:19840429T030000\r\nRDATE:19850428T030000\r\nRDATE:19860427T030000\r\nRDATE:19870405T030000\r\nRDATE:19880403T030000\r\nRDATE:19890402T030000\r\nRDATE:19900401T030000\r\nRDATE:19910407T030000\r\nRDATE:19920405T030000\r\nRDATE:19930404T030000\r\nRDATE:19940403T030000\r\nRDATE:19950402T030000\r\nRDATE:19960407T030000\r\nRDATE:19970406T030000\r\nRDATE:19980405T030000\r\nRDATE:19990404T030000\r\nRDATE:20000402T030000\r\nRDATE:20010401T030000\r\nRDATE:20020407T030000\r\nRDATE:20030406T030000\r\nRDATE:20040404T030000\r\nRDATE:20050403T030000\r\nRDATE:20060402T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0500\r\nTZOFFSETTO:-0600\r\nTZNAME:CST\r\nDTSTART:19181027T020000\r\nRDATE:19181027T020000\r\nRDATE:19191026T020000\r\nRDATE:19201031T020000\r\nRDATE:19211030T020000\r\nRDATE:19220924T020000\r\nRDATE:19230930T020000\r\nRDATE:19240928T020000\r\nRDATE:19250927T020000\r\nRDATE:19260926T020000\r\nRDATE:19270925T020000\r\nRDATE:19280930T020000\r\nRDATE:19290929T020000\r\nRDATE:19300928T020000\r\nRDATE:19310927T020000\r\nRDATE:19320925T020000\r\nRDATE:19330924T020000\r\nRDATE:19340930T020000\r\nRDATE:19350929T020000\r\nRDATE:19361115T020000\r\nRDATE:19370926T020000\r\nRDATE:19380925T020000\r\nRDATE:19390924T020000\r\nRDATE:19400929T020000\r\nRDATE:19410928T020000\r\nRDATE:19450930T020000\r\nRDATE:19460929T020000\r\nRDATE:19470928T020000\r\nRDATE:19480926T020000\r\nRDATE:19490925T020000\r\nRDATE:19500924T020000\r\nRDATE:19510930T020000\r\nRDATE:19520928T020000\r\nRDATE:19530927T020000\r\nRDATE:19540926T020000\r\nRDATE:19551030T020000\r\nRDATE:19561028T020000\r\nRDATE:19571027T020000\r\nRDATE:19581026T020000\r\nRDATE:19591025T020000\r\nRDATE:19601030T020000\r\nRDATE:19611029T020000\r\nRDATE:19621028T020000\r\nRDATE:19631027T020000\r\nRDATE:19641025T020000\r\nRDATE:19651031T020000\r\nRDATE:19661030T020000\r\nRDATE:19671029T020000\r\nRDATE:19681027T020000\r\nRDATE:19691026T020000\r\nRDATE:19701025T020000\r\nRDATE:19711031T020000\r\nRDATE:19721029T020000\r\nRDATE:19731028T020000\r\nRDATE:19741027T020000\r\nRDATE:19751026T020000\r\nRDATE:19761031T020000\r\nRDATE:19771030T020000\r\nRDATE:19781029T020000\r\nRDATE:19791028T020000\r\nRDATE:19801026T020000\r\nRDATE:19811025T020000\r\nRDATE:19821031T020000\r\nRDATE:19831030T020000\r\nRDATE:19841028T020000\r\nRDATE:19851027T020000\r\nRDATE:19861026T020000\r\nRDATE:19871025T020000\r\nRDATE:19881030T020000\r\nRDATE:19891029T020000\r\nRDATE:19901028T020000\r\nRDATE:19911027T020000\r\nRDATE:19921025T020000\r\nRDATE:19931031T020000\r\nRDATE:19941030T020000\r\nRDATE:19951029T020000\r\nRDATE:19961027T020000\r\nRDATE:19971026T020000\r\nRDATE:19981025T020000\r\nRDATE:19991031T020000\r\nRDATE:20001029T020000\r\nRDATE:20011028T020000\r\nRDATE:20021027T020000\r\nRDATE:20031026T020000\r\nRDATE:20041031T020000\r\nRDATE:20051030T020000\r\nRDATE:20061029T020000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0600\r\nTZNAME:CST\r\nDTSTART:19200101T000000\r\nRDATE:19200101T000000\r\nRDATE:19420101T000000\r\nRDATE:19460101T000000\r\nRDATE:19670101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0500\r\nTZNAME:EST\r\nDTSTART:19360301T020000\r\nRDATE:19360301T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0500\r\nTZNAME:CWT\r\nDTSTART:19420209T030000\r\nRDATE:19420209T030000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0500\r\nTZOFFSETTO:-0500\r\nTZNAME:CPT\r\nDTSTART:19450814T180000\r\nRDATE:19450814T180000\r\nEND:DAYLIGHT\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Central Standard Time (Mexico) che sara' America/Mexico_City (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Central Standard Time (Mexico)',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/Mexico_City\r\nX-LIC-LOCATION:America/Mexico_City\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0500\r\nTZNAME:CDT\r\nDTSTART:20020407T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=4;BYDAY=1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0500\r\nTZOFFSETTO:-0600\r\nTZNAME:CST\r\nDTSTART:20021027T020000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-063636\r\nTZOFFSETTO:-0700\r\nTZNAME:MST\r\nDTSTART:19220101T002324\r\nRDATE:19220101T002324\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0600\r\nTZNAME:CST\r\nDTSTART:19270610T230000\r\nRDATE:19270610T230000\r\nRDATE:19310501T230000\r\nRDATE:19320401T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0700\r\nTZNAME:MST\r\nDTSTART:19301115T000000\r\nRDATE:19301115T000000\r\nRDATE:19311001T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0500\r\nTZNAME:CDT\r\nDTSTART:19390205T000000\r\nRDATE:19390205T000000\r\nRDATE:19401209T000000\r\nRDATE:19500212T000000\r\nRDATE:19960407T030000\r\nRDATE:19970406T030000\r\nRDATE:19980405T030000\r\nRDATE:19990404T030000\r\nRDATE:20000402T030000\r\nRDATE:20010506T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0500\r\nTZOFFSETTO:-0600\r\nTZNAME:CST\r\nDTSTART:19390625T000000\r\nRDATE:19390625T000000\r\nRDATE:19410401T000000\r\nRDATE:19440501T000000\r\nRDATE:19500730T000000\r\nRDATE:19961027T020000\r\nRDATE:19971026T020000\r\nRDATE:19981025T020000\r\nRDATE:19991031T020000\r\nRDATE:20001029T020000\r\nRDATE:20010930T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0500\r\nTZNAME:CWT\r\nDTSTART:19431216T000000\r\nRDATE:19431216T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0600\r\nTZNAME:CST\r\nDTSTART:20020220T000000\r\nRDATE:20020220T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: China Standard Time che sara' Asia/Shanghai (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'China Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Shanghai\r\nX-LIC-LOCATION:Asia/Shanghai\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+080552\r\nTZOFFSETTO:+0800\r\nTZNAME:CST\r\nDTSTART:19280101T000000\r\nRDATE:19280101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0800\r\nTZOFFSETTO:+0900\r\nTZNAME:CDT\r\nDTSTART:19400603T000000\r\nRDATE:19400603T000000\r\nRDATE:19410316T000000\r\nRDATE:19860504T000000\r\nRDATE:19870412T000000\r\nRDATE:19880410T000000\r\nRDATE:19890416T000000\r\nRDATE:19900415T000000\r\nRDATE:19910414T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0900\r\nTZOFFSETTO:+0800\r\nTZNAME:CST\r\nDTSTART:19401001T000000\r\nRDATE:19401001T000000\r\nRDATE:19411001T000000\r\nRDATE:19860914T000000\r\nRDATE:19870913T000000\r\nRDATE:19880911T000000\r\nRDATE:19890917T000000\r\nRDATE:19900916T000000\r\nRDATE:19910915T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0800\r\nTZOFFSETTO:+0800\r\nTZNAME:CST\r\nDTSTART:19490101T000000\r\nRDATE:19490101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Dateline Standard Time che sara' Etc/GMT+12 (0) NON TROVATO OK*/

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Dateline Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Dateline Standard Time\r\nX-LIC-LOCATION:Dateline Standard Time\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+115340\r\nTZOFFSETTO:+1200\r\nTZNAME:FJT\r\nDTSTART:19151026T000000\r\nRDATE:19151026T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+1200\r\nTZOFFSETTO:+1300\r\nTZNAME:FJST\r\nDTSTART:19981101T020000\r\nRDATE:19981101T020000\r\nRDATE:19991107T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1300\r\nTZOFFSETTO:+1200\r\nTZNAME:FJT\r\nDTSTART:19990228T030000\r\nRDATE:19990228T030000\r\nRDATE:20000227T030000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);


/* Analizzo: E. Africa Standard Time che sara' Africa/Nairobi (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'E. Africa Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Africa/Nairobi\r\nX-LIC-LOCATION:Africa/Nairobi\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+022716\r\nTZOFFSETTO:+0300\r\nTZNAME:EAT\r\nDTSTART:19280701T000000\r\nRDATE:19280701T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0230\r\nTZNAME:BEAT\r\nDTSTART:19300101T000000\r\nRDATE:19300101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0230\r\nTZOFFSETTO:+024445\r\nTZNAME:BEAUT\r\nDTSTART:19400101T000000\r\nRDATE:19400101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+024445\r\nTZOFFSETTO:+0300\r\nTZNAME:EAT\r\nDTSTART:19600101T000000\r\nRDATE:19600101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: E. Australia Standard Time che sara' Australia/Brisbane (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'E. Australia Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Australia/Brisbane\r\nX-LIC-LOCATION:Australia/Brisbane\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+101208\r\nTZOFFSETTO:+1000\r\nTZNAME:EST\r\nDTSTART:18950101T000000\r\nRDATE:18950101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+1000\r\nTZOFFSETTO:+1100\r\nTZNAME:EST\r\nDTSTART:19170101T000100\r\nRDATE:19170101T000100\r\nRDATE:19420101T020000\r\nRDATE:19420927T020000\r\nRDATE:19431003T020000\r\nRDATE:19711031T020000\r\nRDATE:19891029T020000\r\nRDATE:19901028T020000\r\nRDATE:19911027T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1100\r\nTZOFFSETTO:+1000\r\nTZNAME:EST\r\nDTSTART:19170325T020000\r\nRDATE:19170325T020000\r\nRDATE:19420329T020000\r\nRDATE:19430328T020000\r\nRDATE:19440326T020000\r\nRDATE:19720227T030000\r\nRDATE:19900304T030000\r\nRDATE:19910303T030000\r\nRDATE:19920301T030000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1000\r\nTZOFFSETTO:+1000\r\nTZNAME:EST\r\nDTSTART:19710101T000000\r\nRDATE:19710101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: E. Europe Standard Time che sara' Europe/Minsk (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'E. Europe Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Europe/Minsk\r\nX-LIC-LOCATION:Europe/Minsk\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0300\r\nTZNAME:EEST\r\nDTSTART:19930328T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:19961027T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+015016\r\nTZOFFSETTO:+0150\r\nTZNAME:MMT\r\nDTSTART:18800101T000000\r\nRDATE:18800101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0150\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:19240502T000000\r\nRDATE:19240502T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0300\r\nTZNAME:MSK\r\nDTSTART:19300621T000000\r\nRDATE:19300621T000000\r\nRDATE:19440703T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0200\r\nTZNAME:CEST\r\nDTSTART:19410628T000000\r\nRDATE:19410628T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0100\r\nTZNAME:CET\r\nDTSTART:19421102T030000\r\nRDATE:19421102T030000\r\nRDATE:19431004T030000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0200\r\nTZNAME:CEST\r\nDTSTART:19430329T030000\r\nRDATE:19430329T030000\r\nRDATE:19440403T030000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0400\r\nTZNAME:MSD\r\nDTSTART:19810401T000000\r\nRDATE:19810401T000000\r\nRDATE:19820401T000000\r\nRDATE:19830401T000000\r\nRDATE:19840401T000000\r\nRDATE:19850331T030000\r\nRDATE:19860330T030000\r\nRDATE:19870329T030000\r\nRDATE:19880327T030000\r\nRDATE:19890326T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0300\r\nTZNAME:MSK\r\nDTSTART:19811001T000000\r\nRDATE:19811001T000000\r\nRDATE:19821001T000000\r\nRDATE:19831001T000000\r\nRDATE:19840930T030000\r\nRDATE:19850929T030000\r\nRDATE:19860928T030000\r\nRDATE:19870927T030000\r\nRDATE:19880925T030000\r\nRDATE:19890924T030000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0300\r\nTZNAME:MSK\r\nDTSTART:19900101T000000\r\nRDATE:19900101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0300\r\nTZNAME:EEST\r\nDTSTART:19910331T030000\r\nRDATE:19910331T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:19910929T030000\r\nRDATE:19910929T030000\r\nRDATE:19920927T010000\r\nRDATE:19930926T030000\r\nRDATE:19940925T030000\r\nRDATE:19950924T030000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0300\r\nTZNAME:EEST\r\nDTSTART:19920329T000000\r\nRDATE:19920329T000000\r\nEND:DAYLIGHT\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: E. South America Standard Time che sara' America/Sao_Paulo (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'E. South America Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/Sao_Paulo\r\nX-LIC-LOCATION:America/Sao_Paulo\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0300\r\nTZOFFSETTO:-0200\r\nTZNAME:BRST\r\nDTSTART:20061105T000000\r\nRRULE:FREQ=YEARLY;BYMONTH=11;BYDAY=1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0200\r\nTZOFFSETTO:-0300\r\nTZNAME:BRT\r\nDTSTART:20070225T000000\r\nRRULE:FREQ=YEARLY;BYMONTH=2;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-030628\r\nTZOFFSETTO:-0300\r\nTZNAME:BRT\r\nDTSTART:19140101T000000\r\nRDATE:19140101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0300\r\nTZOFFSETTO:-0200\r\nTZNAME:BRST\r\nDTSTART:19311003T110000\r\nRDATE:19311003T110000\r\nRDATE:19321003T000000\r\nRDATE:19491201T000000\r\nRDATE:19501201T000000\r\nRDATE:19511201T000000\r\nRDATE:19521201T000000\r\nRDATE:19631023T000000\r\nRDATE:19650131T000000\r\nRDATE:19651201T000000\r\nRDATE:19661101T000000\r\nRDATE:19671101T000000\r\nRDATE:19851102T000000\r\nRDATE:19861025T000000\r\nRDATE:19871025T000000\r\nRDATE:19881016T000000\r\nRDATE:19891015T000000\r\nRDATE:19901021T000000\r\nRDATE:19911020T000000\r\nRDATE:19921025T000000\r\nRDATE:19931017T000000\r\nRDATE:19941016T000000\r\nRDATE:19951015T000000\r\nRDATE:19961006T000000\r\nRDATE:19971006T000000\r\nRDATE:19981011T000000\r\nRDATE:19991003T000000\r\nRDATE:20001008T000000\r\nRDATE:20011014T000000\r\nRDATE:20021103T000000\r\nRDATE:20031019T000000\r\nRDATE:20041102T000000\r\nRDATE:20051016T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0200\r\nTZOFFSETTO:-0300\r\nTZNAME:BRT\r\nDTSTART:19320401T000000\r\nRDATE:19320401T000000\r\nRDATE:19330401T000000\r\nRDATE:19500416T010000\r\nRDATE:19510401T000000\r\nRDATE:19520401T000000\r\nRDATE:19530301T000000\r\nRDATE:19640301T000000\r\nRDATE:19650331T000000\r\nRDATE:19660301T000000\r\nRDATE:19670301T000000\r\nRDATE:19680301T000000\r\nRDATE:19860315T000000\r\nRDATE:19870214T000000\r\nRDATE:19880207T000000\r\nRDATE:19890129T000000\r\nRDATE:19900211T000000\r\nRDATE:19910217T000000\r\nRDATE:19920209T000000\r\nRDATE:19930131T000000\r\nRDATE:19940220T000000\r\nRDATE:19950219T000000\r\nRDATE:19960211T000000\r\nRDATE:19970216T000000\r\nRDATE:19980301T000000\r\nRDATE:19990221T000000\r\nRDATE:20000227T000000\r\nRDATE:20010218T000000\r\nRDATE:20020217T000000\r\nRDATE:20030216T000000\r\nRDATE:20040215T000000\r\nRDATE:20050220T000000\r\nRDATE:20060219T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0200\r\nTZOFFSETTO:-0200\r\nTZNAME:BRST\r\nDTSTART:19640101T000000\r\nRDATE:19640101T000000\r\nEND:DAYLIGHT\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Eastern Standard Time che sara' America/New_York (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Eastern Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/New_York\r\nX-LIC-LOCATION:America/New_York\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0500\r\nTZOFFSETTO:-0400\r\nTZNAME:EDT\r\nDTSTART:20070311T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=2SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0400\r\nTZOFFSETTO:-0500\r\nTZNAME:EST\r\nDTSTART:20071104T020000\r\nRRULE:FREQ=YEARLY;BYMONTH=11;BYDAY=1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-045602\r\nTZOFFSETTO:-0500\r\nTZNAME:EST\r\nDTSTART:18831118T120358\r\nRDATE:18831118T120358\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0500\r\nTZOFFSETTO:-0400\r\nTZNAME:EDT\r\nDTSTART:19180331T030000\r\nRDATE:19180331T030000\r\nRDATE:19190330T030000\r\nRDATE:19200328T030000\r\nRDATE:19210424T030000\r\nRDATE:19220430T030000\r\nRDATE:19230429T030000\r\nRDATE:19240427T030000\r\nRDATE:19250426T030000\r\nRDATE:19260425T030000\r\nRDATE:19270424T030000\r\nRDATE:19280429T030000\r\nRDATE:19290428T030000\r\nRDATE:19300427T030000\r\nRDATE:19310426T030000\r\nRDATE:19320424T030000\r\nRDATE:19330430T030000\r\nRDATE:19340429T030000\r\nRDATE:19350428T030000\r\nRDATE:19360426T030000\r\nRDATE:19370425T030000\r\nRDATE:19380424T030000\r\nRDATE:19390430T030000\r\nRDATE:19400428T030000\r\nRDATE:19410427T030000\r\nRDATE:19460428T030000\r\nRDATE:19470427T030000\r\nRDATE:19480425T030000\r\nRDATE:19490424T030000\r\nRDATE:19500430T030000\r\nRDATE:19510429T030000\r\nRDATE:19520427T030000\r\nRDATE:19530426T030000\r\nRDATE:19540425T030000\r\nRDATE:19550424T030000\r\nRDATE:19560429T030000\r\nRDATE:19570428T030000\r\nRDATE:19580427T030000\r\nRDATE:19590426T030000\r\nRDATE:19600424T030000\r\nRDATE:19610430T030000\r\nRDATE:19620429T030000\r\nRDATE:19630428T030000\r\nRDATE:19640426T030000\r\nRDATE:19650425T030000\r\nRDATE:19660424T030000\r\nRDATE:19670430T030000\r\nRDATE:19680428T030000\r\nRDATE:19690427T030000\r\nRDATE:19700426T030000\r\nRDATE:19710425T030000\r\nRDATE:19720430T030000\r\nRDATE:19730429T030000\r\nRDATE:19740106T030000\r\nRDATE:19750223T030000\r\nRDATE:19760425T030000\r\nRDATE:19770424T030000\r\nRDATE:19780430T030000\r\nRDATE:19790429T030000\r\nRDATE:19800427T030000\r\nRDATE:19810426T030000\r\nRDATE:19820425T030000\r\nRDATE:19830424T030000\r\nRDATE:19840429T030000\r\nRDATE:19850428T030000\r\nRDATE:19860427T030000\r\nRDATE:19870405T030000\r\nRDATE:19880403T030000\r\nRDATE:19890402T030000\r\nRDATE:19900401T030000\r\nRDATE:19910407T030000\r\nRDATE:19920405T030000\r\nRDATE:19930404T030000\r\nRDATE:19940403T030000\r\nRDATE:19950402T030000\r\nRDATE:19960407T030000\r\nRDATE:19970406T030000\r\nRDATE:19980405T030000\r\nRDATE:19990404T030000\r\nRDATE:20000402T030000\r\nRDATE:20010401T030000\r\nRDATE:20020407T030000\r\nRDATE:20030406T030000\r\nRDATE:20040404T030000\r\nRDATE:20050403T030000\r\nRDATE:20060402T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0400\r\nTZOFFSETTO:-0500\r\nTZNAME:EST\r\nDTSTART:19181027T020000\r\nRDATE:19181027T020000\r\nRDATE:19191026T020000\r\nRDATE:19201031T020000\r\nRDATE:19210925T020000\r\nRDATE:19220924T020000\r\nRDATE:19230930T020000\r\nRDATE:19240928T020000\r\nRDATE:19250927T020000\r\nRDATE:19260926T020000\r\nRDATE:19270925T020000\r\nRDATE:19280930T020000\r\nRDATE:19290929T020000\r\nRDATE:19300928T020000\r\nRDATE:19310927T020000\r\nRDATE:19320925T020000\r\nRDATE:19330924T020000\r\nRDATE:19340930T020000\r\nRDATE:19350929T020000\r\nRDATE:19360927T020000\r\nRDATE:19370926T020000\r\nRDATE:19380925T020000\r\nRDATE:19390924T020000\r\nRDATE:19400929T020000\r\nRDATE:19410928T020000\r\nRDATE:19450930T020000\r\nRDATE:19460929T020000\r\nRDATE:19470928T020000\r\nRDATE:19480926T020000\r\nRDATE:19490925T020000\r\nRDATE:19500924T020000\r\nRDATE:19510930T020000\r\nRDATE:19520928T020000\r\nRDATE:19530927T020000\r\nRDATE:19540926T020000\r\nRDATE:19551030T020000\r\nRDATE:19561028T020000\r\nRDATE:19571027T020000\r\nRDATE:19581026T020000\r\nRDATE:19591025T020000\r\nRDATE:19601030T020000\r\nRDATE:19611029T020000\r\nRDATE:19621028T020000\r\nRDATE:19631027T020000\r\nRDATE:19641025T020000\r\nRDATE:19651031T020000\r\nRDATE:19661030T020000\r\nRDATE:19671029T020000\r\nRDATE:19681027T020000\r\nRDATE:19691026T020000\r\nRDATE:19701025T020000\r\nRDATE:19711031T020000\r\nRDATE:19721029T020000\r\nRDATE:19731028T020000\r\nRDATE:19741027T020000\r\nRDATE:19751026T020000\r\nRDATE:19761031T020000\r\nRDATE:19771030T020000\r\nRDATE:19781029T020000\r\nRDATE:19791028T020000\r\nRDATE:19801026T020000\r\nRDATE:19811025T020000\r\nRDATE:19821031T020000\r\nRDATE:19831030T020000\r\nRDATE:19841028T020000\r\nRDATE:19851027T020000\r\nRDATE:19861026T020000\r\nRDATE:19871025T020000\r\nRDATE:19881030T020000\r\nRDATE:19891029T020000\r\nRDATE:19901028T020000\r\nRDATE:19911027T020000\r\nRDATE:19921025T020000\r\nRDATE:19931031T020000\r\nRDATE:19941030T020000\r\nRDATE:19951029T020000\r\nRDATE:19961027T020000\r\nRDATE:19971026T020000\r\nRDATE:19981025T020000\r\nRDATE:19991031T020000\r\nRDATE:20001029T020000\r\nRDATE:20011028T020000\r\nRDATE:20021027T020000\r\nRDATE:20031026T020000\r\nRDATE:20041031T020000\r\nRDATE:20051030T020000\r\nRDATE:20061029T020000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0500\r\nTZOFFSETTO:-0500\r\nTZNAME:EST\r\nDTSTART:19200101T000000\r\nRDATE:19200101T000000\r\nRDATE:19420101T000000\r\nRDATE:19460101T000000\r\nRDATE:19670101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0500\r\nTZOFFSETTO:-0400\r\nTZNAME:EWT\r\nDTSTART:19420209T030000\r\nRDATE:19420209T030000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0400\r\nTZOFFSETTO:-0400\r\nTZNAME:EPT\r\nDTSTART:19450814T190000\r\nRDATE:19450814T190000\r\nEND:DAYLIGHT\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Egypt Standard Time che sara' Africa/Cairo (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Egypt Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Africa/Cairo\r\nX-LIC-LOCATION:Africa/Cairo\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0300\r\nTZNAME:EEST\r\nDTSTART:19950428T000000\r\nRRULE:FREQ=YEARLY;BYMONTH=4;BYDAY=-1FR\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:20070927T230000\r\nRRULE:FREQ=YEARLY;BYMONTH=9;BYDAY=-1TH\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0205\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:19001001T000000\r\nRDATE:19001001T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0300\r\nTZNAME:EEST\r\nDTSTART:19400715T000000\r\nRDATE:19400715T000000\r\nRDATE:19410415T000000\r\nRDATE:19420401T000000\r\nRDATE:19430401T000000\r\nRDATE:19440401T000000\r\nRDATE:19450416T000000\r\nRDATE:19570510T000000\r\nRDATE:19580501T000000\r\nRDATE:19590501T010000\r\nRDATE:19600501T010000\r\nRDATE:19610501T010000\r\nRDATE:19620501T010000\r\nRDATE:19630501T010000\r\nRDATE:19640501T010000\r\nRDATE:19650501T010000\r\nRDATE:19660501T010000\r\nRDATE:19670501T010000\r\nRDATE:19680501T010000\r\nRDATE:19690501T010000\r\nRDATE:19700501T010000\r\nRDATE:19710501T010000\r\nRDATE:19720501T010000\r\nRDATE:19730501T010000\r\nRDATE:19740501T010000\r\nRDATE:19750501T010000\r\nRDATE:19760501T010000\r\nRDATE:19770501T010000\r\nRDATE:19780501T010000\r\nRDATE:19790501T010000\r\nRDATE:19800501T010000\r\nRDATE:19810501T010000\r\nRDATE:19820725T010000\r\nRDATE:19830712T010000\r\nRDATE:19840501T010000\r\nRDATE:19850501T010000\r\nRDATE:19860501T010000\r\nRDATE:19870501T010000\r\nRDATE:19880501T010000\r\nRDATE:19890506T010000\r\nRDATE:19900501T010000\r\nRDATE:19910501T010000\r\nRDATE:19920501T010000\r\nRDATE:19930501T010000\r\nRDATE:19940501T010000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:19401001T000000\r\nRDATE:19401001T000000\r\nRDATE:19410916T000000\r\nRDATE:19421027T000000\r\nRDATE:19431101T000000\r\nRDATE:19441101T000000\r\nRDATE:19451101T000000\r\nRDATE:19571001T000000\r\nRDATE:19581001T000000\r\nRDATE:19590930T030000\r\nRDATE:19600930T030000\r\nRDATE:19610930T030000\r\nRDATE:19620930T030000\r\nRDATE:19630930T030000\r\nRDATE:19640930T030000\r\nRDATE:19650930T030000\r\nRDATE:19661001T030000\r\nRDATE:19671001T030000\r\nRDATE:19681001T030000\r\nRDATE:19691001T030000\r\nRDATE:19701001T030000\r\nRDATE:19711001T030000\r\nRDATE:19721001T030000\r\nRDATE:19731001T030000\r\nRDATE:19741001T030000\r\nRDATE:19751001T030000\r\nRDATE:19761001T030000\r\nRDATE:19771001T030000\r\nRDATE:19781001T030000\r\nRDATE:19791001T030000\r\nRDATE:19801001T030000\r\nRDATE:19811001T030000\r\nRDATE:19821001T030000\r\nRDATE:19831001T030000\r\nRDATE:19841001T030000\r\nRDATE:19851001T030000\r\nRDATE:19861001T030000\r\nRDATE:19871001T030000\r\nRDATE:19881001T030000\r\nRDATE:19891001T030000\r\nRDATE:19901001T030000\r\nRDATE:19911001T030000\r\nRDATE:19921001T030000\r\nRDATE:19931001T030000\r\nRDATE:19941001T030000\r\nRDATE:19950929T000000\r\nRDATE:19960927T000000\r\nRDATE:19970926T000000\r\nRDATE:19980925T000000\r\nRDATE:19991001T000000\r\nRDATE:20000929T000000\r\nRDATE:20010928T000000\r\nRDATE:20020927T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:20030925T230000\r\nRDATE:20030925T230000\r\nRDATE:20040930T230000\r\nRDATE:20050929T230000\r\nRDATE:20060921T230000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Ekaterinburg Standard Time che sara' Asia/Yekaterinburg (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Ekaterinburg Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Yekaterinburg\r\nX-LIC-LOCATION:Asia/Yekaterinburg\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0500\r\nTZOFFSETTO:+0600\r\nTZNAME:YEKST\r\nDTSTART:19930328T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0600\r\nTZOFFSETTO:+0500\r\nTZNAME:YEKT\r\nDTSTART:19961027T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+040224\r\nTZOFFSETTO:+0400\r\nTZNAME:SVET\r\nDTSTART:19190715T040000\r\nRDATE:19190715T040000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0500\r\nTZNAME:SVET\r\nDTSTART:19300621T000000\r\nRDATE:19300621T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0500\r\nTZOFFSETTO:+0600\r\nTZNAME:SVEST\r\nDTSTART:19810401T000000\r\nRDATE:19810401T000000\r\nRDATE:19820401T000000\r\nRDATE:19830401T000000\r\nRDATE:19840401T000000\r\nRDATE:19850331T030000\r\nRDATE:19860330T030000\r\nRDATE:19870329T030000\r\nRDATE:19880327T030000\r\nRDATE:19890326T030000\r\nRDATE:19900325T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0600\r\nTZOFFSETTO:+0500\r\nTZNAME:SVET\r\nDTSTART:19811001T000000\r\nRDATE:19811001T000000\r\nRDATE:19821001T000000\r\nRDATE:19831001T000000\r\nRDATE:19840930T030000\r\nRDATE:19850929T030000\r\nRDATE:19860928T030000\r\nRDATE:19870927T030000\r\nRDATE:19880925T030000\r\nRDATE:19890924T030000\r\nRDATE:19900930T030000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0500\r\nTZOFFSETTO:+0500\r\nTZNAME:SVEST\r\nDTSTART:19910331T030000\r\nRDATE:19910331T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0500\r\nTZOFFSETTO:+0400\r\nTZNAME:SVET\r\nDTSTART:19910929T030000\r\nRDATE:19910929T030000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0500\r\nTZNAME:YEKT\r\nDTSTART:19920119T020000\r\nRDATE:19920119T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0500\r\nTZOFFSETTO:+0600\r\nTZNAME:YEKST\r\nDTSTART:19920328T230000\r\nRDATE:19920328T230000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0600\r\nTZOFFSETTO:+0500\r\nTZNAME:YEKT\r\nDTSTART:19920926T230000\r\nRDATE:19920926T230000\r\nRDATE:19930926T030000\r\nRDATE:19940925T030000\r\nRDATE:19950924T030000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: FLE Standard Time che sara' Europe/Kiev (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'FLE Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Europe/Kiev\r\nX-LIC-LOCATION:Europe/Kiev\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0300\r\nTZNAME:EEST\r\nDTSTART:19950326T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:19961027T040000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+020204\r\nTZOFFSETTO:+020204\r\nTZNAME:KMT\r\nDTSTART:18800101T000000\r\nRDATE:18800101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+020204\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:19240502T000000\r\nRDATE:19240502T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0300\r\nTZNAME:MSK\r\nDTSTART:19300621T000000\r\nRDATE:19300621T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0200\r\nTZNAME:CEST\r\nDTSTART:19410920T000000\r\nRDATE:19410920T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0100\r\nTZNAME:CET\r\nDTSTART:19421102T030000\r\nRDATE:19421102T030000\r\nRDATE:19431004T030000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0200\r\nTZNAME:CEST\r\nDTSTART:19430329T030000\r\nRDATE:19430329T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0300\r\nTZNAME:MSK\r\nDTSTART:19431106T000000\r\nRDATE:19431106T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0400\r\nTZNAME:MSD\r\nDTSTART:19810401T000000\r\nRDATE:19810401T000000\r\nRDATE:19820401T000000\r\nRDATE:19830401T000000\r\nRDATE:19840401T000000\r\nRDATE:19850331T030000\r\nRDATE:19860330T030000\r\nRDATE:19870329T030000\r\nRDATE:19880327T030000\r\nRDATE:19890326T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0300\r\nTZNAME:MSK\r\nDTSTART:19811001T000000\r\nRDATE:19811001T000000\r\nRDATE:19821001T000000\r\nRDATE:19831001T000000\r\nRDATE:19840930T030000\r\nRDATE:19850929T030000\r\nRDATE:19860928T030000\r\nRDATE:19870927T030000\r\nRDATE:19880925T030000\r\nRDATE:19890924T030000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0300\r\nTZNAME:MSK\r\nDTSTART:19900101T000000\r\nRDATE:19900101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:19900701T020000\r\nRDATE:19900701T020000\r\nRDATE:19920927T000000\r\nRDATE:19930926T000000\r\nRDATE:19940925T000000\r\nRDATE:19950924T040000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:19920101T000000\r\nRDATE:19920101T000000\r\nRDATE:19950101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0300\r\nTZNAME:EEST\r\nDTSTART:19920329T000000\r\nRDATE:19920329T000000\r\nRDATE:19930328T000000\r\nRDATE:19940327T000000\r\nEND:DAYLIGHT\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Fiji Standard Time che sara' Pacific/Fiji (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Fiji Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Pacific/Fiji\r\nX-LIC-LOCATION:Pacific/Fiji\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+115340\r\nTZOFFSETTO:+1200\r\nTZNAME:FJT\r\nDTSTART:19151026T000000\r\nRDATE:19151026T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+1200\r\nTZOFFSETTO:+1300\r\nTZNAME:FJST\r\nDTSTART:19981101T020000\r\nRDATE:19981101T020000\r\nRDATE:19991107T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1300\r\nTZOFFSETTO:+1200\r\nTZNAME:FJT\r\nDTSTART:19990228T030000\r\nRDATE:19990228T030000\r\nRDATE:20000227T030000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: GMT Standard Time che sara' Europe/London (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'GMT Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Europe/London\r\nX-LIC-LOCATION:Europe/London\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0000\r\nTZOFFSETTO:+0100\r\nTZNAME:BST\r\nDTSTART:19810329T010000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0000\r\nTZNAME:GMT\r\nDTSTART:19961027T020000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-000115\r\nTZOFFSETTO:+0000\r\nTZNAME:GMT\r\nDTSTART:18471201T000000\r\nRDATE:18471201T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0000\r\nTZOFFSETTO:+0100\r\nTZNAME:BST\r\nDTSTART:19160521T020000\r\nRDATE:19160521T020000\r\nRDATE:19170408T020000\r\nRDATE:19180324T020000\r\nRDATE:19190330T030000\r\nRDATE:19200328T030000\r\nRDATE:19210403T020000\r\nRDATE:19220326T020000\r\nRDATE:19230422T020000\r\nRDATE:19240413T020000\r\nRDATE:19250419T020000\r\nRDATE:19260418T020000\r\nRDATE:19270410T020000\r\nRDATE:19280422T020000\r\nRDATE:19290421T020000\r\nRDATE:19300413T020000\r\nRDATE:19310419T020000\r\nRDATE:19320417T020000\r\nRDATE:19330409T020000\r\nRDATE:19340422T020000\r\nRDATE:19350414T020000\r\nRDATE:19360419T020000\r\nRDATE:19370418T020000\r\nRDATE:19380410T020000\r\nRDATE:19390416T020000\r\nRDATE:19400225T020000\r\nRDATE:19460414T020000\r\nRDATE:19470316T020000\r\nRDATE:19480314T020000\r\nRDATE:19490403T020000\r\nRDATE:19500416T020000\r\nRDATE:19510415T020000\r\nRDATE:19520420T020000\r\nRDATE:19530419T020000\r\nRDATE:19540411T020000\r\nRDATE:19550417T020000\r\nRDATE:19560422T020000\r\nRDATE:19570414T020000\r\nRDATE:19580420T020000\r\nRDATE:19590419T020000\r\nRDATE:19600410T020000\r\nRDATE:19610326T020000\r\nRDATE:19620325T020000\r\nRDATE:19630331T020000\r\nRDATE:19640322T020000\r\nRDATE:19650321T020000\r\nRDATE:19660320T020000\r\nRDATE:19670319T020000\r\nRDATE:19680218T020000\r\nRDATE:19720319T020000\r\nRDATE:19730318T020000\r\nRDATE:19740317T020000\r\nRDATE:19750316T020000\r\nRDATE:19760321T020000\r\nRDATE:19770320T020000\r\nRDATE:19780319T020000\r\nRDATE:19790318T020000\r\nRDATE:19800316T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0000\r\nTZNAME:GMT\r\nDTSTART:19161001T030000\r\nRDATE:19161001T030000\r\nRDATE:19170917T030000\r\nRDATE:19180930T030000\r\nRDATE:19190929T030000\r\nRDATE:19201025T030000\r\nRDATE:19211003T030000\r\nRDATE:19221008T030000\r\nRDATE:19230916T030000\r\nRDATE:19240921T030000\r\nRDATE:19251004T030000\r\nRDATE:19261003T030000\r\nRDATE:19271002T030000\r\nRDATE:19281007T030000\r\nRDATE:19291006T030000\r\nRDATE:19301005T030000\r\nRDATE:19311004T030000\r\nRDATE:19321002T030000\r\nRDATE:19331008T030000\r\nRDATE:19341007T030000\r\nRDATE:19351006T030000\r\nRDATE:19361004T030000\r\nRDATE:19371003T030000\r\nRDATE:19381002T030000\r\nRDATE:19391119T030000\r\nRDATE:19451007T030000\r\nRDATE:19461006T030000\r\nRDATE:19471102T030000\r\nRDATE:19481031T030000\r\nRDATE:19491030T030000\r\nRDATE:19501022T030000\r\nRDATE:19511021T030000\r\nRDATE:19521026T030000\r\nRDATE:19531004T030000\r\nRDATE:19541003T030000\r\nRDATE:19551002T030000\r\nRDATE:19561007T030000\r\nRDATE:19571006T030000\r\nRDATE:19581005T030000\r\nRDATE:19591004T030000\r\nRDATE:19601002T030000\r\nRDATE:19611029T030000\r\nRDATE:19621028T030000\r\nRDATE:19631027T030000\r\nRDATE:19641025T030000\r\nRDATE:19651024T030000\r\nRDATE:19661023T030000\r\nRDATE:19671029T030000\r\nRDATE:19711031T030000\r\nRDATE:19721029T030000\r\nRDATE:19731028T030000\r\nRDATE:19741027T030000\r\nRDATE:19751026T030000\r\nRDATE:19761024T030000\r\nRDATE:19771023T030000\r\nRDATE:19781029T030000\r\nRDATE:19791028T030000\r\nRDATE:19801026T030000\r\nRDATE:19811025T020000\r\nRDATE:19821024T020000\r\nRDATE:19831023T020000\r\nRDATE:19841028T020000\r\nRDATE:19851027T020000\r\nRDATE:19861026T020000\r\nRDATE:19871025T020000\r\nRDATE:19881023T020000\r\nRDATE:19891029T020000\r\nRDATE:19901028T020000\r\nRDATE:19911027T020000\r\nRDATE:19921025T020000\r\nRDATE:19931024T020000\r\nRDATE:19941023T020000\r\nRDATE:19951022T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0200\r\nTZNAME:BDST\r\nDTSTART:19410504T020000\r\nRDATE:19410504T020000\r\nRDATE:19420405T020000\r\nRDATE:19430404T020000\r\nRDATE:19440402T020000\r\nRDATE:19450402T030000\r\nRDATE:19470413T020000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0100\r\nTZNAME:BST\r\nDTSTART:19410810T030000\r\nRDATE:19410810T030000\r\nRDATE:19420809T030000\r\nRDATE:19430815T030000\r\nRDATE:19440917T030000\r\nRDATE:19450715T030000\r\nRDATE:19470810T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0100\r\nTZNAME:BST\r\nDTSTART:19681027T000000\r\nRDATE:19681027T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0000\r\nTZOFFSETTO:+0000\r\nTZNAME:GMT\r\nDTSTART:19960101T000000\r\nRDATE:19960101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: GTB Standard Time che sara' Europe/Istanbul (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'GTB Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Europe/Istanbul\r\nX-LIC-LOCATION:Europe/Istanbul\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0300\r\nTZNAME:EEST\r\nDTSTART:20070325T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:20071028T040000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+015552\r\nTZOFFSETTO:+015656\r\nTZNAME:IMT\r\nDTSTART:18800101T000000\r\nRDATE:18800101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+015656\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:19101001T000000\r\nRDATE:19101001T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0300\r\nTZNAME:EEST\r\nDTSTART:19160501T000000\r\nRDATE:19160501T000000\r\nRDATE:19200328T000000\r\nRDATE:19210403T000000\r\nRDATE:19220326T000000\r\nRDATE:19240513T000000\r\nRDATE:19250501T000000\r\nRDATE:19400630T000000\r\nRDATE:19401201T000000\r\nRDATE:19420401T000000\r\nRDATE:19450402T000000\r\nRDATE:19460601T000000\r\nRDATE:19470420T000000\r\nRDATE:19480418T000000\r\nRDATE:19490410T000000\r\nRDATE:19500419T000000\r\nRDATE:19510422T000000\r\nRDATE:19620715T000000\r\nRDATE:19640515T000000\r\nRDATE:19700503T000000\r\nRDATE:19710502T000000\r\nRDATE:19720507T000000\r\nRDATE:19730603T010000\r\nRDATE:19740331T020000\r\nRDATE:19750330T000000\r\nRDATE:19760601T000000\r\nRDATE:19770403T000000\r\nRDATE:19780402T000000\r\nRDATE:19860330T030000\r\nRDATE:19870329T030000\r\nRDATE:19880327T030000\r\nRDATE:19890326T030000\r\nRDATE:19900325T030000\r\nRDATE:19910331T010000\r\nRDATE:19920329T010000\r\nRDATE:19930328T010000\r\nRDATE:19940327T010000\r\nRDATE:19950326T010000\r\nRDATE:19960331T010000\r\nRDATE:19970330T010000\r\nRDATE:19980329T010000\r\nRDATE:19990328T010000\r\nRDATE:20000326T010000\r\nRDATE:20010325T010000\r\nRDATE:20020331T010000\r\nRDATE:20030330T010000\r\nRDATE:20040328T010000\r\nRDATE:20050327T010000\r\nRDATE:20060326T010000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:19161001T000000\r\nRDATE:19161001T000000\r\nRDATE:19201025T000000\r\nRDATE:19211003T000000\r\nRDATE:19221008T000000\r\nRDATE:19241001T000000\r\nRDATE:19251001T000000\r\nRDATE:19401005T000000\r\nRDATE:19410921T000000\r\nRDATE:19421101T000000\r\nRDATE:19451008T000000\r\nRDATE:19461001T000000\r\nRDATE:19471005T000000\r\nRDATE:19481003T000000\r\nRDATE:19491002T000000\r\nRDATE:19501008T000000\r\nRDATE:19511008T000000\r\nRDATE:19621008T000000\r\nRDATE:19641001T000000\r\nRDATE:19701004T000000\r\nRDATE:19711003T000000\r\nRDATE:19721008T000000\r\nRDATE:19731104T030000\r\nRDATE:19741103T050000\r\nRDATE:19751026T000000\r\nRDATE:19761031T000000\r\nRDATE:19771016T000000\r\nRDATE:19850928T000000\r\nRDATE:19860928T030000\r\nRDATE:19870927T030000\r\nRDATE:19880925T030000\r\nRDATE:19890924T030000\r\nRDATE:19900930T030000\r\nRDATE:19910929T020000\r\nRDATE:19920927T020000\r\nRDATE:19930926T020000\r\nRDATE:19940925T020000\r\nRDATE:19950924T020000\r\nRDATE:19961027T020000\r\nRDATE:19971026T020000\r\nRDATE:19981025T020000\r\nRDATE:19991031T020000\r\nRDATE:20001029T020000\r\nRDATE:20011028T020000\r\nRDATE:20021027T020000\r\nRDATE:20031026T020000\r\nRDATE:20041031T020000\r\nRDATE:20051030T020000\r\nRDATE:20061029T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0400\r\nTZNAME:TRST\r\nDTSTART:19781015T000000\r\nRDATE:19781015T000000\r\nRDATE:19800406T030000\r\nRDATE:19810329T030000\r\nRDATE:19820328T030000\r\nRDATE:19830731T000000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0400\r\nTZNAME:TRST\r\nDTSTART:19790401T030000\r\nRDATE:19790401T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0300\r\nTZNAME:TRT\r\nDTSTART:19791015T000000\r\nRDATE:19791015T000000\r\nRDATE:19801013T000000\r\nRDATE:19811012T000000\r\nRDATE:19821011T000000\r\nRDATE:19831002T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0300\r\nTZNAME:EEST\r\nDTSTART:19850420T000000\r\nRDATE:19850420T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:20070101T000000\r\nRDATE:20070101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Georgian Standard Time che sara' Etc/GMT-3 (0) NON TROVATO OK */
INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Georgian Standard Time',1,'T',NULL,NULL);

/* Analizzo: Greenland Standard Time che sara' America/Godthab (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Greenland Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/Godthab\r\nX-LIC-LOCATION:America/Godthab\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0300\r\nTZOFFSETTO:-0200\r\nTZNAME:WGST\r\nDTSTART:19810328T220000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYMONTHDAY=24,25,26,27,28,29,30;BYDAY=SA\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0200\r\nTZOFFSETTO:-0300\r\nTZNAME:WGT\r\nDTSTART:19961026T230000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYMONTHDAY=24,25,26,27,28,29,30;BYDAY=SA\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-032656\r\nTZOFFSETTO:-0300\r\nTZNAME:WGT\r\nDTSTART:19160728T000000\r\nRDATE:19160728T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0300\r\nTZOFFSETTO:-0200\r\nTZNAME:WGST\r\nDTSTART:19800406T030000\r\nRDATE:19800406T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0200\r\nTZOFFSETTO:-0300\r\nTZNAME:WGT\r\nDTSTART:19800927T230000\r\nRDATE:19800927T230000\r\nRDATE:19810926T230000\r\nRDATE:19820925T230000\r\nRDATE:19830924T230000\r\nRDATE:19840929T230000\r\nRDATE:19850928T230000\r\nRDATE:19860927T230000\r\nRDATE:19870926T230000\r\nRDATE:19880924T230000\r\nRDATE:19890923T230000\r\nRDATE:19900929T230000\r\nRDATE:19910928T230000\r\nRDATE:19920926T230000\r\nRDATE:19930925T230000\r\nRDATE:19940924T230000\r\nRDATE:19950923T230000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Greenwich Standard Time che sara' Atlantic/Reykjavik (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Greenwich Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Atlantic/Reykjavik\r\nX-LIC-LOCATION:Atlantic/Reykjavik\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-012724\r\nTZOFFSETTO:-012748\r\nTZNAME:RMT\r\nDTSTART:18370101T000000\r\nRDATE:18370101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-012748\r\nTZOFFSETTO:-0100\r\nTZNAME:IST\r\nDTSTART:19080101T000000\r\nRDATE:19080101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0100\r\nTZOFFSETTO:+0000\r\nTZNAME:ISST\r\nDTSTART:19170219T230000\r\nRDATE:19170219T230000\r\nRDATE:19180219T230000\r\nRDATE:19390429T230000\r\nRDATE:19400225T020000\r\nRDATE:19410302T010000\r\nRDATE:19420308T010000\r\nRDATE:19430307T010000\r\nRDATE:19440305T010000\r\nRDATE:19450304T010000\r\nRDATE:19460303T010000\r\nRDATE:19470406T010000\r\nRDATE:19480404T010000\r\nRDATE:19490403T010000\r\nRDATE:19500402T010000\r\nRDATE:19510401T010000\r\nRDATE:19520406T010000\r\nRDATE:19530405T010000\r\nRDATE:19540404T010000\r\nRDATE:19550403T010000\r\nRDATE:19560401T010000\r\nRDATE:19570407T010000\r\nRDATE:19580406T010000\r\nRDATE:19590405T010000\r\nRDATE:19600403T010000\r\nRDATE:19610402T010000\r\nRDATE:19620401T010000\r\nRDATE:19630407T010000\r\nRDATE:19640405T010000\r\nRDATE:19650404T010000\r\nRDATE:19660403T010000\r\nRDATE:19670402T010000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0000\r\nTZOFFSETTO:-0100\r\nTZNAME:IST\r\nDTSTART:19171021T010000\r\nRDATE:19171021T010000\r\nRDATE:19181116T010000\r\nRDATE:19391129T020000\r\nRDATE:19401103T020000\r\nRDATE:19411102T020000\r\nRDATE:19421025T020000\r\nRDATE:19431024T020000\r\nRDATE:19441022T020000\r\nRDATE:19451028T020000\r\nRDATE:19461027T020000\r\nRDATE:19471026T020000\r\nRDATE:19481024T020000\r\nRDATE:19491030T020000\r\nRDATE:19501022T020000\r\nRDATE:19511028T020000\r\nRDATE:19521026T020000\r\nRDATE:19531025T020000\r\nRDATE:19541024T020000\r\nRDATE:19551023T020000\r\nRDATE:19561028T020000\r\nRDATE:19571027T020000\r\nRDATE:19581026T020000\r\nRDATE:19591025T020000\r\nRDATE:19601023T020000\r\nRDATE:19611022T020000\r\nRDATE:19621028T020000\r\nRDATE:19631027T020000\r\nRDATE:19641025T020000\r\nRDATE:19651024T020000\r\nRDATE:19661023T020000\r\nRDATE:19671029T020000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0100\r\nTZOFFSETTO:+0000\r\nTZNAME:GMT\r\nDTSTART:19680407T010000\r\nRDATE:19680407T010000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Hawaiian Standard Time che sara' Pacific/Honolulu (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Hawaiian Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Pacific/Honolulu\r\nX-LIC-LOCATION:Pacific/Honolulu\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-103126\r\nTZOFFSETTO:-1030\r\nTZNAME:HST\r\nDTSTART:19000101T120000\r\nRDATE:19000101T120000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-1030\r\nTZOFFSETTO:-0930\r\nTZNAME:HDT\r\nDTSTART:19330430T030000\r\nRDATE:19330430T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0930\r\nTZOFFSETTO:-1030\r\nTZNAME:HST\r\nDTSTART:19330521T020000\r\nRDATE:19330521T020000\r\nRDATE:19450930T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-1030\r\nTZOFFSETTO:-0930\r\nTZNAME:HWT\r\nDTSTART:19420209T030000\r\nRDATE:19420209T030000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0930\r\nTZOFFSETTO:-0930\r\nTZNAME:HPT\r\nDTSTART:19450814T133000\r\nRDATE:19450814T133000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-1030\r\nTZOFFSETTO:-1000\r\nTZNAME:HST\r\nDTSTART:19470608T020000\r\nRDATE:19470608T020000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: India Standard Time che sara' Asia/Calcutta (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'India Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Calcutta\r\nX-LIC-LOCATION:Asia/Calcutta\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+055328\r\nTZOFFSETTO:+055320\r\nTZNAME:HMT\r\nDTSTART:18800101T000000\r\nRDATE:18800101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+055320\r\nTZOFFSETTO:+0630\r\nTZNAME:BURT\r\nDTSTART:19411001T000000\r\nRDATE:19411001T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0630\r\nTZOFFSETTO:+0530\r\nTZNAME:IST\r\nDTSTART:19420515T000000\r\nRDATE:19420515T000000\r\nRDATE:19451015T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0530\r\nTZOFFSETTO:+0630\r\nTZNAME:IST\r\nDTSTART:19420901T000000\r\nRDATE:19420901T000000\r\nEND:DAYLIGHT\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Iran Standard Time che sara' Asia/Tehran (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Iran Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Tehran\r\nX-LIC-LOCATION:Asia/Tehran\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+032544\r\nTZOFFSETTO:+032544\r\nTZNAME:TMT\r\nDTSTART:19160101T000000\r\nRDATE:19160101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+032544\r\nTZOFFSETTO:+0330\r\nTZNAME:IRST\r\nDTSTART:19460101T000000\r\nRDATE:19460101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0330\r\nTZOFFSETTO:+0400\r\nTZNAME:IRST\r\nDTSTART:19771101T000000\r\nRDATE:19771101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0500\r\nTZNAME:IRDT\r\nDTSTART:19780321T000000\r\nRDATE:19780321T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0500\r\nTZOFFSETTO:+0400\r\nTZNAME:IRST\r\nDTSTART:19781021T000000\r\nRDATE:19781021T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0330\r\nTZNAME:IRST\r\nDTSTART:19790101T000000\r\nRDATE:19790101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0330\r\nTZOFFSETTO:+0430\r\nTZNAME:IRDT\r\nDTSTART:19790321T000000\r\nRDATE:19790321T000000\r\nRDATE:19800321T000000\r\nRDATE:19910503T000000\r\nRDATE:19920322T000000\r\nRDATE:19930322T000000\r\nRDATE:19940322T000000\r\nRDATE:19950322T000000\r\nRDATE:19960321T000000\r\nRDATE:19970322T000000\r\nRDATE:19980322T000000\r\nRDATE:19990322T000000\r\nRDATE:20000321T000000\r\nRDATE:20010322T000000\r\nRDATE:20020322T000000\r\nRDATE:20030322T000000\r\nRDATE:20040321T000000\r\nRDATE:20050322T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0430\r\nTZOFFSETTO:+0330\r\nTZNAME:IRST\r\nDTSTART:19790919T000000\r\nRDATE:19790919T000000\r\nRDATE:19800923T000000\r\nRDATE:19910922T000000\r\nRDATE:19920922T000000\r\nRDATE:19930922T000000\r\nRDATE:19940922T000000\r\nRDATE:19950922T000000\r\nRDATE:19960921T000000\r\nRDATE:19970922T000000\r\nRDATE:19980922T000000\r\nRDATE:19990922T000000\r\nRDATE:20000921T000000\r\nRDATE:20010922T000000\r\nRDATE:20020922T000000\r\nRDATE:20030922T000000\r\nRDATE:20040921T000000\r\nRDATE:20050922T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Israel Standard Time che sara' Asia/Jerusalem (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Israel Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Jerusalem\r\nX-LIC-LOCATION:Asia/Jerusalem\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+022056\r\nTZOFFSETTO:+022040\r\nTZNAME:JMT\r\nDTSTART:18800101T000000\r\nRDATE:18800101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+022040\r\nTZOFFSETTO:+0200\r\nTZNAME:IST\r\nDTSTART:19180101T000000\r\nRDATE:19180101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0300\r\nTZNAME:IDT\r\nDTSTART:19400601T000000\r\nRDATE:19400601T000000\r\nRDATE:19430401T020000\r\nRDATE:19440401T000000\r\nRDATE:19450416T000000\r\nRDATE:19460416T020000\r\nRDATE:19490501T000000\r\nRDATE:19500416T000000\r\nRDATE:19510401T000000\r\nRDATE:19520420T020000\r\nRDATE:19530412T020000\r\nRDATE:19540613T000000\r\nRDATE:19550611T020000\r\nRDATE:19560603T000000\r\nRDATE:19570429T020000\r\nRDATE:19740707T000000\r\nRDATE:19750420T000000\r\nRDATE:19850414T000000\r\nRDATE:19860518T000000\r\nRDATE:19870415T000000\r\nRDATE:19880409T000000\r\nRDATE:19890430T000000\r\nRDATE:19900325T000000\r\nRDATE:19910324T000000\r\nRDATE:19920329T000000\r\nRDATE:19930402T000000\r\nRDATE:19940401T000000\r\nRDATE:19950331T000000\r\nRDATE:19960315T000000\r\nRDATE:19970321T000000\r\nRDATE:19980320T000000\r\nRDATE:19990402T020000\r\nRDATE:20000414T020000\r\nRDATE:20010409T010000\r\nRDATE:20020329T010000\r\nRDATE:20030328T010000\r\nRDATE:20040407T010000\r\nRDATE:20050401T020000\r\nRDATE:20060331T020000\r\nRDATE:20070330T020000\r\nRDATE:20080328T020000\r\nRDATE:20090327T020000\r\nRDATE:20100326T020000\r\nRDATE:20110401T020000\r\nRDATE:20120330T020000\r\nRDATE:20130329T020000\r\nRDATE:20140328T020000\r\nRDATE:20150327T020000\r\nRDATE:20160401T020000\r\nRDATE:20170331T020000\r\nRDATE:20180330T020000\r\nRDATE:20190329T020000\r\nRDATE:20200327T020000\r\nRDATE:20210326T020000\r\nRDATE:20220401T020000\r\nRDATE:20230331T020000\r\nRDATE:20240329T020000\r\nRDATE:20250328T020000\r\nRDATE:20260327T020000\r\nRDATE:20270326T020000\r\nRDATE:20280331T020000\r\nRDATE:20290330T020000\r\nRDATE:20300329T020000\r\nRDATE:20310328T020000\r\nRDATE:20320326T020000\r\nRDATE:20330401T020000\r\nRDATE:20340331T020000\r\nRDATE:20350330T020000\r\nRDATE:20360328T020000\r\nRDATE:20370327T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0200\r\nTZNAME:IST\r\nDTSTART:19421101T000000\r\nRDATE:19421101T000000\r\nRDATE:19431101T000000\r\nRDATE:19441101T000000\r\nRDATE:19451101T020000\r\nRDATE:19461101T000000\r\nRDATE:19481101T020000\r\nRDATE:19491101T020000\r\nRDATE:19500915T030000\r\nRDATE:19511111T030000\r\nRDATE:19521019T030000\r\nRDATE:19530913T030000\r\nRDATE:19540912T000000\r\nRDATE:19550911T000000\r\nRDATE:19560930T030000\r\nRDATE:19570922T000000\r\nRDATE:19741013T000000\r\nRDATE:19750831T000000\r\nRDATE:19850915T000000\r\nRDATE:19860907T000000\r\nRDATE:19870913T000000\r\nRDATE:19880903T000000\r\nRDATE:19890903T000000\r\nRDATE:19900826T000000\r\nRDATE:19910901T000000\r\nRDATE:19920906T000000\r\nRDATE:19930905T000000\r\nRDATE:19940828T000000\r\nRDATE:19950903T000000\r\nRDATE:19960916T000000\r\nRDATE:19970914T000000\r\nRDATE:19980906T000000\r\nRDATE:19990903T020000\r\nRDATE:20001006T010000\r\nRDATE:20010924T010000\r\nRDATE:20021007T010000\r\nRDATE:20031003T010000\r\nRDATE:20040922T010000\r\nRDATE:20051009T020000\r\nRDATE:20061001T020000\r\nRDATE:20070916T020000\r\nRDATE:20081005T020000\r\nRDATE:20090927T020000\r\nRDATE:20100912T020000\r\nRDATE:20111002T020000\r\nRDATE:20120923T020000\r\nRDATE:20130908T020000\r\nRDATE:20140928T020000\r\nRDATE:20150920T020000\r\nRDATE:20161009T020000\r\nRDATE:20170924T020000\r\nRDATE:20180916T020000\r\nRDATE:20191006T020000\r\nRDATE:20200927T020000\r\nRDATE:20210912T020000\r\nRDATE:20221002T020000\r\nRDATE:20230924T020000\r\nRDATE:20241006T020000\r\nRDATE:20250928T020000\r\nRDATE:20260920T020000\r\nRDATE:20271010T020000\r\nRDATE:20280924T020000\r\nRDATE:20290916T020000\r\nRDATE:20301006T020000\r\nRDATE:20310921T020000\r\nRDATE:20320912T020000\r\nRDATE:20331002T020000\r\nRDATE:20340917T020000\r\nRDATE:20351007T020000\r\nRDATE:20360928T020000\r\nRDATE:20370913T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0400\r\nTZNAME:IDDT\r\nDTSTART:19480523T000000\r\nRDATE:19480523T000000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0300\r\nTZNAME:IDT\r\nDTSTART:19480901T000000\r\nRDATE:19480901T000000\r\nEND:DAYLIGHT\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Jordan Standard Time che sara' Asia/Amman (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Jordan Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Amman\r\nX-LIC-LOCATION:Asia/Amman\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0300\r\nTZNAME:EEST\r\nDTSTART:20000330T000000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1TH\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:20061027T010000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1FR\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+022344\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:19310101T000000\r\nRDATE:19310101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0300\r\nTZNAME:EEST\r\nDTSTART:19730606T000000\r\nRDATE:19730606T000000\r\nRDATE:19740501T000000\r\nRDATE:19750501T000000\r\nRDATE:19760501T000000\r\nRDATE:19770501T000000\r\nRDATE:19780430T000000\r\nRDATE:19850401T000000\r\nRDATE:19860404T000000\r\nRDATE:19870403T000000\r\nRDATE:19880401T000000\r\nRDATE:19890508T000000\r\nRDATE:19900427T000000\r\nRDATE:19910417T000000\r\nRDATE:19920410T000000\r\nRDATE:19930402T000000\r\nRDATE:19940401T000000\r\nRDATE:19950407T000000\r\nRDATE:19960405T000000\r\nRDATE:19970404T000000\r\nRDATE:19980403T000000\r\nRDATE:19990701T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:19731001T000000\r\nRDATE:19731001T000000\r\nRDATE:19741001T000000\r\nRDATE:19751001T000000\r\nRDATE:19761101T000000\r\nRDATE:19771001T000000\r\nRDATE:19780930T000000\r\nRDATE:19851001T000000\r\nRDATE:19861003T000000\r\nRDATE:19871002T000000\r\nRDATE:19881007T000000\r\nRDATE:19891006T000000\r\nRDATE:19901005T000000\r\nRDATE:19910927T000000\r\nRDATE:19921002T000000\r\nRDATE:19931001T000000\r\nRDATE:19940916T000000\r\nRDATE:19950915T010000\r\nRDATE:19960920T010000\r\nRDATE:19970919T010000\r\nRDATE:19980918T010000\r\nRDATE:19990930T010000\r\nRDATE:20000928T010000\r\nRDATE:20010927T010000\r\nRDATE:20020926T010000\r\nRDATE:20031024T010000\r\nRDATE:20041015T010000\r\nRDATE:20050930T010000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Korea Standard Time che sara' Asia/Seoul (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Korea Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Seoul\r\nX-LIC-LOCATION:Asia/Seoul\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+082752\r\nTZOFFSETTO:+0830\r\nTZNAME:KST\r\nDTSTART:18900101T000000\r\nRDATE:18900101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0830\r\nTZOFFSETTO:+0900\r\nTZNAME:KST\r\nDTSTART:19041201T000000\r\nRDATE:19041201T000000\r\nRDATE:19320101T000000\r\nRDATE:19681001T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0900\r\nTZOFFSETTO:+0830\r\nTZNAME:KST\r\nDTSTART:19280101T000000\r\nRDATE:19280101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0900\r\nTZOFFSETTO:+0800\r\nTZNAME:KST\r\nDTSTART:19540321T000000\r\nRDATE:19540321T000000\r\nRDATE:19600913T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0800\r\nTZOFFSETTO:+0900\r\nTZNAME:KDT\r\nDTSTART:19600515T000000\r\nRDATE:19600515T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0800\r\nTZOFFSETTO:+0830\r\nTZNAME:KST\r\nDTSTART:19610810T000000\r\nRDATE:19610810T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0900\r\nTZOFFSETTO:+1000\r\nTZNAME:KDT\r\nDTSTART:19870510T000000\r\nRDATE:19870510T000000\r\nRDATE:19880508T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1000\r\nTZOFFSETTO:+0900\r\nTZNAME:KST\r\nDTSTART:19871011T000000\r\nRDATE:19871011T000000\r\nRDATE:19881009T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Mauritius Standard Time che sara' Indian/Mauritius (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Mauritius Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Indian/Mauritius\r\nX-LIC-LOCATION:Indian/Mauritius\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0350\r\nTZOFFSETTO:+0400\r\nTZNAME:MUT\r\nDTSTART:19070101T000000\r\nRDATE:19070101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Mexico Standard Time che sara' America/Mexico_City (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Mexico Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/Mexico_City\r\nX-LIC-LOCATION:America/Mexico_City\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0500\r\nTZNAME:CDT\r\nDTSTART:20020407T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=4;BYDAY=1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0500\r\nTZOFFSETTO:-0600\r\nTZNAME:CST\r\nDTSTART:20021027T020000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-063636\r\nTZOFFSETTO:-0700\r\nTZNAME:MST\r\nDTSTART:19220101T002324\r\nRDATE:19220101T002324\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0600\r\nTZNAME:CST\r\nDTSTART:19270610T230000\r\nRDATE:19270610T230000\r\nRDATE:19310501T230000\r\nRDATE:19320401T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0700\r\nTZNAME:MST\r\nDTSTART:19301115T000000\r\nRDATE:19301115T000000\r\nRDATE:19311001T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0500\r\nTZNAME:CDT\r\nDTSTART:19390205T000000\r\nRDATE:19390205T000000\r\nRDATE:19401209T000000\r\nRDATE:19500212T000000\r\nRDATE:19960407T030000\r\nRDATE:19970406T030000\r\nRDATE:19980405T030000\r\nRDATE:19990404T030000\r\nRDATE:20000402T030000\r\nRDATE:20010506T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0500\r\nTZOFFSETTO:-0600\r\nTZNAME:CST\r\nDTSTART:19390625T000000\r\nRDATE:19390625T000000\r\nRDATE:19410401T000000\r\nRDATE:19440501T000000\r\nRDATE:19500730T000000\r\nRDATE:19961027T020000\r\nRDATE:19971026T020000\r\nRDATE:19981025T020000\r\nRDATE:19991031T020000\r\nRDATE:20001029T020000\r\nRDATE:20010930T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0500\r\nTZNAME:CWT\r\nDTSTART:19431216T000000\r\nRDATE:19431216T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0600\r\nTZNAME:CST\r\nDTSTART:20020220T000000\r\nRDATE:20020220T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Mexico Standard Time 2 che sara' America/Chihuahua (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Mexico Standard Time 2',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/Chihuahua\r\nX-LIC-LOCATION:America/Chihuahua\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0600\r\nTZNAME:MDT\r\nDTSTART:20020407T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=4;BYDAY=1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0700\r\nTZNAME:MST\r\nDTSTART:20021027T020000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-070420\r\nTZOFFSETTO:-0700\r\nTZNAME:MST\r\nDTSTART:19211231T235540\r\nRDATE:19211231T235540\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0600\r\nTZNAME:CST\r\nDTSTART:19270610T230000\r\nRDATE:19270610T230000\r\nRDATE:19310501T230000\r\nRDATE:19320401T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0700\r\nTZNAME:MST\r\nDTSTART:19301115T000000\r\nRDATE:19301115T000000\r\nRDATE:19311001T000000\r\nRDATE:19981025T020000\r\nRDATE:19991031T020000\r\nRDATE:20001029T020000\r\nRDATE:20010930T020000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0600\r\nTZNAME:CST\r\nDTSTART:19960101T000000\r\nRDATE:19960101T000000\r\nRDATE:19980101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0500\r\nTZNAME:CDT\r\nDTSTART:19960407T030000\r\nRDATE:19960407T030000\r\nRDATE:19970406T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0500\r\nTZOFFSETTO:-0600\r\nTZNAME:CST\r\nDTSTART:19961027T020000\r\nRDATE:19961027T020000\r\nRDATE:19971026T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0600\r\nTZNAME:MDT\r\nDTSTART:19980405T030000\r\nRDATE:19980405T030000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0600\r\nTZNAME:MDT\r\nDTSTART:19990404T030000\r\nRDATE:19990404T030000\r\nRDATE:20000402T030000\r\nRDATE:20010506T020000\r\nEND:DAYLIGHT\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Mid-Atlantic Standard Time che sara' Atlantic/South_Georgia (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Mid-Atlantic Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Atlantic/South_Georgia\r\nX-LIC-LOCATION:Atlantic/South_Georgia\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-022608\r\nTZOFFSETTO:-0200\r\nTZNAME:GST\r\nDTSTART:18900101T000000\r\nRDATE:18900101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Middle East Standard Time che sara' Asia/Beirut (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Middle East Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Beirut\r\nX-LIC-LOCATION:Asia/Beirut\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0300\r\nTZNAME:EEST\r\nDTSTART:19930328T000000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:19991031T000000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0222\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:18800101T000000\r\nRDATE:18800101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0300\r\nTZNAME:EEST\r\nDTSTART:19200328T000000\r\nRDATE:19200328T000000\r\nRDATE:19210403T000000\r\nRDATE:19220326T000000\r\nRDATE:19230422T000000\r\nRDATE:19570501T000000\r\nRDATE:19580501T000000\r\nRDATE:19590501T000000\r\nRDATE:19600501T000000\r\nRDATE:19610501T000000\r\nRDATE:19720622T000000\r\nRDATE:19730501T000000\r\nRDATE:19740501T000000\r\nRDATE:19750501T000000\r\nRDATE:19760501T000000\r\nRDATE:19770501T000000\r\nRDATE:19780430T000000\r\nRDATE:19840501T000000\r\nRDATE:19850501T000000\r\nRDATE:19860501T000000\r\nRDATE:19870501T000000\r\nRDATE:19880601T000000\r\nRDATE:19890510T000000\r\nRDATE:19900501T000000\r\nRDATE:19910501T000000\r\nRDATE:19920501T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:19201025T000000\r\nRDATE:19201025T000000\r\nRDATE:19211003T000000\r\nRDATE:19221008T000000\r\nRDATE:19230916T000000\r\nRDATE:19571001T000000\r\nRDATE:19581001T000000\r\nRDATE:19591001T000000\r\nRDATE:19601001T000000\r\nRDATE:19611001T000000\r\nRDATE:19721001T000000\r\nRDATE:19731001T000000\r\nRDATE:19741001T000000\r\nRDATE:19751001T000000\r\nRDATE:19761001T000000\r\nRDATE:19771001T000000\r\nRDATE:19780930T000000\r\nRDATE:19841016T000000\r\nRDATE:19851016T000000\r\nRDATE:19861016T000000\r\nRDATE:19871016T000000\r\nRDATE:19881016T000000\r\nRDATE:19891016T000000\r\nRDATE:19901016T000000\r\nRDATE:19911016T000000\r\nRDATE:19921004T000000\r\nRDATE:19930926T000000\r\nRDATE:19940925T000000\r\nRDATE:19950924T000000\r\nRDATE:19960929T000000\r\nRDATE:19970928T000000\r\nRDATE:19980927T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Montevideo Standard Time che sara' America/Montevideo (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Montevideo Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/Montevideo\r\nX-LIC-LOCATION:America/Montevideo\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0300\r\nTZOFFSETTO:-0200\r\nTZNAME:UYST\r\nDTSTART:20061001T020000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0200\r\nTZOFFSETTO:-0300\r\nTZNAME:UYT\r\nDTSTART:20070311T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=2SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-034444\r\nTZOFFSETTO:-034444\r\nTZNAME:MMT\r\nDTSTART:18980628T000000\r\nRDATE:18980628T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-034444\r\nTZOFFSETTO:-0330\r\nTZNAME:UYT\r\nDTSTART:19200501T000000\r\nRDATE:19200501T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0330\r\nTZOFFSETTO:-0300\r\nTZNAME:UYHST\r\nDTSTART:19231002T000000\r\nRDATE:19231002T000000\r\nRDATE:19241001T000000\r\nRDATE:19251001T000000\r\nRDATE:19331029T000000\r\nRDATE:19341028T000000\r\nRDATE:19351027T000000\r\nRDATE:19361101T000000\r\nRDATE:19371031T000000\r\nRDATE:19381030T000000\r\nRDATE:19391029T000000\r\nRDATE:19401027T000000\r\nRDATE:19410801T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0300\r\nTZOFFSETTO:-0330\r\nTZNAME:UYT\r\nDTSTART:19240401T000000\r\nRDATE:19240401T000000\r\nRDATE:19250401T000000\r\nRDATE:19260401T000000\r\nRDATE:19340401T000000\r\nRDATE:19350331T000000\r\nRDATE:19360329T000000\r\nRDATE:19370328T000000\r\nRDATE:19380327T000000\r\nRDATE:19390326T000000\r\nRDATE:19400331T000000\r\nRDATE:19410330T000000\r\nRDATE:19420101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0330\r\nTZOFFSETTO:-0200\r\nTZNAME:UYST\r\nDTSTART:19421214T000000\r\nRDATE:19421214T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0200\r\nTZOFFSETTO:-0300\r\nTZNAME:UYT\r\nDTSTART:19430314T000000\r\nRDATE:19430314T000000\r\nRDATE:19591115T000000\r\nRDATE:19600306T000000\r\nRDATE:19650926T000000\r\nRDATE:19661031T000000\r\nRDATE:19671031T000000\r\nRDATE:19720815T000000\r\nRDATE:19761001T000000\r\nRDATE:19780401T000000\r\nRDATE:19800501T000000\r\nRDATE:19880314T000000\r\nRDATE:19890312T000000\r\nRDATE:19900304T000000\r\nRDATE:19910303T000000\r\nRDATE:19920301T000000\r\nRDATE:19930228T000000\r\nRDATE:20050327T030000\r\nRDATE:20060312T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0300\r\nTZOFFSETTO:-0200\r\nTZNAME:UYST\r\nDTSTART:19590524T000000\r\nRDATE:19590524T000000\r\nRDATE:19600117T000000\r\nRDATE:19650404T000000\r\nRDATE:19660403T000000\r\nRDATE:19670402T000000\r\nRDATE:19720424T000000\r\nRDATE:19771204T000000\r\nRDATE:19791001T000000\r\nRDATE:19871214T000000\r\nRDATE:19881211T000000\r\nRDATE:19891029T000000\r\nRDATE:19901021T000000\r\nRDATE:19911027T000000\r\nRDATE:19921018T000000\r\nRDATE:20040919T000000\r\nRDATE:20051009T020000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0300\r\nTZOFFSETTO:-0230\r\nTZNAME:UYHST\r\nDTSTART:19680527T000000\r\nRDATE:19680527T000000\r\nRDATE:19690527T000000\r\nRDATE:19700527T000000\r\nRDATE:19740310T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0230\r\nTZOFFSETTO:-0300\r\nTZNAME:UYT\r\nDTSTART:19681202T000000\r\nRDATE:19681202T000000\r\nRDATE:19691202T000000\r\nRDATE:19701202T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0230\r\nTZOFFSETTO:-0200\r\nTZNAME:UYST\r\nDTSTART:19741222T000000\r\nRDATE:19741222T000000\r\nEND:DAYLIGHT\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Morocco Standard Time che sara' Africa/Casablanca (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Morocco Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Africa/Casablanca\r\nX-LIC-LOCATION:Africa/Casablanca\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-003020\r\nTZOFFSETTO:+0000\r\nTZNAME:WET\r\nDTSTART:19131026T000000\r\nRDATE:19131026T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0000\r\nTZOFFSETTO:+0100\r\nTZNAME:WEST\r\nDTSTART:19390912T000000\r\nRDATE:19390912T000000\r\nRDATE:19400225T000000\r\nRDATE:19500611T000000\r\nRDATE:19670603T120000\r\nRDATE:19740624T000000\r\nRDATE:19760501T000000\r\nRDATE:19770501T000000\r\nRDATE:19780601T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0000\r\nTZNAME:WET\r\nDTSTART:19391119T000000\r\nRDATE:19391119T000000\r\nRDATE:19451118T000000\r\nRDATE:19501029T000000\r\nRDATE:19671001T000000\r\nRDATE:19740901T000000\r\nRDATE:19760801T000000\r\nRDATE:19770928T000000\r\nRDATE:19780804T000000\r\nRDATE:19860101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0000\r\nTZOFFSETTO:+0100\r\nTZNAME:CET\r\nDTSTART:19840316T000000\r\nRDATE:19840316T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Mountain Standard Time che sara' America/Denver (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Mountain Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/Denver\r\nX-LIC-LOCATION:America/Denver\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0600\r\nTZNAME:MDT\r\nDTSTART:20070311T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=2SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0700\r\nTZNAME:MST\r\nDTSTART:20071104T020000\r\nRRULE:FREQ=YEARLY;BYMONTH=11;BYDAY=1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-065956\r\nTZOFFSETTO:-0700\r\nTZNAME:MST\r\nDTSTART:18831118T120004\r\nRDATE:18831118T120004\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0600\r\nTZNAME:MDT\r\nDTSTART:19180331T030000\r\nRDATE:19180331T030000\r\nRDATE:19190330T030000\r\nRDATE:19200328T030000\r\nRDATE:19210327T020000\r\nRDATE:19650425T030000\r\nRDATE:19660424T030000\r\nRDATE:19670430T030000\r\nRDATE:19680428T030000\r\nRDATE:19690427T030000\r\nRDATE:19700426T030000\r\nRDATE:19710425T030000\r\nRDATE:19720430T030000\r\nRDATE:19730429T030000\r\nRDATE:19740106T030000\r\nRDATE:19750223T030000\r\nRDATE:19760425T030000\r\nRDATE:19770424T030000\r\nRDATE:19780430T030000\r\nRDATE:19790429T030000\r\nRDATE:19800427T030000\r\nRDATE:19810426T030000\r\nRDATE:19820425T030000\r\nRDATE:19830424T030000\r\nRDATE:19840429T030000\r\nRDATE:19850428T030000\r\nRDATE:19860427T030000\r\nRDATE:19870405T030000\r\nRDATE:19880403T030000\r\nRDATE:19890402T030000\r\nRDATE:19900401T030000\r\nRDATE:19910407T030000\r\nRDATE:19920405T030000\r\nRDATE:19930404T030000\r\nRDATE:19940403T030000\r\nRDATE:19950402T030000\r\nRDATE:19960407T030000\r\nRDATE:19970406T030000\r\nRDATE:19980405T030000\r\nRDATE:19990404T030000\r\nRDATE:20000402T030000\r\nRDATE:20010401T030000\r\nRDATE:20020407T030000\r\nRDATE:20030406T030000\r\nRDATE:20040404T030000\r\nRDATE:20050403T030000\r\nRDATE:20060402T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0700\r\nTZNAME:MST\r\nDTSTART:19181027T020000\r\nRDATE:19181027T020000\r\nRDATE:19191026T020000\r\nRDATE:19201031T020000\r\nRDATE:19210522T020000\r\nRDATE:19450930T020000\r\nRDATE:19651031T020000\r\nRDATE:19661030T020000\r\nRDATE:19671029T020000\r\nRDATE:19681027T020000\r\nRDATE:19691026T020000\r\nRDATE:19701025T020000\r\nRDATE:19711031T020000\r\nRDATE:19721029T020000\r\nRDATE:19731028T020000\r\nRDATE:19741027T020000\r\nRDATE:19751026T020000\r\nRDATE:19761031T020000\r\nRDATE:19771030T020000\r\nRDATE:19781029T020000\r\nRDATE:19791028T020000\r\nRDATE:19801026T020000\r\nRDATE:19811025T020000\r\nRDATE:19821031T020000\r\nRDATE:19831030T020000\r\nRDATE:19841028T020000\r\nRDATE:19851027T020000\r\nRDATE:19861026T020000\r\nRDATE:19871025T020000\r\nRDATE:19881030T020000\r\nRDATE:19891029T020000\r\nRDATE:19901028T020000\r\nRDATE:19911027T020000\r\nRDATE:19921025T020000\r\nRDATE:19931031T020000\r\nRDATE:19941030T020000\r\nRDATE:19951029T020000\r\nRDATE:19961027T020000\r\nRDATE:19971026T020000\r\nRDATE:19981025T020000\r\nRDATE:19991031T020000\r\nRDATE:20001029T020000\r\nRDATE:20011028T020000\r\nRDATE:20021027T020000\r\nRDATE:20031026T020000\r\nRDATE:20041031T020000\r\nRDATE:20051030T020000\r\nRDATE:20061029T020000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0700\r\nTZNAME:MST\r\nDTSTART:19200101T000000\r\nRDATE:19200101T000000\r\nRDATE:19420101T000000\r\nRDATE:19460101T000000\r\nRDATE:19670101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0600\r\nTZNAME:MWT\r\nDTSTART:19420209T030000\r\nRDATE:19420209T030000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0600\r\nTZNAME:MPT\r\nDTSTART:19450814T170000\r\nRDATE:19450814T170000\r\nEND:DAYLIGHT\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Mountain Standard Time (Mexico) che sara' America/Chihuahua (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Mountain Standard Time (Mexico)',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/Chihuahua\r\nX-LIC-LOCATION:America/Chihuahua\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0600\r\nTZNAME:MDT\r\nDTSTART:20020407T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=4;BYDAY=1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0700\r\nTZNAME:MST\r\nDTSTART:20021027T020000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-070420\r\nTZOFFSETTO:-0700\r\nTZNAME:MST\r\nDTSTART:19211231T235540\r\nRDATE:19211231T235540\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0600\r\nTZNAME:CST\r\nDTSTART:19270610T230000\r\nRDATE:19270610T230000\r\nRDATE:19310501T230000\r\nRDATE:19320401T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0700\r\nTZNAME:MST\r\nDTSTART:19301115T000000\r\nRDATE:19301115T000000\r\nRDATE:19311001T000000\r\nRDATE:19981025T020000\r\nRDATE:19991031T020000\r\nRDATE:20001029T020000\r\nRDATE:20010930T020000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0600\r\nTZNAME:CST\r\nDTSTART:19960101T000000\r\nRDATE:19960101T000000\r\nRDATE:19980101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0500\r\nTZNAME:CDT\r\nDTSTART:19960407T030000\r\nRDATE:19960407T030000\r\nRDATE:19970406T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0500\r\nTZOFFSETTO:-0600\r\nTZNAME:CST\r\nDTSTART:19961027T020000\r\nRDATE:19961027T020000\r\nRDATE:19971026T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0600\r\nTZNAME:MDT\r\nDTSTART:19980405T030000\r\nRDATE:19980405T030000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0600\r\nTZNAME:MDT\r\nDTSTART:19990404T030000\r\nRDATE:19990404T030000\r\nRDATE:20000402T030000\r\nRDATE:20010506T020000\r\nEND:DAYLIGHT\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Myanmar Standard Time che sara' Asia/Rangoon (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Myanmar Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Rangoon\r\nX-LIC-LOCATION:Asia/Rangoon\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+062440\r\nTZOFFSETTO:+062436\r\nTZNAME:RMT\r\nDTSTART:18800101T000000\r\nRDATE:18800101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+062436\r\nTZOFFSETTO:+0630\r\nTZNAME:BURT\r\nDTSTART:19200101T000000\r\nRDATE:19200101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0630\r\nTZOFFSETTO:+0900\r\nTZNAME:JST\r\nDTSTART:19420501T000000\r\nRDATE:19420501T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0900\r\nTZOFFSETTO:+0630\r\nTZNAME:MMT\r\nDTSTART:19450503T000000\r\nRDATE:19450503T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: N. Central Asia Standard Time che sara' Asia/Novosibirsk (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'N. Central Asia Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Novosibirsk\r\nX-LIC-LOCATION:Asia/Novosibirsk\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0600\r\nTZOFFSETTO:+0700\r\nTZNAME:NOVST\r\nDTSTART:19940327T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0700\r\nTZOFFSETTO:+0600\r\nTZNAME:NOVT\r\nDTSTART:19961027T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+053140\r\nTZOFFSETTO:+0600\r\nTZNAME:NOVT\r\nDTSTART:19191214T060000\r\nRDATE:19191214T060000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0600\r\nTZOFFSETTO:+0700\r\nTZNAME:NOVT\r\nDTSTART:19300621T000000\r\nRDATE:19300621T000000\r\nRDATE:19920119T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0700\r\nTZOFFSETTO:+0800\r\nTZNAME:NOVST\r\nDTSTART:19810401T000000\r\nRDATE:19810401T000000\r\nRDATE:19820401T000000\r\nRDATE:19830401T000000\r\nRDATE:19840401T000000\r\nRDATE:19850331T030000\r\nRDATE:19860330T030000\r\nRDATE:19870329T030000\r\nRDATE:19880327T030000\r\nRDATE:19890326T030000\r\nRDATE:19900325T030000\r\nRDATE:19920328T230000\r\nRDATE:19930328T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0800\r\nTZOFFSETTO:+0700\r\nTZNAME:NOVT\r\nDTSTART:19811001T000000\r\nRDATE:19811001T000000\r\nRDATE:19821001T000000\r\nRDATE:19831001T000000\r\nRDATE:19840930T030000\r\nRDATE:19850929T030000\r\nRDATE:19860928T030000\r\nRDATE:19870927T030000\r\nRDATE:19880925T030000\r\nRDATE:19890924T030000\r\nRDATE:19900930T030000\r\nRDATE:19920926T230000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0700\r\nTZOFFSETTO:+0700\r\nTZNAME:NOVST\r\nDTSTART:19910331T030000\r\nRDATE:19910331T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0700\r\nTZOFFSETTO:+0600\r\nTZNAME:NOVT\r\nDTSTART:19910929T030000\r\nRDATE:19910929T030000\r\nRDATE:19930926T030000\r\nRDATE:19940925T030000\r\nRDATE:19950924T030000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0800\r\nTZOFFSETTO:+0700\r\nTZNAME:NOVST\r\nDTSTART:19930523T000000\r\nRDATE:19930523T000000\r\nEND:DAYLIGHT\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Namibia Standard Time che sara' Africa/Windhoek (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Namibia Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Africa/Windhoek\r\nX-LIC-LOCATION:Africa/Windhoek\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0200\r\nTZNAME:WAST\r\nDTSTART:19940904T020000\r\nRRULE:FREQ=YEARLY;BYMONTH=9;BYDAY=1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0100\r\nTZNAME:WAT\r\nDTSTART:19950402T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=4;BYDAY=1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+010824\r\nTZOFFSETTO:+0130\r\nTZNAME:SWAT\r\nDTSTART:18920208T000000\r\nRDATE:18920208T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0130\r\nTZOFFSETTO:+0200\r\nTZNAME:SAST\r\nDTSTART:19030301T000000\r\nRDATE:19030301T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0300\r\nTZNAME:SAST\r\nDTSTART:19420920T020000\r\nRDATE:19420920T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0200\r\nTZNAME:SAST\r\nDTSTART:19430321T020000\r\nRDATE:19430321T020000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0200\r\nTZNAME:CAT\r\nDTSTART:19900321T000000\r\nRDATE:19900321T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0100\r\nTZNAME:WAT\r\nDTSTART:19940403T000000\r\nRDATE:19940403T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Nepal Standard Time che sara' Asia/Katmandu (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Nepal Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Katmandu\r\nX-LIC-LOCATION:Asia/Katmandu\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+054116\r\nTZOFFSETTO:+0530\r\nTZNAME:IST\r\nDTSTART:19200101T000000\r\nRDATE:19200101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0530\r\nTZOFFSETTO:+0545\r\nTZNAME:NPT\r\nDTSTART:19860101T000000\r\nRDATE:19860101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: New Zealand Standard Time che sara' Pacific/Auckland (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'New Zealand Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Pacific/Auckland\r\nX-LIC-LOCATION:Pacific/Auckland\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+1200\r\nTZOFFSETTO:+1300\r\nTZNAME:NZDT\r\nDTSTART:20070930T020000\r\nRRULE:FREQ=YEARLY;BYMONTH=9;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1300\r\nTZOFFSETTO:+1200\r\nTZNAME:NZST\r\nDTSTART:20080406T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=4;BYDAY=1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+113904\r\nTZOFFSETTO:+1130\r\nTZNAME:NZMT\r\nDTSTART:18681102T000000\r\nRDATE:18681102T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+1130\r\nTZOFFSETTO:+1230\r\nTZNAME:NZST\r\nDTSTART:19271106T020000\r\nRDATE:19271106T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1230\r\nTZOFFSETTO:+1130\r\nTZNAME:NZMT\r\nDTSTART:19280304T020000\r\nRDATE:19280304T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+1130\r\nTZOFFSETTO:+1200\r\nTZNAME:NZST\r\nDTSTART:19281014T020000\r\nRDATE:19281014T020000\r\nRDATE:19291013T020000\r\nRDATE:19301012T020000\r\nRDATE:19311011T020000\r\nRDATE:19321009T020000\r\nRDATE:19331008T020000\r\nRDATE:19340930T020000\r\nRDATE:19350929T020000\r\nRDATE:19360927T020000\r\nRDATE:19370926T020000\r\nRDATE:19380925T020000\r\nRDATE:19390924T020000\r\nRDATE:19400929T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1200\r\nTZOFFSETTO:+1130\r\nTZNAME:NZMT\r\nDTSTART:19290317T020000\r\nRDATE:19290317T020000\r\nRDATE:19300316T020000\r\nRDATE:19310315T020000\r\nRDATE:19320320T020000\r\nRDATE:19330319T020000\r\nRDATE:19340429T030000\r\nRDATE:19350428T030000\r\nRDATE:19360426T030000\r\nRDATE:19370425T030000\r\nRDATE:19380424T030000\r\nRDATE:19390430T030000\r\nRDATE:19400428T030000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1200\r\nTZOFFSETTO:+1200\r\nTZNAME:NZST\r\nDTSTART:19460101T000000\r\nRDATE:19460101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+1200\r\nTZOFFSETTO:+1300\r\nTZNAME:NZDT\r\nDTSTART:19741103T020000\r\nRDATE:19741103T020000\r\nRDATE:19751026T020000\r\nRDATE:19761031T020000\r\nRDATE:19771030T020000\r\nRDATE:19781029T020000\r\nRDATE:19791028T020000\r\nRDATE:19801026T020000\r\nRDATE:19811025T020000\r\nRDATE:19821031T020000\r\nRDATE:19831030T020000\r\nRDATE:19841028T020000\r\nRDATE:19851027T020000\r\nRDATE:19861026T020000\r\nRDATE:19871025T020000\r\nRDATE:19881030T020000\r\nRDATE:19891008T020000\r\nRDATE:19901007T020000\r\nRDATE:19911006T020000\r\nRDATE:19921004T020000\r\nRDATE:19931003T020000\r\nRDATE:19941002T020000\r\nRDATE:19951001T020000\r\nRDATE:19961006T020000\r\nRDATE:19971005T020000\r\nRDATE:19981004T020000\r\nRDATE:19991003T020000\r\nRDATE:20001001T020000\r\nRDATE:20011007T020000\r\nRDATE:20021006T020000\r\nRDATE:20031005T020000\r\nRDATE:20041003T020000\r\nRDATE:20051002T020000\r\nRDATE:20061001T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1300\r\nTZOFFSETTO:+1200\r\nTZNAME:NZST\r\nDTSTART:19750223T030000\r\nRDATE:19750223T030000\r\nRDATE:19760307T030000\r\nRDATE:19770306T030000\r\nRDATE:19780305T030000\r\nRDATE:19790304T030000\r\nRDATE:19800302T030000\r\nRDATE:19810301T030000\r\nRDATE:19820307T030000\r\nRDATE:19830306T030000\r\nRDATE:19840304T030000\r\nRDATE:19850303T030000\r\nRDATE:19860302T030000\r\nRDATE:19870301T030000\r\nRDATE:19880306T030000\r\nRDATE:19890305T030000\r\nRDATE:19900318T030000\r\nRDATE:19910317T030000\r\nRDATE:19920315T030000\r\nRDATE:19930321T030000\r\nRDATE:19940320T030000\r\nRDATE:19950319T030000\r\nRDATE:19960317T030000\r\nRDATE:19970316T030000\r\nRDATE:19980315T030000\r\nRDATE:19990321T030000\r\nRDATE:20000319T030000\r\nRDATE:20010318T030000\r\nRDATE:20020317T030000\r\nRDATE:20030316T030000\r\nRDATE:20040321T030000\r\nRDATE:20050320T030000\r\nRDATE:20060319T030000\r\nRDATE:20070318T030000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Newfoundland Standard Time che sara' America/St_Johns (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Newfoundland Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/St_Johns\r\nX-LIC-LOCATION:America/St_Johns\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0330\r\nTZOFFSETTO:-0230\r\nTZNAME:NDT\r\nDTSTART:20070311T000100\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=2SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0230\r\nTZOFFSETTO:-0330\r\nTZNAME:NST\r\nDTSTART:20071104T000100\r\nRRULE:FREQ=YEARLY;BYMONTH=11;BYDAY=1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-033052\r\nTZOFFSETTO:-033052\r\nTZNAME:NST\r\nDTSTART:18840101T000000\r\nRDATE:18840101T000000\r\nRDATE:19180101T000000\r\nRDATE:19190101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-033052\r\nTZOFFSETTO:-023052\r\nTZNAME:NDT\r\nDTSTART:19170408T020000\r\nRDATE:19170408T020000\r\nRDATE:19180414T020000\r\nRDATE:19190505T230000\r\nRDATE:19200502T230000\r\nRDATE:19210501T230000\r\nRDATE:19220507T230000\r\nRDATE:19230506T230000\r\nRDATE:19240504T230000\r\nRDATE:19250503T230000\r\nRDATE:19260502T230000\r\nRDATE:19270501T230000\r\nRDATE:19280506T230000\r\nRDATE:19290505T230000\r\nRDATE:19300504T230000\r\nRDATE:19310503T230000\r\nRDATE:19320501T230000\r\nRDATE:19330507T230000\r\nRDATE:19340506T230000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-023052\r\nTZOFFSETTO:-033052\r\nTZNAME:NST\r\nDTSTART:19170917T020000\r\nRDATE:19170917T020000\r\nRDATE:19181031T020000\r\nRDATE:19190812T230000\r\nRDATE:19201031T230000\r\nRDATE:19211030T230000\r\nRDATE:19221029T230000\r\nRDATE:19231028T230000\r\nRDATE:19241026T230000\r\nRDATE:19251025T230000\r\nRDATE:19261031T230000\r\nRDATE:19271030T230000\r\nRDATE:19281028T230000\r\nRDATE:19291027T230000\r\nRDATE:19301026T230000\r\nRDATE:19311025T230000\r\nRDATE:19321030T230000\r\nRDATE:19331029T230000\r\nRDATE:19341028T230000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-033052\r\nTZOFFSETTO:-0330\r\nTZNAME:NST\r\nDTSTART:19350330T000000\r\nRDATE:19350330T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0330\r\nTZOFFSETTO:-0230\r\nTZNAME:NDT\r\nDTSTART:19350505T230000\r\nRDATE:19350505T230000\r\nRDATE:19360511T000000\r\nRDATE:19370510T000000\r\nRDATE:19380509T000000\r\nRDATE:19390515T000000\r\nRDATE:19400513T000000\r\nRDATE:19410512T000000\r\nRDATE:19460512T020000\r\nRDATE:19470511T020000\r\nRDATE:19480509T020000\r\nRDATE:19490508T020000\r\nRDATE:19500514T020000\r\nRDATE:19510429T030000\r\nRDATE:19520427T030000\r\nRDATE:19530426T030000\r\nRDATE:19540425T030000\r\nRDATE:19550424T030000\r\nRDATE:19560429T030000\r\nRDATE:19570428T030000\r\nRDATE:19580427T030000\r\nRDATE:19590426T030000\r\nRDATE:19600424T030000\r\nRDATE:19610430T030000\r\nRDATE:19620429T030000\r\nRDATE:19630428T030000\r\nRDATE:19640426T030000\r\nRDATE:19650425T030000\r\nRDATE:19660424T030000\r\nRDATE:19670430T030000\r\nRDATE:19680428T030000\r\nRDATE:19690427T030000\r\nRDATE:19700426T030000\r\nRDATE:19710425T030000\r\nRDATE:19720430T030000\r\nRDATE:19730429T030000\r\nRDATE:19740428T020000\r\nRDATE:19750427T020000\r\nRDATE:19760425T030000\r\nRDATE:19770424T030000\r\nRDATE:19780430T030000\r\nRDATE:19790429T030000\r\nRDATE:19800427T030000\r\nRDATE:19810426T030000\r\nRDATE:19820425T030000\r\nRDATE:19830424T030000\r\nRDATE:19840429T030000\r\nRDATE:19850428T030000\r\nRDATE:19860427T030000\r\nRDATE:19870405T000100\r\nRDATE:19890402T000100\r\nRDATE:19900401T000100\r\nRDATE:19910407T000100\r\nRDATE:19920405T000100\r\nRDATE:19930404T000100\r\nRDATE:19940403T000100\r\nRDATE:19950402T000100\r\nRDATE:19960407T000100\r\nRDATE:19970406T000100\r\nRDATE:19980405T000100\r\nRDATE:19990404T000100\r\nRDATE:20000402T000100\r\nRDATE:20010401T000100\r\nRDATE:20020407T000100\r\nRDATE:20030406T000100\r\nRDATE:20040404T000100\r\nRDATE:20050403T000100\r\nRDATE:20060402T000100\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0230\r\nTZOFFSETTO:-0330\r\nTZNAME:NST\r\nDTSTART:19351027T230000\r\nRDATE:19351027T230000\r\nRDATE:19361005T000000\r\nRDATE:19371004T000000\r\nRDATE:19381003T000000\r\nRDATE:19391002T000000\r\nRDATE:19401007T000000\r\nRDATE:19411006T000000\r\nRDATE:19450930T020000\r\nRDATE:19461006T020000\r\nRDATE:19471005T020000\r\nRDATE:19481003T020000\r\nRDATE:19491002T020000\r\nRDATE:19501008T020000\r\nRDATE:19510930T020000\r\nRDATE:19520928T020000\r\nRDATE:19530927T020000\r\nRDATE:19540926T020000\r\nRDATE:19550925T020000\r\nRDATE:19560930T020000\r\nRDATE:19570929T020000\r\nRDATE:19580928T020000\r\nRDATE:19590927T020000\r\nRDATE:19601030T020000\r\nRDATE:19611029T020000\r\nRDATE:19621028T020000\r\nRDATE:19631027T020000\r\nRDATE:19641025T020000\r\nRDATE:19651031T020000\r\nRDATE:19661030T020000\r\nRDATE:19671029T020000\r\nRDATE:19681027T020000\r\nRDATE:19691026T020000\r\nRDATE:19701025T020000\r\nRDATE:19711031T020000\r\nRDATE:19721029T020000\r\nRDATE:19731028T020000\r\nRDATE:19741027T020000\r\nRDATE:19751026T020000\r\nRDATE:19761031T020000\r\nRDATE:19771030T020000\r\nRDATE:19781029T020000\r\nRDATE:19791028T020000\r\nRDATE:19801026T020000\r\nRDATE:19811025T020000\r\nRDATE:19821031T020000\r\nRDATE:19831030T020000\r\nRDATE:19841028T020000\r\nRDATE:19851027T020000\r\nRDATE:19861026T020000\r\nRDATE:19871025T000100\r\nRDATE:19891029T000100\r\nRDATE:19901028T000100\r\nRDATE:19911027T000100\r\nRDATE:19921025T000100\r\nRDATE:19931031T000100\r\nRDATE:19941030T000100\r\nRDATE:19951029T000100\r\nRDATE:19961027T000100\r\nRDATE:19971026T000100\r\nRDATE:19981025T000100\r\nRDATE:19991031T000100\r\nRDATE:20001029T000100\r\nRDATE:20011028T000100\r\nRDATE:20021027T000100\r\nRDATE:20031026T000100\r\nRDATE:20041031T000100\r\nRDATE:20051030T000100\r\nRDATE:20061029T000100\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0330\r\nTZOFFSETTO:-0230\r\nTZNAME:NWT\r\nDTSTART:19420511T000000\r\nRDATE:19420511T000000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0230\r\nTZOFFSETTO:-0230\r\nTZNAME:NPT\r\nDTSTART:19450814T203000\r\nRDATE:19450814T203000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0330\r\nTZOFFSETTO:-0330\r\nTZNAME:NST\r\nDTSTART:19460101T000000\r\nRDATE:19460101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0330\r\nTZOFFSETTO:-0130\r\nTZNAME:NDDT\r\nDTSTART:19880403T000100\r\nRDATE:19880403T000100\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0130\r\nTZOFFSETTO:-0330\r\nTZNAME:NST\r\nDTSTART:19881030T000100\r\nRDATE:19881030T000100\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: North Asia East Standard Time che sara' Asia/Irkutsk (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'North Asia East Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Irkutsk\r\nX-LIC-LOCATION:Asia/Irkutsk\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0800\r\nTZOFFSETTO:+0900\r\nTZNAME:IRKST\r\nDTSTART:19930328T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0900\r\nTZOFFSETTO:+0800\r\nTZNAME:IRKT\r\nDTSTART:19961027T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+065720\r\nTZOFFSETTO:+065720\r\nTZNAME:IMT\r\nDTSTART:18800101T000000\r\nRDATE:18800101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+065720\r\nTZOFFSETTO:+0700\r\nTZNAME:IRKT\r\nDTSTART:19200125T000000\r\nRDATE:19200125T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0700\r\nTZOFFSETTO:+0800\r\nTZNAME:IRKT\r\nDTSTART:19300621T000000\r\nRDATE:19300621T000000\r\nRDATE:19920119T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0800\r\nTZOFFSETTO:+0900\r\nTZNAME:IRKST\r\nDTSTART:19810401T000000\r\nRDATE:19810401T000000\r\nRDATE:19820401T000000\r\nRDATE:19830401T000000\r\nRDATE:19840401T000000\r\nRDATE:19850331T030000\r\nRDATE:19860330T030000\r\nRDATE:19870329T030000\r\nRDATE:19880327T030000\r\nRDATE:19890326T030000\r\nRDATE:19900325T030000\r\nRDATE:19920328T230000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0900\r\nTZOFFSETTO:+0800\r\nTZNAME:IRKT\r\nDTSTART:19811001T000000\r\nRDATE:19811001T000000\r\nRDATE:19821001T000000\r\nRDATE:19831001T000000\r\nRDATE:19840930T030000\r\nRDATE:19850929T030000\r\nRDATE:19860928T030000\r\nRDATE:19870927T030000\r\nRDATE:19880925T030000\r\nRDATE:19890924T030000\r\nRDATE:19900930T030000\r\nRDATE:19920926T230000\r\nRDATE:19930926T030000\r\nRDATE:19940925T030000\r\nRDATE:19950924T030000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0800\r\nTZOFFSETTO:+0800\r\nTZNAME:IRKST\r\nDTSTART:19910331T030000\r\nRDATE:19910331T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0800\r\nTZOFFSETTO:+0700\r\nTZNAME:IRKT\r\nDTSTART:19910929T030000\r\nRDATE:19910929T030000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: North Asia Standard Time che sara' Asia/Krasnoyarsk (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'North Asia Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Krasnoyarsk\r\nX-LIC-LOCATION:Asia/Krasnoyarsk\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0700\r\nTZOFFSETTO:+0800\r\nTZNAME:KRAST\r\nDTSTART:19930328T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0800\r\nTZOFFSETTO:+0700\r\nTZNAME:KRAT\r\nDTSTART:19961027T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+061120\r\nTZOFFSETTO:+0600\r\nTZNAME:KRAT\r\nDTSTART:19200106T000000\r\nRDATE:19200106T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0600\r\nTZOFFSETTO:+0700\r\nTZNAME:KRAT\r\nDTSTART:19300621T000000\r\nRDATE:19300621T000000\r\nRDATE:19920119T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0700\r\nTZOFFSETTO:+0800\r\nTZNAME:KRAST\r\nDTSTART:19810401T000000\r\nRDATE:19810401T000000\r\nRDATE:19820401T000000\r\nRDATE:19830401T000000\r\nRDATE:19840401T000000\r\nRDATE:19850331T030000\r\nRDATE:19860330T030000\r\nRDATE:19870329T030000\r\nRDATE:19880327T030000\r\nRDATE:19890326T030000\r\nRDATE:19900325T030000\r\nRDATE:19920328T230000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0800\r\nTZOFFSETTO:+0700\r\nTZNAME:KRAT\r\nDTSTART:19811001T000000\r\nRDATE:19811001T000000\r\nRDATE:19821001T000000\r\nRDATE:19831001T000000\r\nRDATE:19840930T030000\r\nRDATE:19850929T030000\r\nRDATE:19860928T030000\r\nRDATE:19870927T030000\r\nRDATE:19880925T030000\r\nRDATE:19890924T030000\r\nRDATE:19900930T030000\r\nRDATE:19920926T230000\r\nRDATE:19930926T030000\r\nRDATE:19940925T030000\r\nRDATE:19950924T030000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0700\r\nTZOFFSETTO:+0700\r\nTZNAME:KRAST\r\nDTSTART:19910331T030000\r\nRDATE:19910331T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0700\r\nTZOFFSETTO:+0600\r\nTZNAME:KRAT\r\nDTSTART:19910929T030000\r\nRDATE:19910929T030000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Pacific SA Standard Time che sara' America/Santiago (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Pacific SA Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/Santiago\r\nX-LIC-LOCATION:America/Santiago\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0400\r\nTZOFFSETTO:-0300\r\nTZNAME:CLST\r\nDTSTART:19991010T000000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYMONTHDAY=9,10,11,12,13,14,15;BYDAY=SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0300\r\nTZOFFSETTO:-0400\r\nTZNAME:CLT\r\nDTSTART:20000312T000000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYMONTHDAY=9,10,11,12,13,14,15;BYDAY=SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-044246\r\nTZOFFSETTO:-044246\r\nTZNAME:SMT\r\nDTSTART:18900101T000000\r\nRDATE:18900101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-044246\r\nTZOFFSETTO:-0500\r\nTZNAME:CLT\r\nDTSTART:19100101T000000\r\nRDATE:19100101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0500\r\nTZOFFSETTO:-044246\r\nTZNAME:SMT\r\nDTSTART:19160701T000000\r\nRDATE:19160701T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-044246\r\nTZOFFSETTO:-0400\r\nTZNAME:CLT\r\nDTSTART:19180901T000000\r\nRDATE:19180901T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0400\r\nTZOFFSETTO:-044246\r\nTZNAME:SMT\r\nDTSTART:19190701T000000\r\nRDATE:19190701T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-044246\r\nTZOFFSETTO:-0400\r\nTZNAME:CLST\r\nDTSTART:19270901T000000\r\nRDATE:19270901T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0400\r\nTZOFFSETTO:-0500\r\nTZNAME:CLT\r\nDTSTART:19280401T000000\r\nRDATE:19280401T000000\r\nRDATE:19290401T000000\r\nRDATE:19300401T000000\r\nRDATE:19310401T000000\r\nRDATE:19320401T000000\r\nRDATE:19420601T000000\r\nRDATE:19460831T230000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0500\r\nTZOFFSETTO:-0400\r\nTZNAME:CLST\r\nDTSTART:19280901T000000\r\nRDATE:19280901T000000\r\nRDATE:19290901T000000\r\nRDATE:19300901T000000\r\nRDATE:19310901T000000\r\nRDATE:19320901T000000\r\nRDATE:19420801T000000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0400\r\nTZOFFSETTO:-0400\r\nTZNAME:CLST\r\nDTSTART:19460715T000000\r\nRDATE:19460715T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0500\r\nTZOFFSETTO:-0500\r\nTZNAME:CLT\r\nDTSTART:19470331T230000\r\nRDATE:19470331T230000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0500\r\nTZOFFSETTO:-0400\r\nTZNAME:CLT\r\nDTSTART:19470522T000000\r\nRDATE:19470522T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0400\r\nTZOFFSETTO:-0300\r\nTZNAME:CLST\r\nDTSTART:19681103T000000\r\nRDATE:19681103T000000\r\nRDATE:19691123T000000\r\nRDATE:19701011T000000\r\nRDATE:19711010T000000\r\nRDATE:19721015T000000\r\nRDATE:19730930T000000\r\nRDATE:19741013T000000\r\nRDATE:19751012T000000\r\nRDATE:19761010T000000\r\nRDATE:19771009T000000\r\nRDATE:19781015T000000\r\nRDATE:19791014T000000\r\nRDATE:19801012T000000\r\nRDATE:19811011T000000\r\nRDATE:19821010T000000\r\nRDATE:19831009T000000\r\nRDATE:19841014T000000\r\nRDATE:19851013T000000\r\nRDATE:19861012T000000\r\nRDATE:19871011T000000\r\nRDATE:19881002T000000\r\nRDATE:19891015T000000\r\nRDATE:19900916T000000\r\nRDATE:19911013T000000\r\nRDATE:19921011T000000\r\nRDATE:19931010T000000\r\nRDATE:19941009T000000\r\nRDATE:19951015T000000\r\nRDATE:19961013T000000\r\nRDATE:19971012T000000\r\nRDATE:19980927T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0300\r\nTZOFFSETTO:-0400\r\nTZNAME:CLT\r\nDTSTART:19690330T000000\r\nRDATE:19690330T000000\r\nRDATE:19700329T000000\r\nRDATE:19710314T000000\r\nRDATE:19720312T000000\r\nRDATE:19730311T000000\r\nRDATE:19740310T000000\r\nRDATE:19750309T000000\r\nRDATE:19760314T000000\r\nRDATE:19770313T000000\r\nRDATE:19780312T000000\r\nRDATE:19790311T000000\r\nRDATE:19800309T000000\r\nRDATE:19810315T000000\r\nRDATE:19820314T000000\r\nRDATE:19830313T000000\r\nRDATE:19840311T000000\r\nRDATE:19850310T000000\r\nRDATE:19860309T000000\r\nRDATE:19870412T000000\r\nRDATE:19880313T000000\r\nRDATE:19890312T000000\r\nRDATE:19900318T000000\r\nRDATE:19910310T000000\r\nRDATE:19920315T000000\r\nRDATE:19930314T000000\r\nRDATE:19940313T000000\r\nRDATE:19950312T000000\r\nRDATE:19960310T000000\r\nRDATE:19970330T000000\r\nRDATE:19980315T000000\r\nRDATE:19990404T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Pacific Standard Time che sara' America/Los_Angeles (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Pacific Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/Los_Angeles\r\nX-LIC-LOCATION:America/Los_Angeles\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0800\r\nTZOFFSETTO:-0700\r\nTZNAME:PDT\r\nDTSTART:20070311T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=2SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0800\r\nTZNAME:PST\r\nDTSTART:20071104T020000\r\nRRULE:FREQ=YEARLY;BYMONTH=11;BYDAY=1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-075258\r\nTZOFFSETTO:-0800\r\nTZNAME:PST\r\nDTSTART:18831118T120702\r\nRDATE:18831118T120702\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0800\r\nTZOFFSETTO:-0700\r\nTZNAME:PDT\r\nDTSTART:19180331T030000\r\nRDATE:19180331T030000\r\nRDATE:19190330T030000\r\nRDATE:19480314T020000\r\nRDATE:19500430T030000\r\nRDATE:19510429T030000\r\nRDATE:19520427T030000\r\nRDATE:19530426T030000\r\nRDATE:19540425T030000\r\nRDATE:19550424T030000\r\nRDATE:19560429T030000\r\nRDATE:19570428T030000\r\nRDATE:19580427T030000\r\nRDATE:19590426T030000\r\nRDATE:19600424T030000\r\nRDATE:19610430T030000\r\nRDATE:19620429T030000\r\nRDATE:19630428T030000\r\nRDATE:19640426T030000\r\nRDATE:19650425T030000\r\nRDATE:19660424T030000\r\nRDATE:19670430T030000\r\nRDATE:19680428T030000\r\nRDATE:19690427T030000\r\nRDATE:19700426T030000\r\nRDATE:19710425T030000\r\nRDATE:19720430T030000\r\nRDATE:19730429T030000\r\nRDATE:19740106T030000\r\nRDATE:19750223T030000\r\nRDATE:19760425T030000\r\nRDATE:19770424T030000\r\nRDATE:19780430T030000\r\nRDATE:19790429T030000\r\nRDATE:19800427T030000\r\nRDATE:19810426T030000\r\nRDATE:19820425T030000\r\nRDATE:19830424T030000\r\nRDATE:19840429T030000\r\nRDATE:19850428T030000\r\nRDATE:19860427T030000\r\nRDATE:19870405T030000\r\nRDATE:19880403T030000\r\nRDATE:19890402T030000\r\nRDATE:19900401T030000\r\nRDATE:19910407T030000\r\nRDATE:19920405T030000\r\nRDATE:19930404T030000\r\nRDATE:19940403T030000\r\nRDATE:19950402T030000\r\nRDATE:19960407T030000\r\nRDATE:19970406T030000\r\nRDATE:19980405T030000\r\nRDATE:19990404T030000\r\nRDATE:20000402T030000\r\nRDATE:20010401T030000\r\nRDATE:20020407T030000\r\nRDATE:20030406T030000\r\nRDATE:20040404T030000\r\nRDATE:20050403T030000\r\nRDATE:20060402T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0800\r\nTZNAME:PST\r\nDTSTART:19181027T020000\r\nRDATE:19181027T020000\r\nRDATE:19191026T020000\r\nRDATE:19450930T020000\r\nRDATE:19490101T020000\r\nRDATE:19500924T020000\r\nRDATE:19510930T020000\r\nRDATE:19520928T020000\r\nRDATE:19530927T020000\r\nRDATE:19540926T020000\r\nRDATE:19550925T020000\r\nRDATE:19560930T020000\r\nRDATE:19570929T020000\r\nRDATE:19580928T020000\r\nRDATE:19590927T020000\r\nRDATE:19600925T020000\r\nRDATE:19610924T020000\r\nRDATE:19621028T020000\r\nRDATE:19631027T020000\r\nRDATE:19641025T020000\r\nRDATE:19651031T020000\r\nRDATE:19661030T020000\r\nRDATE:19671029T020000\r\nRDATE:19681027T020000\r\nRDATE:19691026T020000\r\nRDATE:19701025T020000\r\nRDATE:19711031T020000\r\nRDATE:19721029T020000\r\nRDATE:19731028T020000\r\nRDATE:19741027T020000\r\nRDATE:19751026T020000\r\nRDATE:19761031T020000\r\nRDATE:19771030T020000\r\nRDATE:19781029T020000\r\nRDATE:19791028T020000\r\nRDATE:19801026T020000\r\nRDATE:19811025T020000\r\nRDATE:19821031T020000\r\nRDATE:19831030T020000\r\nRDATE:19841028T020000\r\nRDATE:19851027T020000\r\nRDATE:19861026T020000\r\nRDATE:19871025T020000\r\nRDATE:19881030T020000\r\nRDATE:19891029T020000\r\nRDATE:19901028T020000\r\nRDATE:19911027T020000\r\nRDATE:19921025T020000\r\nRDATE:19931031T020000\r\nRDATE:19941030T020000\r\nRDATE:19951029T020000\r\nRDATE:19961027T020000\r\nRDATE:19971026T020000\r\nRDATE:19981025T020000\r\nRDATE:19991031T020000\r\nRDATE:20001029T020000\r\nRDATE:20011028T020000\r\nRDATE:20021027T020000\r\nRDATE:20031026T020000\r\nRDATE:20041031T020000\r\nRDATE:20051030T020000\r\nRDATE:20061029T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0800\r\nTZOFFSETTO:-0700\r\nTZNAME:PWT\r\nDTSTART:19420209T030000\r\nRDATE:19420209T030000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0700\r\nTZNAME:PPT\r\nDTSTART:19450814T160000\r\nRDATE:19450814T160000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0800\r\nTZOFFSETTO:-0800\r\nTZNAME:PST\r\nDTSTART:19460101T000000\r\nRDATE:19460101T000000\r\nRDATE:19670101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Pacific Standard Time (Mexico) che sara' America/Tijuana (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Pacific Standard Time (Mexico)',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/Tijuana\r\nX-LIC-LOCATION:America/Tijuana\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0800\r\nTZNAME:PST\r\nDTSTART:19761031T020000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0800\r\nTZOFFSETTO:-0700\r\nTZNAME:PDT\r\nDTSTART:19870405T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=4;BYDAY=1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-074804\r\nTZOFFSETTO:-0700\r\nTZNAME:MST\r\nDTSTART:19220101T001156\r\nRDATE:19220101T001156\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0800\r\nTZNAME:PST\r\nDTSTART:19240101T000000\r\nRDATE:19240101T000000\r\nRDATE:19301115T000000\r\nRDATE:19310930T000000\r\nRDATE:19451112T000000\r\nRDATE:19490114T000000\r\nRDATE:19540926T020000\r\nRDATE:19550925T020000\r\nRDATE:19560930T020000\r\nRDATE:19570929T020000\r\nRDATE:19580928T020000\r\nRDATE:19590927T020000\r\nRDATE:19600925T020000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0800\r\nTZOFFSETTO:-0700\r\nTZNAME:MST\r\nDTSTART:19270610T230000\r\nRDATE:19270610T230000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0800\r\nTZOFFSETTO:-0700\r\nTZNAME:PDT\r\nDTSTART:19310401T000000\r\nRDATE:19310401T000000\r\nRDATE:19480405T000000\r\nRDATE:19540425T030000\r\nRDATE:19550424T030000\r\nRDATE:19560429T030000\r\nRDATE:19570428T030000\r\nRDATE:19580427T030000\r\nRDATE:19590426T030000\r\nRDATE:19600424T030000\r\nRDATE:19760425T030000\r\nRDATE:19770424T030000\r\nRDATE:19780430T030000\r\nRDATE:19790429T030000\r\nRDATE:19800427T030000\r\nRDATE:19810426T030000\r\nRDATE:19820425T030000\r\nRDATE:19830424T030000\r\nRDATE:19840429T030000\r\nRDATE:19850428T030000\r\nRDATE:19860427T030000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0800\r\nTZOFFSETTO:-0700\r\nTZNAME:PWT\r\nDTSTART:19420424T000000\r\nRDATE:19420424T000000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0700\r\nTZNAME:PPT\r\nDTSTART:19450814T160000\r\nRDATE:19450814T160000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0800\r\nTZOFFSETTO:-0800\r\nTZNAME:PST\r\nDTSTART:19540101T000000\r\nRDATE:19540101T000000\r\nRDATE:19610101T000000\r\nRDATE:19760101T000000\r\nRDATE:19960101T000000\r\nRDATE:20010101T000000\r\nRDATE:20020220T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Pakistan Standard Time che sara' Asia/Karachi (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Pakistan Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Karachi\r\nX-LIC-LOCATION:Asia/Karachi\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+042812\r\nTZOFFSETTO:+0530\r\nTZNAME:IST\r\nDTSTART:19070101T000000\r\nRDATE:19070101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0530\r\nTZOFFSETTO:+0630\r\nTZNAME:IST\r\nDTSTART:19420901T000000\r\nRDATE:19420901T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0630\r\nTZOFFSETTO:+0530\r\nTZNAME:IST\r\nDTSTART:19451015T000000\r\nRDATE:19451015T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0530\r\nTZOFFSETTO:+0500\r\nTZNAME:KART\r\nDTSTART:19510930T000000\r\nRDATE:19510930T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0500\r\nTZOFFSETTO:+0500\r\nTZNAME:PKT\r\nDTSTART:19710326T000000\r\nRDATE:19710326T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0500\r\nTZOFFSETTO:+0600\r\nTZNAME:PKST\r\nDTSTART:20020407T000100\r\nRDATE:20020407T000100\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0600\r\nTZOFFSETTO:+0500\r\nTZNAME:PKT\r\nDTSTART:20021006T000100\r\nRDATE:20021006T000100\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Romance Standard Time che sara' Europe/Paris (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Romance Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Europe/Paris\r\nX-LIC-LOCATION:Europe/Paris\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0200\r\nTZNAME:CEST\r\nDTSTART:19810329T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0100\r\nTZNAME:CET\r\nDTSTART:19961027T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+000921\r\nTZOFFSETTO:+000921\r\nTZNAME:PMT\r\nDTSTART:18910315T000100\r\nRDATE:18910315T000100\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+000921\r\nTZOFFSETTO:+0000\r\nTZNAME:WET\r\nDTSTART:19110311T000100\r\nRDATE:19110311T000100\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0000\r\nTZOFFSETTO:+0100\r\nTZNAME:WEST\r\nDTSTART:19160614T230000\r\nRDATE:19160614T230000\r\nRDATE:19170324T230000\r\nRDATE:19180309T230000\r\nRDATE:19190301T230000\r\nRDATE:19200214T230000\r\nRDATE:19210314T230000\r\nRDATE:19220325T230000\r\nRDATE:19230526T230000\r\nRDATE:19240329T230000\r\nRDATE:19250404T230000\r\nRDATE:19260417T230000\r\nRDATE:19270409T230000\r\nRDATE:19280414T230000\r\nRDATE:19290420T230000\r\nRDATE:19300412T230000\r\nRDATE:19310418T230000\r\nRDATE:19320402T230000\r\nRDATE:19330325T230000\r\nRDATE:19340407T230000\r\nRDATE:19350330T230000\r\nRDATE:19360418T230000\r\nRDATE:19370403T230000\r\nRDATE:19380326T230000\r\nRDATE:19390415T230000\r\nRDATE:19400225T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0000\r\nTZNAME:WET\r\nDTSTART:19161002T000000\r\nRDATE:19161002T000000\r\nRDATE:19171008T000000\r\nRDATE:19181007T000000\r\nRDATE:19191006T000000\r\nRDATE:19201024T000000\r\nRDATE:19211026T000000\r\nRDATE:19221008T000000\r\nRDATE:19231007T000000\r\nRDATE:19241005T000000\r\nRDATE:19251004T000000\r\nRDATE:19261003T000000\r\nRDATE:19271002T000000\r\nRDATE:19281007T000000\r\nRDATE:19291006T000000\r\nRDATE:19301005T000000\r\nRDATE:19311004T000000\r\nRDATE:19321002T000000\r\nRDATE:19331008T000000\r\nRDATE:19341007T000000\r\nRDATE:19351006T000000\r\nRDATE:19361004T000000\r\nRDATE:19371003T000000\r\nRDATE:19381002T000000\r\nRDATE:19391119T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0200\r\nTZNAME:CEST\r\nDTSTART:19400614T230000\r\nRDATE:19400614T230000\r\nRDATE:19430329T030000\r\nRDATE:19440403T030000\r\nRDATE:19760328T010000\r\nRDATE:19770403T020000\r\nRDATE:19780402T020000\r\nRDATE:19790401T020000\r\nRDATE:19800406T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0100\r\nTZNAME:CET\r\nDTSTART:19421102T030000\r\nRDATE:19421102T030000\r\nRDATE:19431004T030000\r\nRDATE:19450916T030000\r\nRDATE:19760926T010000\r\nRDATE:19770925T030000\r\nRDATE:19781001T030000\r\nRDATE:19790930T030000\r\nRDATE:19800928T030000\r\nRDATE:19810927T030000\r\nRDATE:19820926T030000\r\nRDATE:19830925T030000\r\nRDATE:19840930T030000\r\nRDATE:19850929T030000\r\nRDATE:19860928T030000\r\nRDATE:19870927T030000\r\nRDATE:19880925T030000\r\nRDATE:19890924T030000\r\nRDATE:19900930T030000\r\nRDATE:19910929T030000\r\nRDATE:19920927T030000\r\nRDATE:19930926T030000\r\nRDATE:19940925T030000\r\nRDATE:19950924T030000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0200\r\nTZNAME:WEMT\r\nDTSTART:19440825T000000\r\nRDATE:19440825T000000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0100\r\nTZNAME:WEST\r\nDTSTART:19441008T010000\r\nRDATE:19441008T010000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0200\r\nTZNAME:WEMT\r\nDTSTART:19450402T030000\r\nRDATE:19450402T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0100\r\nTZNAME:CET\r\nDTSTART:19770101T000000\r\nRDATE:19770101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Russian Standard Time che sara' Europe/Moscow (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Russian Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Europe/Moscow\r\nX-LIC-LOCATION:Europe/Moscow\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0400\r\nTZNAME:MSD\r\nDTSTART:19930328T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0300\r\nTZNAME:MSK\r\nDTSTART:19961027T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+023020\r\nTZOFFSETTO:+0230\r\nTZNAME:MMT\r\nDTSTART:18800101T000000\r\nRDATE:18800101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0230\r\nTZOFFSETTO:+023048\r\nTZNAME:MMT\r\nDTSTART:19160703T000000\r\nRDATE:19160703T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+023048\r\nTZOFFSETTO:+033048\r\nTZNAME:MST\r\nDTSTART:19170701T230000\r\nRDATE:19170701T230000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+033048\r\nTZOFFSETTO:+023048\r\nTZNAME:MMT\r\nDTSTART:19171228T000000\r\nRDATE:19171228T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+023048\r\nTZOFFSETTO:+043048\r\nTZNAME:MDST\r\nDTSTART:19180531T220000\r\nRDATE:19180531T220000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+043048\r\nTZOFFSETTO:+033048\r\nTZNAME:MST\r\nDTSTART:19180916T010000\r\nRDATE:19180916T010000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+033048\r\nTZOFFSETTO:+043048\r\nTZNAME:MDST\r\nDTSTART:19190531T230000\r\nRDATE:19190531T230000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+043048\r\nTZOFFSETTO:+0400\r\nTZNAME:MSD\r\nDTSTART:19190701T020000\r\nRDATE:19190701T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0300\r\nTZNAME:MSK\r\nDTSTART:19190816T000000\r\nRDATE:19190816T000000\r\nRDATE:19211001T000000\r\nRDATE:19811001T000000\r\nRDATE:19821001T000000\r\nRDATE:19831001T000000\r\nRDATE:19840930T030000\r\nRDATE:19850929T030000\r\nRDATE:19860928T030000\r\nRDATE:19870927T030000\r\nRDATE:19880925T030000\r\nRDATE:19890924T030000\r\nRDATE:19900930T030000\r\nRDATE:19920926T230000\r\nRDATE:19930926T030000\r\nRDATE:19940925T030000\r\nRDATE:19950924T030000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0400\r\nTZNAME:MSD\r\nDTSTART:19210214T230000\r\nRDATE:19210214T230000\r\nRDATE:19810401T000000\r\nRDATE:19820401T000000\r\nRDATE:19830401T000000\r\nRDATE:19840401T000000\r\nRDATE:19850331T030000\r\nRDATE:19860330T030000\r\nRDATE:19870329T030000\r\nRDATE:19880327T030000\r\nRDATE:19890326T030000\r\nRDATE:19900325T030000\r\nRDATE:19920328T230000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0400\r\nTZOFFSETTO:+0500\r\nTZNAME:MSD\r\nDTSTART:19210320T230000\r\nRDATE:19210320T230000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0500\r\nTZOFFSETTO:+0400\r\nTZNAME:MSD\r\nDTSTART:19210901T000000\r\nRDATE:19210901T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0200\r\nTZNAME:EET\r\nDTSTART:19221001T000000\r\nRDATE:19221001T000000\r\nRDATE:19910929T030000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0300\r\nTZNAME:MSK\r\nDTSTART:19300621T000000\r\nRDATE:19300621T000000\r\nRDATE:19920119T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0300\r\nTZNAME:EEST\r\nDTSTART:19910331T030000\r\nRDATE:19910331T030000\r\nEND:DAYLIGHT\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: SA Eastern Standard Time che sara' Etc/GMT+3 (0) NON TROVATO OK */
INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'SA Eastern Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:SA Eastern Standard Time\r\nX-LIC-LOCATION:SA Eastern Standard Time\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0152\r\nTZOFFSETTO:+0130\r\nTZNAME:SAST\r\nDTSTART:18920208T000000\r\nRDATE:18920208T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0130\r\nTZOFFSETTO:+0200\r\nTZNAME:SAST\r\nDTSTART:19030301T000000\r\nRDATE:19030301T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0300\r\nTZNAME:SAST\r\nDTSTART:19420920T020000\r\nRDATE:19420920T020000\r\nRDATE:19430919T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0200\r\nTZNAME:SAST\r\nDTSTART:19430321T020000\r\nRDATE:19430321T020000\r\nRDATE:19440319T020000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);


/* Analizzo: SA Pacific Standard Time che sara' America/Bogota (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'SA Pacific Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/Bogota\r\nX-LIC-LOCATION:America/Bogota\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-045620\r\nTZOFFSETTO:-045620\r\nTZNAME:BMT\r\nDTSTART:18840313T000000\r\nRDATE:18840313T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-045620\r\nTZOFFSETTO:-0500\r\nTZNAME:COT\r\nDTSTART:19141123T000000\r\nRDATE:19141123T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0500\r\nTZOFFSETTO:-0400\r\nTZNAME:COST\r\nDTSTART:19920503T000000\r\nRDATE:19920503T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0400\r\nTZOFFSETTO:-0500\r\nTZNAME:COT\r\nDTSTART:19930404T000000\r\nRDATE:19930404T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: SA Western Standard Time che sara' America/La_Paz (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'SA Western Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/La_Paz\r\nX-LIC-LOCATION:America/La_Paz\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-043236\r\nTZOFFSETTO:-043236\r\nTZNAME:CMT\r\nDTSTART:18900101T000000\r\nRDATE:18900101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-043236\r\nTZOFFSETTO:-033236\r\nTZNAME:BOST\r\nDTSTART:19311015T000000\r\nRDATE:19311015T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-033236\r\nTZOFFSETTO:-0400\r\nTZNAME:BOT\r\nDTSTART:19320321T000000\r\nRDATE:19320321T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: SE Asia Standard Time che sara' Asia/Bangkok (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'SE Asia Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Bangkok\r\nX-LIC-LOCATION:Asia/Bangkok\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+064204\r\nTZOFFSETTO:+064204\r\nTZNAME:BMT\r\nDTSTART:18800101T000000\r\nRDATE:18800101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+064204\r\nTZOFFSETTO:+0700\r\nTZNAME:ICT\r\nDTSTART:19200401T000000\r\nRDATE:19200401T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Samoa Standard Time che sara' Pacific/Apia (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Samoa Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Pacific/Apia\r\nX-LIC-LOCATION:Pacific/Apia\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+123304\r\nTZOFFSETTO:-112656\r\nTZNAME:LMT\r\nDTSTART:18790705T000000\r\nRDATE:18790705T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-112656\r\nTZOFFSETTO:-1130\r\nTZNAME:SAMT\r\nDTSTART:19110101T000000\r\nRDATE:19110101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-1130\r\nTZOFFSETTO:-1100\r\nTZNAME:WST\r\nDTSTART:19500101T000000\r\nRDATE:19500101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Singapore Standard Time che sara' Asia/Singapore (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Singapore Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Singapore\r\nX-LIC-LOCATION:Asia/Singapore\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+065525\r\nTZOFFSETTO:+065525\r\nTZNAME:SMT\r\nDTSTART:19010101T000000\r\nRDATE:19010101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+065525\r\nTZOFFSETTO:+0700\r\nTZNAME:MALT\r\nDTSTART:19050601T000000\r\nRDATE:19050601T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0700\r\nTZOFFSETTO:+0720\r\nTZNAME:MALST\r\nDTSTART:19330101T000000\r\nRDATE:19330101T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0720\r\nTZOFFSETTO:+0720\r\nTZNAME:MALT\r\nDTSTART:19360101T000000\r\nRDATE:19360101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0720\r\nTZOFFSETTO:+0730\r\nTZNAME:MALT\r\nDTSTART:19410901T000000\r\nRDATE:19410901T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0730\r\nTZOFFSETTO:+0900\r\nTZNAME:JST\r\nDTSTART:19420216T000000\r\nRDATE:19420216T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0900\r\nTZOFFSETTO:+0730\r\nTZNAME:MALT\r\nDTSTART:19450912T000000\r\nRDATE:19450912T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0730\r\nTZOFFSETTO:+0730\r\nTZNAME:SGT\r\nDTSTART:19650809T000000\r\nRDATE:19650809T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0730\r\nTZOFFSETTO:+0800\r\nTZNAME:SGT\r\nDTSTART:19820101T000000\r\nRDATE:19820101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: South Africa Standard Time che sara' Africa/Johannesburg (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'South Africa Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Africa/Johannesburg\r\nX-LIC-LOCATION:Africa/Johannesburg\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0152\r\nTZOFFSETTO:+0130\r\nTZNAME:SAST\r\nDTSTART:18920208T000000\r\nRDATE:18920208T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0130\r\nTZOFFSETTO:+0200\r\nTZNAME:SAST\r\nDTSTART:19030301T000000\r\nRDATE:19030301T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0300\r\nTZNAME:SAST\r\nDTSTART:19420920T020000\r\nRDATE:19420920T020000\r\nRDATE:19430919T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0200\r\nTZNAME:SAST\r\nDTSTART:19430321T020000\r\nRDATE:19430321T020000\r\nRDATE:19440319T020000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Sri Lanka Standard Time che sara' Asia/Colombo (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Sri Lanka Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Colombo\r\nX-LIC-LOCATION:Asia/Colombo\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+051924\r\nTZOFFSETTO:+051932\r\nTZNAME:MMT\r\nDTSTART:18800101T000000\r\nRDATE:18800101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+051932\r\nTZOFFSETTO:+0530\r\nTZNAME:IST\r\nDTSTART:19060101T000000\r\nRDATE:19060101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0530\r\nTZOFFSETTO:+0600\r\nTZNAME:IHST\r\nDTSTART:19420105T000000\r\nRDATE:19420105T000000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0600\r\nTZOFFSETTO:+0630\r\nTZNAME:IST\r\nDTSTART:19420901T000000\r\nRDATE:19420901T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0630\r\nTZOFFSETTO:+0530\r\nTZNAME:IST\r\nDTSTART:19451016T020000\r\nRDATE:19451016T020000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0530\r\nTZOFFSETTO:+0630\r\nTZNAME:LKT\r\nDTSTART:19960525T000000\r\nRDATE:19960525T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0630\r\nTZOFFSETTO:+0600\r\nTZNAME:LKT\r\nDTSTART:19961026T003000\r\nRDATE:19961026T003000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0600\r\nTZOFFSETTO:+0530\r\nTZNAME:IST\r\nDTSTART:20060415T003000\r\nRDATE:20060415T003000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Taipei Standard Time che sara' Asia/Taipei (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Taipei Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Taipei\r\nX-LIC-LOCATION:Asia/Taipei\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0806\r\nTZOFFSETTO:+0800\r\nTZNAME:CST\r\nDTSTART:18960101T000000\r\nRDATE:18960101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0800\r\nTZOFFSETTO:+0900\r\nTZNAME:CDT\r\nDTSTART:19450501T000000\r\nRDATE:19450501T000000\r\nRDATE:19460501T000000\r\nRDATE:19470501T000000\r\nRDATE:19480501T000000\r\nRDATE:19490501T000000\r\nRDATE:19500501T000000\r\nRDATE:19510501T000000\r\nRDATE:19520301T000000\r\nRDATE:19530401T000000\r\nRDATE:19540401T000000\r\nRDATE:19550401T000000\r\nRDATE:19560401T000000\r\nRDATE:19570401T000000\r\nRDATE:19580401T000000\r\nRDATE:19590401T000000\r\nRDATE:19600601T000000\r\nRDATE:19610601T000000\r\nRDATE:19740401T000000\r\nRDATE:19750401T000000\r\nRDATE:19800630T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0900\r\nTZOFFSETTO:+0800\r\nTZNAME:CST\r\nDTSTART:19451001T000000\r\nRDATE:19451001T000000\r\nRDATE:19461001T000000\r\nRDATE:19471001T000000\r\nRDATE:19481001T000000\r\nRDATE:19491001T000000\r\nRDATE:19501001T000000\r\nRDATE:19511001T000000\r\nRDATE:19521101T000000\r\nRDATE:19531101T000000\r\nRDATE:19541101T000000\r\nRDATE:19551001T000000\r\nRDATE:19561001T000000\r\nRDATE:19571001T000000\r\nRDATE:19581001T000000\r\nRDATE:19591001T000000\r\nRDATE:19601001T000000\r\nRDATE:19611001T000000\r\nRDATE:19741001T000000\r\nRDATE:19751001T000000\r\nRDATE:19800930T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Tasmania Standard Time che sara' Australia/Hobart (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Tasmania Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Australia/Hobart\r\nX-LIC-LOCATION:Australia/Hobart\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+1000\r\nTZOFFSETTO:+1100\r\nTZNAME:EST\r\nDTSTART:20011007T020000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1000\r\nTZOFFSETTO:+1000\r\nTZNAME:EST\r\nDTSTART:20070325T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+094916\r\nTZOFFSETTO:+1000\r\nTZNAME:EST\r\nDTSTART:18950901T000000\r\nRDATE:18950901T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+1000\r\nTZOFFSETTO:+1100\r\nTZNAME:EST\r\nDTSTART:19161001T020000\r\nRDATE:19161001T020000\r\nRDATE:19420101T020000\r\nRDATE:19420927T020000\r\nRDATE:19431003T020000\r\nRDATE:19671001T020000\r\nRDATE:19681027T020000\r\nRDATE:19691026T020000\r\nRDATE:19701025T020000\r\nRDATE:19711031T020000\r\nRDATE:19721029T020000\r\nRDATE:19731028T020000\r\nRDATE:19741027T020000\r\nRDATE:19751026T020000\r\nRDATE:19761031T020000\r\nRDATE:19771030T020000\r\nRDATE:19781029T020000\r\nRDATE:19791028T020000\r\nRDATE:19801026T020000\r\nRDATE:19811025T020000\r\nRDATE:19821031T020000\r\nRDATE:19831030T020000\r\nRDATE:19841028T020000\r\nRDATE:19851027T020000\r\nRDATE:19861019T020000\r\nRDATE:19871025T020000\r\nRDATE:19881030T020000\r\nRDATE:19891029T020000\r\nRDATE:19901028T020000\r\nRDATE:19911006T020000\r\nRDATE:19921004T020000\r\nRDATE:19931003T020000\r\nRDATE:19941002T020000\r\nRDATE:19951001T020000\r\nRDATE:19961006T020000\r\nRDATE:19971005T020000\r\nRDATE:19981004T020000\r\nRDATE:19991003T020000\r\nRDATE:20000827T020000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+1100\r\nTZOFFSETTO:+1100\r\nTZNAME:EST\r\nDTSTART:19170201T000000\r\nRDATE:19170201T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1100\r\nTZOFFSETTO:+1000\r\nTZNAME:EST\r\nDTSTART:19170325T020000\r\nRDATE:19170325T020000\r\nRDATE:19420329T020000\r\nRDATE:19430328T020000\r\nRDATE:19440326T020000\r\nRDATE:19680331T030000\r\nRDATE:19690309T030000\r\nRDATE:19700308T030000\r\nRDATE:19710314T030000\r\nRDATE:19720227T030000\r\nRDATE:19730304T030000\r\nRDATE:19740303T030000\r\nRDATE:19750302T030000\r\nRDATE:19760307T030000\r\nRDATE:19770306T030000\r\nRDATE:19780305T030000\r\nRDATE:19790304T030000\r\nRDATE:19800302T030000\r\nRDATE:19810301T030000\r\nRDATE:19820328T030000\r\nRDATE:19830327T030000\r\nRDATE:19840304T030000\r\nRDATE:19850303T030000\r\nRDATE:19860302T030000\r\nRDATE:19870315T030000\r\nRDATE:19880320T030000\r\nRDATE:19890319T030000\r\nRDATE:19900318T030000\r\nRDATE:19910331T030000\r\nRDATE:19920329T030000\r\nRDATE:19930328T030000\r\nRDATE:19940327T030000\r\nRDATE:19950326T030000\r\nRDATE:19960331T030000\r\nRDATE:19970330T030000\r\nRDATE:19980329T030000\r\nRDATE:19990328T030000\r\nRDATE:20000326T030000\r\nRDATE:20010325T030000\r\nRDATE:20020331T030000\r\nRDATE:20030330T030000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1000\r\nTZOFFSETTO:+1000\r\nTZNAME:EST\r\nDTSTART:19670101T000000\r\nRDATE:19670101T000000\r\nRDATE:20040328T030000\r\nRDATE:20050327T030000\r\nRDATE:20060402T030000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Tokyo Standard Time che sara' Asia/Tokyo (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Tokyo Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Tokyo\r\nX-LIC-LOCATION:Asia/Tokyo\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+091859\r\nTZOFFSETTO:+0900\r\nTZNAME:JST\r\nDTSTART:18880101T001859\r\nRDATE:18880101T001859\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0900\r\nTZOFFSETTO:+0900\r\nTZNAME:CJT\r\nDTSTART:18960101T000000\r\nRDATE:18960101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0900\r\nTZOFFSETTO:+0900\r\nTZNAME:JST\r\nDTSTART:19380101T000000\r\nRDATE:19380101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0900\r\nTZOFFSETTO:+1000\r\nTZNAME:JDT\r\nDTSTART:19480502T020000\r\nRDATE:19480502T020000\r\nRDATE:19490403T020000\r\nRDATE:19500507T020000\r\nRDATE:19510506T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1000\r\nTZOFFSETTO:+0900\r\nTZNAME:JST\r\nDTSTART:19480911T020000\r\nRDATE:19480911T020000\r\nRDATE:19490910T020000\r\nRDATE:19500909T020000\r\nRDATE:19510908T020000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Tonga Standard Time che sara' Pacific/Tongatapu (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Tonga Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Pacific/Tongatapu\r\nX-LIC-LOCATION:Pacific/Tongatapu\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+121920\r\nTZOFFSETTO:+1220\r\nTZNAME:TOT\r\nDTSTART:19010101T000000\r\nRDATE:19010101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1220\r\nTZOFFSETTO:+1300\r\nTZNAME:TOT\r\nDTSTART:19410101T000000\r\nRDATE:19410101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1300\r\nTZOFFSETTO:+1300\r\nTZNAME:TOT\r\nDTSTART:19990101T000000\r\nRDATE:19990101T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+1300\r\nTZOFFSETTO:+1400\r\nTZNAME:TOST\r\nDTSTART:19991007T020000\r\nRDATE:19991007T020000\r\nRDATE:20001105T020000\r\nRDATE:20011104T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1400\r\nTZOFFSETTO:+1300\r\nTZNAME:TOT\r\nDTSTART:20000319T030000\r\nRDATE:20000319T030000\r\nRDATE:20010128T020000\r\nRDATE:20020127T020000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: US Eastern Standard Time che sara' Etc/GMT+5 (0) NON TROVATO */
INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'US Eastern Standard Time',1,'T',NULL,NULL);

/* Analizzo: US Mountain Standard Time che sara' America/Phoenix (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'US Mountain Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/Phoenix\r\nX-LIC-LOCATION:America/Phoenix\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-072818\r\nTZOFFSETTO:-0700\r\nTZNAME:MST\r\nDTSTART:18831118T113142\r\nRDATE:18831118T113142\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0600\r\nTZNAME:MDT\r\nDTSTART:19180331T030000\r\nRDATE:19180331T030000\r\nRDATE:19190330T030000\r\nRDATE:19670430T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0600\r\nTZOFFSETTO:-0700\r\nTZNAME:MST\r\nDTSTART:19181027T020000\r\nRDATE:19181027T020000\r\nRDATE:19191026T020000\r\nRDATE:19440101T000100\r\nRDATE:19441001T000100\r\nRDATE:19671029T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0600\r\nTZNAME:MWT\r\nDTSTART:19420209T030000\r\nRDATE:19420209T030000\r\nRDATE:19440401T000100\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0700\r\nTZOFFSETTO:-0700\r\nTZNAME:MST\r\nDTSTART:19670101T000000\r\nRDATE:19670101T000000\r\nRDATE:19680321T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Venezuela Standard Time che sara' America/Caracas (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Venezuela Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:America/Caracas\r\nX-LIC-LOCATION:America/Caracas\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-042744\r\nTZOFFSETTO:-042740\r\nTZNAME:CMT\r\nDTSTART:18900101T000000\r\nRDATE:18900101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-042740\r\nTZOFFSETTO:-0430\r\nTZNAME:VET\r\nDTSTART:19120212T000000\r\nRDATE:19120212T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:-0430\r\nTZOFFSETTO:-0400\r\nTZNAME:VET\r\nDTSTART:19650101T000000\r\nRDATE:19650101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Vladivostok Standard Time che sara' Asia/Vladivostok (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Vladivostok Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Vladivostok\r\nX-LIC-LOCATION:Asia/Vladivostok\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+1000\r\nTZOFFSETTO:+1100\r\nTZNAME:VLAST\r\nDTSTART:19930328T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1100\r\nTZOFFSETTO:+1000\r\nTZNAME:VLAT\r\nDTSTART:19961027T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+084744\r\nTZOFFSETTO:+0900\r\nTZNAME:VLAT\r\nDTSTART:19221115T000000\r\nRDATE:19221115T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0900\r\nTZOFFSETTO:+1000\r\nTZNAME:VLAT\r\nDTSTART:19300621T000000\r\nRDATE:19300621T000000\r\nRDATE:19920119T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+1000\r\nTZOFFSETTO:+1100\r\nTZNAME:VLAST\r\nDTSTART:19810401T000000\r\nRDATE:19810401T000000\r\nRDATE:19820401T000000\r\nRDATE:19830401T000000\r\nRDATE:19840401T000000\r\nRDATE:19850331T030000\r\nRDATE:19860330T030000\r\nRDATE:19870329T030000\r\nRDATE:19880327T030000\r\nRDATE:19890326T030000\r\nRDATE:19900325T030000\r\nRDATE:19920328T230000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1100\r\nTZOFFSETTO:+1000\r\nTZNAME:VLAT\r\nDTSTART:19811001T000000\r\nRDATE:19811001T000000\r\nRDATE:19821001T000000\r\nRDATE:19831001T000000\r\nRDATE:19840930T030000\r\nRDATE:19850929T030000\r\nRDATE:19860928T030000\r\nRDATE:19870927T030000\r\nRDATE:19880925T030000\r\nRDATE:19890924T030000\r\nRDATE:19900930T030000\r\nRDATE:19920926T230000\r\nRDATE:19930926T030000\r\nRDATE:19940925T030000\r\nRDATE:19950924T030000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+1000\r\nTZOFFSETTO:+1000\r\nTZNAME:VLASST\r\nDTSTART:19910331T030000\r\nRDATE:19910331T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1000\r\nTZOFFSETTO:+0900\r\nTZNAME:VLAST\r\nDTSTART:19910929T030000\r\nRDATE:19910929T030000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: W. Australia Standard Time che sara' Australia/Perth (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'W. Australia Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Australia/Perth\r\nX-LIC-LOCATION:Australia/Perth\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+074324\r\nTZOFFSETTO:+0800\r\nTZNAME:WST\r\nDTSTART:18951201T000000\r\nRDATE:18951201T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0800\r\nTZOFFSETTO:+0900\r\nTZNAME:WST\r\nDTSTART:19170101T000100\r\nRDATE:19170101T000100\r\nRDATE:19420101T020000\r\nRDATE:19420927T020000\r\nRDATE:19741027T020000\r\nRDATE:19831030T020000\r\nRDATE:19911117T020000\r\nRDATE:20061203T020000\r\nRDATE:20071028T020000\r\nRDATE:20081026T020000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0900\r\nTZOFFSETTO:+0800\r\nTZNAME:WST\r\nDTSTART:19170325T020000\r\nRDATE:19170325T020000\r\nRDATE:19420329T020000\r\nRDATE:19430328T020000\r\nRDATE:19750302T030000\r\nRDATE:19840304T030000\r\nRDATE:19920301T030000\r\nRDATE:20070325T030000\r\nRDATE:20080330T030000\r\nRDATE:20090329T030000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0800\r\nTZOFFSETTO:+0800\r\nTZNAME:WST\r\nDTSTART:19430701T000000\r\nRDATE:19430701T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: W. Central Africa Standard Time che sara' Africa/Lagos (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'W. Central Africa Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Africa/Lagos\r\nX-LIC-LOCATION:Africa/Lagos\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+001336\r\nTZOFFSETTO:+0100\r\nTZNAME:WAT\r\nDTSTART:19190901T000000\r\nRDATE:19190901T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: W. Europe Standard Time che sara' Europe/Berlin (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'W. Europe Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Europe/Berlin\r\nX-LIC-LOCATION:Europe/Berlin\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0200\r\nTZNAME:CEST\r\nDTSTART:19810329T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0100\r\nTZNAME:CET\r\nDTSTART:19961027T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+005328\r\nTZOFFSETTO:+0100\r\nTZNAME:CET\r\nDTSTART:18930401T000000\r\nRDATE:18930401T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0200\r\nTZNAME:CEST\r\nDTSTART:19160430T230000\r\nRDATE:19160430T230000\r\nRDATE:19170416T020000\r\nRDATE:19180415T020000\r\nRDATE:19400401T020000\r\nRDATE:19430329T030000\r\nRDATE:19440403T030000\r\nRDATE:19450402T030000\r\nRDATE:19460414T020000\r\nRDATE:19470406T020000\r\nRDATE:19480418T020000\r\nRDATE:19490410T020000\r\nRDATE:19800406T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0100\r\nTZNAME:CET\r\nDTSTART:19161001T010000\r\nRDATE:19161001T010000\r\nRDATE:19170917T030000\r\nRDATE:19180916T030000\r\nRDATE:19421102T030000\r\nRDATE:19431004T030000\r\nRDATE:19441002T030000\r\nRDATE:19451118T030000\r\nRDATE:19461007T030000\r\nRDATE:19471005T030000\r\nRDATE:19481003T030000\r\nRDATE:19491002T030000\r\nRDATE:19800928T030000\r\nRDATE:19810927T030000\r\nRDATE:19820926T030000\r\nRDATE:19830925T030000\r\nRDATE:19840930T030000\r\nRDATE:19850929T030000\r\nRDATE:19860928T030000\r\nRDATE:19870927T030000\r\nRDATE:19880925T030000\r\nRDATE:19890924T030000\r\nRDATE:19900930T030000\r\nRDATE:19910929T030000\r\nRDATE:19920927T030000\r\nRDATE:19930926T030000\r\nRDATE:19940925T030000\r\nRDATE:19950924T030000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0200\r\nTZOFFSETTO:+0300\r\nTZNAME:CEMT\r\nDTSTART:19450524T020000\r\nRDATE:19450524T020000\r\nRDATE:19470511T030000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0300\r\nTZOFFSETTO:+0200\r\nTZNAME:CEST\r\nDTSTART:19450924T030000\r\nRDATE:19450924T030000\r\nRDATE:19470629T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0100\r\nTZOFFSETTO:+0100\r\nTZNAME:CET\r\nDTSTART:19800101T000000\r\nRDATE:19800101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: West Asia Standard Time che sara' Asia/Tashkent (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'West Asia Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Tashkent\r\nX-LIC-LOCATION:Asia/Tashkent\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+043712\r\nTZOFFSETTO:+0500\r\nTZNAME:TAST\r\nDTSTART:19240502T000000\r\nRDATE:19240502T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0500\r\nTZOFFSETTO:+0600\r\nTZNAME:TAST\r\nDTSTART:19300621T000000\r\nRDATE:19300621T000000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0600\r\nTZOFFSETTO:+0700\r\nTZNAME:TASST\r\nDTSTART:19810401T000000\r\nRDATE:19810401T000000\r\nRDATE:19820401T000000\r\nRDATE:19830401T000000\r\nRDATE:19840401T000000\r\nRDATE:19850331T030000\r\nRDATE:19860330T030000\r\nRDATE:19870329T030000\r\nRDATE:19880327T030000\r\nRDATE:19890326T030000\r\nRDATE:19900325T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0700\r\nTZOFFSETTO:+0600\r\nTZNAME:TAST\r\nDTSTART:19811001T000000\r\nRDATE:19811001T000000\r\nRDATE:19821001T000000\r\nRDATE:19831001T000000\r\nRDATE:19840930T030000\r\nRDATE:19850929T030000\r\nRDATE:19860928T030000\r\nRDATE:19870927T030000\r\nRDATE:19880925T030000\r\nRDATE:19890924T030000\r\nRDATE:19900930T030000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0600\r\nTZOFFSETTO:+0600\r\nTZNAME:TASST\r\nDTSTART:19910331T030000\r\nRDATE:19910331T030000\r\nEND:DAYLIGHT\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0600\r\nTZOFFSETTO:+0600\r\nTZNAME:UZST\r\nDTSTART:19910901T000000\r\nRDATE:19910901T000000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0600\r\nTZOFFSETTO:+0500\r\nTZNAME:UZT\r\nDTSTART:19910929T030000\r\nRDATE:19910929T030000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0500\r\nTZOFFSETTO:+0500\r\nTZNAME:UZT\r\nDTSTART:19920101T000000\r\nRDATE:19920101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: West Pacific Standard Time che sara' Pacific/Port_Moresby (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'West Pacific Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Pacific/Port_Moresby\r\nX-LIC-LOCATION:Pacific/Port_Moresby\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+094840\r\nTZOFFSETTO:+094832\r\nTZNAME:PMMT\r\nDTSTART:18800101T000000\r\nRDATE:18800101T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+094832\r\nTZOFFSETTO:+1000\r\nTZNAME:PGT\r\nDTSTART:18950101T000000\r\nRDATE:18950101T000000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

/* Analizzo: Yakutsk Standard Time che sara' Asia/Yakutsk (1) TROVATO */

INSERT INTO `bw_timezones` (`bwseq`, `tzid`, `ownerid`, `publick`, `vtimezone`, `jtzid`) VALUES (0,'Yakutsk Standard Time',1,'T','BEGIN:VCALENDAR\nPRODID:-//RPI//BEDEWORK//US\nVERSION:2.0\nBEGIN:VTIMEZONE\r\nTZID:Asia/Yakutsk\r\nX-LIC-LOCATION:Asia/Yakutsk\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0900\r\nTZOFFSETTO:+1000\r\nTZNAME:YAKST\r\nDTSTART:19930328T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1000\r\nTZOFFSETTO:+0900\r\nTZNAME:YAKT\r\nDTSTART:19961027T030000\r\nRRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+083840\r\nTZOFFSETTO:+0800\r\nTZNAME:YAKT\r\nDTSTART:19191215T000000\r\nRDATE:19191215T000000\r\nEND:STANDARD\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0800\r\nTZOFFSETTO:+0900\r\nTZNAME:YAKT\r\nDTSTART:19300621T000000\r\nRDATE:19300621T000000\r\nRDATE:19920119T020000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0900\r\nTZOFFSETTO:+1000\r\nTZNAME:YAKST\r\nDTSTART:19810401T000000\r\nRDATE:19810401T000000\r\nRDATE:19820401T000000\r\nRDATE:19830401T000000\r\nRDATE:19840401T000000\r\nRDATE:19850331T030000\r\nRDATE:19860330T030000\r\nRDATE:19870329T030000\r\nRDATE:19880327T030000\r\nRDATE:19890326T030000\r\nRDATE:19900325T030000\r\nRDATE:19920328T230000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+1000\r\nTZOFFSETTO:+0900\r\nTZNAME:YAKT\r\nDTSTART:19811001T000000\r\nRDATE:19811001T000000\r\nRDATE:19821001T000000\r\nRDATE:19831001T000000\r\nRDATE:19840930T030000\r\nRDATE:19850929T030000\r\nRDATE:19860928T030000\r\nRDATE:19870927T030000\r\nRDATE:19880925T030000\r\nRDATE:19890924T030000\r\nRDATE:19900930T030000\r\nRDATE:19920926T230000\r\nRDATE:19930926T030000\r\nRDATE:19940925T030000\r\nRDATE:19950924T030000\r\nEND:STANDARD\r\nBEGIN:DAYLIGHT\r\nTZOFFSETFROM:+0900\r\nTZOFFSETTO:+0900\r\nTZNAME:YAKST\r\nDTSTART:19910331T030000\r\nRDATE:19910331T030000\r\nEND:DAYLIGHT\r\nBEGIN:STANDARD\r\nTZOFFSETFROM:+0900\r\nTZOFFSETTO:+0800\r\nTZNAME:YAKT\r\nDTSTART:19910929T030000\r\nRDATE:19910929T030000\r\nEND:STANDARD\r\nEND:VTIMEZONE\r\nEND:VCALENDAR\n',NULL);

