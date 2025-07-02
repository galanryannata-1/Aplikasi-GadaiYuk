<?php
include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$userId = $_POST['id'];
//$userId = 'PNG001';

$query = "SELECT * FROM nasabah WHERE id_nbh='".$userId."'";
$result = $conn->query($query);

$response = array();

if ($result && $result->num_rows > 0) {
  $row = $result->fetch_assoc();
  $response['status'] = 'success';
  $response['nomer'] = $row['NOMER_NBH'];
  $response['nama_depan'] = $row['FIRST_NAMA_NBH'];
  $response['nama_blkg'] = $row['LAST_NAMA_NBH'];
  $response['alamat'] = $row['ALAMAT_NBH'];// Ganti 'alamat_png' dengan atribut alamat yang sesuai
} else {
  $response['status'] = 'gagal';
}

echo json_encode($response);
?>
