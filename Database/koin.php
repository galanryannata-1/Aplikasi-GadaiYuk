<?php

include 'koneksi.php';
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// Query untuk mengambil data dari database
$sql = "SELECT nama_koin, jml_koin FROM koin";
$result = $conn->query($sql);

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
