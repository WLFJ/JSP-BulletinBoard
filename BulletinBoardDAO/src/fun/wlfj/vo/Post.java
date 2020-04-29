package fun.wlfj.vo;

import java.sql.Date;

public class Post {
	
	private int postid, userid;
	private String title, post, username;
	Date postdate;
	

	public Post(int postid, int userid, String title, String post, Date postdate, String username) {
		super();
		this.postid = postid;
		this.userid = userid;
		this.title = title;
		this.post = post;
		this.postdate = postdate;
		this.username = username;
	}
	
	public Post() {
		// TODO Auto-generated constructor stub
	}
	
	public int getPostid() {
		return postid;
	}
	public void setPostid(int postid) {
		this.postid = postid;
	}
	public int getUserid() {
		return userid;
	}
	public void setUserid(int userid) {
		this.userid = userid;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getPost() {
		return post;
	}
	public void setPost(String post) {
		this.post = post;
	}
	public Date getPostdate() {
		return postdate;
	}
	public void setPostdate(Date postdate) {
		this.postdate = postdate;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	
	public boolean isValid() {
		return this.userid != 0 && this.title.length() > 0 && this.post.length() > 0;
	}

	@Override
	public String toString() {
		return "Post [postid=" + postid + ", userid=" + userid + ", title=" + title + ", post=" + post + ", username="
				+ username + ", postdate=" + postdate + "]";
	}
	
	

}
