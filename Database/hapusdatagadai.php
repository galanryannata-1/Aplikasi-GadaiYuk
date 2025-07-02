<?php
include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");


$IDPNG  = $_POST['id'];
//$IDPNG  = 'NBH001';




$response = array();

  $insert_data_gadai = "UPDATE data_gadai 
  SET 
      status_dg = 'Tidak menggadaikan',
      id_ktg = null,
      jenis_dg = '',
      nama_merek_dg = '',
      harga_dg = '',
      penawaran_dg = '',
      bulan_dg = '',
      uangper_dg = '',
      first_nama_dg = '',
      last_nama_dg = '',
      alamat_dg =  '',
      nomer_hp_dg =  '',
      tanggal_mulai_dg =  '',
      nomer_ktp_dg =  ''
  WHERE 
      id_nbh = '$IDPNG'";
  
  if ( $conn->query($insert_data_gadai) === TRUE) {
    $response['status'] = 'success';
  } else {
    $response['status'] = 'failed';
  }


echo json_encode($response);
?>
