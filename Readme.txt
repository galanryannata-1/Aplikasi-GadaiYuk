PANDUAN KONFIGURASI IP UNTUK APLIKASI GADAIYUK (FLUTTER)

LANGKAH 1: CEK IP ADDRESS LOKAL (UNTUK SERVER XAMPP)
1. Buka CMD (Command Prompt)
2. Ketik perintah berikut lalu tekan Enter:
   ipconfig
3. Cari bagian:
   IPv4 Address (biasanya muncul seperti: 192.168.100.12)
4. Salin alamat IP tersebut

LANGKAH 2: GANTI IP DI FILE-FILE FLUTTER
Gantilah semua IP default (contoh: 192.168.100.12) dengan IP yang baru kamu salin, di file berikut:

>> Folder `auth`:
- SignUp.dart

>> Folder `db`:
- dbHelper.dart

>> Folder `gadai`:
- bayar.dart
- cek.dart
- cekStatusGadai.dart
- gadai.dart
- lihatTanggal.dart
- setCardJ.dart
- setCardK.dart

>> Folder `update`:
- setCardJU.dart
- setCardKU.dart
- update.dart

>> Folder `page`:
- akun.dart
- updateAkun.dart
- home.dart

>> Folder `riwayat`:
- riwayat.dart

CARA MENGGANTI:
- Buka masing-masing file di atas
- Cari baris seperti:
  `http://192.168.100.12/PA/nama_file.php`
- Ganti IP tersebut (192.168.100.12) dengan IP kamu sendiri dari langkah 1.
  Contoh:
  `http://192.168.1.5/PA/nama_file.php`

CATATAN:
✔ Jangan gunakan "localhost" di Flutter, harus pakai IP asli
✔ Pastikan HP/emulator dan komputer terhubung ke jaringan yang sama
✔ Jalankan Apache & MySQL di XAMPP


