<?php
include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$query = mysqli_query($conn, "SELECT max(id_dg) as kodeTerbesar FROM data_gadai");
$data = mysqli_fetch_array($query);
$kodePng = $data['kodeTerbesar'];

$urutan = (int) substr($kodePng, 3, 3);

$urutan++;
 
$huruf = "GDI";
$kodePng = $huruf . sprintf("%03s", $urutan);
//=================================================================================================================


$IDDG    = $kodePng;
$IDPNG    = $_POST['iddg'];
$IDJNS   = $_POST['idjns'];
$merek  = $_POST['merek'];
$harga =  $_POST['harga'];
$penawaran =  $_POST['penawaran'];
$bulan =  $_POST['bulan'];
$bayar =  $_POST['bayar'];
$ktp =  $_POST['ktp'];
$STATUS_DG   = "Menunggu Konfirmasi";

/*$IDDG    = $kodePng;
$IDPNG    = "NBH001";
$IDJNS   = "JNS001";
$merek  = "REALME";
$harga = "20000";
$penawaran = "2000";
$bulan =  "5";
$bayar =  "70000";
$ktp =  "123343";
$STATUS_DG   = "Menunggu Konfirmasi";*/



$response = array();

  $insert_data_gadai = "INSERT INTO data_gadai (id_dg,id_nbh,id_jns,nomer_ktp_dg,nama_merek_dg,harga_dg,penawaran_dg,bulan_dg,uangper_dg,status_dg) VALUES('$IDDG','$IDPNG','$IDJNS','$ktp','$merek','$harga','$penawaran','$bulan','$bayar','$STATUS_DG')";
  
  if ( $conn->query($insert_data_gadai) === TRUE) {
    $response['status'] = 'success';
    $response['id'] = $kodePng;

  } else {
    $response['status'] = 'failed';
  }


echo json_encode($response);
?>
