<?php
include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$NOMER_HP = $_POST['nomer'];
$PASSWORD = md5($_POST['password']);


/*$NOMER_HP = "1234567";
$PASSWORD = md5("1234567");*/


$cek = "SELECT * FROM nasabah  WHERE nomer_nbh='".$NOMER_HP."' AND password_nbh='".$PASSWORD."'";
$result = $conn->query($cek);

$response = array();

if ($result && $result->num_rows > 0) {
  $row = $result->fetch_assoc();
  $response['status'] = 'success';
  $response['id'] = $row['ID_NBH'];
  $response['nama'] = $row['FIRST_NAMA_NBH']; 
  $response['namaBelakang'] = $row['LAST_NAMA_NBH'];
  $response['nomer123'] = $row['NOMER_NBH'];  
  $response['alamat'] = $row['ALAMAT_NBH'];  
 // Simpan ID pengguna dalam respons
} else{
  $response['status'] = 'gagal';
  $response['id'] = ''; // Set ID pengguna ke kosong jika login gagal
}

echo json_encode($response);
?>