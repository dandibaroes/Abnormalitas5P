-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 16, 2019 at 07:37 AM
-- Server version: 10.1.30-MariaDB
-- PHP Version: 5.6.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_dandi`
--

-- --------------------------------------------------------

--
-- Table structure for table `abnormalitas`
--

CREATE TABLE `abnormalitas` (
  `id` int(11) NOT NULL,
  `user_pelapor` varchar(20) DEFAULT NULL,
  `unit_kerja` varchar(50) DEFAULT NULL,
  `keterangan` varchar(150) DEFAULT NULL,
  `status_abnormalitas` enum('Open','Inprogress','Close','') DEFAULT NULL,
  `prioritas` enum('Low','Medium','High','') DEFAULT NULL,
  `gambar` text,
  `gambar_sesudah` text,
  `lokasi` varchar(100) DEFAULT NULL,
  `koordinat` varchar(30) DEFAULT NULL,
  `ketinggian` varchar(20) DEFAULT NULL,
  `pic` varchar(20) DEFAULT NULL,
  `tanggal_input` date DEFAULT NULL,
  `tanggal_selesai` date NOT NULL,
  `idUsers` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `abnormalitas`
--

INSERT INTO `abnormalitas` (`id`, `user_pelapor`, `unit_kerja`, `keterangan`, `status_abnormalitas`, `prioritas`, `gambar`, `gambar_sesudah`, `lokasi`, `koordinat`, `ketinggian`, `pic`, `tanggal_input`, `tanggal_selesai`, `idUsers`) VALUES
(35, 'admin.jpa', 'Staff of Personnel Relation', 'coba', 'Open', 'Medium', '12082019104253scaled_6483dd75-8724-4311-94c1-b46272bc355d-1399628852.jpg', '15082019031005scaled_48541745-fdc2-459d-83ff-e79bca83ed0e2115211357.jpg', 'ATM Bank Negara Indonesia (Persero) Tbk', '-0.9535471 | 100.4696672', '197.8000030517578', 'karambia', '2019-08-12', '2019-08-12', 7),
(38, 'admin.jpa', 'Staff of Personnel Relation', 'aspire v15', 'Open', 'High', 'image_4828.jpg', 'default.png', 'BPD Sumatera Barat (Bank Nagari) Capem Indarung Padang', '-6.9760316 | 107.6338145', '695.2999877929688', '-', '2019-08-15', '2019-08-23', 7),
(39, 'dandi.barus', 'Staff of Personnel Relation', 'fuitr', 'Open', 'Low', 'image_73994.jpg', '15082019134915scaled_59e00852-c527-4f50-8482-186c6f1744e22034541144.jpg', 'Kedai Limponi', '-6.976693 | 107.6293239', '699.2999877929688', '-', '2019-08-15', '2019-08-23', 9);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(30) NOT NULL,
  `password` varchar(40) NOT NULL,
  `unit_kerja` varchar(50) DEFAULT NULL,
  `level` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  `waktu_buat` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `unit_kerja`, `level`, `status`, `waktu_buat`) VALUES
(7, 'admin.jpa', '66693cca050a833c7971fffd26c40230', 'Staff of Personnel Relation', 2, 1, '2019-08-12'),
(8, 'desra.fitri', 'a1bbeb5408ae3edb01daa25c7d857417', 'Department of ICT', 1, 1, '2019-08-12'),
(9, 'dandi.barus', '66693cca050a833c7971fffd26c40230', 'Staff of Personnel Relation', 1, 1, '2019-08-12');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `abnormalitas`
--
ALTER TABLE `abnormalitas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idUsers` (`idUsers`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `abnormalitas`
--
ALTER TABLE `abnormalitas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `abnormalitas`
--
ALTER TABLE `abnormalitas`
  ADD CONSTRAINT `abnormalitas_ibfk_1` FOREIGN KEY (`idUsers`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
