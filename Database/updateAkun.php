<?php
include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");


$IDPNG    = $_POST['idpng'];
$Fnama  = $_POST['Fnama'];
$Lnama  = $_POST['Lnama'];
$NOMER_HP =  $_POST['nomer'];
$ALAMAT =  $_POST['alamat'];


$response = array();


  $insert_pengguna = "UPDATE nasabah SET
  last_nama_nbh = '$Lnama', 
  nomer_nbh = '$NOMER_HP', 
  first_nama_nbh = '$Fnama' , 
  alamat_nbh = '$ALAMAT'
  WHERE id_nbh = '$IDPNG'";
 
  
  if ($conn->query($insert_pengguna) === TRUE)  {
    $response['status'] = 'success';
  } else {
    $response['status'] = 'failed';
  }


echo json_encode($response);
?>
