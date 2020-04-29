package fun.wlfj.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import fun.wlfj.dao.IPostDAO;
import fun.wlfj.vo.Post;

public class PostDaoImpl implements IPostDAO {
	
	private Connection conn = null;
	private PreparedStatement pstsm = null;
	
	public PostDaoImpl(Connection conn) {
		this.conn = conn;
	}
	
	@Override
	public boolean doPost(Post post) throws SQLException {
		//发布文章
		pstsm = conn.prepareStatement("INSERT INTO posts(userid, title, post) VALUES(?, ?, ?)");
		pstsm.setInt(1, post.getUserid());
		pstsm.setString(2, post.getTitle());
		pstsm.setString(3, post.getPost());
		return pstsm.executeUpdate() == 1;
	}

	@Override
	public boolean doModify(Post post) throws SQLException {
		//修改文章
		pstsm = conn.prepareStatement("UPDATE posts SET title = ?, post = ? WHERE userid = ? AND postid = ?");
		pstsm.setString(1, post.getTitle());
		pstsm.setString(2, post.getPost());
		pstsm.setInt(3, post.getUserid());
		pstsm.setInt(4, post.getPostid());
		return pstsm.executeUpdate() == 1;
	}

	@Override
	public boolean doDelete(Post post) throws SQLException {
		pstsm = conn.prepareStatement("DELETE FROM posts WHERE userid = ? AND postid = ?");
		pstsm.setInt(1, post.getUserid());
		pstsm.setInt(2, post.getPostid());
		return pstsm.executeUpdate() == 1;
	}

	@Override
	public List<Post> findByKeyword(String keyword) throws SQLException {
		pstsm = conn.prepareStatement("SELECT * FROM uzer, posts WHERE uzer.userid = posts.userid AND (title LIKE ? or post LIKE ?);");
		pstsm.setString(1, "%" + keyword + "%");
		pstsm.setString(2, "%" + keyword + "%");
		ResultSet res = pstsm.executeQuery();
		LinkedList<Post> list = new LinkedList<Post>();
		while(res.next()) {
			list.push(new Post(res.getInt("postid"), res.getInt("userid"), res.getString("title"), res.getString("post"), res.getDate("postdate"), res.getString("username")));
		}
		return list;
	}

	@Override
	public List<Post> getPosts() throws SQLException {
		String sql = "SELECT * FROM uzer, posts WHERE uzer.userid = posts.userid ORDER BY postid ASC";
		pstsm = conn.prepareStatement(sql);
		ResultSet res = pstsm.executeQuery();
		LinkedList<Post> list = new LinkedList<Post>();
		while(res.next()) {
			list.push(new Post(res.getInt("postid"), res.getInt("userid"), res.getString("title"), res.getString("post"), res.getDate("postdate"), res.getString("username")));
		}
		return list;
	}

	@Override
	public Post getPostByID(Post post) throws SQLException {
		String sql = "SELECT * FROM uzer, posts WHERE uzer.userid = posts.userid AND postid = ?";
		pstsm = conn.prepareStatement(sql);
		pstsm.setInt(1, post.getPostid());
		ResultSet res = pstsm.executeQuery();
		Post p = null;
		while(res.next()) {
			p = new Post(res.getInt("postid"), res.getInt("userid"), res.getString("title"), res.getString("post"), res.getDate("postdate"), res.getString("username"));
		}
		return p;
	}
	
}
