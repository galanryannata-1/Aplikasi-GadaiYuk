<?php
// Konfigurasi database
$host = '127.0.0.1'; // Ganti sesuai dengan host MySQL Anda
$db = 'gadaiyuk'; // Ganti sesuai dengan nama database Anda
$user = 'root'; // Ganti sesuai dengan username MySQL Anda
$password = ''; // Ganti sesuai dengan password MySQL Anda

// Koneksi ke database
$conn = new mysqli($host, $user, $password, $db);
?>