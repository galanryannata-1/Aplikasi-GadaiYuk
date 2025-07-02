<?php
include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");




$IDPNG    = $_POST['idpng'];
$STATUS_DG   = $_POST['statusdg'];

//$IDPNG    = "PNG001";
//$STATUS_DG   = "UJI";


$response = array();

  $insert_data_gadai = "UPDATE data_gadai 
  SET 
      status_dg = '$STATUS_DG'
     
  WHERE 
      status_dg = 'Sudah' AND id_nbh = '$IDPNG'";
  
  if ( $conn->query($insert_data_gadai) === TRUE) {
    $response['status'] = 'success';
  } else {
    $response['status'] = 'failed';
  }


echo json_encode($response);
?>
