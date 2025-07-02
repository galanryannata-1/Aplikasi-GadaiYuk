<?php

include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$idd = $_GET['id'];
//$idd = 'NBH003';
$kondisi = "Belum Bayar";
$tolak = "Ditolak";
$konfir = "Menunggu Konfirmasi";
$terima = "Diterima";


// Ambil status dari database
$sql = "SELECT tanggal_bg,status_bg FROM bayar_gadai JOIN data_gadai ON bayar_gadai.id_dg = data_gadai.id_dg
WHERE (STATUS_BG = '$kondisi' OR STATUS_BG = '$tolak' OR STATUS_BG ='$konfir' OR STATUS_BG ='$terima') AND ID_NBH = '$idd'";
$result = $conn->query($sql);

if ($result && $result->num_rows > 0) {
  $row = $result->fetch_assoc();
  $tanggal = $row['tanggal_bg'];
  $status = $row['status_bg'];

  $response['tanggal'] = $tanggal;
  $response['status'] = $status;
} else {
  $response['tanggal'] = null;
  $response['status'] = null;
}
echo json_encode($response);

?>
