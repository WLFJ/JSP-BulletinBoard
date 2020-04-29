package fun.wlfj.dao.proxy;

import java.sql.SQLException;

import fun.wlfj.dao.IUserDAO;
import fun.wlfj.dao.impl.UserDaoImpl;
import fun.wlfj.dbc.MySQLConnection;
import fun.wlfj.vo.User;

public class UserDaoProxy implements IUserDAO {
	
	private MySQLConnection conn = null;
	private IUserDAO dao = null;
	
	public UserDaoProxy() {
		conn = new MySQLConnection();
		dao = new UserDaoImpl(conn.getConnection());
	}

	@Override
	public User doLogin(User u) throws SQLException {
		User user = null;
		try {
			user = dao.doLogin(u);
		}catch (Exception e) {
			// TODO: handle exception
		}finally {
			conn.closeConnection();
		}
		return user;
	}

	@Override
	public boolean doRegist(User u) throws SQLException {
		boolean res = false;
		try {
			res = dao.doRegist(u);
		}catch (Exception e) {
			// TODO: handle exception
		}finally {
			conn.closeConnection();
		}
		return res;
	}

}
