// main.pwn
// Demo sistem password hashing dengan salt
// Run di server SA-MP buat test

#include <a_samp>
#include "hash_utils.inc"

main() {
    print("\n======================================");
    print("   PASSWORD HASHING SYSTEM - DEMO");
    print("======================================\n");
    
    // Test 1: Register user
    new password[] = "Rahasia123!";
    new user_salt[17];
    new stored_hash[128];
    
    // Generate hash baru
    strcat(user_salt, GenerateSalt(), 17);
    stored_hash = HashPassword(password, user_salt);
    
    printf("[REGISTER] Password: %s", password);
    printf("[REGISTER] Salt: %s", user_salt);
    printf("[REGISTER] Stored Hash: %s\n", stored_hash);
    
    // Test 2: Login dengan password benar
    new login_password[] = "Rahasia123!";
    if(VerifyPassword(login_password, stored_hash)) {
        printf("[LOGIN] ✅ Password benar untuk: %s", login_password);
    } else {
        printf("[LOGIN] ❌ Password salah!");
    }
    
    // Test 3: Login dengan password salah
    new wrong_password[] = "Salah123";
    if(VerifyPassword(wrong_password, stored_hash)) {
        printf("[LOGIN] ✅ Password benar untuk: %s", wrong_password);
    } else {
        printf("[LOGIN] ❌ Password salah untuk: %s\n", wrong_password);
    }
    
    // Test 4: Multiple user simulation
    print("--------------------------------------");
    print("  SIMULASI MULTI USER");
    print("--------------------------------------");
    
    new users[3][2][64] = {
        {"user1", ""},
        {"user2", ""},
        {"user3", ""}
    };
    new user_passwords[3][] = {"Pass123", "Secure@456", "Test#789"};
    new user_hashes[3][128];
    
    for(new i = 0; i < 3; i++) {
        new salt[17];
        strcat(salt, GenerateSalt(), 17);
        user_hashes[i] = HashPassword(user_passwords[i], salt);
        printf("[USER %d] %s -> Hash: %s", 
            i+1, 
            user_passwords[i], 
            user_hashes[i]
        );
    }
    
    print("\n--------------------------------------");
    print("  VERIFIKASI SEMUA USER");
    print("--------------------------------------");
    
    for(new i = 0; i < 3; i++) {
        if(VerifyPassword(user_passwords[i], user_hashes[i])) {
            printf("[USER %d] ✅ Verifikasi sukses", i+1);
        } else {
            printf("[USER %d] ❌ Verifikasi gagal", i+1);
        }
    }
    
    print("\n======================================");
    print("   DEMO SELESAI");
    print("======================================\n");
}