<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="com.mysql.cj.protocol.Resultset"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="">
<meta name="author" content="WLFJ, and Bootstrap contributors">
<title>箴言·留言板</title>

<!-- Bootstrap core CSS -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css"
	integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh"
	crossorigin="anonymous">
<!-- Favicons -->
<link rel="apple-touch-icon"
	href="/docs/assets/img/favicons/apple-touch-icon.png" sizes="180x180">
<link rel="icon" href="/docs/assets/img/favicons/favicon-32x32.png"
	sizes="32x32" type="image/png">
<link rel="icon" href="/docs/assets/img/favicons/favicon-16x16.png"
	sizes="16x16" type="image/png">
<link rel="manifest"
	href="https://v4.bootcss.com/docs/assets/img/favicons/manifest.json">
<link rel="mask-icon"
	href="/docs/assets/img/favicons/safari-pinned-tab.svg" color="#563d7c">
<link rel="icon" href="/docs/assets/img/favicons/favicon.ico">
<meta name="msapplication-config"
	content="https://v4.bootcss.com/docs/assets/img/favicons/browserconfig.xml">
<meta name="theme-color" content="#563d7c">


<style>
.bd-placeholder-img {
	font-size: 1.125rem;
	text-anchor: middle;
	-webkit-user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
	user-select: none;
}

@media ( min-width : 768px) {
	.bd-placeholder-img-lg {
		font-size: 3.5rem;
	}
}
</style>
<!-- Custom styles for this template -->
<link href="album.css" rel="stylesheet">
</head>
<%!
	public abstract class SqlHelper{
		
		PreparedStatement pstsm = null;
		Connection conn = null;
	
		public ResultSet query(){
			ResultSet rs = null;
			try{
				Class.forName("com.mysql.cj.jdbc.Driver");
				conn = DriverManager.getConnection("jdbc:mysql://your_mysql_server/bulentinboard", "bbs_server", "pAsSwOrD");
				rs = getResult(conn);
			}catch(ClassNotFoundException e){
				System.out.println("无法加载驱动");
			}catch(SQLException e){
				System.out.println("SQL执行错误");
			}
			
			return rs;
		}
		public abstract ResultSet getResult(Connection conn);
		public void closeDB(){
			try{
				if(pstsm != null) pstsm.close();
				if(conn != null) conn.close();
			}catch(SQLException e){
				
			}
		}
	}
%>
<%
	final int user_id = session.getAttribute("user_id") != null ? (int)session.getAttribute("user_id") : -1;
	String user_name = null;
	if(session.getAttribute("user_id") != null){
		user_name = (String)session.getAttribute("user_name");	
	}
	%>
	<%
	//编辑界面展示所需
	String show_title = null, show_post = null;
	%>
	<%
	request.setCharacterEncoding("utf-8");
	final String method = request.getParameter("method"), postid = request.getParameter("postid"),
		title = request.getParameter("title"), post = request.getParameter("post");
	int status = 0;
	if(user_id != -1 && method != null){
		if(method.equals("new")){
			//新建模式 只要参数全就更新
			if(title != null && post != null){
				new SqlHelper(){
					public ResultSet getResult(Connection conn){
						
						try{
							pstsm = conn.prepareStatement("INSERT INTO posts(userid, title, post) VALUES(?, ?, ?)");
							pstsm.setInt(1, user_id);
							pstsm.setString(2, title);
							pstsm.setString(3, post);
							pstsm.executeUpdate();
						}catch(Exception e){
							
						}
						
						closeDB();
						return null;
					}
				}.query();
				session.setAttribute("flash_msg", "发布成功");
				response.sendRedirect("index.jsp");
			}
		}else if(method.equals("edit")){
			//编辑模式
			status = 1;
			if(postid != null && title != null && post != null){
				new SqlHelper(){
					public ResultSet getResult(Connection conn){
						
						try{
							pstsm = conn.prepareStatement("UPDATE posts SET title = ?, post = ? WHERE userid = ? AND postid = ?");
							pstsm.setString(1, title);
							pstsm.setString(2, post);
							pstsm.setInt(3, user_id);
							pstsm.setString(4, postid);
							pstsm.executeUpdate();
						}catch(Exception e){
							
						}
						
						closeDB();
						return null;
					}
				}.query();
				session.setAttribute("flash_msg", "编辑操作完成");
				response.sendRedirect("index.jsp");
			}else if(postid != null){
				//我们将需要展示的内容都放在这里
				SqlHelper helper = new SqlHelper(){
					public ResultSet getResult(Connection conn){
						ResultSet res = null;
						try{
							pstsm = conn.prepareStatement("SELECT * FROM posts WHERE userid = ? AND postid = ?");
							pstsm.setInt(1, user_id);
							pstsm.setString(2, postid);
							res = pstsm.executeQuery();
						}catch(Exception e){
							
						}
						
						
						return res;
					}
				};
				ResultSet res = helper.query();
				if(res.next()){
					show_title = res.getString("title");
					show_post = res.getString("post");
				}else{
					response.sendRedirect("index.jsp");
				}
				helper.closeDB();

			}else{
				response.sendRedirect("index.jsp");
			}
		}else if(method.equals("delete")){
			//删除模式
			//新建模式 只要参数全就更新
			if(postid != null){
				new SqlHelper(){
					public ResultSet getResult(Connection conn){
						
						try{
							pstsm = conn.prepareStatement("DELETE FROM posts WHERE userid = ? AND postid = ?");
							pstsm.setInt(1, user_id);
							pstsm.setString(2, postid);
							pstsm.executeUpdate();
						}catch(Exception e){
							
						}
						
						closeDB();
						return null;
					}
				}.query();
				session.setAttribute("flash_msg", "删除成功");
				response.sendRedirect("index.jsp");
			}else{
				response.sendRedirect("index.jsp");
			}
		}else{
			response.sendRedirect("index.jsp");
		}
	}else{
		response.sendRedirect("index.jsp");
	}
	%>
