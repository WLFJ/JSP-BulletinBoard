package fun.wlfj.dbc;

import java.sql.Connection;
import java.sql.DriverManager;

public class MySQLConnection {
	private static final String DBDRIVER = "com.mysql.cj.jdbc.Driver";
	private static final String DBURL = "jdbc:mysql://your_url";
	private static final String DBUSER = "bbs_server";
	private static final String DBPASSWORD = "pAsSwOrd";
	private Connection conn = null;
	
	public MySQLConnection(){
		try {
			Class.forName(DBDRIVER);
			conn = DriverManager.getConnection(DBURL, DBUSER, DBPASSWORD);
		}catch(Exception e) {
			System.out.println("建立数据库连接出错!");
		}
	}
	
	public Connection getConnection() {
		return this.conn;
	}
	
	public void closeConnection() {
		if(this.conn != null) {
			try {
				this.conn.close();
			}catch(Exception e) {
				System.out.println("关闭数据库连接出错!");
			}
		}
	}
}
