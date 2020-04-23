<%@page import="java.util.LinkedList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
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

<body>
	<%
	int user_id = -1;
	String user_name = null;
	if(session.getAttribute("user_id") != null){
		user_id = (int)session.getAttribute("user_id");
		user_name = (String)session.getAttribute("user_name");	
	}
	%>
	<%
	//处理传入事件
	String sql = "SELECT * FROM uzer, posts WHERE uzer.userid = posts.userid ORDER BY postid desc";
	List<Object> para = new LinkedList<Object>();
	request.setCharacterEncoding("utf-8");
	if(request.getParameter("method") != null){
		if(request.getParameter("method").equals("search") && request.getParameter("keywords") != null){
			sql = "SELECT * FROM uzer, posts WHERE uzer.userid = posts.userid AND (title LIKE ? or post LIKE ?);";
			para.add("%" + (String)request.getParameter("keywords") + "%");
			para.add("%" + (String)request.getParameter("keywords") + "%");
		}else if(request.getParameter("method").equals("mypost")){
			if(user_id != -1){
				sql = "SELECT * FROM uzer, posts WHERE uzer.userid = posts.userid AND uzer.userid = ?;";
				para.add(user_id);
			}
		}
	}
	
	%>
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
		<div class="container" style="padding-top:30px">
			<div class="row">
				<div class="col-md-4">
					<div class="card mb-3">
						<div class="card-body">
							<form class="form-inline" action="index.jsp">
								<input class="sr-only" type="text" name="method" value="search">
							    <input class="form-control mr-sm-2" type="text" placeholder="关心的话题" aria-label="Search" name="keywords">
							    <button class="btn btn-outline-success my-1 my-sm-2 mb-2" type="submit">搜索</button>
							</form>
							<div class="mb-3"></div>
							<a href="post.jsp?method=new" class="btn btn-primary">新留言</a>
							<a href="index.jsp?method=mypost" class="btn btn-primary">我所发布</a>
						</div>
					</div>
				</div>
				<!--col4-->

				<div class="col-md-8">
					<!-- 通知条 -->
					<!--{{{-->
					<%if(session.getAttribute("flash_msg") != null){ %>
					<div class="alert alert-danger alert-dismissable">
			            <button type="button" class="close" data-dismiss="alert"
			                    aria-hidden="true">
			                &times;
			            </button>
			            <%=session.getAttribute("flash_msg") %>
			        </div>
			        <%
			        if(response.getHeader("Location") == null){//通过头来判断是否需要删除消息
			        	session.removeAttribute("flash_msg");
			        }
					} %>
					<%
					//现在要查表构造
					//现在我们要将其变成安全的
				    Connection conn = null;
					PreparedStatement pstsm = null;
				    try{
				    	Class.forName("com.mysql.cj.jdbc.Driver");
				    	conn = DriverManager.getConnection("jdbc:mysql://rm-8vbn3p61kwwhoh0p158870.mysql.zhangbei.rds.aliyuncs.com/bulentinboard", "bbs_server", "SzWlFj2020");
				        //这里判断删除操作
				        if(request.getParameter("method") != null && request.getParameter("method").equals("delete") && request.getParameter("postid") != null){
				        	sql = "DELETE FROM posts WHERE postid = ? AND userid = ?";
				        	pstsm = conn.prepareStatement(sql);
				        	pstsm.setInt(1, Integer.parseInt(request.getParameter("postid")));
				        	pstsm.setInt(2, user_id);
				        	pstsm.executeUpdate();
				        	pstsm.close();
				        }
				        pstsm = conn.prepareStatement(sql);
				        //通过列表动态传入
				        for(int i = 0; i < para.size(); i ++){
				        	pstsm.setString(i + 1, (String)para.get(i) + "%");
				        }
				        //现在我们想将里面所有的内容展示出来
				        ResultSet res = pstsm.executeQuery();
				        //现在我们遍历这个对象得到信息
				        while(res.next()){
				        	%>
				        	<div class="card mb-3">
								<div class="card-body">
									    <div class="d-flex w-100 justify-content-between">
									      <h5 class="mb-3"><%=res.getString("title") %></h5>
									      <small><%=res.getDate("postdate") %></small>
									    </div>
									    <p class="mb-3"><%=res.getString("post") %></p>
									    <div class="d-flex w-100 justify-content-between">
									      <span><small>由<em><%=res.getString("username") %></em>发表</small></span>
									      <span>
									      <%if(user_id == res.getInt("uzer.userid")){ %>
									      <small><a href="post.jsp?method=edit&postid=<%=res.getInt("postid")%>">编辑</a></small>
									      <small><a href="post.jsp?method=delete&postid=<%=res.getInt("postid")%>">删除</a></small>
									      </span>
									      <%} %>
									    </div>
								</div>
							</div>
				        	
				        	
				        	<%
				        	
				        }
				        
				        
				        //释放资源
				        if(pstsm != null){
				        	pstsm.close();
				        }
				    }catch(Exception e){
				    	out.print(e.toString());
				    }finally{
				    	//这里会自动关闭!
				    	if(conn != null){
				    		conn.close();
				    	}
				    }
					%>
					<div class="mb-5"></div>
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
