-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 02, 2025 at 05:06 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gadaiyuk`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `ID_ADMIN` varchar(6) NOT NULL,
  `ID_ROLE` varchar(6) NOT NULL,
  `FIRST_NAMA_ADM` varchar(255) NOT NULL,
  `LAST_NAMA_ADM` varchar(255) NOT NULL,
  `NOMER_ADM` varchar(20) NOT NULL,
  `PASSWORD_ADM` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`ID_ADMIN`, `ID_ROLE`, `FIRST_NAMA_ADM`, `LAST_NAMA_ADM`, `NOMER_ADM`, `PASSWORD_ADM`) VALUES
('ADM001', 'IRL001', 'Rendi', 'Dermawanan', '083628373643', '$2y$10$X3ReiwpDESWcuUOOHG8lvuwXO0heItOPO5ykqLT99.6RTiTm6aIAq');

-- --------------------------------------------------------

--
-- Table structure for table `bayar_gadai`
--

CREATE TABLE `bayar_gadai` (
  `ID_BG` varchar(6) NOT NULL,
  `ID_DG` varchar(6) NOT NULL,
  `TANGGAL_BG` date DEFAULT NULL,
  `STATUS_BG` varchar(20) DEFAULT NULL,
  `FOTO_BUKTI_BG` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `data_gadai`
--

CREATE TABLE `data_gadai` (
  `ID_DG` varchar(6) NOT NULL,
  `ID_NBH` varchar(6) NOT NULL,
  `ID_JNS` varchar(6) NOT NULL,
  `NOMER_KTP_DG` varchar(255) DEFAULT NULL,
  `NAMA_MEREK_DG` varchar(255) DEFAULT NULL,
  `HARGA_DG` int(11) DEFAULT NULL,
  `PENAWARAN_DG` int(11) DEFAULT NULL,
  `BULAN_DG` int(11) DEFAULT NULL,
  `UANGPER_DG` int(11) DEFAULT NULL,
  `TANGGAL_MULAI_DG` date DEFAULT NULL,
  `TANGGAL_AKHIR_DG` date DEFAULT NULL,
  `STATUS_DG` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jenis_katagori`
--

