<?php

include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

//$idd = $_GET['id'];
$idd = 'NBH002';

// Ambil status dari database
$sql = "SELECT nasabah.id_nbh, id_dg, first_nama_nbh FROM nasabah JOIN data_gadai ON nasabah.id_nbh=data_gadai.id_nbh WHERE nasabah.id_nbh='$idd'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $id = $row["id_nbh"];
    $dg = $row["id_dg"];
    $nama = $row["first_nama_nbh"];

    // Kirim status ke Flutter
$response = array("id" => $id, "dg" => $dg, "nama" => $nama);
    echo json_encode($response);
} else {
    $response = array("ID tidak ditemukan");
    echo json_encode($response);
}

$conn->close();
?>
