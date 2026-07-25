// example_usage.pwn
// Contoh implementasi di gamemode real (register/login system)

#include <a_samp>
#include "hash_utils.inc"

// Simulasi database pake array
new PlayerData[MAX_PLAYERS][2][64]; // [playerid][0] = username, [1] = password_hash
new bool:PlayerLogged[MAX_PLAYERS];

// Fungsi Register
CMD:register(playerid, params[]) {
    new password[64];
    if(sscanf(params, "s[64]", password)) {
        SendClientMessage(playerid, -1, "Usage: /register [password]");
        return 1;
    }
    
    // Cek username udah dipake
    new username[24];
    GetPlayerName(playerid, username, sizeof(username));
    
    // Hash password dengan salt baru
    new salt[17];
    strcat(salt, GenerateSalt(), 17);
    new hashed[128];
    strcat(hashed, HashPassword(password, salt), 128);
    
    // Simpan ke "database"
    strcat(PlayerData[playerid][0], username, 64);
    strcat(PlayerData[playerid][1], hashed, 64);
    
    new msg[128];
    format(msg, sizeof(msg), "✅ Registrasi berhasil! Username: %s", username);
    SendClientMessage(playerid, 0x00FF00FF, msg);
    
    PlayerLogged[playerid] = true;
    return 1;
}

// Fungsi Login
CMD:login(playerid, params[]) {
    if(PlayerLogged[playerid]) {
        SendClientMessage(playerid, -1, "⚠️ Kamu sudah login!");
        return 1;
    }
    
    new password[64];
    if(sscanf(params, "s[64]", password)) {
        SendClientMessage(playerid, -1, "Usage: /login [password]");
        return 1;
    }
    
    new username[24];
    GetPlayerName(playerid, username, sizeof(username));
    
    // Cek data user (di real case pake database)
    new stored_hash[128];
    strcat(stored_hash, PlayerData[playerid][1], 128);
    
    if(VerifyPassword(password, stored_hash)) {
        SendClientMessage(playerid, 0x00FF00FF, "✅ Login berhasil!");
        PlayerLogged[playerid] = true;
    } else {
        SendClientMessage(playerid, 0xFF0000FF, "❌ Password salah!");
    }
    return 1;
}

// Fungsi ganti password
CMD:changepass(playerid, params[]) {
    if(!PlayerLogged[playerid]) {
        SendClientMessage(playerid, -1, "⚠️ Login dulu!");
        return 1;
    }
    
    new old_pass[64], new_pass[64];
    if(sscanf(params, "s[64]s[64]", old_pass, new_pass)) {
        SendClientMessage(playerid, -1, "Usage: /changepass [password_lama] [password_baru]");
        return 1;
    }
    
    // Verify old password
    new stored_hash[128];
    strcat(stored_hash, PlayerData[playerid][1], 128);
    
    if(!VerifyPassword(old_pass, stored_hash)) {
        SendClientMessage(playerid, 0xFF0000FF, "❌ Password lama salah!");
        return 1;
    }
    
    // Update ke password baru
    new salt[17];
    strcat(salt, GenerateSalt(), 17);
    new new_hashed[128];
    strcat(new_hashed, HashPassword(new_pass, salt), 128);
    strcat(PlayerData[playerid][1], new_hashed, 64);
    
    SendClientMessage(playerid, 0x00FF00FF, "✅ Password berhasil diganti!");
    return 1;
}