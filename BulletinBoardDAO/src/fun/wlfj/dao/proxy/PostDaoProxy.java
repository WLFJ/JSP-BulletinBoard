package fun.wlfj.dao.proxy;

import java.sql.SQLException;
import java.util.List;

import fun.wlfj.dao.IPostDAO;
import fun.wlfj.dao.impl.PostDaoImpl;
import fun.wlfj.dbc.MySQLConnection;
import fun.wlfj.vo.Post;

public class PostDaoProxy implements IPostDAO {
	
	//在这里处理各种异常信息 检查传入的值是否合法
	
	private MySQLConnection conn = null;
	private IPostDAO dao = null;
	
	public PostDaoProxy() {
		this.conn = new MySQLConnection();
		this.dao = new PostDaoImpl(this.conn.getConnection());
	}
	

	@Override
	public boolean doPost(Post post) throws SQLException {
		boolean res = false;
		try {
			res = dao.doPost(post);
		}catch (Exception e) {
			// TODO: handle exception
		}finally {
			conn.closeConnection();
		}
		return res;
	}

	@Override
	public boolean doModify(Post post) throws SQLException {
		boolean res = false;
		try {
			res = dao.doModify(post);
		}catch (Exception e) {
			// TODO: handle exception
		}finally {
			conn.closeConnection();
		}
		return res;
	}

	@Override
	public boolean doDelete(Post post) throws SQLException {
		boolean res = false;
		try {
			res = dao.doDelete(post);
		}catch (Exception e) {
			// TODO: handle exception
		}finally {
			conn.closeConnection();
		}
		return res;
	}

	@Override
	public List<Post> findByKeyword(String keyword) throws SQLException {
		List<Post> list = null;
		try {
			list = dao.findByKeyword(keyword);
		}catch (Exception e) {
			// TODO: handle exception
		}finally {
			conn.closeConnection();
		}
		return list;
	}

	@Override
	public List<Post> getPosts() throws SQLException {
		List<Post> list = null;
		try {
			list = dao.getPosts();
		}catch (Exception e) {
			// TODO: handle exception
		}finally {
			conn.closeConnection();
		}
		return list;
	}


	@Override
	public Post getPostByID(Post post) throws SQLException {
		Post p = null;
		try {
			p = dao.getPostByID(post);
		}catch (Exception e) {
			// TODO: handle exception
		}finally {
			conn.closeConnection();
		}
		return p;
	}

}
