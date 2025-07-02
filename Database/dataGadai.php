<?php
include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

//$userId = "NBH001";
$userId = $_POST['id'];

$konfr = "Dikonfirmasi";
$gadai="Sedang menggadaikan";
$aktif = "Aktif";
$cek = "Pengecekan";
$mkonfr = "Menunggu Konfirmasi";
$done = "Sudah";
$selesai = "Selesai";

$query ="SELECT * FROM nasabah 
JOIN data_gadai ON nasabah.id_nbh = data_gadai.id_nbh 
JOIN jenis_katagori ON data_gadai.id_jns = jenis_katagori.id_jns 
JOIN katagori ON jenis_katagori.id_ktg = katagori.id_ktg 
WHERE (status_dg ='$konfr' OR status_dg ='$gadai' OR status_dg ='$aktif' OR status_dg ='$cek' OR status_dg ='$mkonfr' OR status_dg ='$done') AND nasabah.id_nbh = '$userId'AND status_dg != '$selesai'";

$response = array();

// Execute the query
$result = $conn->query($query);

if ($result && $result->num_rows > 0) {
  $row = $result->fetch_assoc();
  $response['status'] = 'success';
  $response['statusDG'] = $row['STATUS_DG'];
  $response['id'] = $row['ID_DG'];
  $response['ktp'] = $row['NOMER_KTP_DG'];
  $response['nomer'] = $row['NOMER_NBH'];
  $response['nama_depan'] = $row['FIRST_NAMA_NBH'];
  $response['nama_blkg'] = $row['LAST_NAMA_NBH'];
  $response['katagori'] = $row['NAMA_KTG'];
  $response['jenis'] = $row['NAMA_JNS']; 
  $response['merek'] = $row['NAMA_MEREK_DG'];
  $response['harga'] = $row['HARGA_DG'];
  $response['pnwr'] = $row['PENAWARAN_DG'];
  $response['cll'] = $row['BULAN_DG'];
  $response['tgl_mulai'] = $row['TANGGAL_MULAI_DG'];
  $response['tgl_akhir'] = $row['TANGGAL_AKHIR_DG'];
  $response['uangper'] = $row['UANGPER_DG'];
  $response['alamat'] = $row['ALAMAT_NBH'];
} else {
  $response['status'] = 'gagal';
}

echo json_encode($response);
?>
