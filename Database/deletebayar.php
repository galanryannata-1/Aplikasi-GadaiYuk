<?php
include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// Menerima ID dari permintaan
$id = $_POST['id'];

//$id = "NBH001";


// Query untuk menghapus data berdasarkan ID
$query = "DELETE FROM bayar_gadai WHERE id_dg IN (SELECT id_dg FROM data_gadai WHERE id_nbh = '$id')";
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
