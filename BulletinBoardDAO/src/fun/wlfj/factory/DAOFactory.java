package fun.wlfj.factory;

import fun.wlfj.dao.IPostDAO;
import fun.wlfj.dao.IUserDAO;
import fun.wlfj.dao.proxy.PostDaoProxy;
import fun.wlfj.dao.proxy.UserDaoProxy;

public class DAOFactory {
	public static IPostDAO getIPostInstance() {
		return new PostDaoProxy();
	}
	public static IUserDAO getIUserInstance() {
		return new UserDaoProxy();
	}
}
