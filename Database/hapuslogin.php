<?php
include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$NOMER_HP = $_POST['idnbh'];


/*$NOMER_HP = "NBH001";
$PASSWORD ="DGI001";*/

$cek = "SELECT * FROM nasabah WHERE id_nbh='$NOMER_HP'";
$result = $conn->query($cek);

$response = array();

if ($result && $result->num_rows > 0) {
  $row = $result->fetch_assoc();
  $response['status'] = 'success';
  $response['id'] = "";
  $response['nama'] = ""; 
  $response['namaBelakang'] ="";
  $response['nomer123'] = "";  
  $response['alamat'] = "";  
// Simpan ID pengguna dalam respons
} else{
  $response['status'] = 'gagal';
  $response['id'] = ''; // Set ID pengguna ke kosong jika login gagal
}

echo json_encode($response);
?>