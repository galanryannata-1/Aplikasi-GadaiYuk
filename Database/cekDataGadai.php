<?php
include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$userId = $_GET['id'];

$query = "SELECT status_dg FROM data_gadai WHERE id_nbh='".$userId."'";
$result = $conn->query($query);

$response = array();

if ($result && $result->num_rows > 0) {
  $row = $result->fetch_assoc();
  $response['status'] = 'success';
  $response['idgadai'] = $row['status_dg']; // Simpan ID pengguna dalam respons
} else{
  $response['status'] = 'gagal';
  $response['idgadai'] = ''; // Set ID pengguna ke kosong jika login gagal
}
echo json_encode($response);
?>
