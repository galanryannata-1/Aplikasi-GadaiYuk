<?php
  include 'koneksi.php';
  header("Access-Control-Allow-Origin: *");
  header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
  header("Access-Control-Allow-Headers: Content-Type");

  $query = mysqli_query($conn, "SELECT max(id_bg) as kodeTerbesar FROM bayar_gadai");
  $data = mysqli_fetch_array($query);
  $kodePng = $data['kodeTerbesar'];

  $urutan = (int) substr($kodePng, 3, 3);

  $urutan++;

  $huruf = "DBI";
  $kodePng = $huruf . sprintf("%03s", $urutan);
  //=================
  

  $IDBG =  $kodePng;
  $IDDG= $_POST['iddg'];
  $TANGGAL = $_POST['tanggal'];
  $STATUSDG = "Belum Bayar";

  /*$IDDG= "GDI001";
  $TANGGAL = "2023-08-01";*/

  $query = "INSERT INTO bayar_gadai (id_bg, id_dg, tanggal_bg,status_bg) VALUES ('$IDBG', '$IDDG', '$TANGGAL','$STATUSDG')";
  $result = $conn->query($query);

  if ($result) {
    echo "Data inserted successfully";
  } else {
    echo "Failed to insert data";
  }
?>
