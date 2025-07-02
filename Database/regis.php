<?php
include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$query = mysqli_query($conn, "SELECT max(id_nbh) as kodeTerbesar FROM nasabah");
$data = mysqli_fetch_array($query);
$kodePng = $data['kodeTerbesar'];

$urutan = (int) substr($kodePng, 3, 3);

$urutan++;
 
$huruf = "NBH";
$kodePng = $huruf . sprintf("%03s", $urutan);
//=================================================================================================================
$querydg = mysqli_query($conn, "SELECT max(id_dg) as kodedg FROM data_gadai");
$datadg = mysqli_fetch_array($querydg);
$koddg = $datadg['kodedg'];

$urutandg = (int) substr($koddg, 3, 3);

$urutandg++;
 
$hurufdg = "DGI";
$koddg = $hurufdg . sprintf("%03s", $urutandg);


$IDPNG    = $kodePng;
$IDDG    = $koddg;
$IDROLE   = "IRL002";
$Fnama  = $_POST['Fnama'];
$Lnama  = $_POST['Lnama'];
$NOMER_HP =  $_POST['nomer'];
$ALAMAT =  $_POST['alamat'];
$PASSWORD =  md5($_POST['password']);
$statusdg = "Tidak menggadaikan";


$cek = "SELECT * FROM nasabah WHERE nomer_nbh='".$NOMER_HP."'";
$result = $conn->query($cek);

$response = array();

if ($result && $result->num_rows > 0) {
  $response['status'] = 'pngs';
} else {
  $insert_pengguna = "INSERT INTO nasabah (id_nbh, id_role, last_nama_nbh, nomer_nbh, password_nbh, first_nama_nbh, alamat_nbh) VALUES ('$IDPNG', '$IDROLE', '$Lnama', '$NOMER_HP', '$PASSWORD','$Fnama', '$ALAMAT')";
  //$insert_data_gadai = "INSERT INTO data_gadai(id_nbh, id_dg,status_dg) VALUES ('$IDPNG', '$IDDG','$statusdg')";
  
  if ($conn->query($insert_pengguna) === TRUE)  {
    $response['status'] = 'success';
  } else {
    $response['status'] = 'failed';
  }
}

echo json_encode($response);
?>
