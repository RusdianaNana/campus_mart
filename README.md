# Campus Mart

Marketplace mahasiswa sederhana (Flutter + Provider), simulasi dua akun pada satu perangkat.
Tanpa Firebase, backend, atau internet. Data disimpan lokal dengan `shared_preferences`.

## Cara menjalankan

```bash
flutter create campus_mart
cd campus_mart
# Ganti folder lib/ dan file pubspec.yaml dengan isi proyek ini, lalu:
flutter pub get
flutter run
```

(Alternatif pubspec: `flutter pub add provider shared_preferences`.)

## Akun demo

| Username | Password |
|---|---|
| penjual | jual123 |
| pembeli | beli123 |

## Skenario uji

1. Login `penjual` -> menu Jual -> Tambah Barang (Headphone, Rp150000) -> Simpan.
2. Profil -> Logout. Login `pembeli`. Home -> buka Headphone -> Chat Penjual -> kirim pesan.
3. Logout. Login `penjual` -> menu Chat -> buka percakapan -> balas.
4. Logout. Login `pembeli` -> baca balasan -> Ajukan Pembelian -> Ajukan (status Menunggu).
5. Logout. Login `penjual` -> Chat -> Terima atau Tolak.
6. Logout. Login `pembeli` -> status terbaru tampil di Chat dan Detail Barang.
