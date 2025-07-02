<?php
include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$query = mysqli_query($conn, "SELECT max(id_rwy) as kodeTerbesar FROM riwayat");
$data = mysqli_fetch_array($query);
$kodePng = $data['kodeTerbesar'];

$urutan = (int) substr($kodePng, 3, 3);

$urutan++;
 
$huruf = "RWY";
$kodePng = $huruf . sprintf("%03s", $urutan);
//=================================================================================================================
/*$IDRWY   = $kodePng;
$IDPNG    = $_POST['idpng'];
$IDDG   = $_POST['iddg'];*/

$IDRWY   = $kodePng;
$IDPNG    = $_POST['idpng'];
$IDDG   = $_POST['iddg'];
$statusrwy = $_POST['statusrwy'];

/*$IDRWY   = $kodePng;
$IDPNG    = "NBG001";
$IDDG   ="DGI001";
$statusrwy = "Selesai";*/

$cek = "SELECT * FROM riwayat WHERE id_rwy='".$IDRWY."'";
$result = $conn->query($cek);

$response = array();

if ($result && $result->num_rows > 0) {
  $response['status'] = 'pngs';
} else {
  $insert_riwyat = "INSERT INTO riwayat(id_rwy, id_dg,id_nbh,harga_rwy,tanggal_mulai_rwy,status_rwy,bulan_rwy,katagori_rwy,nama_merek_rwy,uangper_rwy,penawaran_rwy,jenis_rwy) 
  SELECT '$IDRWY','$IDDG','$IDPNG',harga_dg,tanggal_mulai_dg,'$statusrwy',bulan_dg,nama_ktg,nama_merek_dg,uangper_dg,penawaran_dg,jenis_dg FROM data_gadai JOIN katagori ON data_gadai.id_ktg = katagori.id_ktg WHERE id_nbh = '$IDPNG'";

//$insert_data_gadai = "INSERT INTO data_gadai (id_png, id_dg, status_dg, katagori_dg, jenis_dg, nama_merek_dg, harga_dg, penawaran_dg, bulan_dg, uangper_dg, first_nama_dg, last_nama_dg, alamat_dg, nomer_hp_dg) SELECT '$IDPNG', '$IDDG', '$STATUS_DG', '$katagori', '$jenis', '$merek', '$harga', '$penawaran', '$bulan', '$bayar', first_nama_png, last_nama_png, alamat_png, nomer_png FROM pengguna WHERE id_png = '$IDPNG'";

  
  if ($conn->query($insert_riwyat))  {
    $response['status'] = 'success';
  } else {
    $response['status'] = 'failed';
  }
}


echo json_encode($response);
?>
