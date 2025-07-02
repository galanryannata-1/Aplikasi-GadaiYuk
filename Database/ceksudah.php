<?php

include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

//$idd = "NBH002";
$idd = $_GET['id'];

// Ambil status dari database

$konfr = "Dikonfirmasi";
$gadai="Sedang menggadaikan";
$aktf = "Diaktifkan";
$cek = "Pengecekan";
$mkonfr = "Menunggu Konfirmasi";
$done = "Sudah";
$selesai = "Selesai";

$sql = "SELECT status_dg FROM data_gadai WHERE (status_dg ='$konfr' OR status_dg ='$gadai' OR status_dg ='$aktf' OR status_dg ='$cek' OR status_dg ='$mkonfr' OR status_dg ='$done') AND ID_NBH = '$idd' AND status_dg != '$selesai'";
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
