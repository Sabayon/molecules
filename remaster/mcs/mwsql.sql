-- phpMyAdmin SQL Dump
-- version 3.3.2
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generato il: 02 ott, 2010 at 03:50 AM
-- Versione MySQL: 5.1.46
-- Versione PHP: 5.3.2-pl0-gentoo

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `mwsql`
--
CREATE DATABASE /*!32312 IF NOT EXISTS*/ mwsql /*!40100 DEFAULT CHARACTER SET latin1 */;
USE mwsql;


-- --------------------------------------------------------

--
-- Struttura della tabella `calendars`
--

DROP TABLE IF EXISTS `calendars`;
CREATE TABLE IF NOT EXISTS `calendars` (
  `username` varchar(320) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `name` varchar(700) CHARACTER SET latin1 NOT NULL DEFAULT '',
  `color` char(6) NOT NULL DEFAULT '999966',
  PRIMARY KEY (`username`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Struttura della tabella `collector_settings`
--

DROP TABLE IF EXISTS `collector_settings`;
CREATE TABLE IF NOT EXISTS `collector_settings` (
  `username` varchar(320) CHARACTER SET latin1 NOT NULL,
  `email` varchar(320) CHARACTER SET latin1 DEFAULT NULL,
  `protocol` varchar(10) DEFAULT NULL,
  `server` varchar(256) DEFAULT NULL,
  `porta` int(5) DEFAULT '110',
  `password` varchar(100) DEFAULT NULL,
  `label` varchar(100) DEFAULT NULL,
  `toremove` char(1) DEFAULT 'y'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dump dei dati per la tabella `collector_settings`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `DISTRICTS`
--

DROP TABLE IF EXISTS `DISTRICTS`;
CREATE TABLE IF NOT EXISTS `DISTRICTS` (
  `DISTRICT_ID` varchar(25) NOT NULL DEFAULT '',
  `DISTRICT_NAME` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`DISTRICT_ID`),
  UNIQUE KEY `NAME_UNQ` (`DISTRICT_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dump dei dati per la tabella `DISTRICTS`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `FAX_NUMBERS`
--

DROP TABLE IF EXISTS `FAX_NUMBERS`;
CREATE TABLE IF NOT EXISTS `FAX_NUMBERS` (
  `FAX_NUMBER` varchar(25) NOT NULL DEFAULT '',
  `DISTRICT_ID` varchar(25) DEFAULT NULL,
  `STATUS` varchar(1) NOT NULL DEFAULT 'F',
  `FREEZE_TS` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`FAX_NUMBER`),
  KEY `STATUS_FK` (`STATUS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dump dei dati per la tabella `FAX_NUMBERS`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `FAX_STATUS`
--

DROP TABLE IF EXISTS `FAX_STATUS`;
CREATE TABLE IF NOT EXISTS `FAX_STATUS` (
  `STATUS` varchar(1) NOT NULL,
  `DESCRIPTION` varchar(50) NOT NULL,
  PRIMARY KEY (`STATUS`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dump dei dati per la tabella `FAX_STATUS`
--

INSERT INTO `FAX_STATUS` (`STATUS`, `DESCRIPTION`) VALUES
('A', 'Assegnato'),
('F', 'Non assegnato'),
('R', 'Non assegnabile');

-- --------------------------------------------------------

--
-- Struttura della tabella `groups`
--

DROP TABLE IF EXISTS `groups`;
CREATE TABLE IF NOT EXISTS `groups` (
  `username` varchar(320) CHARACTER SET latin1 NOT NULL,
  `name` varchar(25) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `addresses` text,
  PRIMARY KEY (`username`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dump dei dati per la tabella `groups`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `labels_names`
--

DROP TABLE IF EXISTS `labels_names`;
CREATE TABLE IF NOT EXISTS `labels_names` (
  `username` varchar(320) CHARACTER SET latin1 NOT NULL,
  `lid` varchar(10) NOT NULL,
  `color` char(7) DEFAULT NULL,
  `labelname` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`username`,`lid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dump dei dati per la tabella `labels_names`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `shared_addressbook`
--

DROP TABLE IF EXISTS `shared_addressbook`;
CREATE TABLE IF NOT EXISTS `shared_addressbook` (
  `username` varchar(320) CHARACTER SET latin1 NOT NULL,
  `id_rubrica` varchar(300) CHARACTER SET latin1 NOT NULL,
  `rights` char(1) DEFAULT NULL,
  PRIMARY KEY (`username`,`id_rubrica`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dump dei dati per la tabella `shared_addressbook`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `users_chat_settings`
--

DROP TABLE IF EXISTS `users_chat_settings`;
CREATE TABLE IF NOT EXISTS `users_chat_settings` (
  `username` varchar(320) CHARACTER SET latin1 NOT NULL,
  `loginenable` char(1) DEFAULT NULL,
  `onlyOnlineContacts` char(1) DEFAULT NULL,
  `personalMessage` varchar(320) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dump dei dati per la tabella `users_chat_settings`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `users_settings`
--

DROP TABLE IF EXISTS `users_settings`;
CREATE TABLE IF NOT EXISTS `users_settings` (
  `username` varchar(320) CHARACTER SET latin1 NOT NULL COMMENT 'username utente chiave primaria',
  `signature` text,
  `pager` smallint(5) unsigned DEFAULT '20',
  `language` varchar(5) DEFAULT NULL,
  `sendvcard` char(1) DEFAULT NULL,
  `sendtype` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `calendars`
--
ALTER TABLE `calendars`
  ADD CONSTRAINT `calendars_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users_settings` (`username`) ON DELETE CASCADE;

--
-- Limiti per la tabella `FAX_NUMBERS`
--
ALTER TABLE `FAX_NUMBERS`
  ADD CONSTRAINT `STATUS_FK` FOREIGN KEY (`STATUS`) REFERENCES `FAX_STATUS` (`STATUS`);

--
-- Limiti per la tabella `groups`
--
ALTER TABLE `groups`
  ADD CONSTRAINT `groups_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users_settings` (`username`) ON DELETE CASCADE;

--
-- Limiti per la tabella `labels_names`
--
ALTER TABLE `labels_names`
  ADD CONSTRAINT `labels_names_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users_settings` (`username`) ON DELETE CASCADE;

--
-- Limiti per la tabella `shared_addressbook`
--
ALTER TABLE `shared_addressbook`
  ADD CONSTRAINT `shared_addressbook_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users_settings` (`username`) ON DELETE CASCADE;
