INSTALLASI BACKEND GADAIYUK (XAMPP + PHP + MySQL)

LANGKAH 1: BUAT FOLDER DI HTDOCS
1. Buka folder XAMPP → htdocs
2. Buat folder baru dengan nama:
   PA
3. Salin semua file PHP backend ke dalam folder tersebut.
   Contohnya:
   - login.php
   - dataGadai.php
   - cek.php
   - updateStatusGadaiRandom.php
   - dan file PHP lainnya yang digunakan aplikasi

LANGKAH 2: BUAT DATABASE DI PHPMYADMIN
1. Buka browser, lalu akses:
   http://localhost/phpmyadmin
2. Klik menu "New"
3. Buat database baru dengan nama:
   gadaiyuk
4. Klik "Create"

LANGKAH 3: IMPORT DATABASE
1. Masuk ke database "gadaiyuk" di phpMyAdmin
2. Klik tab "Import"
3. Pilih file:
   gadaiyuk.sql
4. Klik "Go" atau "Kirim"

CATATAN TAMBAHAN:
- Pastikan Apache dan MySQL sudah dijalankan di XAMPP
- Pastikan koneksi database di file PHP sesuai:
  $conn = new mysqli("localhost", "root", "", "gadaiyuk");
- Semua file backend harus berada dalam folder:
  htdocs/PA
