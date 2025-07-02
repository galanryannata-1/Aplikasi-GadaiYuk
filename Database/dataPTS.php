<?php
include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$userId = $_POST['id'];
//$userId = 'KTG001';

$query = "SELECT * FROM persentase WHERE id_ktg='".$userId."'";
$result = $conn->query($query);

$response = array();

if ($result && $result->num_rows > 0) {
  $row = $result->fetch_assoc();
  $response['status'] = 'success';
  $response['ptss'] = $row['PERSENTASE_PTS'];
// Ganti 'alamat_png' dengan atribut alamat yang sesuai
} else {
  $response['status'] = 'gagal';
}

echo json_encode($response);
?>
