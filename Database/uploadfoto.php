<?php
  include 'koneksi.php';
  header("Access-Control-Allow-Origin: *");
  header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
  header("Access-Control-Allow-Headers: Content-Type");

  // Mendapatkan data yang dikirim dari aplikasi Flutter
$id = $_POST['id'];
$imageData = $_POST['image'];
$tanggal = $_POST['tanggal'];
$status = "Menunggu Konfirmasi";

// Membuat folder penyimpanan jika belum ada
$folderPath = 'foto/'; // Ganti dengan path folder penyimpanan Anda
if (!is_dir($folderPath)) {
  mkdir($folderPath, 0777, true);
}

// Menentukan nama file dan path tujuan penyimpanan
$fileName = $id . '_' . time() . '.jpg';  // Ganti dengan logika pengambilan nama file yang sesuai
$destinationPath = $folderPath . $fileName;

// Mengubah data gambar dari base64 ke bentuk file
$imageData = base64_decode($imageData);

// Menyimpan file gambar
if (file_put_contents($destinationPath,$imageData)) {
  // File berhasil disimpan, lakukan operasi lain yang diperlukan, misalnya penyimpanan path file ke dalam database

  $sql = " UPDATE bayar_gadai JOIN data_gadai ON bayar_gadai.id_dg = data_gadai.id_dg SET
         status_bg= '$status',
         foto_bukti_bg = '$fileName'
         WHERE id_nbh = '$id' AND tanggal_bg = '$tanggal'";
  if ($conn->query($sql) === TRUE) {
    // Tampilkan response sukses ke aplikasi Flutter
    http_response_code(200);
    echo json_encode(array('message' => 'Upload berhasil'));
  } else {
    // Gagal menyimpan path file ke dalam database, berikan response error ke aplikasi Flutter
    http_response_code(500);
    echo json_encode(array('message' => 'Upload gagal'));
  }

  // Menutup koneksi database
  $conn->close();;
} else {
  // Gagal menyimpan file, berikan response error ke aplikasi Flutter
  http_response_code(500);
  echo json_encode(array('message' => 'Upload gagal'));
}
?>
