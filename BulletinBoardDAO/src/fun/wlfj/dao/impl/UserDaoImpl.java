package fun.wlfj.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import fun.wlfj.dao.IUserDAO;
import fun.wlfj.vo.User;

public class UserDaoImpl implements IUserDAO {
	
	private Connection conn = null;
	private PreparedStatement pstsm = null;
	
	public UserDaoImpl(Connection conn) {
		this.conn = conn;
	}

	@Override
	public User doLogin(User u) throws SQLException {
		pstsm = conn.prepareStatement("SELECT * FROM uzer WHERE username = ? AND password = ?;");
		pstsm.setString(1, u.getUsername());
		pstsm.setString(2, u.getPassword());
		ResultSet res = pstsm.executeQuery();
		User user = null;
		if(res.next()) {
			user = new User(res.getInt("userid"), res.getString("username"), res.getString("password"));
		}
		return user;
	}

	@Override
	public boolean doRegist(User u) throws SQLException {
		//发布文章
		pstsm = conn.prepareStatement("INSERT INTO uzer(username, password) VALUES(?, ?)");
		pstsm.setString(1, u.getUsername());
		pstsm.setString(2, u.getPassword());
		return pstsm.executeUpdate() == 1;
	}

}
