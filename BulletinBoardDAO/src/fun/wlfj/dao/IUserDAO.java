package fun.wlfj.dao;

import java.sql.SQLException;

import fun.wlfj.vo.User;

public interface IUserDAO {
	
	public User doLogin(User u) throws SQLException;
	
	public boolean doRegist(User u) throws SQLException;
	
}