CREATE TABLE `jenis_katagori` (
  `ID_JNS` varchar(6) NOT NULL,
  `ID_KTG` varchar(6) NOT NULL,
  `NAMA_JNS` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jenis_katagori`
--

INSERT INTO `jenis_katagori` (`ID_JNS`, `ID_KTG`, `NAMA_JNS`) VALUES
('JNS001', 'KTG001', 'Handphone'),
('JNS002', 'KTG001', 'Laptop'),
('JNS003', 'KTG002', 'BPKP'),
('JNS004', 'KTG002', 'Surat Rumah');

-- --------------------------------------------------------

--
-- Table structure for table `katagori`
--

CREATE TABLE `katagori` (
  `ID_KTG` varchar(6) NOT NULL,
  `NAMA_KTG` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `katagori`
--

INSERT INTO `katagori` (`ID_KTG`, `NAMA_KTG`) VALUES
('KTG001', 'Elektronik'),
('KTG002', 'Non Elektronik');

-- --------------------------------------------------------

--
-- Table structure for table `nasabah`
--

CREATE TABLE `nasabah` (
  `ID_NBH` varchar(6) NOT NULL,
  `ID_ROLE` varchar(6) NOT NULL,
  `FIRST_NAMA_NBH` varchar(255) NOT NULL,
  `LAST_NAMA_NBH` varchar(255) NOT NULL,
  `NOMER_NBH` varchar(20) NOT NULL,
  `PASSWORD_NBH` varchar(255) NOT NULL,
  `ALAMAT_NBH` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `nasabah`
--

INSERT INTO `nasabah` (`ID_NBH`, `ID_ROLE`, `FIRST_NAMA_NBH`, `LAST_NAMA_NBH`, `NOMER_NBH`, `PASSWORD_NBH`, `ALAMAT_NBH`) VALUES
('NBH001', 'IRL002', 'rian ', 'ndra', '123456', 'e10adc3949ba59abbe56e057f20f883e', 'Jlkk'),
('NBH002', 'IRL002', 'bro', 'seven', '1234567', 'fcea920f7412b5da7be0cf42b8c93759', 'jkl');

-- --------------------------------------------------------

--
-- Table structure for table `persentase`
--

CREATE TABLE `persentase` (
  `ID_PTS` varchar(6) NOT NULL,
  `ID_KTG` varchar(6) NOT NULL,
  `PERSENTASE_PTS` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `persentase`
--

INSERT INTO `persentase` (`ID_PTS`, `ID_KTG`, `PERSENTASE_PTS`) VALUES
('PST001', 'KTG001', 25),
('PTS001', 'KTG002', 40);

-- --------------------------------------------------------

--
-- Table structure for table `role`
--

CREATE TABLE `role` (
  `ID_ROLE` varchar(6) NOT NULL,
  `NAMA_ROLE` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `role`
--

INSERT INTO `role` (`ID_ROLE`, `NAMA_ROLE`) VALUES
('IRL001', 'Admin'),
('IRL002', 'Nasabah');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`ID_ADMIN`),
  ADD KEY `FK_ADMIN_CEK_AROLE_ROLE` (`ID_ROLE`);

--
-- Indexes for table `bayar_gadai`
--
ALTER TABLE `bayar_gadai`
  ADD PRIMARY KEY (`ID_BG`),
  ADD KEY `FK_BAYAR_GA_PENGECEKA_DATA_GAD` (`ID_DG`);

--
-- Indexes for table `data_gadai`
--
ALTER TABLE `data_gadai`
  ADD PRIMARY KEY (`ID_DG`),
  ADD KEY `FK_DATA_GAD_MENYIMPAN_NASABAH` (`ID_NBH`),
  ADD KEY `FK_DATA_GAD_JENIS_KAT_JENIS_KA` (`ID_JNS`);

--
-- Indexes for table `jenis_katagori`
--
ALTER TABLE `jenis_katagori`
  ADD PRIMARY KEY (`ID_JNS`),
  ADD KEY `FK_JENIS_KA_KATAGORI_KATAGORI` (`ID_KTG`);

--
-- Indexes for table `katagori`
--
ALTER TABLE `katagori`
  ADD PRIMARY KEY (`ID_KTG`);

--
-- Indexes for table `nasabah`
--
ALTER TABLE `nasabah`
  ADD PRIMARY KEY (`ID_NBH`),
  ADD KEY `FK_NASABAH_CEK_NROLE_ROLE` (`ID_ROLE`);

--
-- Indexes for table `persentase`
--
ALTER TABLE `persentase`
  ADD PRIMARY KEY (`ID_PTS`),
  ADD KEY `FK_PERSENTA_PRESENTAS_KATAGORI` (`ID_KTG`);

--
-- Indexes for table `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`ID_ROLE`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin`
--
ALTER TABLE `admin`
  ADD CONSTRAINT `FK_ADMIN_CEK_AROLE_ROLE` FOREIGN KEY (`ID_ROLE`) REFERENCES `role` (`ID_ROLE`);

--
-- Constraints for table `bayar_gadai`
--
ALTER TABLE `bayar_gadai`
  ADD CONSTRAINT `FK_BAYAR_GA_PENGECEKA_DATA_GAD` FOREIGN KEY (`ID_DG`) REFERENCES `data_gadai` (`ID_DG`);

--
-- Constraints for table `data_gadai`
--
ALTER TABLE `data_gadai`
  ADD CONSTRAINT `FK_DATA_GAD_JENIS_KAT_JENIS_KA` FOREIGN KEY (`ID_JNS`) REFERENCES `jenis_katagori` (`ID_JNS`),
  ADD CONSTRAINT `FK_DATA_GAD_MENYIMPAN_NASABAH` FOREIGN KEY (`ID_NBH`) REFERENCES `nasabah` (`ID_NBH`);

--
-- Constraints for table `jenis_katagori`
--
ALTER TABLE `jenis_katagori`
  ADD CONSTRAINT `FK_JENIS_KA_KATAGORI_KATAGORI` FOREIGN KEY (`ID_KTG`) REFERENCES `katagori` (`ID_KTG`);

--
-- Constraints for table `nasabah`
--
ALTER TABLE `nasabah`
  ADD CONSTRAINT `FK_NASABAH_CEK_NROLE_ROLE` FOREIGN KEY (`ID_ROLE`) REFERENCES `role` (`ID_ROLE`);

--
-- Constraints for table `persentase`
--
ALTER TABLE `persentase`
  ADD CONSTRAINT `FK_PERSENTA_PRESENTAS_KATAGORI` FOREIGN KEY (`ID_KTG`) REFERENCES `katagori` (`ID_KTG`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
