<?php
include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// Menerima ID dari permintaan
$id = $_POST['id'];
$tanggal = $_POST['tanggal'];

//$id = 'PNG001';
//$tanggal = '2023-08-02';

// Query untuk menghapus data berdasarkan ID
$query = "DELETE FROM riwayat WHERE tanggal_mulai_rwy = '$tanggal' AND id_nbh = '$id'";
$result = $conn->query($query);

$response = array();

if ($result) {
  $response['status'] = 'success';
  $response['message'] = 'Data berhasil dihapus';
} else {
  $response['status'] = 'error';
  $response['message'] = 'Gagal menghapus data';
}

echo json_encode($response);
?>
