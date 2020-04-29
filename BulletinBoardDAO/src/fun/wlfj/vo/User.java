package fun.wlfj.vo;

public class User {
	private int userid;
	private String username, password, password_confirm;
	public User(int userid, String username, String password, String password_confirm) {
		this(userid, username, password);
		this.password_confirm = password_confirm;
	}
	public User(int userid, String username, String password) {
		this.userid = userid;
		this.username = username;
		this.password = password;
	}
	public User() {
		this.username = "";
		this.password = "";
		this.password_confirm = "";
	}
	public boolean isValid() {
		return this.userid != 0 && this.password.length() > 0;
	}
	public boolean isValid1() {
		return this.username.length() > 0 && this.password.length() > 0;
	}
	public boolean isValid2() {
		return this.password.length() > 0 && this.password_confirm.equals(this.password);
	}
	public int getUserid() {
		return userid;
	}
	public void setUserid(int userid) {
		this.userid = userid;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getPassword_confirm() {
		return password_confirm;
	}
	public void setPassword_confirm(String password_confirm) {
		this.password_confirm = password_confirm;
	}
	@Override
	public String toString() {
		return "User [userid=" + userid + ", username=" + username + ", password=" + password + ", password_confirm="
				+ password_confirm + "]";
	}
	
	
}
