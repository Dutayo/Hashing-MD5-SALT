# 🔐 Password Hashing System - PAWN

Sistem keamanan password menggunakan **MD5 + Salt** untuk server SA-MP/Open.MP.

## 🧠 Kenapa Pake Salt?
MD5 doang itu **rapuh** kalo kena rainbow table attack. Dengan salt, hash tiap user jadi unik meskipun passwordnya sama.

## ⚙️ Fitur
- Generate random salt (16 karakter)
- Hash password dengan format `salt:hash`
- Verify password tanpa perlu nyimpen plaintext
- Anti-collision dengan salt unik tiap user

## 📦 Cara Pake
1. Include `hash_utils.inc` di gamemode
2. Panggil `HashPassword(password, salt)` buat register
3. Panggil `VerifyPassword(password, stored_hash)` buat login
4. Simpen `stored_hash` di database (jangan simpen plaintext!)

## 🚀 Contoh
```pawn
new salt[17];
strcat(salt, GenerateSalt(), 17);
new hash[128] = HashPassword("Rahasia123!", salt);

// Verify
if(VerifyPassword("Rahasia123!", hash)) {
    print("Login sukses!");
}