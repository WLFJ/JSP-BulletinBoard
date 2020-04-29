package fun.wlfj.dao;

import java.sql.SQLException;
import java.util.List;

import fun.wlfj.vo.Post;

public interface IPostDAO {
	//这里考虑用户可以做什么 问题是登陆显然不是用户做的事情
	//留言内容的添加、修改、删除及查询功能
	public boolean doPost(Post post) throws SQLException;
	public boolean doModify(Post post) throws SQLException;
	public boolean doDelete(Post post) throws SQLException;
	//通过关键字搜索
	public List<Post> findByKeyword(String keyword) throws SQLException;
	public List<Post> getPosts() throws SQLException;
	public Post getPostByID(Post post) throws SQLException;
}
