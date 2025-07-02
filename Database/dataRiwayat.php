<?php
include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$userId = $_POST['id'];

//$userId = "NBH001";

$query = "SELECT status_dg, nama_ktg, nama_merek_dg, harga_dg, penawaran_dg, tanggal_mulai_dg,tanggal_akhir_dg,bulan_dg, uangper_dg, nama_jns
FROM data_gadai 
JOIN jenis_katagori ON data_gadai.id_jns = jenis_katagori.id_jns
JOIN katagori ON jenis_katagori.id_ktg = katagori.id_ktg
WHERE status_dg = 'Selesai' AND id_nbh = '".$userId."'";
$result = $conn->query($query);


if ($result->num_rows > 0) {
  $data = array();
  while ($row = $result->fetch_assoc()) {
      $data[] = $row;
  }
  echo json_encode($data);
} else {
  http_response_code(404); // Mengatur kode status respons menjadi 404 (Not Found)
  $response = array(
      'error' => true,
      'message' => 'Data tidak ditemukan'
  );
  echo json_encode($response);
}

$conn->close();
?>
