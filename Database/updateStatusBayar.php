<?php
include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");


$IDPNG = $_POST['idpng'];
$TANGGAL = $_POST['tanggal'];
$STATUS = "Sudah Bayar";

$response = array();

  $insert_data_gadai = "UPDATE bayar_gadai JOIN data_gadai ON bayar_gadai.id_dg = data_gadai.id_dg 
  SET 
      status_bg = '$STATUS'
     
  WHERE 
      tanggal_bg = '$TANGGAL'  AND id_nbh = '$IDPNG'";
  
  if ( $conn->query($insert_data_gadai) === TRUE) {
    $response['status'] = 'success';
  } else {
    $response['status'] = 'failed';
  }


echo json_encode($response);
?>
