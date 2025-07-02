<?php
include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");




$IDPNG    = $_POST['inbg'];
$IDDG    = $_POST['id'];

//$IDPNG = "NBH001";
//$IDDG = "GDI003";

$response = array();

$insert_data_gadai = "UPDATE data_gadai 
SET 
    tanggal_mulai_dg = (SELECT MIN(tanggal_bg) FROM bayar_gadai WHERE id_dg = '$IDDG' AND bayar_gadai.id_dg = data_gadai.id_dg),
    tanggal_akhir_dg = (SELECT MAX(tanggal_bg) FROM bayar_gadai WHERE id_dg = '$IDDG' AND bayar_gadai.id_dg = data_gadai.id_dg)
WHERE 
    id_dg = '$IDDG'";

if ($conn->query($insert_data_gadai) === TRUE) {
    $response['status'] = 'success';
} else {
    $response['status'] = 'failed';
}

echo json_encode($response);
?>
