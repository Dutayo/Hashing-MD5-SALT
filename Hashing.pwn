// hash_utils.inc
// System salt & hashing password - MD5 with random salt
// Author: [Nama Kamu]
// Note: Pure PAWN implementation, no external plugins

#if defined _hash_utils_included
    #endinput
#endif
#define _hash_utils_included

#include <a_samp>
#include <md5> // built-in MD5 plugin atau bisa pake custom MD5

#define SALT_LENGTH 16
#define HASH_LENGTH 32 // MD5 hex length

// Generate random salt dengan kombinasi alphanumeric + special chars
stock GenerateSalt() {
    new salt[SALT_LENGTH + 1];
    new const chars[] = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%&*";
    new len = strlen(chars);
    
    for(new i = 0; i < SALT_LENGTH; i++) {
        salt[i] = chars[random(len)];
    }
    salt[SALT_LENGTH] = '\0';
    return salt;
}

// Hash password dengan salt (format: salt + hash)
stock HashPassword(const password[], salt[] = "") {
    new salted[128];
    new hashed[33];
    new result[128];
    
    // Kalo salt kosong, generate baru
    if(strlen(salt) == 0) {
        strcat(salt, GenerateSalt(), SALT_LENGTH + 1);
    }
    
    // Format: password + salt (biar susah di-bruteforce)
    format(salted, sizeof(salted), "%s%s", password, salt);
    
    // MD5 hashing
    MD5(salted, hashed);
    
    // Simpan salt + hash (format: salt:hash)
    format(result, sizeof(result), "%s:%s", salt, hashed);
    return result;
}

// Verify password dengan stored hash
stock VerifyPassword(const password[], const stored_hash[]) {
    new salt[17];
    new hash[33];
    new test_hash[33];
    new salted[128];
    
    // Extract salt dan hash dari stored
    new pos = strfind(stored_hash, ":");
    if(pos == -1) return false;
    
    strmid(salt, stored_hash, 0, pos);
    strmid(hash, stored_hash, pos + 1, strlen(stored_hash));
    
    // Test dengan password yang diberikan
    format(salted, sizeof(salted), "%s%s", password, salt);
    MD5(salted, test_hash);
    
    // Bandingkan
    return strcmp(hash, test_hash) == 0;
}
