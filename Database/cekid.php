<?php

include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$idd = $_GET['id'];

// Ambil status dari database

$konfr = "Dikonfirmasi";
$gadai="Sedang menggadaikan";
$aktif = "Aktif";
$cek = "Pengecekan";
$mkonfr = "Menunggu Konfirmasi";
$done = "Sudah";

$sql = "SELECT status_dg FROM data_gadai WHERE status_dg ='$gadai' AND ID_NBH = '$idd'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $status = $row["status_dg"];

    // Kirim status ke Flutter
    $response = array("status" => $status);
    echo json_encode($response);
} else {
    $response = array("status" => "Tidak menggadaikan");
    echo json_encode($response);
}

$conn->close();
?>