<body>
	<header>
		<div class="navbar navbar-dark bg-dark shadow-sm">
			<div class="container d-flex justify-content-between">
				<a href="#" class="navbar-brand d-flex align-items-center"> <svg
						width="20" height="20" viewBox="0 0 16 16" fill="currentColor"
						class="mr-2" xmlns="http://www.w3.org/2000/svg">
		  <path fill-rule="evenodd"
							d="M14 1H2a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h2.5a2 2 0 0 1 1.6.8L8 14.333 9.9 11.8a2 2 0 0 1 1.6-.8H14a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1zM2 0a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h2.5a1 1 0 0 1 .8.4l1.9 2.533a1 1 0 0 0 1.6 0l1.9-2.533a1 1 0 0 1 .8-.4H14a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"
							clip-rule="evenodd" />
		  <path
							d="M7.468 5.667c0 .92-.776 1.666-1.734 1.666S4 6.587 4 5.667C4 4.747 4.776 4 5.734 4s1.734.746 1.734 1.667z" />
		  <path fill-rule="evenodd"
							d="M6.157 4.936a.438.438 0 0 1-.56.293.413.413 0 0 1-.274-.527c.08-.23.23-.44.477-.546a.891.891 0 0 1 .698.014c.387.16.72.545.923.997.428.948.393 2.377-.942 3.706a.446.446 0 0 1-.612.01.405.405 0 0 1-.011-.59c1.093-1.087 1.058-2.158.77-2.794-.152-.336-.354-.514-.47-.563z"
							clip-rule="evenodd" />
		  <path
							d="M11.803 5.667c0 .92-.776 1.666-1.734 1.666-.957 0-1.734-.746-1.734-1.666 0-.92.777-1.667 1.734-1.667.958 0 1.734.746 1.734 1.667z" />
		  <path fill-rule="evenodd"
							d="M10.492 4.936a.438.438 0 0 1-.56.293.413.413 0 0 1-.274-.527c.08-.23.23-.44.477-.546a.891.891 0 0 1 .698.014c.387.16.72.545.924.997.428.948.392 2.377-.942 3.706a.446.446 0 0 1-.613.01.405.405 0 0 1-.011-.59c1.093-1.087 1.058-2.158.77-2.794-.152-.336-.354-.514-.469-.563z"
							clip-rule="evenodd" />
		</svg> <strong>箴言·留言板</strong>
				</a>
				<%
				if(user_id != -1){
				%>
				<div class="text-white">欢迎朋友,<em><%=user_name %></em><a href="auth.jsp?method=logout">安全退出</a></div>
				<%
				}else{
				%>
				<div class="text-white"><a href="auth.jsp?method=login">登陆/注册</a></div>
				<%
				}
				%>
			</div>
		</div>
	</header>

	<main role="main" class="bg-light">

		<!-- 内容区域 -->
		<div class="container" style="padding-top:20px">
			<div class="row">
				<div class="col-md-8 offset-md-2">
					<div class="card mb-3">
					  <div class="card-header">
					    发布新留言
					  </div>
					  <div class="card-body">
					    <form method="post">
					    <input type="text" name="method" class="sr-only" value="<%=method%>">
					    <input type="text" name="userid" class="sr-only" value="<%=user_id%>">
						  <div class="form-group">
						    <label for="inputTitle">标题</label>
						    <input type="text" class="form-control" id="inputTitle" name="title" value="<%=show_title != null ? show_title : ""  %>" required>
						  </div>
						  <div class="form-group">
						    <label for="inputText">正文</label>
						    <textarea class="form-control" id="inputText" rows="6" name="post"  required><%=show_post != null ? show_post : ""  %></textarea>
						  </div>
						  <hr>
						  <button type="submit" class="btn btn-primary">发布</button>
						</form>
					  </div>
					</div>
				</div>

			</div>
		</div>
	</main>

	<footer class="text-muted">
		<!-- 底部区域 -->
		<div class="container">
			<p class="float-right">
				<a href="#">返回顶部</a>
			</p>
			<p>2020 @WLFJ 谁知晚来风急</p>
			<p>
				生命分毫之间,思想在闪烁.有关我生活的一隅,访问 <a href="https://wlfj.fun/">我的博客</a>.
			</p>
		</div>
	</footer>
	<script
		src="https://cdn.jsdelivr.net/npm/jquery@3.4.1/dist/jquery.slim.min.js"
		integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n"
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
		integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.min.js"
		integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6"
		crossorigin="anonymous"></script>
</html>
