/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

/**
 *
 * @author Admin
 */
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;
import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    /**
     * Băm (Hash) mật khẩu văn bản thường (plain text) bằng BCrypt.
     * BCrypt.gensalt() tự động tạo ra một salt ngẫu nhiên và nhúng vào hash.
     */
    public static String hashPassword(String plainTextPassword) {
        if (plainTextPassword == null) {
            return null;
        }
        return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt());
    }

    /**
     * Xác thực mật khẩu văn bản thường (plain text) với mật khẩu đã băm (hash) đã lưu.
     */
    public static boolean verifyPassword(String plainTextPassword, String hashedPassword) {
        if (plainTextPassword == null || hashedPassword == null) {
            return false;
        }
        // BCrypt.checkpw tự động trích xuất salt và so sánh
        return BCrypt.checkpw(plainTextPassword, hashedPassword);
    }
}