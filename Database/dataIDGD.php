<?php
include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

//$userId = $_POST['id'];
$userId = 'NBH001'; // Nilai contoh, gantilah dengan nilai yang sesuai atau gunakan $_POST['id'] jika dikirim dari Flutter

$response = array();

// Mengambil nilai terbesar dari kolom 'id_dg' di tabel 'data_gadai'
$query_max_id = mysqli_query($conn, "SELECT MAX(id_dg) as kodeTerbesar FROM data_gadai");
$data_max_id = mysqli_fetch_array($query_max_id);
$kodePng = $data_max_id['kodeTerbesar'];

$urutan = (int) substr($kodePng, 3, 3);
$urutan++;

$huruf = "GDI";
$kodePng = $huruf . sprintf("%03s", $urutan);

// Mengambil data dari tabel 'data_gadai' berdasarkan 'id_nbh'
$query_data_gadai = "SELECT * FROM data_gadai WHERE id_nbh='$userId'";
$result_data_gadai = $conn->query($query_data_gadai);

if ($result_data_gadai && $result_data_gadai->num_rows > 0) {
  $row_data_gadai = $result_data_gadai->fetch_assoc();
  $response['status'] = 'success';
  $response['gd'] = $kodePng;
  // Ganti 'alamat_png' dengan atribut alamat yang sesuai
} else {
  $response['status'] = 'gagal';
}

echo json_encode($response);
?>
