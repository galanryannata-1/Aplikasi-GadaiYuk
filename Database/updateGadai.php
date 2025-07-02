<?php
include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

//$IDPNG    = $_POST['iddg'];
$IDDG    = $_POST['iddg'];
$merek  = $_POST['merek'];
$jenis  = $_POST['idjns'];
$harga =  $_POST['harga'];
$penawaran =  $_POST['penawaran'];
$bulan =  $_POST['bulan'];
$bayar =  $_POST['bayar'];
$STATUS_DG   = "Menunggu Konfirmasi";




$response = array();

$insert_data_gadai = "UPDATE data_gadai 
SET 
    status_dg = '$STATUS_DG',
    id_jns='$jenis',
    nama_merek_dg = '$merek',
    harga_dg = '$harga',
    penawaran_dg = '$penawaran',
    bulan_dg = '$bulan',
    uangper_dg = '$bayar'
WHERE id_dg ='$IDDG'";

  
  if ( $conn->query($insert_data_gadai) === TRUE) {
    $response['status'] = 'success';
  } else {
    $response['status'] = 'failed';
  }


echo json_encode($response);
?>
